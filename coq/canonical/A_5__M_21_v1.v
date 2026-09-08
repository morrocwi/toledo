(* A.5/M.21.v1 — CAN-244 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-244 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN244_lh_lv_not_truth :
  CAN2xx_LH <> CAN2xx_Truth /\ CAN2xx_LV <> CAN2xx_Truth.
Proof. split; discriminate. Qed.

