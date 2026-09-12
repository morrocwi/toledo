(* weld/M.63.v1 — CAN-1299 — Th_coqc — parents: weld/M.03.v1, weld/M.02.v1 — occurrences 0 — future-equivalence dynamic-weld congruence *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1299 — Future-reader equivalence is stable under a declared
    first action (dynamic weld congruence)

    [s ~_Q t -> F_u(s) ~_Q F_u(t)] — all-future reader equivalence is a
    congruence with respect to every declared action: the relational
    well-definedness condition required before the quotient transition
    [F_u^#] can be named (CAN-006 / weld/M.02.v1 commuting-square
    precondition). Note: [T4_dynamic_weld_well_defined] is proof-identical
    to [T3_future_equivalence_dynamic_stability] and supplies only the
    congruence property; the literal quotient/projection/commuting-square
    instantiation is a separate, already-registered occurrence of CAN-006
    ([T4b_quotient_commuting_square], merged information-discrete-math
    PR #131, recorded as a coq.identifiers cross-reference on CAN-006
    via toledo PR #37).

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([T3_future_equivalence_dynamic_stability],
    [T4_dynamic_weld_well_defined], merged PR #129, axiom-free). Toledo
    governance: toledo issue #36 proposal packet, PROP-GRD-03, TG-RFG-01. *)

Definition CAN_1299_future_equivalence_dynamic_stability := @T3_future_equivalence_dynamic_stability.
Definition CAN_1299_dynamic_weld_well_defined := @T4_dynamic_weld_well_defined.
