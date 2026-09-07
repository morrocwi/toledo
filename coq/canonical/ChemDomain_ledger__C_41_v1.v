(* ChemDomain_ledger/C.41.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Zero-point-energy model of the primary kinetic isotope effect:
   k_H/k_D = exp(hc(w_H - w_D)/(2 kB T)). exp is an opaque Q -> Q function. *)
Section C41_v1.
  Variable expfn : Q -> Q.

  Definition C41_v1_kie (hc w_H w_D kB T : Q) : Q :=
    expfn (hc * (w_H - w_D) / (2 * kB * T)).
End C41_v1.
