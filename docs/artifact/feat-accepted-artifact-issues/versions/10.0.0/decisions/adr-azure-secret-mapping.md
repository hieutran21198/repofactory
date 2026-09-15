# adr-azure-secret-mapping: Map secret names one to one onto Azure secret variables

**Relates to:** spec-azure-pipelines-sync
**Context:** context-factory

## Context

The provider adapters and the notifier read credentials from named secrets.
GitHub Actions supplies them as repository secrets. Azure Pipelines supplies
them as secret variables. The factory must define how each secret name maps
to Azure.

## Options

1. Map each secret name one to one onto an Azure secret variable with the same
   name. Pro: The configuration, the guides, and the validation stay the same.
   Con: The user must create Azure variables with the same names.
2. Use Azure-prefixed variable names per provider. Pro: Names show the target
   CI system. Con: The configuration needs a CI branch and two guides.

## Decision

Map each secret name one to one onto an Azure secret variable with the same
name. The user copies the same names from the credential guide into Azure.
The Telegram chat ID stays a plain variable.

## Consequences

Adapter code and name validation stay CI-independent. The setup guide must
tell the Azure user to mark each mapped variable as secret.
