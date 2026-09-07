(* weld/H.37.v1 -- not_yet_formalised -> definition -- Evidence-driven convergence regime *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Delta D^{eff}_{\mathcal G}<0,\ \Delta R^{ex}_{\mathcal G}>0 \quad\text{and}\quad \Delta P^{ind}_{\mathcal G}>0 \ \text{or}\ WorldRecord=Decisive *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section weld__H_37_v1_sec.
  Parameter DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Parameter WorldRecordState : Type.
  Parameter WorldRecord : nat -> WorldRecordState.
  Parameter Decisive : WorldRecordState.
  Definition weld__H_37_v1_def (t : nat) : Prop :=
    (DeltaDEff t < 0)%Q /\ (DeltaREx t > 0)%Q /\
    ((DeltaPInd t > 0)%Q \/ WorldRecord t = Decisive).
End weld__H_37_v1_sec.
