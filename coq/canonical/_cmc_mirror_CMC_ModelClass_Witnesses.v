(* _cmc_mirror_CMC_ModelClass_Witnesses.v -- Toledo v1.5 lane B (DEBT #45/CMC).
   Mechanical import-path republication of "solver arc (private)"'s own
   formal/CMC_ModelClass_Witnesses.v (commit 961151db33b0491cba8fabade69f594238d33f84,
   registry/coq_imports.json S5 manifest, PROVENANCE.json in
   coq/solver-arc/). The ORIGINAL file at coq/solver-arc/formal/CMC_ModelClass_Witnesses.v is
   left byte-identical and untouched -- this is a SEPARATE file, not an edit
   of the mirror.

   Why this file exists: CMC_ModelClass_Witnesses.v's own header line(s) read
   "From RDL Require Import <X>." -- correct when CMC_ModelClass_Witnesses.v is compiled
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
   republishes CMC_ModelClass_Witnesses.v's OWN body, character-for-character identical
   below except that its internal "From RDL Require Import <X>." line(s)
   are rewritten to "From RDL.formal Require Import <X>." (matching the
   ALREADY-WORKING recursive binding) -- no theorem, proof, definition,
   comment, or any other content changed. Diff is exactly the import
   line(s); verify with:
     diff <(sed -n '/^Set Implicit/,$p' CMC_ModelClass_Witnesses.v) \
          <(sed -n '/^Set Implicit/,$p' _cmc_mirror_CMC_ModelClass_Witnesses.v)
   which is empty. *)

(******************************************************************************)
(* CMC_ModelClass_Witnesses.v                                                  *)
(*                                                                            *)
(* Axiom-free bookkeeping theorems for concrete model-class closure witnesses. *)
(* These theorems do not claim that a real physical system belongs to a class; *)
(* they prove that once a class supplies its witness form, it cannot be a CMC   *)
(* refuter.                                                                    *)
(******************************************************************************)

From RDL.formal Require Import CMC_TargetClass_Definitions.

Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive WitnessModelClass : Type :=
| CattaneoTelegraphClass
| KineticProjectionClass
| WaveBoundedPropagatorClass
| FluxLimitedClass
| GraphLocalRetainedClass
| KernelMemoryClass
| OperatorMemoryClass.

Definition primary_witness_form (c : WitnessModelClass) : ClosureForm :=
  match c with
  | CattaneoTelegraphClass => AuxiliaryFluxState
  | KineticProjectionClass => KineticHiddenState
  | WaveBoundedPropagatorClass => BoundedPropagator
  | FluxLimitedClass => NonlinearSupportGenerator
  | GraphLocalRetainedClass => GraphLocalStorage
  | KernelMemoryClass => TemporalKernel
  | OperatorMemoryClass => OperatorMemory
  end.

Definition ClassWitness (c : WitnessModelClass) (g : TransportReadout) : Prop :=
  CMC_TargetClass g /\ closure_form_present g (primary_witness_form c).

Theorem class_witness_has_nonzero_closure :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> NonzeroClosure g.
Proof.
  intros c g Hclass.
  destruct Hclass as [_ Hpresent].
  exists (primary_witness_form c).
  exact Hpresent.
Qed.

Theorem class_witness_not_closure_free :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> ~ ClosureFree g.
Proof.
  intros c g Hclass.
  apply nonzero_closure_not_closure_free.
  exact (class_witness_has_nonzero_closure Hclass).
Qed.

Theorem class_witness_blocks_refuter :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> CMC_Refuter_Burden g -> False.
Proof.
  intros c g Hclass Hburden.
  destruct Hburden as [_ Hfree].
  exact (class_witness_not_closure_free Hclass Hfree).
Qed.

Definition FourierMemorylessFace (g : TransportReadout) : Prop :=
  diffusion_positive g /\ ClosureFree g /\ ~ intrinsic_finite_speed g.

Theorem fourier_memoryless_face_not_target :
  forall g : TransportReadout,
    FourierMemorylessFace g -> ~ CMC_TargetClass g.
Proof.
  intros g Hfourier Htarget.
  destruct Hfourier as [_ [_ Hnot_intrinsic]].
  unfold CMC_TargetClass in Htarget.
  destruct Htarget as [_ [_ [_ [_ [Hintrinsic _]]]]].
  exact (Hnot_intrinsic Hintrinsic).
Qed.

Print Assumptions class_witness_blocks_refuter.
Print Assumptions fourier_memoryless_face_not_target.
