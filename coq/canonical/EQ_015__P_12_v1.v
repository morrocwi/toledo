(* EQ-015/P.12.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Ginsparg–Wilson relation `{Γ,D}=a D Γ D` (lattice chirality without naïve anticommutation) and the overlap/sign-operator realization `D=(1/ā)(I−V)`, `V=Γε` *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: the GW/overlap MECHANISM is used (explicitly not claimed as new) to give exact modified chirality + no doubling at finite spacing; here `Γ_T`, `V` (rational unitary) and `D_T` are built from this framework's own orientation⊗incidence carrier, and the division-free identity `Γ(I−V)+(I−V)Γ=(I−V)Γ(I−V)` is mechanized over ℚ. `[GW EXACT, FREE FIXTURE]` — interacting gauge measure/positivity/anomaly OPEN) *)
(* statement (Toledo canonical, latest): Ginsparg–Wilson relation {\Gamma,D}=a D \Gamma D (lattice chirality without naïve anticommutation) and the overlap/sign-operator realization D=(1/ā)(I−V), V=\Gamma\varepsilon *)
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

Definition EQ_015__P_12_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
