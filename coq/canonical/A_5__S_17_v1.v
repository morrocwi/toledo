(* A.5/S.17.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.03.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Require Import MR.MR_Live.

(* [duplicate of CBC-01: choice membership] pi^choice_{A,t} in Pi^live_{A,t}(g).
   This is the same formula already formalised at the CBC-01 sibling child
   (A.5/S.14.v1, CAN_128_is_valid_choice) -- restated here under this code's
   own name via a direct alias, per registry occurrence 22357788:CBC-02. *)
Definition A5_S17_v1_choice_membership := @MR_Live.is_valid_choice.
