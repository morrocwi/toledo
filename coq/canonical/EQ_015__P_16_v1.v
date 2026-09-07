(* EQ-015/P.16.v1 — wrapped_related — wraps evidence/DRL_Forced_Master.v.discrete_Lagrange_d_Alembert_forced_master_theorem — parents: EQ-015 *)
(* name: Gatto–Sartori–Tonin relation `sin θ_C ≈ √(m_d/m_s)` (Cabibbo angle from the down-type quark mass ratio)|R. Gatto, G. Sartori, M. Tonin|1968 *)
(* tier: untagged (fit_calibrated -- use_text: =0.2250±0.0004` (0.62% relative error). Tier `fit_calibrated` per `DRIFT_CONTRACT.json` DEV-SM-003 — FITTED (borrowed 1968 formula + real PDG masses), not derived from the root; consistent-with, not forced-by. Citation verified via primary-source search 2026-07-24: *Phys. Lett.* 28B, 128–130, DOI `10.1016/0370-2693(68)90150-0`) *)
(* statement (Toledo canonical, latest): Gatto–Sartori–Tonin relation sin \theta_C \approx \sqrt(m_d/m_s) (Cabibbo angle from the down-type quark mass ratio)|R. Gatto, G. Sartori, M. Tonin|1968 *)
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

Definition EQ_015__P_16_v1_reads := discrete_Lagrange_d_Alembert_forced_master_theorem.
