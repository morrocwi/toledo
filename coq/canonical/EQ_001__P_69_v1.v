(* EQ-001/P.69.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* four named fail states for the geometry stationarity gate *)
Inductive EQ001_P69_FailState :=
  | EQ001_P69_FAIL_GEOMETRY_PIVOT
  | EQ001_P69_FAIL_METRIC_ADMISSIBILITY
  | EQ001_P69_FAIL_NULL_MIXING
  | EQ001_P69_HORIZON_BOUNDARY.
