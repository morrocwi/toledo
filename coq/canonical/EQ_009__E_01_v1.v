(* EQ-009/E.01.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Append-only record branch/split step, parametrized by the already-
   computed orthogonal-split coefficients s := sqrt(1-gamma), t :=
   sqrt(gamma) (kept as free Q parameters rather than computing an
   irrational sqrt; s,t satisfy s*s + t*t = 1 as the unitarity side
   condition, stated as a hypothesis not derived here). *)
Section EQ009_E01.
  Variable C : Q -> Q.
  Definition EQ009_E01_zprime (s z : Q) : Q := s * (C z).
  Definition EQ009_E01_rho (t z : Q) : Q := - (t * (C z)).
  Definition EQ009_E01_unitary (s t : Q) : Prop := s * s + t * t == 1.
  Definition EQ009_E01_Psi_next (Psi rho : Q) : Q := Psi + rho.
End EQ009_E01.
