(* CMC/M.05.v1 -- mapped_not_wrapped -> wrapped -- restates closure_free_iff_no_named_closure (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_ClosureFree_Exhaustive.v) -- parents: CMC *)
(* name: closure_free_iff_no_named_closure (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of closure_free_iff_no_named_closure` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact closure_free_iff_no_named_closure.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
From MRC Require Import _cmc_mirror_CMC_ClosureFree_Exhaustive.

Definition CMC__M_05_v1_restates_closure_free_iff_no_named_closure_type := ltac:(let t := type of closure_free_iff_no_named_closure in exact t).
Theorem CMC__M_05_v1_restates_closure_free_iff_no_named_closure : CMC__M_05_v1_restates_closure_free_iff_no_named_closure_type.
Proof. exact closure_free_iff_no_named_closure. Qed.

Print Assumptions CMC__M_05_v1_restates_closure_free_iff_no_named_closure.
