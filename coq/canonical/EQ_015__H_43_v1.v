(* EQ-015/H.43.v1 -- not_yet_formalised -> definition -- Tunnel-contraction regime *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Delta\chi_{\mathrm{recip}}^{\mathcal G}>0,\ \Delta\kappa_{\mathcal G}>0,\ \Delta D^{eff}_{\mathcal G}<0,\ \Delta R^{ex}_{\mathcal G}\le 0,\ \Delta P^{ind}_{\mathcal G}\le 0 *)
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

Section EQ_015__H_43_v1_sec.
  Parameter DeltaChi DeltaKappa DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Definition EQ_015__H_43_v1_def (t : nat) : Prop :=
    (DeltaChi t > 0)%Q /\ (DeltaKappa t > 0)%Q /\ (DeltaDEff t < 0)%Q /\
    (DeltaREx t <= 0)%Q /\ (DeltaPInd t <= 0)%Q.
End EQ_015__H_43_v1_sec.
