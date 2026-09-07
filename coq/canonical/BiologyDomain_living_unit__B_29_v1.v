(* BiologyDomain_living_unit/B.29.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Karlin-Altschul local-alignment E-value: E = K m n exp(-lam S).
   exp is treated as an opaque Q -> Q function. *)
Section B29_v1.
  Variable expfn : Q -> Q.

  Definition B29_v1_karlin_altschul_evalue (K m n lam S : Q) : Q :=
    K * m * n * expfn (- lam * S).
End B29_v1.
