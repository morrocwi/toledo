(* EQ-001/B.31.v1 -- Open -- parents: EQ-001 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* OPEN: DNA/genome as a real molecular carrier is a destination the
   ordered-sequence carrier (BIO-G1) might eventually be calibrated to
   reach -- never a premise anywhere in this registry. *)
Section EQ001_B31_v1.
  Variables OrderedSequenceCarrier Genome : Type.
  Variable Reaches : OrderedSequenceCarrier -> Genome -> Prop.

  Definition EQ001_B31_v1_hyp : Prop :=
    exists (c : OrderedSequenceCarrier) (g : Genome), Reaches c g.
End EQ001_B31_v1.
