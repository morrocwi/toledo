(* EQ-001/P.23.v1 -- Toledo v1.1 lane B2 -- Open *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* quantum quotient q_Q: the commuting-square condition
   q_Q o F_full = F_Q o q_Q has NOT been proven or witnessed -- stated as
   an open Prop over abstract carriers, matching the source's own claim
   that this is unproved. *)
Definition EQ001_P23_hyp
  (A B : Type) (q_Q : A -> B) (F_full : A -> A) (F_Q : B -> B) : Prop :=
  forall x, q_Q (F_full x) = F_Q (q_Q x).
