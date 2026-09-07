(* ChemDomain_ledger/C.07.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Limiting-reagent product yield: compare n_i/coeff_i over the finite list
   of reagents, take the minimum. *)
Definition C07_v1_ratios (ns coeffs : list Q) : list Q :=
  map (fun p => let '(n, c) := p in n / c) (combine ns coeffs).

Definition C07_v1_limiting_ratio (ns coeffs : list Q) (d : Q) : Q :=
  fold_right Qmin d (C07_v1_ratios ns coeffs).
