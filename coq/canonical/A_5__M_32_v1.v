(* A.5/M.32.v1 — CAN-256 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-256 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN256_aicontribution_not_epistemicresponsibility :
  CAN2xx_AIContribution <> CAN2xx_EpistemicResponsibility.
Proof. discriminate. Qed.
