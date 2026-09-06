(* A.8/M.19.v1 — CAN-215 — Definition — parents: A.8/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-215 — root: historical-invariance (CAN-009) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
(** The worked Bayes example: P(D|+) = 0.90*0.01 / (0.90*0.01+0.09*0.99),
    checked exactly against its reduced fraction 10/109 (approx 0.0917) by
    a decidable [Q] computation, never a floating approximation. *)
Definition CAN215_p_D_given_pos : Q :=
  ((9#10) * (1#100)) / (((9#10) * (1#100)) + ((9#100) * (99#100))).

Theorem CAN215_bayes_value : Qeq_bool CAN215_p_D_given_pos (10#109) = true.
Proof. vm_compute. reflexivity. Qed.

