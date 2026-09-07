(* EQ-015/S.55.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015/M.03.v1, EQ-015/S.06.v1 *)
(* name: Chain-rule decomposition p_{A,g}(pi)=r*d*x*f *)
(* tier: Definition (definition) *)
(* statement (Toledo canonical, latest): p_{A,g}(π) = r·d·x·f, with r = Pr(Rg), d = Pr(Dg|Rg), x = Pr(Xg|Rg,Dg), f = Pr(Fg|Rg,Dg,Xg) *)
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

Definition EQ_015__S_55_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
