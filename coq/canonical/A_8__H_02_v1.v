(* A.8/H.02.v1 — CAN-089 — Definition — parents: A.8/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-089 — DCP-expand-contract

    (* CAN-089 — root: Expansion:=maximize candidate diversity and discriminability; Contraction:=prune by evidence, provenance, stakes, action relevance — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Both
    named policies are typed as [Prop]-valued predicates on a declared
    candidate-set operation, never asserted of a specific procedure. *)

Section CAN_089_DCPExpandContract.

  Variables CandSetT : Type.
  Variable maximizes_diversity_discriminability : CandSetT -> CandSetT -> Prop.
  Variable prunes_by_evidence_provenance_stakes_relevance : CandSetT -> CandSetT -> Prop.

  Definition CAN_089_is_expansion (before after : CandSetT) : Prop :=
    maximizes_diversity_discriminability before after.

  Definition CAN_089_is_contraction (before after : CandSetT) : Prop :=
    prunes_by_evidence_provenance_stakes_relevance before after.

End CAN_089_DCPExpandContract.

