(* A.5/M.08.v1 — CAN-231 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-231 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN231_friction_not_fellowship : CAN2xx_Friction <> CAN2xx_Fellowship.
Proof. discriminate. Qed.

