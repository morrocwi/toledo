(* A.5/W.09.v1 -- Definition -- parents: A.5/M.01.v1, A.5/W.02.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Epistemic power P^E_t = P_E( P_t, Gdot^conv, D^H_t, 1 - Gamma^eff_t ) --
   P_E is an unspecified (opaque) function of the four listed arguments. *)
Section A5_W09_v1.
  Variables Pt Gdotconv DHt : Type.
  Variable P_E : Pt -> Gdotconv -> DHt -> Q -> Q.

  Definition A5_W09_v1_epistemic_power (p : Pt) (g : Gdotconv) (d : DHt) (Gamma_eff : Q) : Q :=
    P_E p g d (1 - Gamma_eff).
End A5_W09_v1.
