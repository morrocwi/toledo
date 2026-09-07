(* ChemDomain_ledger/C.08.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Empirical-formula mole ratio from percent composition: moles_i =
   percent_i/M_i, then each is normalised by the smallest mole value. *)
Definition C08_v1_moles (percents molarmasses : list Q) : list Q :=
  map (fun p => let '(pc, m) := p in pc / m) (combine percents molarmasses).

Definition C08_v1_mole_ratio (percents molarmasses : list Q) (d : Q) : list Q :=
  let moles := C08_v1_moles percents molarmasses in
  let least := fold_right Qmin d moles in
  map (fun x => x / least) moles.
