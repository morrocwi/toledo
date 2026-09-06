(* A.8/M.18.v1 — CAN-213 — Definition — parents: A.8/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-213 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** Epistemic overreach as a three-way disjunction; silent lift is
    defined as exactly its third disjunct (a concealed essential
    augmentation), so "silent lift implies overreach" is a genuine, if
    short, logical inclusion — not a re-tagging. *)
Section CAN213_Overreach.
  Variables LacksAdequatePath AttributedWithoutLicense ConcealsEssentialAugmentation : Prop.
  Definition CAN213_overreach : Prop :=
    LacksAdequatePath \/ AttributedWithoutLicense \/ ConcealsEssentialAugmentation.
  Definition CAN213_silent_lift : Prop := ConcealsEssentialAugmentation.
  Theorem CAN213_silent_lift_is_overreach : CAN213_silent_lift -> CAN213_overreach.
  Proof. intro H. unfold CAN213_overreach. right. right. exact H. Qed.
End CAN213_Overreach.

(* ==================================================================== *)
(** ** Group 3 — the essential-dependency set and its misrouted-defeat
    corollary (CAN-214) *)

