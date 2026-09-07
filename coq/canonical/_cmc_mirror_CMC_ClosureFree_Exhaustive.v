(* _cmc_mirror_CMC_ClosureFree_Exhaustive.v -- Toledo v1.5 lane B (DEBT #45/CMC).
   Mechanical import-path republication of "solver arc (private)"'s own
   formal/CMC_ClosureFree_Exhaustive.v (commit 961151db33b0491cba8fabade69f594238d33f84,
   registry/coq_imports.json S5 manifest, PROVENANCE.json in
   coq/solver-arc/). The ORIGINAL file at coq/solver-arc/formal/CMC_ClosureFree_Exhaustive.v is
   left byte-identical and untouched -- this is a SEPARATE file, not an edit
   of the mirror.

   Why this file exists: CMC_ClosureFree_Exhaustive.v's own header line(s) read
   "From RDL Require Import <X>." -- correct when CMC_ClosureFree_Exhaustive.v is compiled
   standalone from inside coq/solver-arc/formal/ (that directory's own
   _CoqProject binds "-R . RDL", i.e. RDL = formal/ itself, flat). But
   Toledo's shared coq/canonical/build_sequential.sh and verify.sh already
   bind "-R ../solver-arc RDL" (RECURSIVE over the whole solver-arc tree,
   so formal/ is reachable as RDL.formal.<X>) -- needed by the 210
   q_formal/EQ-015 wrapper files Toledo v1.1 already shipped
   (scripts/v11_wrapa.py), which cannot be renamed. Registering formal/ a
   SECOND time under a flat "RDL" binding in the SAME coqc invocation was
   tested and confirmed to silently override/break the recursive one
   (verified empirically, 2026-09-07: a flat "-Q .../formal RDL" added
   alongside the existing "-R .../solver-arc RDL" remaps formal/ away from
   RDL.formal, breaking every existing RDL.formal.<X> Require in the 210
   already-shipped files) -- so the two conventions cannot coexist in one
   invocation. This file resolves the conflict the only way that touches
   neither the verbatim mirror nor the 210 already-shipped files: it
   republishes CMC_ClosureFree_Exhaustive.v's OWN body, character-for-character identical
   below except that its internal "From RDL Require Import <X>." line(s)
   are rewritten to "From RDL.formal Require Import <X>." (matching the
   ALREADY-WORKING recursive binding) -- no theorem, proof, definition,
   comment, or any other content changed. Diff is exactly the import
   line(s); verify with:
     diff <(sed -n '/^Set Implicit/,$p' CMC_ClosureFree_Exhaustive.v) \
          <(sed -n '/^Set Implicit/,$p' _cmc_mirror_CMC_ClosureFree_Exhaustive.v)
   which is empty. *)

(******************************************************************************)
(* CMC_ClosureFree_Exhaustive.v                                                *)
(*                                                                            *)
(* Finite constructor audit for the CMC refuter burden. A claimed              *)
(* ClosureFree witness must deny every declared ClosureForm constructor.        *)
(******************************************************************************)

From RDL.formal Require Import CMC_TargetClass_Definitions.

Set Implicit Arguments.
Set Asymmetric Patterns.

Definition NoNamedClosure (g : TransportReadout) : Prop :=
  ~ closure_form_present g ScalarRelaxation /\
  ~ closure_form_present g TensorMemory /\
  ~ closure_form_present g TemporalKernel /\
  ~ closure_form_present g SpectralMemory /\
  ~ closure_form_present g OperatorMemory /\
  ~ closure_form_present g PathDelay /\
  ~ closure_form_present g AuxiliaryFluxState /\
  ~ closure_form_present g KineticHiddenState /\
  ~ closure_form_present g NonlinearSupportGenerator /\
  ~ closure_form_present g BoundedPropagator /\
  ~ closure_form_present g GraphLocalStorage /\
  ~ closure_form_present g HiddenNonlocalUpdate.

Theorem closure_free_implies_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g -> NoNamedClosure g.
Proof.
  intros g Hfree.
  repeat split; apply Hfree.
Qed.

Theorem no_named_closure_implies_closure_free :
  forall g : TransportReadout,
    NoNamedClosure g -> ClosureFree g.
Proof.
  intros g Hnone f.
  unfold NoNamedClosure in Hnone.
  destruct f; tauto.
Qed.

Theorem closure_free_iff_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g <-> NoNamedClosure g.
Proof.
  intros g.
  split.
  - apply closure_free_implies_no_named_closure.
  - apply no_named_closure_implies_closure_free.
Qed.

Theorem refuter_burden_expands_to_named_absence :
  forall g : TransportReadout,
    CMC_Refuter_Burden g ->
    CMC_TargetClass g /\ NoNamedClosure g.
Proof.
  intros g Hburden.
  destruct Hburden as [Htarget Hfree].
  split.
  - exact Htarget.
  - exact (closure_free_implies_no_named_closure Hfree).
Qed.

Print Assumptions closure_free_iff_no_named_closure.
Print Assumptions refuter_burden_expands_to_named_absence.
