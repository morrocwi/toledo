(* BiologyDomain_living_unit/B.16.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Goldman-Hodgkin-Katz multi-ion membrane potential:
   Vm = (RT/F) ln((P_K K_out + P_Na Na_out + P_Cl Cl_in) /
                  (P_K K_in + P_Na Na_in + P_Cl Cl_out))
   ln is treated as an opaque Q -> Q function. *)
Section B16_v1.
  Variable lnfn : Q -> Q.

  Definition B16_v1_ghk_potential
      (R T F P_K K_out K_in P_Na Na_out Na_in P_Cl Cl_in Cl_out : Q) : Q :=
    (R * T / F) *
    lnfn ((P_K * K_out + P_Na * Na_out + P_Cl * Cl_in) /
          (P_K * K_in + P_Na * Na_in + P_Cl * Cl_out)).
End B16_v1.
