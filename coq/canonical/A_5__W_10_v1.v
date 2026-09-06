(* A.5/W.10.v1 — Definition — parents: A.5/M.01.v1, A.5/W.02.v1 *)

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

Section CAN_154_PowerChannels.

  Variables PEcon PInfo PCoerc State3 : Type.

  Definition PowerVector : Type := PEcon * PInfo * PCoerc.
  Variable F_I : State3 -> PowerVector -> State3.

  (* Idot_t = F_I(P^B_t, P^E_t, state capacity, rules, shocks): the
     institutional trajectory is not predetermined by the power vector
     alone — typed and left un-proved, per the source's own framing. *)
  Definition CAN_154_Open_not_predetermined (s : State3) (p : PowerVector) : Prop :=
    exists s' : State3, F_I s p = s' /\ s' <> s.

End CAN_154_PowerChannels.
