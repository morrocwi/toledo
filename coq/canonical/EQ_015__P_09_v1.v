(* EQ-015/P.09.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Gauge-anomaly cancellation conditions `[SU(3)]²U(1)`, `[SU(2)]²U(1)`, `[grav]²U(1)`, `[U(1)]³` fixing the SM hypercharges *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: the anomaly-cancellation LINEAR SYSTEM is solved on the SM one-generation rep content (a finite BLIND fixture — reps discovered, not fed) to FORCE `q=1/6,ℓ=−1/2,u=2/3,d=−1/3,e=−1`; the cubic `[U(1)]³` anomaly `=0` is mechanized exact. That anomaly cancellation fixes hypercharges is the classical result; here it is re-derived from the discovered rep/coupling graph, not with a fed-in charge list. `[FINITE BLIND]`, not a root derivation of the rep content) *)
(* statement (Toledo canonical, latest): Gauge-anomaly cancellation conditions [SU(3)]^{2}U(1), [SU(2)]^{2}U(1), [grav]^{2}U(1), [U(1)]^{3} fixing the SM hypercharges *)
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

Definition EQ_015__P_09_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
