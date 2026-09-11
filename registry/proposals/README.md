# Toledo Equation Proposal Lane

This directory is the governed intake lane for equations/definitions that are **present in the Toledo repository but not yet promoted into `registry/CANONICAL.json`**.

It exists to satisfy `EQUATION_SOURCE_POLICY.md` without bypassing the canonical build/checker process.

## Status rule

Every entry in this directory must be explicitly labeled:

```text
new derivation/proposal
```

Presence here means:

```text
repository-grounded proposal
```

not:

```text
canonical theorem / canonical equation
```

Promotion into `registry/CANONICAL.json` requires the normal Toledo schema, lineage, parentage, code, evidence, status, and checker workflow.

## Why this lane exists

New application layers can develop faster than the canonical registry can safely absorb them. The proposal lane preserves:

- exact statement;
- symbol definitions;
- intended domain;
- provenance/source document;
- dependencies;
- status;
- promotion notes.

It prevents equations from living only in conversations or adjacent repositories.

## Cross-repository rule

`morrocwi/toledo` remains the authoritative mathematical source.

Application repositories such as `morrocwi/toledo.biz` should reference proposals/canonical codes here rather than silently forking equation statements.
