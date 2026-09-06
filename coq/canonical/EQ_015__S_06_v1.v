(* EQ-015/S.06.v1 — CAN-132 — Definition — parents: EQ-015/M.03.v1 — occurrences 5 *)

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
(** ** CAN-132 — B-SOC-POTENTIAL

    (* CAN-132 — root: p*_{A,g}(h,z;T,B,P)=max_{pi in Pi^wit} Pr^pi_P(...) — domain: social — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(25), already
    formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section PotentialEnvelope], [p_star]/[p_star_upper_bound]).
    Discharged here by aliasing. *)

Definition CAN_132_p_star := @MR_Live.p_star.
Definition CAN_132_p_star_upper_bound := @MR_Live.p_star_upper_bound.

