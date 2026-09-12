(* weld/M.66.v1 — CAN-1302 — Th_coqc — parents: weld/M.61.v1 — occurrences 0 — joint-question intersection *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1302 — Joint-question intersection

    [Eq(E_A union E_B) = Eq(E_A) intersect Eq(E_B)] — the
    indistinguishability induced by the union of two experiment families
    is exactly the intersection of the two separately-induced relations.
    This does not silently create any mixed/joint intervention — mixed-
    action experiments must be declared explicitly.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v
    ([T7_joint_question_intersection], merged PR #129, axiom-free).
    Toledo governance: toledo issue #36 proposal packet, PROP-GRD-06,
    TG-RFG-01. *)

Definition CAN_1302_joint_question_intersection := @T7_joint_question_intersection.
