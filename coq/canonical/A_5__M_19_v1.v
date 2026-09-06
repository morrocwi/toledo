(* A.5/M.19.v1 — CAN-242 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-242 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN242_activation_action_not_credit_event :
  CAN2xx_ActivationAction <> CAN2xx_CreditEvent.
Proof. discriminate. Qed.

