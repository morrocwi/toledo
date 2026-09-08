(* Q/M.02.v1 -- mapped_not_wrapped -> wrapped -- restates Sum_plus (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_Matrix.v) -- parents: Q *)
(* name: Sum_plus (Lemma) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of Sum_plus`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact Sum_plus.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_Matrix.

Definition Q__M_02_v1_restates_Sum_plus_type := ltac:(let t := type of (@Sum_plus) in exact t).
Lemma Q__M_02_v1_restates_Sum_plus : Q__M_02_v1_restates_Sum_plus_type.
Proof. exact (@Sum_plus). Qed.

Print Assumptions Q__M_02_v1_restates_Sum_plus.
