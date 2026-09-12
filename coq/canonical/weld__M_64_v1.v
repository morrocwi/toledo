(* weld/M.64.v1 — CAN-1300 — Th_coqc — parents: weld/E.06.v1, EQ-002/M.01.v1 — occurrences 0 — sufficiency kernel inclusion *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1300 — Sufficiency kernel inclusion

    For a candidate representation [rho] that is sufficient for a
    relation [R]: [rho(s) = rho(t) -> R s t], i.e. [ker rho subseteq R].
    The corresponding factor-map existence is not duplicated here — it
    is Toledo CAN-165 ([EQ-002/M.01.v1]).

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([T5_sufficiency_kernel_inclusion],
    merged PR #129, axiom-free). Toledo governance: toledo issue #36
    proposal packet, PROP-GRD-04, TG-RFG-01. *)

Definition CAN_1300_sufficiency_kernel_inclusion := @T5_sufficiency_kernel_inclusion.
