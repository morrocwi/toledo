(* A.5/S.03.v1 — CAN-128 — Definition — parents: A.5/M.01.v1 — occurrences 7 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-128 — B-SOC-LIVEPOSS

    (* CAN-128 — root: Pi^live subseteq Pi^feas subseteq Pi^phys; possible<>feasible<>live<>chosen<>enacted<>observed — domain: social — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(19)-(24),
    already formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section LivePossibility]/[Section EnactmentObservation]). Discharged
    here by aliasing, never redefining. *)

Definition CAN_128_Pi_live := @MR_Live.Pi_live.
Definition CAN_128_live_field := @MR_Live.live_field.
Definition CAN_128_is_valid_choice := @MR_Live.is_valid_choice.
Definition CAN_128_live_full_nesting := @MR_Live.eq19_full_nesting.
Definition CAN_128_enactment_may_differ_from_choice := @MR_Live.eq23_enactment_may_differ_from_choice.
Definition CAN_128_observation_loses_information := @MR_Live.eq23_observation_loses_information.
Definition CAN_128_six_level_non_collapse := @MR_Live.eq24_stage_chain_non_collapse.

