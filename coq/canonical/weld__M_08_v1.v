(* weld/M.08.v1 — CAN-170 — Definition — parents: weld/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-170 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 4 *)
Section CAN170_DiscriminatingActionLoop.
  Variables ActionTy Obs BeliefTy ReaderTy : Type.
  Variable delta_hat : ReaderTy -> ActionTy -> Q.
  Variable delta_star : ActionTy -> Q.
  Definition CAN170_discriminating (i j : ReaderTy) (u : ActionTy) : Prop :=
    delta_hat i u <> delta_hat j u.
  Definition CAN170_local_residual (i : ReaderTy) (u : ActionTy) : Q :=
    delta_hat i u - delta_star u.
End CAN170_DiscriminatingActionLoop.

(* ==================================================================== *)
(** ** Group 3 — provenance ledger, DCP status categories, credit-Goodhart
    guard, and the tier-ledger invariant (CAN-171..174) *)

