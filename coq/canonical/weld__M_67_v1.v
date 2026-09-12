(* weld/M.67.v1 — CAN-1303 — Th_coqc — parents: weld/M.62.v1 — occurrences 0 — closed-reader binary meet/join laws *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1303 — Closed-reader binary meet/join laws

    Under a fixed admissible experiment universe, closed reader families
    form a binary meet/join structure: closure is itself closed, the
    intersection of two closed families is closed (binary meet), and the
    closure of the union of two families is closed (binary join). No
    claim is made that every domain-specific bridge exists.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([closure_is_closed],
    [closed_intersection], [closed_join], merged PR #129, axiom-free).
    Toledo governance: toledo issue #36 proposal packet, PROP-GRD-07,
    TG-RFG-01. *)

Definition CAN_1303_closure_is_closed := @closure_is_closed.
Definition CAN_1303_closed_intersection := @closed_intersection.
Definition CAN_1303_closed_join := @closed_join.
