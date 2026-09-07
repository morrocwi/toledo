(* EQ-001/C.17.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* NP-FINITE-GATE-002: enumerate all registered same-count pairs and
   compare exact frozen signatures -- typed as a filter over a declared
   finite list of candidate pairs, keeping exact-signature matches. *)
Definition EQ001_C17_gate
  (l : list (list nat * list nat))
  (eq_dec : forall x y : list nat, {x = y} + {x <> y})
  : list (list nat * list nat) :=
  filter (fun p => if eq_dec (fst p) (snd p) then true else false) l.
