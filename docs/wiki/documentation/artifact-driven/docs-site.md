# Documentation site

The documentation site is a website that renders the `docs/` tree of the repository. The factory
renders the site project at `apps/documentation/`. The project sets the options
`factory.composition.artifact-driven.docs-site` in `devenv.local.nix`: `enable`, `title`, `url`,
`base-url`, and `notification`. The shell renders the site project from these options.

## Run locally

Node.js 22 is not in the shell. Get it in one of two ways:

- Add `languages.javascript = { enable = true; npm.enable = true; };` to `devenv.local.nix`.
- Run the commands below with `nix shell nixpkgs#nodejs_22`.

Then run these commands:

1. `cd apps/documentation`
2. `npm ci`
3. `npm run start`

The last command starts a local server and opens the website in the browser.

## Publish

The factory renders one CI pipeline for the selected CI provider. The provider `github-actions`
renders `.github/workflows/docs-site.yml`. The provider `azure-pipelines` renders
`azure-pipelines/docs-site.yml`. Each pipeline builds the website and publishes it to GitHub
Pages on each push to the default branch. One manual step remains. In the repository settings,
under Pages, set the source to "GitHub Actions". Do this step one time.

A push to another branch does not change the published website. A failed build does not change
the published website. The Actions tab shows the failed run for `github-actions`. The pipeline
run shows the failed run for `azure-pipelines`.

## Set up Azure Pipelines

Select the CI provider in `devenv.local.nix`:

```nix
factory.domain.ci-cd.provider.use = "azure-pipelines";
```

Create the pipeline in Azure DevOps from `azure-pipelines/docs-site.yml`. The pipeline starts on
each push to the default branch when the push changes `docs/**`, `apps/documentation/**`,
`azure-pipelines/docs-site.yml`, or a configured `workflow.watch-paths` value. You can also
start a manual run for setup and recovery.

Store the GitHub token as a secret variable with the name `DOCS_SITE_GITHUB_TOKEN`. Mark the
variable as secret. The publish step uses this variable to publish the build output to GitHub
Pages. Store each notification secret as a secret variable with the same name. Mark each variable
as secret. The Telegram chat ID stays a plain variable.

One manual step remains. In the repository settings, under Pages, set the source to "GitHub
Actions". Do this step one time. The factory cannot do this step.

## Publish generated assets

Use typed options to add generated files to the site. Do not replace `docusaurus.config.js` or
`.github/workflows/docs-site.yml`. You do not need a `docusaurus.config.local.js` file.

`static-directories` contains paths relative to `apps/documentation/`. The factory adds each
`workflow.watch-paths` value after its default watch paths.

The build workflow has three step lists:

| Option | Position |
| --- | --- |
| `workflow.build.before-node-setup` | After checkout and before Node.js setup. |
| `workflow.build.before-site-build` | After `npm ci` and before `npm run build`. |
| `workflow.build.after-site-build` | After `npm run build` and before the Pages artifact upload. |

A step supports `name`, `uses`, `with`, `run`, `env`, and `working-directory`. Set one of `uses`
or `run`. A run step uses `apps/documentation/` as its default working directory. Azure
Pipelines runs the same steps in the same order with the same values.

This example builds a LaTeX manual from one service. It copies the PDF into a static directory.
Docusaurus then adds the PDF to the website build.

```nix
factory.composition.artifact-driven.docs-site = {
  static-directories = [ "static" ];

  workflow = {
    watch-paths = [ "services/manual/docs/**" ];

    build.before-node-setup = [
      {
        name = "Build the manual PDF";
        uses = "xu-cheng/latex-action@v4";
        "with" = {
          root_file = "manual.tex";
          working_directory = "services/manual/docs";
          latexmk_use_xelatex = true;
        };
      }
    ];

    build.before-site-build = [
      {
        name = "Copy the manual PDF";
        run = ''
          mkdir -p static/manual
          cp "$PDF_SOURCE" static/manual/manual.pdf
        '';
        env.PDF_SOURCE = "../../services/manual/docs/manual.pdf";
        working-directory = "apps/documentation";
      }
    ];

    build.after-site-build = [
      {
        name = "Check the published manual PDF";
        run = "test -f build/manual/manual.pdf";
      }
    ];
  };
};
```

The published file URL is `<base-url>/manual/manual.pdf`. A failed custom step stops the build and
prevents a deployment.

## Set up deployment notifications

The workflow can send one message to each selected provider after GitHub Pages deploys the site.

```nix
factory.composition.artifact-driven.docs-site.notification = {
  uses = [ "google-chat" "telegram" ];
  google-chat.webhook-secret = "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK";
  telegram = {
    token-secret = "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN";
    chat-id = "-100123";
  };
};
```

The default is an empty `uses` list. This list generates no notifier or notification step.

Make an incoming webhook for the Google Chat space or Slack channel. Use a bot token and chat ID
for Telegram. Use the provider procedure:

- [Google Chat incoming webhooks](https://developers.google.com/workspace/chat/quickstart/webhooks)
- [Slack incoming webhooks](https://api.slack.com/messaging/webhooks)
- [Telegram Bot API](https://core.telegram.org/bots/api#sendmessage)

Treat a webhook URL or a bot token as a password. Store each value in its configured GitHub
Actions repository secret. When the CI provider is `azure-pipelines`, store each value as an
Azure secret variable with the same name and mark it as secret.

```bash
read -rsp "Google Chat webhook: " DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK
printf '\n'
printf '%s' "$DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK" \
  | gh secret set DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK
unset DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK
```

The message identifies the repository, the deployed URL, the source revision, and the workflow
run. The workflow sends a message after a successful push or manual deployment. It sends no message
after a failed build or deployment.

The notifier retries a temporary delivery failure two times. If all attempts fail, the workflow
reports a failure, but GitHub Pages keeps the deployed site. A workflow rerun can send the message
again.

## Write pages that render

- A `.md` file renders as CommonMark. Put a `<name>` placeholder in backticks or in a code
  block. A bare `<name>` in prose does not render.
- Link a `README.md` file, not a folder. The link `](decisions/README.md)` opens the index page
  of the folder.
- A link to a URL path of a folder must end with `/`, for example `](decisions/)`. Without the
  `/`, the browser resolves the link in the parent folder.
- The templates under `docs/wiki/**/templates/` do not render.
- A version folder `versions/<version>/` has no README. The site generates an index page for it
  and shows the version number as the label. Do not link to the version folder itself: the site
  builder reads `versions/1.0.0/` as a file with the extension `.0`. Link to a file in the folder.
