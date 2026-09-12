(* weld/M.61.v1 — CAN-1297 — Th_coqc — parents: weld — occurrences 0 — Eq-Obs correspondence *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1297 — Eq-Obs correspondence (reader-family / indistinguishability
    Galois connection)

    [E subseteq Obs(R) <-> R subseteq Eq(E)] — the defining Galois-connection
    property between (Family, subseteq) and (Rel, subseteq): a declared
    experiment family [E] is admissible under a state relation [R] iff [R]
    refines the indistinguishability [Eq(E)] induced by [E].

    Imported verbatim (license-compatible, MIT — see
    coq/information-discrete-math/PROVENANCE.json) from
    information-discrete-math's formal/IDM_ReaderDomainFoundation.v
    ([T1_eq_obs_correspondence], merged PR #129, axiom-free). This file
    restates it under its Toledo code only; no proof content is
    re-derived. Toledo governance: registered from toledo issue #36's
    proposal packet (registry/proposals/grd_foundation_v1_theorem_packet.json,
    PROP-GRD-01), TG-RFG-01. *)

Definition CAN_1297_eq_obs_correspondence := @T1_eq_obs_correspondence.
