(* EQ-015/M.12.v1 — CAN-245 — untagged — parents: EQ-015/M.02.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-245 — root: root-stepper (CAN-003) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN245_mission_stepper_not_theta : CAN2xx_MA_n <> CAN2xx_ThetaE.
Proof. discriminate. Qed.

