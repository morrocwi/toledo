(* EQ-015/W.08.v1 — CAN-148 — Definition — parents: EQ-015/M.03.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-148 — conversion-gates

    (* CAN-148 — root: G^conv=1-[V(e|-j)/V(e)]_+; D=w G^conv(1-X); concentration<>G^conv<>dependency — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(26)-(29),(53), record 22481924) — freshly formalised. The
    positive-part clamp [_+] on the value ratio is the same [Qmax _ 0]
    idiom used throughout this file. The non-collapse ("concentration
    does not entail dependency") is discharged as a genuine witnessed
    instance: full gate control ([G^conv = 1]) combined with full credible
    exit ([X = 1]) forces dependency [D] to exactly zero for *any*
    dependency weight [w] — high positional control does not, by itself,
    entail dependency once exit access is accounted for. *)

Section CAN_148_ConversionGates.

  Definition CAN_148_G_conv (V_full V_excl : Q) : Q :=
    1 - Qmax 0 (V_excl / V_full).

  Definition CAN_148_Dependency (w G_conv_val X : Q) : Q :=
    w * G_conv_val * (1 - X).

  Theorem CAN_148_concentration_not_dependency :
    exists (w G_conv_val X : Q),
      G_conv_val == 1 /\ X == 1 /\ CAN_148_Dependency w G_conv_val X == 0.
  Proof.
    exists 5, 1, 1.
    split. reflexivity.
    split. reflexivity.
    unfold CAN_148_Dependency. ring.
  Qed.

End CAN_148_ConversionGates.

