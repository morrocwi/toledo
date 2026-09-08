(* L_R/M.08.v1 -- mapped_not_wrapped -> wrapped -- restates orient_coincident_bc (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_Geometry.v) -- parents: L_R *)
(* name: orient_coincident_bc (Lemma) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of orient_coincident_bc`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact orient_coincident_bc.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_Geometry.

Definition L_R__M_08_v1_restates_orient_coincident_bc_type := ltac:(let t := type of (@orient_coincident_bc) in exact t).
Lemma L_R__M_08_v1_restates_orient_coincident_bc : L_R__M_08_v1_restates_orient_coincident_bc_type.
Proof. exact (@orient_coincident_bc). Qed.

Print Assumptions L_R__M_08_v1_restates_orient_coincident_bc.
