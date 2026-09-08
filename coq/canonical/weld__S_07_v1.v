(* weld/S.07.v1 — CAN-125 — Definition — parents: weld/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-125 — DCP-relational-route

    (* CAN-125 — root: Experience->Interpretations->Absent Perspective->Observable Evidence->Direct Human Conversation — domain: social — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". Where the primary source (another
    person's mind) is unavailable to AI, route back to direct human
    conversation. Discrete replacement: the five named stages are a
    five-constructor [Inductive] with an injective [nat] index — exactly
    [MRC_root_spine.v]'s [CAN_004_Stage]/[CAN_004_index] pattern — never an
    informal prose ordering. *)

Inductive CAN_125_DCPStage : Type :=
  | DCP_Experience | DCP_Interpretations | DCP_AbsentPerspective
  | DCP_ObservableEvidence | DCP_DirectHumanConversation.

Definition CAN_125_index (s : CAN_125_DCPStage) : nat :=
  match s with
  | DCP_Experience => 0 | DCP_Interpretations => 1
  | DCP_AbsentPerspective => 2 | DCP_ObservableEvidence => 3
  | DCP_DirectHumanConversation => 4
  end.

Theorem CAN_125_index_injective :
  forall s1 s2 : CAN_125_DCPStage, CAN_125_index s1 = CAN_125_index s2 -> s1 = s2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

Theorem CAN_125_route_is_strictly_ordered :
  (CAN_125_index DCP_Experience < CAN_125_index DCP_Interpretations)%nat /\
  (CAN_125_index DCP_Interpretations < CAN_125_index DCP_AbsentPerspective)%nat /\
  (CAN_125_index DCP_AbsentPerspective < CAN_125_index DCP_ObservableEvidence)%nat /\
  (CAN_125_index DCP_ObservableEvidence < CAN_125_index DCP_DirectHumanConversation)%nat.
Proof. simpl. repeat split; lia. Qed.

