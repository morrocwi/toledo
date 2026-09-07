(* EQ-001/P.53.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* free-path obstruction minimizer: argmin over a finite list of
   candidate paths of a cost function. *)
Definition EQ001_P53_argmin_path
  (paths : list nat) (cost : nat -> Q) (default : nat) : nat :=
  fold_right (fun p best => if Qle_bool (cost p) (cost best) then p else best)
    default paths.
