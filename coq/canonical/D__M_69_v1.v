(* D/M.69.v1 -- mapped_not_wrapped -> wrapped -- restates neutral_is_not_below_sign (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_ReadoutMinimality.v) -- parents: D *)
(* name: neutral_is_not_below_sign (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of neutral_is_not_below_sign`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact neutral_is_not_below_sign.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_ReadoutMinimality.

Definition D__M_69_v1_restates_neutral_is_not_below_sign_type := ltac:(let t := type of (@neutral_is_not_below_sign) in exact t).
Theorem D__M_69_v1_restates_neutral_is_not_below_sign : D__M_69_v1_restates_neutral_is_not_below_sign_type.
Proof. exact (@neutral_is_not_below_sign). Qed.

Print Assumptions D__M_69_v1_restates_neutral_is_not_below_sign.
