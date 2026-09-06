(* A.5/M.11.v1 — CAN-234 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-234 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN234_community_trust_not_representativeness :
  CAN2xx_CommunityTrust <> CAN2xx_Representativeness.
Proof. discriminate. Qed.

