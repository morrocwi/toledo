(* delta_R/M.06.v1 -- mapped_not_wrapped -> wrapped -- restates lookup_graph_in (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_SetsFunctions.v) -- parents: delta_R *)
(* name: lookup_graph_in (Lemma) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of lookup_graph_in`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact lookup_graph_in.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_SetsFunctions.

Definition delta_R__M_06_v1_restates_lookup_graph_in_type := ltac:(let t := type of (@lookup_graph_in) in exact t).
Lemma delta_R__M_06_v1_restates_lookup_graph_in : delta_R__M_06_v1_restates_lookup_graph_in_type.
Proof. exact (@lookup_graph_in). Qed.

Print Assumptions delta_R__M_06_v1_restates_lookup_graph_in.
