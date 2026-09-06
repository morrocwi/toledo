(* A.5/M.15.v1 — CAN-238 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-238 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN238_source_existence_not_claim_support :
  CAN2xx_SourceExistence <> CAN2xx_ClaimSupport.
Proof. discriminate. Qed.

