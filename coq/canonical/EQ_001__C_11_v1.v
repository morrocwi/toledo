(* EQ-001/C.11.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-FCM-008: for a frozen finite generator registry G, N^G with
   coordinatewise addition and zero is a free commutative monoid. The
   commutative-monoid law verification (assoc/comm/identity) over
   finite-support vectors is a real but nontrivial fact; the deeper
   "free" (universal-property) content is not attempted here -- stated
   openly rather than partially proved and overclaimed as the full result. *)
Definition EQ001_C11_hyp
  (k : nat) (Vec : Type) (vadd : Vec -> Vec -> Vec) (vzero : Vec) : Prop :=
  (forall a, vadd a vzero = a) /\
  (forall a, vadd vzero a = a) /\
  (forall a b c, vadd (vadd a b) c = vadd a (vadd b c)) /\
  (forall a b, vadd a b = vadd b a).
