(* A.5/M.14.v1 — CAN-237 — untagged — parents: A.5/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-237 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 3 *)
Theorem CAN237_mechanical_not_semantic_validity :
  CAN2xx_MechanicalValidity <> CAN2xx_SemanticValidity.
Proof. discriminate. Qed.

