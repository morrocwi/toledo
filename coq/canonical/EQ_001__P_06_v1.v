(* EQ-001/P.06.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* spine characteristic equation: M s^2 + D s + K lambda = 0 *)
Definition EQ001_P06_char (M D K s lambda : Q) : Q := M * s * s + D * s + K * lambda.
