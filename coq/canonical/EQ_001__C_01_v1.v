(* EQ-001/C.01.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section EQ001_C01.
  Variable A n0 n1 : Q.
  (* ledger L(n) := A * n; boundary preserves the ledger: L(n1) = L(n0) *)
  Definition EQ001_C01_L (n : Q) : Q := A * n.

  Theorem EQ001_C01_ledger_conservation :
    EQ001_C01_L n1 == EQ001_C01_L n0 -> A * (n1 - n0) == 0.
  Proof.
    unfold EQ001_C01_L. intro H. ring_simplify. ring_simplify in H. lra.
  Qed.
End EQ001_C01.
