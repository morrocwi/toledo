(* A.5/M.23.v1 — CAN-247 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-247 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN247_doubleblind_bonus_not_requirement :
  CAN2xx_DoubleBlind <> CAN2xx_Requirement.
Proof. discriminate. Qed.

