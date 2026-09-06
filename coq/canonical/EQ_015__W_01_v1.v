(* EQ-015/W.01.v1 — CAN-140 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-140 — labour-claim-chain

    (* CAN-140 — root: labour->production->wage->claim on output; labour-claim->citizen claim — domain: world-system — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour Section 1/21, record 22481924) — freshly formalised. The
    weakening industrial bridge and the institutional transition beyond
    it, typed as a closed finite chain of five named stages with a total
    "next" step function, never an open-ended narrative. *)

Inductive LabourClaimStage : Type :=
  | LCS_HumanLabour
  | LCS_Production
  | LCS_Wage
  | LCS_ClaimOnOutput
  | LCS_CitizenClaim.

Definition CAN_140_labour_claim_next (s : LabourClaimStage) : LabourClaimStage :=
  match s with
  | LCS_HumanLabour => LCS_Production
  | LCS_Production => LCS_Wage
  | LCS_Wage => LCS_ClaimOnOutput
  | LCS_ClaimOnOutput => LCS_CitizenClaim
  | LCS_CitizenClaim => LCS_CitizenClaim
  end.

