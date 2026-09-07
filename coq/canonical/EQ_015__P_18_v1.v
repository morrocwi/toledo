(* EQ-015/P.18.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Osterwalder–Schrader reflection positivity via the Gram / transfer-matrix construction (a half-slab amplitude `B` gives a positive kernel `K=B†B⪰0`, i.e. reflection positivity by construction; hidden-midpoint reconstruction) *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: the OS `K=B†B` mechanism is used to make the derived frame-transfer reflection-positive *by construction*; here the half-step amplitudes `b_m=e^{−ε(m)/2}` and the relative-frame weights `p(h)` are this framework's own outputs from `S_UF`, and `ρ_aniso=0.7361824549886` is mechanized (rational root bracket) — `[EXACT FOR DERIVED WEIGHTS]`, uniform gap / interacting-Gram audit OPEN) *)
(* statement (Toledo canonical, latest): Osterwalder–Schrader reflection positivity via the Gram / transfer-matrix construction (a half-slab amplitude B gives a positive kernel K=B^{\dagger}B⪰0, i.e. reflection positivity by construction; hidden-midpoint reconstruction) *)
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

Definition EQ_015__P_18_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
