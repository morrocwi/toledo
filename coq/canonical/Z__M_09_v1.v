(* Z/M.09.v1 -- mapped_not_wrapped -> wrapped -- restates summation_by_parts (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_Calculus.v) -- parents: Z *)
(* name: summation_by_parts (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of summation_by_parts`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact summation_by_parts.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_Calculus.

Definition Z__M_09_v1_restates_summation_by_parts_type := ltac:(let t := type of (@summation_by_parts) in exact t).
Theorem Z__M_09_v1_restates_summation_by_parts : Z__M_09_v1_restates_summation_by_parts_type.
Proof. exact (@summation_by_parts). Qed.

Print Assumptions Z__M_09_v1_restates_summation_by_parts.
