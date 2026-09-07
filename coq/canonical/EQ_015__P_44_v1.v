(* EQ-015/P.44.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Neutrino oscillation mass-squared splittings `Delta m^2_21`, `Delta m^2_31` (PMNS-driven flavor oscillation probability depends only on these differences, not absolute masses) *)
(* tier: untagged (fit_calibrated -- use_text: real measured global-fit central values registered `fit_calibrated` (DRIFT_CONTRACT.json DEV-SM-004), normal-ordering convention for `Delta m^2_31`; explicitly NOT an absolute mass value (none exists in real oscillation data) and NOT a seesaw-mechanism connection to `item23_majorana_lift_v1.py`'s Majorana-branch finding, which this file does not attempt) *)
(* statement (Toledo canonical, latest): Neutrino oscillation mass-squared splittings Delta m^2_21, Delta m^2_31 (PMNS-driven flavor oscillation probability depends only on these differences, not absolute masses) *)
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

Definition EQ_015__P_44_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
