(* D/M.13.v1 -- mapped_not_wrapped -> wrapped -- restates approx_count_deferred_lower_bound (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_ApproxCount.v) -- parents: D *)
(* name: approx_count_deferred_lower_bound (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of approx_count_deferred_lower_bound`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact approx_count_deferred_lower_bound.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_ApproxCount.

Definition D__M_13_v1_restates_approx_count_deferred_lower_bound_type := ltac:(let t := type of (@approx_count_deferred_lower_bound) in exact t).
Theorem D__M_13_v1_restates_approx_count_deferred_lower_bound : D__M_13_v1_restates_approx_count_deferred_lower_bound_type.
Proof. exact (@approx_count_deferred_lower_bound). Qed.

Print Assumptions D__M_13_v1_restates_approx_count_deferred_lower_bound.
