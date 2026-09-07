(* EQ-015/P.08.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Fermi coupling `G_F` and `v=(√2 G_F)^{-1/2}` (Higgs vev) *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: `G_F=1.1663787e-5 GeV⁻²` (CODATA 2022) plugged in to fix the scale `v`; calibration input, not derived) *)
(* statement (Toledo canonical, latest): Fermi coupling G_F and v=(\sqrt2 G_F)^{-1/2} (Higgs vev) *)
(* Gap (readout-not-truth, v1.1 lane wrap): registry/coq_map.json's own
   evidence for this reading cites readout_universe's discrete
   Lagrange-d'Alembert forced master theorem (evidence/DRL_Forced_Master.v,
   the EQ-015 trunk equation's own Coq proof) as the general
   discrete-mechanics construct this reading is claimed to specialize from.
   It is NOT a literal Coq restatement of this entry's own statement above --
   no closure of the statement as written is claimed here. What is genuinely
   proved and imported below is the cited theorem itself: for any NoDup node
   list, any symmetric graph weight W, any per-node heterogeneous
   M/D/K2/J/eta, at any node k, the central-difference stationarity of the
   force-augmented discrete action is algebraically equivalent (over Q, no
   approximation) to the full forced master-equation recurrence at that node
   -- Closed under the global context, 0 axioms, per readout_universe's own
   verify_report.json (quoted, not asserted). *)

From URR Require Import DRL_Forced_Master.

Definition EQ_015__P_08_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
