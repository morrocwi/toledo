(* A.5/S.10.v1 — Definition — parents: A.5/M.01.v1, A.5/S.01.v1 *)

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

Section CAN_121_AgencyHierarchy.

  Variables X C H : Type.
  Variable F : X -> C -> X.

  (* Level 0/1 (Proto-Agency): the constraint update does not depend on
     the state at all — "partial C / partial x = 0" discretely replaced
     as: the update function ignores its state argument. *)
  Definition CAN_121_ProtoAgency (G : X -> C -> C) : Prop :=
    forall (x1 x2 : X) (c : C), G x1 c = G x2 c.

End CAN_121_AgencyHierarchy.
