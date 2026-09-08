(* R/P.03.v1 -- mapped_not_wrapped -> wrapped -- restates delta_num_not_perfect_square (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:case_studies/double_pendulum_readout/ShakeIrrational.v) -- parents: R *)
(* name: delta_num_not_perfect_square (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of delta_num_not_perfect_square`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact delta_num_not_perfect_square.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.case_studies.double_pendulum_readout Require Import ShakeIrrational.

Definition R__P_03_v1_restates_delta_num_not_perfect_square_type := ltac:(let t := type of (@delta_num_not_perfect_square) in exact t).
Theorem R__P_03_v1_restates_delta_num_not_perfect_square : R__P_03_v1_restates_delta_num_not_perfect_square_type.
Proof. exact (@delta_num_not_perfect_square). Qed.

Print Assumptions R__P_03_v1_restates_delta_num_not_perfect_square.
