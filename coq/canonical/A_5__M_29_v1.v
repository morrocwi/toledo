(* A.5/M.29.v1 — CAN-253 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-253 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN253_nohuman_not_researchstop :
  CAN2xx_NoHumanAvailable <> CAN2xx_ResearchStop.
Proof. discriminate. Qed.

