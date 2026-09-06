(* EQ-015/W.07.v1 — CAN-146 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

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
(** ** CAN-146 — ownership-accumulation

    (* CAN-146 — root: W^M_{t+1}=(1-delta_W)W^M_t+r^M_tW^M_t+s^cap+T^cap-Tax^cap; current redistribution <> future ownership reproduction — domain: world-system — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(16)-(18), record 22481924) — freshly formalised. The stock-
    flow accumulation stepper is a plain discrete [Q] update (no
    continuum limit); "current redistribution ≠ future ownership
    reproduction" is discharged as a genuine witnessed non-collapse on
    concrete [Q] numbers (not the generic scaffolding above, since the
    source's own numeric shape — a positive transfer that leaves the
    ownership *share* unchanged once the counterparty's own return is
    accounted for — is directly modellable): a positive capital transfer
    [T^cap = 5] to agent [i] (starting wealth 10, growing to 15) leaves
    the beneficial-ownership share unchanged (still 1/2) once the
    counterparty (also starting at 10, growing to 15 via its own return
    rate) is included — a positive redistribution flow does not, by
    itself, move the ownership-share readout. *)

Section CAN_146_OwnershipAccumulation.

  Definition CAN_146_ownership_accumulate
             (delta_W r W s_cap T_cap Tax_cap : Q) : Q :=
    (1 - delta_W) * W + r * W + s_cap + T_cap - Tax_cap.

  Definition CAN_146_ownership_share (W_i W_total : Q) : Q := W_i / W_total.

  Theorem CAN_146_redistribution_not_ownership_reproduction :
    exists (Wi Wother Wi' Wother' Tcap : Q),
      0 < Tcap /\
      Wi' == CAN_146_ownership_accumulate 0 0 Wi 0 Tcap 0 /\
      Wother' == CAN_146_ownership_accumulate 0 (1#2) Wother 0 0 0 /\
      CAN_146_ownership_share Wi (Wi + Wother)
      == CAN_146_ownership_share Wi' (Wi' + Wother').
  Proof.
    exists 10, 10, 15, 15, 5.
    split. lra.
    split. unfold CAN_146_ownership_accumulate. ring.
    split. unfold CAN_146_ownership_accumulate. ring.
    unfold CAN_146_ownership_share. field.
  Qed.

End CAN_146_OwnershipAccumulation.

