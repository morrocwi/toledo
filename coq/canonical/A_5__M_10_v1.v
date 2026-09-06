(* A.5/M.10.v1 — CAN-233 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-233 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN233_positional_access_not_population_authority :
  CAN2xx_PositionalAccess <> CAN2xx_PopulationAuthority.
Proof. discriminate. Qed.

