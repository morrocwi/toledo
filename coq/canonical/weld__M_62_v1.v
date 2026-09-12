(* weld/M.62.v1 — CAN-1298 — Th_coqc — parents: weld/M.61.v1 — occurrences 0 — reader closure *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1298 — Reader closure: extensive, monotone, idempotent,
    saturation-invariant

    [Cl(E) := Obs(Eq(E))]; the reader-saturation closure operator is
    extensive ([E subseteq Cl(E)]), monotone, idempotent, and leaves the
    induced indistinguishability relation unchanged
    ([Eq(Cl(E)) = Eq(E)]).

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([T2_closure_extensive],
    [T2_closure_monotone], [T2_eq_closure_invariant],
    [T2_closure_idempotent], merged PR #129, axiom-free). Toledo
    governance: toledo issue #36 proposal packet, PROP-GRD-02, TG-RFG-01. *)

Definition CAN_1298_closure_extensive := @T2_closure_extensive.
Definition CAN_1298_closure_monotone := @T2_closure_monotone.
Definition CAN_1298_eq_closure_invariant := @T2_eq_closure_invariant.
Definition CAN_1298_closure_idempotent := @T2_closure_idempotent.
