(* EQ-001/P.46.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* time dilation / length contraction, following from OA-09 with no new law *)
Definition EQ001_P46_time_dilation (Gamma_R : Q) : Q := 1 / Gamma_R.
Definition EQ001_P46_length_contraction (L0 Gamma_R : Q) : Q := L0 / Gamma_R.
