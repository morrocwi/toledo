(* A.5/S.09.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)
(* discretises both partial derivatives as supplied finite-difference quotients (information-discrete-math table). *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Section A5_S09_v1.
  (* Agency condition: partial Tp/partial C . partial C/partial x > 0.
     The two continuum partial derivatives are discretised (information-
     discrete-math table: derivative -> discrete difference quotient) as two
     already-computed Q-valued finite-difference quotients supplied as
     parameters, rather than differentiated here. *)
  Definition A5_S09_v1_agency_condition (dTp_dC dC_dx : Q) : Prop :=
    0 < dTp_dC * dC_dx.
End A5_S09_v1.
