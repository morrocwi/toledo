(* A.5/M.27.v1 — CAN-251 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-251 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN251_at_not_ctscholarly : CAN2xx_At <> CAN2xx_CtScholarly.
Proof. discriminate. Qed.

