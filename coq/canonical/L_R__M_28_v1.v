(* L_R/M.28.v1 -- mapped_not_wrapped -> wrapped -- restates schur_pivots_are_boundary_and_complement (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_Schur.v) -- parents: L_R *)
(* name: schur_pivots_are_boundary_and_complement (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of schur_pivots_are_boundary_and_complement`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact schur_pivots_are_boundary_and_complement.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_Schur.

Definition L_R__M_28_v1_restates_schur_pivots_are_boundary_and_complement_type := ltac:(let t := type of (@schur_pivots_are_boundary_and_complement) in exact t).
Theorem L_R__M_28_v1_restates_schur_pivots_are_boundary_and_complement : L_R__M_28_v1_restates_schur_pivots_are_boundary_and_complement_type.
Proof. exact (@schur_pivots_are_boundary_and_complement). Qed.

Print Assumptions L_R__M_28_v1_restates_schur_pivots_are_boundary_and_complement.
