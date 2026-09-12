(* EQ-001/C.18.v1 — CAN-1304 — Th_coqc — parents: EQ-001/C.05.v1 (repairs) — occurrences 0 — safe finite strict-refinement termination *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1304 — Safe finite strict-refinement termination
    (bounded-block-growth kernel; C.05 repair)

    If a partition's block count is bounded by [N] and every non-closed
    refinement step strictly increases the block count (with closedness
    decidable), then repeated refinement reaches a closed partition
    after finitely many steps. Proved by bounded strict growth
    (pigeonhole); no termination assumption is smuggled into the
    premise.

    This repairs, but does not force-close, EQ-001/C.05.v1: that code's
    current wrapper (coq/canonical/EQ_001__C_05_v1.v) quantifies over
    arbitrary [refine_step]/[is_closed] and states unconditional
    termination, which is not provable as written (e.g. [is_closed]
    always false gives no witness). This code registers the strengthened
    statement with explicit finite-bound and strict-growth hypotheses as
    a superseding proposal, per toledo issue #36's own instruction: "mark
    current C.05 v1 as imprecise/superseded only through normal registry
    tooling if the review agrees" — that supersession decision is a
    separate step, not made by this file's mere registration.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v
    ([finite_strict_refinement_terminates], merged PR #129, axiom-free).
    Toledo governance: toledo issue #36 proposal packet, PROP-GRD-08,
    TG-RFG-01. *)

Definition CAN_1304_finite_strict_refinement_terminates := @finite_strict_refinement_terminates.
