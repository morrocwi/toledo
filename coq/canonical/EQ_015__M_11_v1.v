(* EQ-015/M.11.v1 — CAN-211 — Definition — parents: EQ-015/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-211 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 4 *)
(** The source's own four-part taxonomy of ways an epistemic basis can be
    augmented (access, contrast/relevance, inferential commitment,
    decision-policy) as a closed finite [Inductive], pairwise distinct by
    construction. *)
Inductive CAN211_AugmentationKind :=
  | CAN211_AccessAug | CAN211_ContrastAug | CAN211_InferentialAug | CAN211_DecisionPolicyAug.

Theorem CAN211_kinds_pairwise_distinct :
  CAN211_AccessAug <> CAN211_ContrastAug
  /\ CAN211_ContrastAug <> CAN211_InferentialAug
  /\ CAN211_InferentialAug <> CAN211_DecisionPolicyAug
  /\ CAN211_AccessAug <> CAN211_DecisionPolicyAug.
Proof. repeat split; discriminate. Qed.

Section CAN211_Grammar.
  Variables Y1 Y2 Xty : Type.
  Definition CAN211_access_aug (y1 : Y1) (y2 : Y2) : Y1 * Y2 := (y1, y2).
  Definition CAN211_contrast_aug (Xsub : Xty -> Prop) : Xty -> Prop := Xsub.
  Variables DecisionState Action : Type.
  Variable decision_policy : DecisionState -> Action.
  Definition CAN211_decision_policy_aug := decision_policy.
End CAN211_Grammar.

(* ==================================================================== *)
(** ** Group 2 — provenance-adequacy norms and their two named failure
    modes (CAN-212, CAN-213) *)

