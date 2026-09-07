(* A.5/S.20.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.03.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Witnessed-set refinement of containment: Pi^live_{A,t}(g) subseteq
   Pi^feas_A(g; h, z, T, B). Formalised generically as list inclusion over an
   abstract option type X (the two option-sets are finite, declared lists). *)
Section A5_S20_v1.
  Variable X : Type.

  Definition A5_S20_v1_refinement (Pi_live Pi_feas : list X) : Prop :=
    incl Pi_live Pi_feas.
End A5_S20_v1.
