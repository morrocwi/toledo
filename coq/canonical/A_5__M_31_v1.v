(* A.5/M.31.v1 — CAN-255 — finite_diagnostic — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-255 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Definition — occurrences: 1 *)
Theorem CAN255_disclosurepenalty_not_concealment :
  CAN2xx_DisclosurePenalty <> CAN2xx_Concealment.
Proof. discriminate. Qed.

Section CAN255_PenaltyChain.
  Variables BetterProvenance BetterHumanDefence VenueFit DisclosurePenaltyHolds : Prop.
  Definition CAN255_penalty_requires : Prop :=
    DisclosurePenaltyHolds -> BetterProvenance /\ BetterHumanDefence /\ VenueFit.
End CAN255_PenaltyChain.

