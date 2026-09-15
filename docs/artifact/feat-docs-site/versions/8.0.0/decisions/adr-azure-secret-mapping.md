# adr-azure-secret-mapping: Map secret names one to one onto Azure secret variables

**Relates to:** spec-docs-site-azure-pipeline
**Context:** context-factory

## Context

The publisher and the notifier read credentials from named secrets. GitHub Actions supplies them
as repository secrets. Azure Pipelines supplies them as secret variables. The factory must define
how each secret name maps to Azure. The secrets are the GitHub Pages token and the notification
provider secrets.

## Options

1. Map each secret name one to one onto an Azure secret variable with the same name. Pro: The
   configuration, the guide, and the validation stay the same. Con: The user must create Azure
   variables with the same names.
2. Use Azure-prefixed variable names per secret. Pro: Names show the target CI system. Con: The
   configuration needs a CI branch and two guides.

## Decision

Map each secret name one to one onto an Azure secret variable with the same name. The user copies
the same names from the guide into Azure. The Telegram chat ID stays a plain variable.

## Consequences

Notifier code and name validation stay CI-independent. The setup guide must tell the Azure user to
mark each mapped variable as secret.
