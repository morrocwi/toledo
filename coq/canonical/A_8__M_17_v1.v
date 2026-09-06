(* A.8/M.17.v1 — CAN-212 — Dr — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-212 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Th_coqc — occurrences: 3 *)
(** The Existence-Attribution-Disclosure triad: adequate provenance is
    exactly the conjunction of the three named norms, left abstract as
    Section [Prop]s (each is itself a further per-study predicate, not
    re-derived here); the introduction lemma confirms the conjunction is
    not vacuous. *)
Section CAN212_EAD.
  Variables ExistenceP AttributionP DisclosureP : Prop.
  Definition CAN212_adequate : Prop := ExistenceP /\ AttributionP /\ DisclosureP.
  Theorem CAN212_adequate_intro : ExistenceP -> AttributionP -> DisclosureP -> CAN212_adequate.
  Proof. intros; unfold CAN212_adequate; auto. Qed.
End CAN212_EAD.

