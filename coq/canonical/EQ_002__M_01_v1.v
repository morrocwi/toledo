(* EQ-002/M.01.v1 — CAN-165 — Definition — parents: EQ-002/M.03.v1 — occurrences 20 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-165 — root: root-readout-gate (CAN-201) — domain: method —
   tier: Th_coqc / Open — occurrences: 20 *)
(** Phi:X->Z is admissible relative to R:X->Y iff constant on every fiber
    of R (ker R subset ker Phi), equivalently Phi factors as g o R — the
    source's own "Factorization Theorem", instantiating shared device 1
    above. The stochastic form (C = G composed with K-star) and the data-processing
    inequality are recorded as an [Open] scaffold: mutual information is a
    continuum (log-based) quantity with no discrete/[Q] surrogate fixed
    here, so it is left abstract rather than silently imported from
    [Coq.Reals]. The non-collapse companion (R*<>Rtilde: the actual source
    relation need not equal a claimant's model of it) is witnessed on a
    minimal two-valued instance. *)
Definition CAN165_admissible := @mr_admissible.
Definition CAN165_g_of := @mr_g_of.
Definition CAN165_factorization_thm := @mr_factorization_thm.

Definition CAN165_data_processing_inequality_Open
  (T : Type) (MutualInfo : T -> T -> Q) (chain : nat -> T) : Prop :=
  forall j : nat, MutualInfo (chain 0%nat) (chain (S j)) <= MutualInfo (chain 0%nat) (chain j).

Theorem CAN165_source_relation_may_differ_from_model :
  exists R1 R2 : bool -> bool, R1 <> R2.
Proof.
  exists (fun b => b), negb. intro H.
  apply (f_equal (fun f => f true)) in H.
  simpl in H. discriminate.
Qed.

