(* EQ-001/P.67.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* geometry stationarity: explicit Theta stepper
   Theta_{n+1} = 2 Theta_n - Theta_{n-1}
                 - dt^2 * (1/M) * (gradU(Theta_n) + K S_Theta,n)
   with gradU(Theta) := Theta/2 (power-rule derivative of U=Theta^2/4,
   an exact algebraic/finite operation on this quadratic, not a
   continuum limit). Exact fixture: Theta_{n-1}=0, Theta_n=1/2, M=2,
   K=1, dt=1, S_Theta=1 -> Theta_{n+1} = 3/8, residual R_Theta = 0. *)
Definition EQ001_P67_gradU (Theta : Q) : Q := Theta / 2.
Definition EQ001_P67_stepper (Theta_n Theta_prev M K dt S_Theta : Q) : Q :=
  2 * Theta_n - Theta_prev - dt * dt * (1 / M) * (EQ001_P67_gradU Theta_n + K * S_Theta).
Definition EQ001_P67_residual (Theta_next Theta_n Theta_prev M K dt S_Theta : Q) : Q :=
  Theta_next - EQ001_P67_stepper Theta_n Theta_prev M K dt S_Theta.

Theorem EQ001_P67_witness :
  EQ001_P67_stepper (1 # 2) 0 2 1 1 1 == 3 # 8 /\
  EQ001_P67_residual (3 # 8) (1 # 2) 0 2 1 1 1 == 0.
Proof.
  split.
  - unfold EQ001_P67_stepper, EQ001_P67_gradU. field.
  - unfold EQ001_P67_residual, EQ001_P67_stepper, EQ001_P67_gradU. field.
Qed.
