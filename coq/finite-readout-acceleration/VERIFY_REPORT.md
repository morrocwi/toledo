# VERIFY_REPORT — finite-readout-acceleration

Source: `finite-readout-acceleration` (public, `github.com/morrocwi/finite-readout-acceleration`),
commit `f7fbc318eb104314cbc81d9f718a9a03abaadc05`, per `registry/coq_imports.json` and
`PROVENANCE.json`. Coq 8.20.1. Built and verified sequentially, one `coqc` process at a time
(`make`, no `-j`), inside `coq/finite-readout-acceleration/` on this machine; `docs/RAM_LOW`
was absent before every build/verify step (checked immediately before each `coqc` invocation).

## Files (1)

| File | Build status |
|---|---|
| `formal/FRA_Closures.v` | **PASS** — `coqc -q` (via `make`, `_CoqProject`: `-Q formal FRA`) compiled cleanly, exit 0. No warnings surfaced beyond the file's own 5 `Print Assumptions` outputs. |

## Theorems (6, all from the one file above)

Per manifest `registry/coq_imports.json`'s per-file `theorems` list for this source (6 names).
Each classified by an independent scratch-file `Print Assumptions` check (`From FRA Require
Import FRA_Closures. Print Assumptions <name>.`, one `coqc` process, all 6 in one run), separate
from the file's own trailing 5 `Print Assumptions` calls.

| # | Identifier | Kind | Status | Axioms |
|---|---|---|---|---|
| 1 | `Qdiv_cross_lt` | Lemma | **Closed** | none |
| 2 | `break_even_iff` | Theorem | **Closed** | none |
| 3 | `ceiling_strict` | Theorem | **Closed** | none |
| 4 | `injective_key_slowdown` | Theorem | **Closed** | none |
| 5 | `hit_rate_bounds` | Theorem | **Closed** | none |
| 6 | `bottleneck_ceiling` | Theorem | **Closed** | none |

"Closed" means `Print Assumptions <name>.` printed exactly `Closed under the global context` —
the literal string this project's tier rule requires; no theorem here prints a named axiom.

## Reconciliation with upstream's own claim

Upstream's `README.md` badge/prose claims "Coq 8.20 . 5 theorems axiom-free" — counting only the
5 `Theorem`-keyword results. The manifest's own file-level extraction (`registry/coq_imports.json`)
records 6 `Theorem`/`Lemma`/`Corollary`/`Proposition` names for this file, the extra one being the
`Qdiv_cross_lt` field `Lemma` that every other theorem in the file depends on. The manifest itself
already flags this as "not reconciled" — this verify pass resolves it in the safe direction: it
checked the manifest's full 6-name superset (not just upstream's narrower 5-name headline count)
and found all 6 independently "Closed under the global context." No claim is adopted on say-so;
both counts are stated here and the wider one is what was actually re-verified.

## Summary

- Files: 1/1 built (100%).
- Theorems/Lemmas classified: 6/6 (100% of the manifest's list for this source).
- Closed under the global context: 6/6.
- With named axioms: 0.
- Build failures: 0.

No axioms, no `Admitted`, no build failures for this source.
