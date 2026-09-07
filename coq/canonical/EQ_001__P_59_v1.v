(* EQ-001/P.59.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* horizon as rank-loss boundary: N=0 iff det B=0. Exact witness:
   B_h = diag(0,5), det=0, singular (no left-inverse for the first row). *)
Theorem EQ001_P59_witness :
  0 * 5 == 0 /\ ~ (exists m : Q, 0 * m == 1).
Proof.
  split.
  - lra.
  - intros [m Hm]. lra.
Qed.
