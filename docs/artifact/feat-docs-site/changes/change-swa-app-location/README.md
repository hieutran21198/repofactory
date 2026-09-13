# Change: Point SWA app_location at build output

**Feature:** [Documentation site](../../README.md)
**From:** 6.0.0
**To:** 6.1.0
**Type:** Specifications

## Reason

The real Azure deployment failed (DeploymentId 1e40472a). With `skip_app_build: true`, the Static Web Apps task ignores `output_location` and finds `index.html` directly in `app_location`. Thus `app_location` must point at the Docusaurus build output `apps/documentation/build`. Hotfix commit `9fc9e77` already corrected the code. This change records the corrected contract in the specifications. The requirement is unchanged.

## Artifacts

No specification files exist yet in this change. Phase 2 adds the specifications.
