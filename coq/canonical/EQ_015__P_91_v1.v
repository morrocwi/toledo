(* EQ-015/P.91.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Rotational dynamics: `τ=Iα`, `L=Iω`, `KE=½Iω²`, and standard moment-of-inertia forms (rod, disc, sphere, hoop) *)
(* tier: untagged (textbook_closure -- use_text: numeric closures, `textbook_closure`) *)
(* statement (Toledo canonical, latest): Rotational dynamics: \tau=I\alpha, L=I\omega, KE=\tfrac{1}{2}I\omega^{2}, and standard moment-of-inertia forms (rod, disc, sphere, hoop) *)
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

Definition EQ_015__P_91_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
