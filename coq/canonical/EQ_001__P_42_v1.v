(* EQ-001/P.42.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* O4 RD-neutrality gate: a pure observer change preserves n+ * n- (Qv);
   proposed internal gate, not derived from the root backbone. *)
Definition EQ001_P42_neutrality
  (Qv : Q -> Q -> Q -> Q) (B : Q * Q -> Q * Q) : Prop :=
  forall v t x, Qv v (fst (B (t, x))) (snd (B (t, x))) == Qv v t x.
