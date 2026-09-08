(* Z/M.10.v1 -- mapped_not_wrapped -> wrapped -- restates lagrange_order_div (information-discrete-math@147fc92671f35eb102405fec913eb361dc41f966:formal/IDM_FiniteWitnesses2.v) -- parents: Z *)
(* name: lagrange_order_div (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (coq/information-discrete-math/verify_report.json: theorems_total 274, theorems_closed 274, theorems_with_axioms 0) -- Print Assumptions output, the corpus's own working definition of Th_coqc.) *)
(* Toledo v1.7 cheap-win lane 1 (IDM wrap): restatement, not a bare
   alias. The type is obtained from Coq's own `type of lagrange_order_div`
   (see scripts/v17_wrap_idm.py's own docstring, following the
   v1.5 lane B precedent in scripts/v15_b.py: a hand-copied type
   text from statement.latest is not always reliable -- trailing
   Coq comments, Section-variable auto-generalization). The proof
   is `exact lagrange_order_div.` against the already-verified IDM mirror
   import below -- no new proof technique, no new claim. *)

From IDM.formal Require Import IDM_FiniteWitnesses2.

Definition Z__M_10_v1_restates_lagrange_order_div_type := ltac:(let t := type of (@lagrange_order_div) in exact t).
Theorem Z__M_10_v1_restates_lagrange_order_div : Z__M_10_v1_restates_lagrange_order_div_type.
Proof. exact (@lagrange_order_div). Qed.

Print Assumptions Z__M_10_v1_restates_lagrange_order_div.
