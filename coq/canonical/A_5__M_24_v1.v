(* A.5/M.24.v1 — CAN-248 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-248 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 2 *)
Theorem CAN248_k2global_not_k2thai : CAN2xx_K2Global <> CAN2xx_K2Thai.
Proof. discriminate. Qed.

