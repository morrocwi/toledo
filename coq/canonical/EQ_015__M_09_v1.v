(* EQ-015/M.09.v1 — CAN-199 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-199 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 3 *)
(** Coupled brain-body / mind-core dynamics, neither alone: a mutually
    recursive pair of finite [Q]-valued sequences, each step folding in
    the other's coupling term — the discrete surrogate for
    B[t+1]=F(B[t])+C_H(H[t]), H[t+1]=G(H[t])+C_B(B[t]). *)
Section CAN199_MindBodyCoupling.
  Variable F199 G199 C_H199 C_B199 : Q -> Q.

  Fixpoint CAN199_B (B0 H0 : Q) (t : nat) : Q :=
    match t with
    | O => B0
    | S t' => F199 (CAN199_B B0 H0 t') + C_H199 (CAN199_H B0 H0 t')
    end
  with CAN199_H (B0 H0 : Q) (t : nat) : Q :=
    match t with
    | O => H0
    | S t' => G199 (CAN199_H B0 H0 t') + C_B199 (CAN199_B B0 H0 t')
    end.

  Variable R199 : Q -> Q -> Q.
  Definition CAN199_E (B0 H0 : Q) (t : nat) : Q := R199 (CAN199_B B0 H0 t) (CAN199_H B0 H0 t).
End CAN199_MindBodyCoupling.

