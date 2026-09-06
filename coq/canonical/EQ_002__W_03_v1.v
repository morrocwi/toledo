(* EQ-002/W.03.v1 — Definition — parents: EQ-002/M.03.v1, EQ-002/W.01.v1 *)
(* also carries the Coq apparatus for the founder-excluded prose member '22481926:Proposition 4' (broad human expansion requires conversion gains across the distribution -- CAN_164_Open_proposition4_broad_expansion) -- ruled not_an_equation, so it carries no child code of its own; its (deliberately un-proved, Open) declaration is kept here, disclosed, since it is stated directly over the percentile readouts I_H already formalises. *)

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

Section CAN_164_DistributionalConversion.

  Definition CAN_164_I_H (C_10 C_90 : Q) : Q := C_90 - C_10.

  Definition CAN_164_Open_proposition4_broad_expansion
             (C_10_t C_10_t' C_90_t C_90_t' : Q) : Prop :=
    (0 < C_10_t' - C_10_t) /\ (0 < C_90_t' - C_90_t).

End CAN_164_DistributionalConversion.
