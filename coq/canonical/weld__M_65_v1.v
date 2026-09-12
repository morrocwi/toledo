(* weld/M.65.v1 — CAN-1301 — Th_coqc — parents: weld/M.61.v1 — occurrences 0 — question monotonicity *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1301 — Question monotonicity

    [E_A subseteq E_B -> Eq(E_B) subseteq Eq(E_A)] — adding experiments
    can only refine (never coarsen) the induced indistinguishability
    relation.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([T6_question_monotonicity],
    merged PR #129, axiom-free). Toledo governance: toledo issue #36
    proposal packet, PROP-GRD-05, TG-RFG-01. *)

Definition CAN_1301_question_monotonicity := @T6_question_monotonicity.
