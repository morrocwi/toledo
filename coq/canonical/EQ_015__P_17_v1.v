(* EQ-015/P.17.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Group-averaging / Reynolds ("twirl") projection onto the invariant subspace `Π(X)=(1/|G|)Σ_{R∈G} RᵀXR`, here for the signed-permutation (hyperoctahedral) group `B₄=(ℤ₂)⁴⋊S₄` ⇒ `Π₄(X)=(Tr X/4)I` *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: standard invariant-averaging used as the coarse frame twirl; here the *meaning* (finite local relation-frame relabelings, not spacetime rotations) and the `ρ_frame=0.858010754588` five-move contraction rate are this framework's own — `[EXACT FOR DECLARED MAP]`, mixing weights from the action OPEN) *)
(* statement (Toledo canonical, latest): Group-averaging / Reynolds ("twirl") projection onto the invariant subspace Π(X)=(1/|G|)\Sigma_{R\inG} R^{T}XR, here for the signed-permutation (hyperoctahedral) group B_{4}=(\mathbb{Z}_{2})^{4}⋊S_{4} ⇒ Π_{4}(X)=(Tr X/4)I *)
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

Definition EQ_015__P_17_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
