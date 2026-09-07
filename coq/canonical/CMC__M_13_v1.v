(* CMC/M.13.v1 -- mapped_not_wrapped -> wrapped -- restates class_witness_not_closure_free (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_ModelClass_Witnesses.v) -- parents: CMC *)
(* name: class_witness_not_closure_free (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact class_witness_not_closure_free.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
From MRC Require Import _cmc_mirror_CMC_ModelClass_Witnesses.

Theorem CMC__M_13_v1_restates_class_witness_not_closure_free : forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> ~ ClosureFree g.
Proof. exact class_witness_not_closure_free. Qed.

Print Assumptions CMC__M_13_v1_restates_class_witness_not_closure_free.
