{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  workflow =
    notification:
    let
      notificationEnabled = notification.uses != [ ];
      notificationPermission = if notificationEnabled then "\n      contents: read" else "";
      notificationSteps =
        if notificationEnabled then
          "\n      - name: Check out the notification code\n        uses: actions/checkout@v4\n        with:\n          persist-credentials: false\n      - name: Notify the team about the deployment\n        run: python3 .github/docs-site/notify.py\n        env:\n          DOCS_SITE_NOTIFICATION_USES: '${builtins.toJSON notification.uses}'${lib.optionalString (builtins.elem "google-chat" notification.uses) "\n          DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: \${{ secrets.${notification.google-chat.webhook-secret} }}"}${lib.optionalString (builtins.elem "slack" notification.uses) "\n          DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK: \${{ secrets.${notification.slack.webhook-secret} }}"}${lib.optionalString (builtins.elem "telegram" notification.uses) "\n          DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN: \${{ secrets.${notification.telegram.token-secret} }}\n          DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID: ${builtins.toJSON notification.telegram.chat-id}"}\n          DOCS_SITE_DEPLOYMENT_URL: \${{ steps.deployment.outputs.page_url }}\n          DOCS_SITE_REPOSITORY: \${{ github.repository }}\n          DOCS_SITE_REF_NAME: \${{ github.ref_name }}\n          DOCS_SITE_COMMIT_SHA: \${{ github.sha }}\n          DOCS_SITE_RUN_URL: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}\n"
        else
          "\n";
    in
    ''
      name: Documentation site

      on:
        push:
          paths:
            - docs/**
            - apps/documentation/**
            - .github/workflows/docs-site.yml
        workflow_dispatch:

      permissions:
        contents: read

      concurrency:
        group: docs-site
        cancel-in-progress: false

      jobs:
        build:
          if: github.ref_name == github.event.repository.default_branch
          runs-on: ubuntu-latest
          defaults:
            run:
              working-directory: apps/documentation
          steps:
            - name: Check out the repository
              uses: actions/checkout@v4
            - name: Set up Node.js
              uses: actions/setup-node@v4
              with:
                node-version: 22
                cache: npm
                cache-dependency-path: apps/documentation/package-lock.json
            - name: Install the dependencies
              run: npm ci
            - name: Build the website
              run: npm run build
            - name: Upload the website
              uses: actions/upload-pages-artifact@v3
              with:
                path: apps/documentation/build

        deploy:
          needs: build
          runs-on: ubuntu-latest
          permissions:
            pages: write
            id-token: write${notificationPermission}
          environment:
            name: github-pages
            url: ''${{ steps.deployment.outputs.page_url }}
          steps:
            - name: Deploy to GitHub Pages
              id: deployment
              uses: actions/deploy-pages@v4${notificationSteps}'';
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
    notification = {
      uses = _utils.mkListOpt {
        ofType = lib.types.enum [
          "google-chat"
          "slack"
          "telegram"
        ];
        default = [ ];
        description = "The team providers for documentation site deployment messages";
      };
      google-chat.webhook-secret = _utils.mkStrOpt {
        default = "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK";
        description = "The GitHub Actions secret that contains the Google Chat webhook URL";
      };
      slack.webhook-secret = _utils.mkStrOpt {
        default = "DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK";
        description = "The GitHub Actions secret that contains the Slack webhook URL";
      };
      telegram = {
        token-secret = _utils.mkStrOpt {
          default = "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN";
          description = "The GitHub Actions secret that contains the Telegram bot token";
        };
        chat-id = _utils.mkStrOpt {
          default = "";
          description = "The Telegram chat ID that receives documentation site deployment messages";
        };
      };
    };
  };

  config =
    let
      docsSite = config.${namespace}.composition.artifact-driven.docs-site;
      inherit (config.${namespace}.domain) repo-arch documentation ci-cd;
      notificationEnabled = docsSite.notification.uses != [ ];
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
      ]
      ++ lib.optional notificationEnabled {
        assertion = builtins.all (
          use:
          builtins.elem use [
            "google-chat"
            "slack"
            "telegram"
          ]
        ) docsSite.notification.uses;
        message = "${namespace}.composition.artifact-driven.docs-site.notification.uses must contain only supported providers";
      }
      ++ lib.optional notificationEnabled {
        assertion =
          builtins.length docsSite.notification.uses
          == builtins.length (lib.unique docsSite.notification.uses);
        message = "${namespace}.composition.artifact-driven.docs-site.notification.uses must not contain a provider more than once";
      }
      ++ lib.optional (builtins.elem "google-chat" docsSite.notification.uses) {
        assertion =
          builtins.match "[A-Za-z_][A-Za-z0-9_]*" docsSite.notification.google-chat.webhook-secret != null;
        message = "${namespace}.composition.artifact-driven.docs-site.notification.google-chat.webhook-secret must be a GitHub secret name";
      }
      ++ lib.optional (builtins.elem "slack" docsSite.notification.uses) {
        assertion =
          builtins.match "[A-Za-z_][A-Za-z0-9_]*" docsSite.notification.slack.webhook-secret != null;
        message = "${namespace}.composition.artifact-driven.docs-site.notification.slack.webhook-secret must be a GitHub secret name";
      }
      ++ lib.optional (builtins.elem "telegram" docsSite.notification.uses) {
        assertion =
          builtins.match "[A-Za-z_][A-Za-z0-9_]*" docsSite.notification.telegram.token-secret != null;
        message = "${namespace}.composition.artifact-driven.docs-site.notification.telegram.token-secret must be a GitHub secret name";
      }
      ++ lib.optional (builtins.elem "telegram" docsSite.notification.uses) {
        assertion = docsSite.notification.telegram.chat-id != "";
        message = "${namespace}.composition.artifact-driven.docs-site.notification.telegram.chat-id must not be empty";
      };

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
          text = workflow docsSite.notification;
          copyMode = "copy";
        };
        "docs/wiki/documentation/artifact-driven/docs-site.md" = {
          source = ./_assets/docs/wiki/documentation/artifact-driven/docs-site.md;
          copyMode = "copy";
        };
      }
      // (
        if notificationEnabled then
          {
            ".github/docs-site/notify.py" = {
              source = ./_assets/.github/docs-site/notify.py;
              copyMode = "copy";
            };
          }
        else
          { }
      );
    };
}
