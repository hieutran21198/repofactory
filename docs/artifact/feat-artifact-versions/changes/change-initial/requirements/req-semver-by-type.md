# req-semver-by-type: The type of a change gives the version number

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

A version must have the form major.minor.patch. The first version of a feature must be 1.0.0. The
change README must state the version before the change (From), the version after the change (To),
and the type of the change (Type). Type Requirements must bump the major number. Type
Specifications or Type Decisions must bump the minor number. Type Correction, an artifact
correction without a change to a contract, must bump the patch number.

## Acceptance criteria

- Given a feature without a version, when the first change gets a version, then the version is 1.0.0.
- Given a change README, when a reader opens it, then it states From, To, and Type.
- Given the current version 2.3.1 and a change of Type Requirements, when the change gets a version, then the version is 3.0.0.
- Given the current version 2.3.1 and a change of Type Specifications or Type Decisions, when the change gets a version, then the version is 2.4.0.
- Given the current version 2.3.1 and a change of Type Correction, when the change gets a version, then the version is 2.3.2.

## Notes

A version number says how much the contract of the feature changed. It is not a status.
