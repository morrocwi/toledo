(* weld/M.69.v1 — CAN-1306 — Th_coqc — parents: weld/M.61.v1, weld/M.62.v1 — occurrences 0 — constructive firewall *)

Require Import IDM.formal.IDM_ReaderDomainFoundation.

(* ==================================================================== *)
(** ** CAN-1306 — Constructive firewall: A_con subseteq A_sem and
    constructive-closure invariance

    A bookkeeping/closure fact about which sub-family of experiments
    [EqOf] is allowed to range over once membership is filtered by an
    abstract, uninterpreted resource predicate [Constructive]. No
    P-vs-NP-shaped claim, no computational-hardness premise or
    conclusion; domain instantiation of [Constructive] is a separate
    obligation. Not to be confused with the unrelated, still-open
    toledo registry/proposals/semantic_closure_accounting_p_vs_np_v0_1.json
    ([PROP-SCA-PNP-01..06]) cluster, which shares vocabulary but no
    theorem/proof/object.

    Imported verbatim (MIT) from information-discrete-math's
    formal/IDM_ReaderDomainFoundation.v ([A_con_subseteq_A_sem],
    [constructive_closure_invariant], merged PR #133, axiom-free).
    Toledo governance: toledo issue #36 proposal packet, PROP-GRD-10,
    TG-RFG-01. Genuinely new — no existing Toledo object covers this
    (confirmed by an ultracode Workflow reuse-pipeline lookup before it
    was written upstream). *)

Definition CAN_1306_A_con_subseteq_A_sem := @A_con_subseteq_A_sem.
Definition CAN_1306_constructive_closure_invariant := @constructive_closure_invariant.
