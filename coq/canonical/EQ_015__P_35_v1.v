(* EQ-015/P.35.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: One-loop non-abelian gauge β-function with matter, `b_a = (11/3)C₂(G_a) − (2/3)ΣT_a(R_fermion) − (1/3)ΣT_a(R_scalar)` (the `11/3, 2/3, 1/3` kinematic weights are the gauge-boson+ghost, Weyl-fermion, and complex-scalar one-loop vacuum-polarization contributions) *)
(* tier: finite_diagnostic (finite_diagnostic -- use_text: the three kinematic weights (`11/3,2/3,1/3`) are used as an EXPLICITLY EXTERNAL, NOT-derived input (item 25/26's still-open "gauge-orbit fluctuation Hessian" machinery would be needed to derive them); this project's own contribution is recomputing the GROUP-THEORY half (`C₂(G_a)`, `ΣT_a(R)`) exactly from this repo's own already-fixed SU(3)×SU(2)×U(1) matter content and confirming the combination reproduces the real SM values `b3=7, b2=19/6, b1=−41/10` — `finite_diagnostic`, not a derivation of the weights themselves) *)
(* statement (Toledo canonical, latest): One-loop non-abelian gauge \beta-function with matter, b_a = (11/3)C_{2}(G_a) − (2/3)\SigmaT_a(R_fermion) − (1/3)\SigmaT_a(R_scalar) (the 11/3, 2/3, 1/3 kinematic weights are the gauge-boson+ghost, Weyl-fermion, and complex-scalar one-loop vacuum-polarization contributions) *)
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

Definition EQ_015__P_35_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
