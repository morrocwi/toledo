(* A.5/M.25.v1 — CAN-249 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-249 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN249_interventioncreator_not_soleevaluator :
  CAN2xx_InterventionCreator <> CAN2xx_SoleEvaluator.
Proof. discriminate. Qed.

