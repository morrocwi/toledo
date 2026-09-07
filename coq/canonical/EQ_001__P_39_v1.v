(* EQ-001/P.39.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* O1 path-additivity gate: B(delta1+delta2) = B(delta1)+B(delta2) is
   imposed on the observer map B. Direct, honestly-scoped consequence:
   composing two equal displacements is additive (the doubling
   instance of the imposed law), proved directly from the hypothesis
   with no further assumption on B (a general Q-linearity extension
   would additionally require B to respect Qeq, not assumed here). *)
Section EQ001_P39.
  Variable B : Q -> Q.
  Hypothesis Hadd : forall d1 d2, B (d1 + d2) == B d1 + B d2.

  Theorem EQ001_P39_doubling : forall x : Q, B (x + x) == B x + B x.
  Proof. intro x. apply Hadd. Qed.
End EQ001_P39.
