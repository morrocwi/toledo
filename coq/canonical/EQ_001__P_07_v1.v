(* EQ-001/P.07.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* oscillatory-regime split: lambda_c = D^2 / (4 M K); disc(lambda) =
   D^2 - 4 M K lambda. Exact rational witness M=D=K=1: lambda_c=1/4;
   lambda=1 gives disc=-3 (oscillatory); lambda=1/8 gives disc=1/2
   (overdamped); lambda=lambda_c gives disc=0 (critical). *)
Definition EQ001_P07_lambda_c (M D K : Q) : Q := (D * D) / (4 * M * K).
Definition EQ001_P07_disc (M D K lambda : Q) : Q := D * D - 4 * M * K * lambda.

Theorem EQ001_P07_witness :
  EQ001_P07_lambda_c 1 1 1 == 1 # 4 /\
  EQ001_P07_disc 1 1 1 1 == -3 /\
  EQ001_P07_disc 1 1 1 (1 # 8) == 1 # 2 /\
  EQ001_P07_disc 1 1 1 (EQ001_P07_lambda_c 1 1 1) == 0.
Proof.
  unfold EQ001_P07_lambda_c, EQ001_P07_disc. repeat split; lra.
Qed.
