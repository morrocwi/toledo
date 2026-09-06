(* A.5/M.09.v1 — CAN-232 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-232 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN232_self_experience_not_general_evidence :
  CAN2xx_SelfExperience <> CAN2xx_GeneralEvidence.
Proof. discriminate. Qed.

