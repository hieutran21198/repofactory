{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.composition.artifact-driven.docs-site = {
    enable = _utils.mkBoolOpt {
      default = false;
      description = "Whether the factory renders the documentation site at apps/documentation and its GitHub Pages workflow";
    };
    title = _utils.mkStrOpt {
      default = "Documentation";
      description = "The title of the website. It is the browser title and the navbar title.";
    };
    url = _utils.mkStrOpt {
      default = "";
      description = "The origin of the website, for example https://<owner>.github.io. No path and no trailing slash.";
    };
    base-url = _utils.mkStrOpt {
      default = "/";
      description = "The path of the website under the origin, for example /<repo>/ for a project site. It starts and ends with a slash.";
    };
  };

  config =
    let
      docsSite = config.${namespace}.composition.artifact-driven.docs-site;
      inherit (config.${namespace}.domain) repo-arch documentation ci-cd;
      site = "apps/documentation";
    in
    lib.mkIf docsSite.enable {
      assertions = [
        {
          assertion = documentation.use == "artifact-driven";
          message = "${namespace}.composition.artifact-driven.docs-site requires ${namespace}.domain.documentation.use = \"artifact-driven\"";
        }
        {
          assertion = repo-arch.use == "multiple";
          message = "${namespace}.composition.artifact-driven.docs-site requires ${namespace}.domain.repo-arch.use = \"multiple\"";
        }
        {
          assertion = ci-cd.provider.use == "github-actions";
          message = "${namespace}.composition.artifact-driven.docs-site requires ${namespace}.domain.ci-cd.provider.use = \"github-actions\"";
        }
        {
          assertion = builtins.match "https?://[^/]+" docsSite.url != null;
          message = "${namespace}.composition.artifact-driven.docs-site.url must be an origin such as https://owner.github.io";
        }
        {
          assertion = builtins.match "/|/.*/" docsSite.base-url != null;
          message = "${namespace}.composition.artifact-driven.docs-site.base-url must start and end with \"/\"";
        }
        {
          assertion = docsSite.title != "";
          message = "${namespace}.composition.artifact-driven.docs-site.title must not be empty";
        }
      ];

      files = {
        "${site}/package.json" = {
          source = ./_assets/apps/documentation/package.json;
          copyMode = "copy";
        };
        "${site}/package-lock.json" = {
          source = ./_assets/apps/documentation/package-lock.json;
          copyMode = "copy";
        };
        "${site}/docusaurus.config.js" = {
          source = ./_assets/apps/documentation/docusaurus.config.js;
          copyMode = "copy";
        };
        "${site}/sidebars.js" = {
          source = ./_assets/apps/documentation/sidebars.js;
          copyMode = "copy";
        };
        # Nix owns the settings file. The authored docusaurus.config.js reads it.
        "${site}/site.json" = {
          text = builtins.toJSON {
            title = docsSite.title;
            url = docsSite.url;
            baseUrl = docsSite.base-url;
          };
          copyMode = "copy";
        };
        "${site}/.gitignore" = {
          source = ./_assets/apps/documentation/.gitignore;
          copyMode = "copy";
        };
        "${site}/src/css/custom.css" = {
          source = ./_assets/apps/documentation/src/css/custom.css;
          copyMode = "seed";
        };
        "${site}/README.md" = {
          source = ./_assets/apps/documentation/README.md;
          copyMode = "seed";
        };
        ".github/workflows/docs-site.yml" = {
          source = ./_assets/.github/workflows/docs-site.yml;
          copyMode = "copy";
        };
        "docs/wiki/documentation/artifact-driven/docs-site.md" = {
          source = ./_assets/docs/wiki/documentation/artifact-driven/docs-site.md;
          copyMode = "copy";
        };
      };
    };
}
