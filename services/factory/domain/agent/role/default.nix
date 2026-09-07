{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  inherit (config.${namespace}.domain.agent) harness role;

  roleModule =
    { name, ... }:
    {
      options = {
        enable = _utils.mkBoolOpt {
          default = true;
          description = "Whether to generate this role";
        };
        name = _utils.mkStrOpt {
          default = name;
          description = "Role name; used as the file name in each harness";
        };
        description = _utils.mkStrOpt {
          description = "Short description of the role; tells the harness when to use it";
        };
        instruction = _utils.mkStrOpt {
          description = "Role instruction in markdown; the body of the role file";
        };
        harness = {
          claude = _utils.mkAttrsOpt {
            default = { };
            description = "Extra Claude agent fields; rendered as frontmatter of .claude/agents/<name>.md";
          };
          codex = _utils.mkAttrsOpt {
            default = { };
            description = "Extra Codex agent fields; rendered into .codex/agents/<name>.toml";
          };
          opencode = _utils.mkAttrsOpt {
            default = { };
            description = "Extra OpenCode agent fields; rendered as frontmatter of .opencode/agents/<name>.md";
          };
        };
      };
    };

  roles = lib.filterAttrs (_: r: r.enable) role.builder;

  # Line-based YAML. Scalars are JSON encoded, which YAML accepts; nested attrs and lists indent.
  scalar = builtins.toJSON;
  # Plain keys stay bare; anything else (spaces, punctuation) is quoted.
  key = k: if builtins.match "[A-Za-z0-9_-]+" k != null then k else scalar k;
  isNested = v: (builtins.isAttrs v && v != { }) || (builtins.isList v && v != [ ]);
  toYAML =
    indent: value:
    if builtins.isAttrs value then
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          k: v:
          if isNested v then
            "${indent}${key k}:\n${toYAML (indent + "  ") v}"
          else
            "${indent}${key k}: ${scalar v}"
        ) value
      )
    else if builtins.isList value then
      lib.concatMapStringsSep "\n" (
        v: if isNested v then "${indent}-\n${toYAML (indent + "  ") v}" else "${indent}- ${scalar v}"
      ) value
    else
      "${indent}${scalar value}";
  frontmatter = attrs: "---\n${toYAML "" attrs}\n---\n\n";

  forEachRole = target: value: lib.mapAttrs' (_: r: lib.nameValuePair (target r) (value r)) roles;
in
{
  options.${namespace}.domain.agent.role.builder = _utils.mkAttrsOpt {
    ofType = lib.types.submodule roleModule;
    default = { };
    description = "Roles declared once and rendered for each harness in use";
  };

  config = lib.mkMerge [
    (lib.mkIf (builtins.elem "claude" harness.uses) {
      files = forEachRole (r: ".claude/agents/${r.name}.md") (r: {
        text = frontmatter ({ inherit (r) name description; } // r.harness.claude) + r.instruction;
        copyMode = "copy";
      });
    })

    (lib.mkIf (builtins.elem "opencode" harness.uses) {
      files = forEachRole (r: ".opencode/agents/${r.name}.md") (r: {
        text = frontmatter ({ inherit (r) description; } // r.harness.opencode) + r.instruction;
        copyMode = "copy";
      });
    })

    (lib.mkIf (builtins.elem "codex" harness.uses) {
      files = forEachRole (r: ".codex/agents/${r.name}.toml") (r: {
        toml = {
          inherit (r) name description;
          developer_instructions = r.instruction;
        }
        // r.harness.codex;
        copyMode = "copy";
      });

      ${namespace}.domain.agent.harness.codex.settings = lib.mkIf (roles != { }) {
        agents = lib.mapAttrs (_: r: {
          inherit (r) description;
          config_file = "agents/${r.name}.toml";
        }) roles;
      };
    })
  ];
}
