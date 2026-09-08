(* A.5/H.18.v1 — CAN-105 — Definition — parents: A.5/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-105 — opportunity-conversion

    (* CAN-105 — root: Omega^real_{i,n}=G_O(Rreturn,Klife,Cred,Net,Perm,MarketReadout); Credential<>Capability; MarketLegibility<>HumanWorth — domain: human–AI — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(75)-(76): [omega_real_75] and the two witnessed non-collapses
    [eq76a]/[eq76b]. *)

Definition CAN_105_omega_real := MR_HCA.omega_real_75.
Definition CAN_105_credential_ne_capability_witness := MR_HCA.eq76a_credential_not_capability.
Definition CAN_105_legibility_ne_worth_witness := MR_HCA.eq76b_market_legibility_not_human_worth.

