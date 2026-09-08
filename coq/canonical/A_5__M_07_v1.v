(* A.5/M.07.v1 — CAN-230 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-230 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN230_credit_not_epistemic_value : CAN2xx_Credit <> CAN2xx_EpistemicValue.
Proof. discriminate. Qed.

