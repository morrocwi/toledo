(* A.5/M.28.v1 — CAN-252 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-252 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN252_mattention_not_mtruth_mk2 :
  CAN2xx_MAttention <> CAN2xx_MTruth /\ CAN2xx_MAttention <> CAN2xx_MK2.
Proof. split; discriminate. Qed.

