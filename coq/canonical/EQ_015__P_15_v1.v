(* EQ-015/P.15.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Unitary `N×N` quark-mixing-matrix physical-parameter counting (`N²` real params, `2N−1` removable by phase redefinition ⇒ `(N−1)²` physical, split into `N(N−1)/2` mixing angles + `(N−1)(N−2)/2` CP-violating phases; nonzero phase count requires `N≥3`) *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: the standard parameter-counting identity is used, exactly computed over the integers (plain Python `int`, no fractional values arise) for `N=0..6`, to show `phase_count(N)=0` for `N<3` and `≥1` for `N≥3`; combined (fit_calibrated, per `DRIFT_CONTRACT.json` DEV-SM-002) with the externally-OBSERVED fact that CP violation exists and this framework's own minimality-selection STYLE to select `N=3` as the smallest count consistent with observation — explicitly NOT a re-derivation of the KM mechanism itself, and explicitly NOT the same strength of "minimal" as `SM_INFORMATION_PHILOSOPHY_MASTER.md` §2.2/§3.1 (there, smaller values are mathematically impossible; here, smaller `N` is merely inconsistent with an observation)) *)
(* statement (Toledo canonical, latest): Unitary N\timesN quark-mixing-matrix physical-parameter counting (N^{2} real params, 2N−1 removable by phase redefinition ⇒ (N−1)^{2} physical, split into N(N−1)/2 mixing angles + (N−1)(N−2)/2 CP-violating phases; nonzero phase count requires N\ge3) *)
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

Definition EQ_015__P_15_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
