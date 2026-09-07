(* EQ-001/C.02.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section EQ001_C02.
  Variable A n delta : Q.
  Definition EQ001_C02_L (x : Q) : Q := A * x.
  Definition EQ001_C02_in_ker (d : Q) : Prop := A * d == 0.

  Theorem EQ001_C02_preserves_iff_ker :
    EQ001_C02_L (n + delta) == EQ001_C02_L n <-> EQ001_C02_in_ker delta.
  Proof.
    unfold EQ001_C02_L, EQ001_C02_in_ker. split; intro H; lra.
  Qed.
End EQ001_C02.
