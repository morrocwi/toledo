(* BiologyDomain_living_unit/B.22.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Kleiber's law, 3/4-power metabolic scaling: BMR = a M^0.75.
   The 0.75 exponent is non-integer, so exponentiation is an opaque
   Q -> Q -> Q operation, applied here at the fixed exponent 3#4. *)
Section B22_v1.
  Variable qpow : Q -> Q -> Q.

  Definition B22_v1_kleiber (a M : Q) : Q := a * qpow M (3 # 4).
End B22_v1.
