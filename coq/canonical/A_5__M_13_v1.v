(* A.5/M.13.v1 — CAN-236 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-236 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN236_many_models_not_independence :
  CAN2xx_ManyModels <> CAN2xx_Independence.
Proof. discriminate. Qed.

