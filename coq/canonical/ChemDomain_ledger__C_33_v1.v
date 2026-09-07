(* ChemDomain_ledger/C.33.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Born-Lande lattice energy:
   U = -(N_A M z1 z2 e^2)/(4 pi eps0 r0) (1 - 1/n).
   pi is a readout-invariant (information-discrete-math), kept as an opaque
   Q constant rather than a computed real; the Born exponent n is generally
   non-integer, so 1/n is ordinary Q division (no exponentiation needed
   here -- only the closing factor (1 - 1/n) uses n). *)
Section C33_v1.
  Variable pi_const : Q.

  Definition C33_v1_born_lande (N_A M z1 z2 e eps0 r0 n : Q) : Q :=
    - (N_A * M * z1 * z2 * e * e) / (4 * pi_const * eps0 * r0) * (1 - 1 / n).
End C33_v1.
