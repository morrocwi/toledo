(* A.5/M.16.v1 — CAN-239 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-239 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN239_friendship_not_independent_evidence :
  CAN2xx_Friendship <> CAN2xx_IndependentEvidence.
Proof. discriminate. Qed.

