(* A.5/M.26.v1 — CAN-250 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-250 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN250_practiceexperience_not_populationevidence :
  CAN2xx_PracticeExperience <> CAN2xx_PopulationEvidence.
Proof. discriminate. Qed.

