# VERIFY_REPORT — zero-readout-certifies import

Upstream commit: `adfd25a26f78d0568739c364ef2fa416dab881de` (public, MIT). Verified on this machine 2026-09-06. Readout-not-truth: every count below is read from the actual build/verify run recorded in `verify_report.json`, not copied from upstream's own claims.

## Build status (per file)

| file | build |
|---|---|
| `coq/IDM_KeystoneKernel.v` | OK (coqc -q, sequential, one at a time) |
| `coq/Examples.v` | OK (coqc -q, sequential, one at a time) |
| `coq/ReaderTwoLevels.v` | OK (coqc -q, sequential, one at a time) |
| `coq/CheckAssumptions.v` | OK (coqc -q, sequential, one at a time) |

All **4** files compiled cleanly with `coqc -q`, one process at a time (no `make -j`), in the same dependency order as upstream's own `scripts/check_assumptions.sh` (`IDM_KeystoneKernel.v` -> `Examples.v` -> `ReaderTwoLevels.v` -> `CheckAssumptions.v`). No `-Q` logical-path qualification is used anywhere in this source (every `Require Import` is unqualified), so no Toledo-side `_CoqProject`/Makefile was needed -- coqc's default current-directory module search resolved each dependency from the prior step's `.vo`.

A repo-wide grep for forbidden global assumptions (upstream's own `scripts/check_assumptions.sh` check) was independently re-run against the copied tree: `grep -RInE '^[[:space:]]*(Axiom|Axioms|Parameter|Parameters|Conjecture|Conjectures|Admitted|admit)' coq/*.v` -- **no match** (no axiom, parameter, conjecture, or admitted proof anywhere in the imported tree).

## Theorem-level verification (`Print Assumptions`)

**42** identifiers checked (every Theorem/Lemma/Corollary/Proposition the manifest lists for this source, across `IDM_KeystoneKernel.v` and `ReaderTwoLevels.v`; `CheckAssumptions.v` is the audit harness itself and declares none of its own, and `Examples.v`'s 5 results are declared with the `Example` keyword, outside the manifest's Theorem/Lemma/Corollary/Proposition scope) — **42 Closed under the global context**, **0 with named axioms**, **0 build/print failures**.

This is a strict superset of upstream's own `README.md` claim ('38 audited results, axiom-free'): upstream's own `scripts/check_assumptions.sh` runs `Print Assumptions` on only 38 hand-picked identifiers (it omits 9 `IDM_KeystoneKernel.v` lemmas — `Qsq_nonneg`, `Qadd_nonneg`, `Qsq_zero`, `Qplus_nonneg_eq0`, `I_edge_nonneg`, `I_edge_zero_iff`, `I_form_zero_forall`, `edge_gives_reach`, `I_form_ext` — and separately checks 5 further `Example`-keyword results from `Examples.v` that sit outside this source's manifest scope). This Toledo pass independently re-ran `Print Assumptions` on all 42 manifest-listed Theorem/Lemma/Corollary/Proposition identifiers via one scratch file (not upstream's script) and confirms every one of them axiom-free too.

| file | identifier | status | axioms |
|---|---|---|---|
| `coq/IDM_KeystoneKernel.v` | `Qsq_nonneg` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `Qadd_nonneg` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `Qsq_zero` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `Qplus_nonneg_eq0` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `I_edge_nonneg` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `I_edge_zero_iff` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `I_form_zero_forall` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `keystone_zero_iff_edge` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `edge_gives_reach` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `keystone_zero_iff_component` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `I_form_ext` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `kernel_zero` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `kernel_add` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `kernel_scale` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `indist_refl` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `indist_sym` | Closed |  |
| `coq/IDM_KeystoneKernel.v` | `indist_trans` | Closed |  |
| `coq/ReaderTwoLevels.v` | `rr_identity_and_absorbing_collapses` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_acc_left_unit` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_acc_right_unit` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_seq_left_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_seq_right_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_seq_associative` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_two_roles_no_collapse` | Closed |  |
| `coq/ReaderTwoLevels.v` | `recorded_zero_differs_from_boundary` | Closed |  |
| `coq/ReaderTwoLevels.v` | `recorded_zero_allows_next_stage` | Closed |  |
| `coq/ReaderTwoLevels.v` | `boundary_blocks_next_stage` | Closed |  |
| `coq/ReaderTwoLevels.v` | `init_left_unit` | Closed |  |
| `coq/ReaderTwoLevels.v` | `init_right_unit` | Closed |  |
| `coq/ReaderTwoLevels.v` | `accumulator_failure_left_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `accumulator_failure_right_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `accumulator_states_are_distinct` | Closed |  |
| `coq/ReaderTwoLevels.v` | `pipeline_unresolved_left_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `pipeline_unresolved_right_absorbing` | Closed |  |
| `coq/ReaderTwoLevels.v` | `pipeline_seq_associative` | Closed |  |
| `coq/ReaderTwoLevels.v` | `resolved_zero_is_not_unresolved` | Closed |  |
| `coq/ReaderTwoLevels.v` | `resolved_zero_continues_pipeline` | Closed |  |
| `coq/ReaderTwoLevels.v` | `unresolved_stops_pipeline` | Closed |  |
| `coq/ReaderTwoLevels.v` | `total_contract_empty_is_zero` | Closed |  |
| `coq/ReaderTwoLevels.v` | `strict_contract_empty_is_unresolved` | Closed |  |
| `coq/ReaderTwoLevels.v` | `empty_case_depends_on_contract` | Closed |  |
| `coq/ReaderTwoLevels.v` | `failed_accumulator_finalizes_unresolved` | Closed |  |

## Tier classification

All 42 identifiers are **Closed under the global context** — per the task's tier rule, each is classified `Closed`, not merely 'axiom-free' by assertion. No lemma in this source carries a named axiom.

## Redactions

None required. This source is public (`github.com/morrocwi/zero-readout-certifies`); its repository name and URL are safe to state in Toledo's own files. This import never touched the private solver-arc source at all, so its name was never available to leak here. A grep of the copied tree and this report for the private repository's name and for local absolute filesystem paths found no matches (see the redaction grep run recorded in the task's structured summary).
