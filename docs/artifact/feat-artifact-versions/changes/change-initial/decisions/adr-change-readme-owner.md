# adr-change-readme-owner: The requirement expert writes every change README

**Relates to:** spec-requirement-expert-role
**Context:** context-factory

## Context

Each change has a README with the version before, the version after, the type, and the reason. A
change of type Specifications, Decisions, or Correction has no requirement work. One role must
own the README of every change, so that the shape and the version arithmetic are the same for
every type.

## Options

1. The requirement expert writes the change README in phase 1 for every type. When the type is
   not Requirements, phase 1 is only that file, and the requirement expert hands over to the
   solution expert. Pro: one owner, one procedure, one place that computes `To` from `Type`. Pro:
   the reason of a change is a business statement, which is the domain of the requirement expert.
   Con: a change without requirement work still starts with the requirement expert.
2. The owner of the first phase that changes writes the README: the requirement expert for type
   Requirements, the solution expert for the other types. Pro: no hand-over for a specification
   change. Con: two roles compute the version and write the same file; the two procedures drift.
   Con: the solution expert writes a reason, which is business text.

## Decision

Select option 1. One owner keeps the change README uniform. The cost is one short phase 1 for a
change without requirement work.

## Consequences

The requirement expert role has one procedure for every change. Its first steps create the change
folder and the README; the requirement steps run only when the type includes Requirements. The
solution expert role reads the change README before phase 2. The solution expert writes in it only
under `## Removed artifacts`, for a specification or a decision that the change removes; the
requirement expert lists a removed requirement there in phase 1.
