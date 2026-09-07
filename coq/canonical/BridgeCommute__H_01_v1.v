(* BridgeCommute/H.01.v1 -- untagged -- parents: BridgeCommute *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Closure-meaningful commutation criterion for cross-agent communication:
   T_{j->i} . F#_H^j = F#_H^i . T_{j->i} *)
Section BridgeCommute_H01_v1.
  Variable Agent : Type.
  Variable Signal : Type.
  Variable T : Agent -> Agent -> Signal -> Signal.   (* translation j -> i *)
  Variable Fsharp : Agent -> Signal -> Signal.        (* per-agent closure-meaningful update *)

  Definition BridgeCommute_H01_v1_commutes (i j : Agent) : Prop :=
    forall s : Signal, T j i (Fsharp j s) = Fsharp i (T j i s).
End BridgeCommute_H01_v1.
