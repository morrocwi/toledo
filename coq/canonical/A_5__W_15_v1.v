(* A.5/W.15.v1 -- Definition -- parents: A.5/M.01.v1, A.5/W.03.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)
(* instantiates the already-closed joint theorem at A.5/W.12.v1 with n=4; not a new proof. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


From MRC Require Import A_5__W_12_v1.

(* This bundle's own non-collapse pair is instance n=4 of the joint
   parametrised theorem already proved once at A.5/W.12.v1
   (CAN_160_all_separations_satisfiable), per registry relations[].reads on
   this code -- not a separate/duplicated proof. *)
Theorem A_5__W_15_v1_holds : CAN_160_separation 4.
Proof. apply CAN_160_all_separations_satisfiable. Qed.
