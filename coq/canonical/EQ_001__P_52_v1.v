(* EQ-001/P.52.v1 -- Toledo v1.1 lane B2 -- Th_coqc *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* curvature certificate K_C = U_C(loop) - I: loop transport failing to
   commute. Kept abstract (no specific loop-composition convention
   asserted, to avoid guessing an unverified sign/order convention). *)
Definition EQ001_P52_curvature
  (V : Type) (loop_holonomy identity_action : V -> V) (sub : V -> V -> V) (phi : V)
  : V :=
  sub (loop_holonomy phi) (identity_action phi).
