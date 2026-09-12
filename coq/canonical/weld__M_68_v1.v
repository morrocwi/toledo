(* weld/M.68.v1 — CAN-1305 — Th_coqc — parents: weld/M.03.v1 — occurrences 0 — stable finite-depth equals all-future equivalence *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1305 — Stable finite-depth reader equivalence equals
    all-future reader equivalence

    If depth-n reader equivalence is a fixed point of one more step of
    refinement ([DepthStable(n)]), then depth-n equivalence is exactly
    all-future reader equivalence — a finite, checkable witness for a
    claim that is a priori about infinitely many future steps.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([stable_depth_exact_future],
    merged PR #129, axiom-free). Toledo governance: toledo issue #36
    proposal packet, PROP-GRD-09, TG-RFG-01. *)

Definition CAN_1305_stable_depth_exact_future := @stable_depth_exact_future.
