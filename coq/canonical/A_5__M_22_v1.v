(* A.5/M.22.v1 — CAN-246 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-246 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN246_multiai_consensus_not_geographic_completeness :
  CAN2xx_MultiAIConsensus <> CAN2xx_GeographicCompleteness.
Proof. discriminate. Qed.

