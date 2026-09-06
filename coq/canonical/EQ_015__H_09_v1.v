(* EQ-015/H.09.v1 — CAN-060 — Definition — parents: EQ-015/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-060 — corrigible-agency-witnessed

    (* CAN-060 — root: p*_{A,g}(h,z;T,B,P)=max_{pi in Pi^wit_A(g;h,z,T,B)} Pr^pi_P(Read cap D cap X cap F) — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition (measurement architecture; empirical
    claims Open)". Direct reuse of [MR_Live.v] eq.(25): [p_star], a finite
    max over a witnessed policy list, together with its proved upper-bound
    fact [p_star_upper_bound]. *)

Definition CAN_060_p_star := MR_Live.p_star.
Definition CAN_060_p_star_upper_bound_witness := MR_Live.p_star_upper_bound.

