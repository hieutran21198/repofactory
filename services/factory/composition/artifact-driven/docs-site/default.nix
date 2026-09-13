{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  workflowScalarType = lib.types.oneOf [
    lib.types.str
    lib.types.bool
    lib.types.int
    lib.types.float
  ];
  workflowStepModule = {
    options = {
      name = _utils.mkStrOpt {
        nullable = true;
        default = null;
        description = "The displayed name of the GitHub Actions step";
      };
      uses = _utils.mkStrOpt {
        nullable = true;
        default = null;
        description = "The GitHub Action that the step uses";
      };
      "with" = _utils.mkAttrsOpt {
        ofType = workflowScalarType;
        default = { };
        description = "Scalar inputs for the GitHub Action";
      };
      run = _utils.mkStrOpt {
        nullable = true;
        default = null;
        description = "The command or script that the step runs";
      };
      env = _utils.mkAttrsOpt {
        ofType = workflowScalarType;
        default = { };
        description = "Scalar environment variables for the step";
      };
      working-directory = _utils.mkStrOpt {
        nullable = true;
        default = null;
        description = "The working directory for a run step";
      };
    };
  };
  yamlScalar = builtins.toJSON;
  yamlKey = key: if builtins.match "[A-Za-z0-9_-]+" key != null then key else yamlScalar key;
  renderMap =
    name: values:
    lib.optionalString (values != { }) (
      "\n        ${name}:\n"
      + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: value: "          ${yamlKey key}: ${yamlScalar value}") values
      )
    );
  renderWorkflowStep =
    step:
    "\n      -"
    + lib.optionalString (step.name != null) "\n        name: ${yamlScalar step.name}"
    + lib.optionalString (step.uses != null) "\n        uses: ${yamlScalar step.uses}"
    + renderMap "with" (step."with" or { })
    + lib.optionalString (step.run != null) "\n        run: ${yamlScalar step.run}"
    + renderMap "env" (step.env or { })
    + lib.optionalString (
      step.working-directory != null
    ) "\n        working-directory: ${yamlScalar step.working-directory}";
  renderWorkflowSteps = steps: lib.concatMapStrings renderWorkflowStep steps;
  renderAzureEnv =
    values:
    lib.optionalString (values != { }) (
      "\n  env:\n"
      + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: value: "    ${yamlKey key}: ${yamlScalar value}") values
      )
    );
  renderAzureRunStep =
    step:
    "\n- script: ${yamlScalar step.run}"
    + lib.optionalString (step.name != null) "\n  displayName: ${yamlScalar step.name}"
    + "\n  workingDirectory: ${
      yamlScalar (if step.working-directory != null then step.working-directory else "apps/documentation")
    }"
    + renderAzureEnv (step.env or { });
  renderAzureUsesStep =
    step:
    "\n- script: ${yamlScalar "Run action ${step.uses}"}"
    + lib.optionalString (step.name != null) "\n  displayName: ${yamlScalar step.name}"
    + renderAzureEnv ((step."with" or { }) // (step.env or { }));
  renderAzureStep =
    step: if step.run != null then renderAzureRunStep step else renderAzureUsesStep step;
  renderAzureSteps = steps: lib.concatMapStrings renderAzureStep steps;
  workflow =
    docsSite:
    let
      inherit (docsSite) notification;
      notificationEnabled = notification.uses != [ ];
      isAzure = docsSite.target == "azure-static-web-app";
      notificationPermission = if notificationEnabled then "\n      contents: read" else "";
      watchPaths = lib.concatMapStrings (
        path: "\n      - ${yamlScalar path}"
      ) docsSite.workflow.watch-paths;
      beforeNodeSetup = renderWorkflowSteps docsSite.workflow.build.before-node-setup;
      beforeSiteBuild = renderWorkflowSteps docsSite.workflow.build.before-site-build;
      afterSiteBuild = renderWorkflowSteps docsSite.workflow.build.after-site-build;
      deploymentUrlLine =
        if isAzure then
          "\n          DOCS_SITE_DEPLOYMENT_URL: ${builtins.toJSON "${docsSite.url}${docsSite.base-url}"}"
        else
          "\n          DOCS_SITE_DEPLOYMENT_URL: \${{ steps.deployment.outputs.page_url }}";
      notificationSteps =
        if notificationEnabled then
          "\n      - name: Check out the notification code\n        uses: actions/checkout@v4\n        with:\n          persist-credentials: false\n      - name: Notify the team about the deployment\n        run: python3 .github/docs-site/notify.py\n        env:\n          DOCS_SITE_NOTIFICATION_USES: '${builtins.toJSON notification.uses}'${lib.optionalString (builtins.elem "google-chat" notification.uses) "\n          DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: \${{ secrets.${notification.google-chat.webhook-secret} }}"}${lib.optionalString (builtins.elem "slack" notification.uses) "\n          DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK: \${{ secrets.${notification.slack.webhook-secret} }}"}${lib.optionalString (builtins.elem "telegram" notification.uses) "\n          DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN: \${{ secrets.${notification.telegram.token-secret} }}\n          DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID: ${builtins.toJSON notification.telegram.chat-id}"}${deploymentUrlLine}\n          DOCS_SITE_REPOSITORY: \${{ github.repository }}\n          DOCS_SITE_REF_NAME: \${{ github.ref_name }}\n          DOCS_SITE_COMMIT_SHA: \${{ github.sha }}\n          DOCS_SITE_RUN_URL: \${{ github.server_url }}/\${{ github.repository }}/actions/runs/\${{ github.run_id }}\n"
        else
          "\n";
      azureDeployStep = "\n      - name: Deploy to Azure Static Web Apps\n        uses: Azure/static-web-apps-deploy@v1\n        with:\n          azure_static_web_apps_api_token: \${{ secrets.${docsSite.azure-static-web-app.api-token-secret} }}\n                app_location: apps/documentation/build\n                output_location: build\n                skip_app_build: true";
      buildStepsTail =
        if isAzure then
          "${azureDeployStep}${notificationSteps}"
        else
          "\n      - name: Upload the website\n        uses: actions/upload-pages-artifact@v3\n        with:\n          path: apps/documentation/build\n";
      deployJob =
        if isAzure then
          ""
        else
          "\n  deploy:\n    needs: build\n    runs-on: ubuntu-latest\n    permissions:\n      pages: write\n      id-token: write${notificationPermission}\n    environment:\n      name: github-pages\n      url: \${{ steps.deployment.outputs.page_url }}\n    steps:\n      - name: Deploy to GitHub Pages\n        id: deployment\n        uses: actions/deploy-pages@v4${notificationSteps}";
    in
    ''
      name: Documentation site

      on:
        push:
          paths:
            - docs/**
            - apps/documentation/**
            - .github/workflows/docs-site.yml${watchPaths}
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
              uses: actions/checkout@v4${beforeNodeSetup}
            - name: Set up Node.js
              uses: actions/setup-node@v4
              with:
                node-version: 22
                cache: npm
                cache-dependency-path: apps/documentation/package-lock.json
            - name: Install the dependencies
              run: npm ci${beforeSiteBuild}
            - name: Build the website
              run: npm run build${afterSiteBuild}${buildStepsTail}${deployJob}'';
  azurePipeline =
    docsSite:
    let
      inherit (docsSite) notification;
      notificationEnabled = notification.uses != [ ];
      isAzure = docsSite.target == "azure-static-web-app";
      watchPaths = lib.concatMapStrings (
        path: "\n    - ${yamlScalar path}"
      ) docsSite.workflow.watch-paths;
      beforeNodeSetup = renderAzureSteps docsSite.workflow.build.before-node-setup;
      beforeSiteBuild = renderAzureSteps docsSite.workflow.build.before-site-build;
      afterSiteBuild = renderAzureSteps docsSite.workflow.build.after-site-build;
      notificationEnv =
        "\n    DOCS_SITE_NOTIFICATION_USES: '${builtins.toJSON notification.uses}'"
        + lib.optionalString (builtins.elem "google-chat" notification.uses) "\n    DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: $(${notification.google-chat.webhook-secret})"
        + lib.optionalString (builtins.elem "slack" notification.uses) "\n    DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK: $(${notification.slack.webhook-secret})"
        + lib.optionalString (builtins.elem "telegram" notification.uses) "\n    DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN: $(${notification.telegram.token-secret})\n    DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID: ${builtins.toJSON notification.telegram.chat-id}"
        + "\n    DOCS_SITE_DEPLOYMENT_URL: '${docsSite.url}${docsSite.base-url}'"
        + "\n    DOCS_SITE_REPOSITORY: $(Build.Repository.Name)"
        + "\n    DOCS_SITE_REF_NAME: $(Build.SourceBranchName)"
        + "\n    DOCS_SITE_COMMIT_SHA: $(Build.SourceVersion)"
        + "\n    DOCS_SITE_RUN_URL: $(System.CollectionUri)$(System.TeamProject)/_build/results?buildId=$(Build.BuildId)";
      notificationStep =
        if notificationEnabled then
          "- script: python3 .github/docs-site/notify.py\n  displayName: Notify the team about the deployment\n  env:${notificationEnv}\n"
        else
          "";
      publishStep =
        if isAzure then
          ''
            - task: AzureStaticWebApp@0
              displayName: Deploy to Azure Static Web Apps
              inputs:
                app_location: apps/documentation/build
                output_location: build
                skip_app_build: true
                azure_static_web_apps_api_token: $(${docsSite.azure-static-web-app.api-token-secret})
          ''
        else
          ''
            - script: |
                export GH_TOKEN="$DOCS_SITE_GITHUB_TOKEN"
                export GITHUB_TOKEN="$DOCS_SITE_GITHUB_TOKEN"
                npx --yes gh-pages --dist build --message "Deploy docs site $(Build.SourceVersion)"
              displayName: Publish to GitHub Pages
              workingDirectory: apps/documentation
              env:
                DOCS_SITE_GITHUB_TOKEN: $(DOCS_SITE_GITHUB_TOKEN)
          '';
    in
    ''
      trigger:
        branches:
          include:
          - main
        paths:
          include:
          - docs/**
          - apps/documentation/**
          - azure-pipelines/docs-site.yml${watchPaths}
      pr: none

      pool:
        vmImage: 'ubuntu-latest'

      steps:
      - checkout: self
        persistCredentials: false${beforeNodeSetup}
      - task: NodeTool@0
        displayName: Set up Node.js
        inputs:
          versionSpec: '22.x'
      - script: npm ci
        displayName: Install the dependencies
        workingDirectory: apps/documentation${beforeSiteBuild}
      - script: npm run build
        displayName: Build the website
        workingDirectory: apps/documentation${afterSiteBuild}
      ${publishStep}''
    + notificationStep;
in
{
  options.${namespace}.composition.artifact-driven.docs-site = {
    enable = _utils.mkBoolOpt {
      default = false;
      description = "Whether the factory renders the documentation site at apps/documentation and its CI pipeline";
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
    target = _utils.mkEnumOpt {
      values = [
        "github-pages"
        "azure-static-web-app"
      ];
      default = "github-pages";
      description = "The hosting service for the website: github-pages or azure-static-web-app.";
    };
    azure-static-web-app.api-token-secret = _utils.mkStrOpt {
      default = "DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN";
      description = "The secret that holds the Static Web App deployment token.";
    };
    static-directories = _utils.mkListOpt {
      ofType = lib.types.str;
      default = [ ];
      description = "Docusaurus static directories relative to apps/documentation";
    };
    workflow = {
      watch-paths = _utils.mkListOpt {
        ofType = lib.types.str;
        default = [ ];
        description = "More paths that trigger the documentation site workflow";
      };
      build = {
        before-node-setup = _utils.mkListOpt {
          ofType = lib.types.submodule workflowStepModule;
          default = [ ];
          description = "Build steps after checkout and before Node.js setup";
        };
        before-site-build = _utils.mkListOpt {
          ofType = lib.types.submodule workflowStepModule;
          default = [ ];
          description = "Build steps after dependency installation and before the site build";
        };
        after-site-build = _utils.mkListOpt {
          ofType = lib.types.submodule workflowStepModule;
          default = [ ];
          description = "Build steps after the site build and before artifact upload";
        };
      };
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
      workflowSteps =
        docsSite.workflow.build.before-node-setup
        ++ docsSite.workflow.build.before-site-build
        ++ docsSite.workflow.build.after-site-build;
      validWorkflowStep =
        step:
        let
          hasUses = step.uses != null && step.uses != "";
          hasRun = step.run != null && step.run != "";
        in
        hasUses != hasRun
        && ((step."with" or { }) == { } || hasUses)
        && (step.working-directory == null || (hasRun && step.working-directory != ""));
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
          assertion = builtins.elem ci-cd.provider.use [
            "github-actions"
            "azure-pipelines"
          ];
          message = "${namespace}.composition.artifact-driven.docs-site requires ${namespace}.domain.ci-cd.provider.use = \"github-actions\" or \"azure-pipelines\"";
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
        {
          assertion = builtins.all (path: path != "") (
            docsSite.static-directories ++ docsSite.workflow.watch-paths
          );
          message = "${namespace}.composition.artifact-driven.docs-site static directories and workflow watch paths must not be empty";
        }
        {
          assertion = builtins.all validWorkflowStep workflowSteps;
          message = "${namespace}.composition.artifact-driven.docs-site workflow steps must set exactly one of uses or run; with needs uses; working-directory needs run";
        }
        {
          assertion = builtins.elem docsSite.target [
            "github-pages"
            "azure-static-web-app"
          ];
          message = "${namespace}.composition.artifact-driven.docs-site.target must be \"github-pages\" or \"azure-static-web-app\"";
        }
        {
          assertion =
            docsSite.target != "azure-static-web-app"
            || builtins.match "[A-Za-z_][A-Za-z0-9_]*" docsSite.azure-static-web-app.api-token-secret != null;
          message = "${namespace}.composition.artifact-driven.docs-site.azure-static-web-app.api-token-secret must be a secret name";
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
            staticDirectories = docsSite.static-directories;
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
        "docs/wiki/documentation/artifact-driven/docs-site.md" = {
          source = ./_assets/docs/wiki/documentation/artifact-driven/docs-site.md;
          copyMode = "copy";
        };
      }
      // lib.optionalAttrs (ci-cd.provider.use == "github-actions") {
        ".github/workflows/docs-site.yml" = {
          text = workflow docsSite;
          copyMode = "copy";
        };
      }
      // lib.optionalAttrs (ci-cd.provider.use == "azure-pipelines") {
        "azure-pipelines/docs-site.yml" = {
          text = azurePipeline docsSite;
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
