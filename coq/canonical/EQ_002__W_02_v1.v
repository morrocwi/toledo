(* EQ-002/W.02.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Conversion percentile readouts C^10, C^50, C^90 at (j,t) *)
Record EQ002_W02_Percentiles := mkEQ002W02 { w02_c10 : Q; w02_c50 : Q; w02_c90 : Q }.
