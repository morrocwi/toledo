(* R/M.17.v1 -- mapped_not_wrapped -> wrapped -- restates q01_le (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_Certified.v) -- parents: R *)
(* name: q01_le (Lemma) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of q01_le`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact q01_le.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_Certified.

Definition R__M_17_v1_restates_q01_le_type := ltac:(let t := type of (@q01_le) in exact t).
Lemma R__M_17_v1_restates_q01_le : R__M_17_v1_restates_q01_le_type.
Proof. exact (@q01_le). Qed.

Print Assumptions R__M_17_v1_restates_q01_le.
