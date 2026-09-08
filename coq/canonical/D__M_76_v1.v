(* D/M.76.v1 -- mapped_not_wrapped -> wrapped -- restates classify_not_bot_is_determinate (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_ResolvedCount.v) -- parents: D *)
(* name: classify_not_bot_is_determinate (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of classify_not_bot_is_determinate`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact classify_not_bot_is_determinate.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_ResolvedCount.

Definition D__M_76_v1_restates_classify_not_bot_is_determinate_type := ltac:(let t := type of (@classify_not_bot_is_determinate) in exact t).
Theorem D__M_76_v1_restates_classify_not_bot_is_determinate : D__M_76_v1_restates_classify_not_bot_is_determinate_type.
Proof. exact (@classify_not_bot_is_determinate). Qed.

Print Assumptions D__M_76_v1_restates_classify_not_bot_is_determinate.
