(* A.5/W.08.v1 -- Definition -- parents: A.5/M.01.v1, A.5/W.02.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Bargaining power P^B_t proportional-to Gamma^eff_t A^corr_(H,t)
   Lambda^live_(H,t) X^H_t r^H_t -- a proportionality claim, formalised as
   existence of a (state-independent) proportionality constant. *)
Definition A5_W08_v1_proportional (P_B Gamma_eff A_corr Lambda_live X_H r_H : Q) : Prop :=
  exists k : Q, P_B == k * (Gamma_eff * A_corr * Lambda_live * X_H * r_H).
