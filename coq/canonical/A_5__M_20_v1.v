(* A.5/M.20.v1 — CAN-243 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-243 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN243_rawspeed_not_vc : CAN2xx_RawSpeedDown <> CAN2xx_VCDown.
Proof. discriminate. Qed.

