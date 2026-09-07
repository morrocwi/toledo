(* EQ-015/H.48.v1 -- not_yet_formalised -> open_prop -- RET network stop rule *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Delta\chi_{\mathrm{recip}}^{\mathcal G}>0,\ \Delta\kappa_{\mathcal G}>0 \ \text{while}\ \Delta D_{\mathcal G}^{eff}\le0,\ \Delta R_{\mathcal G}^{ex}\le0,\ \Delta P_{\mathcal G}^{ind}\le0 *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section EQ_015__H_48_v1_sec.
  Parameter DeltaChi DeltaKappa DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Definition EQ_015__H_48_v1_hyp (t : nat) : Prop :=
    (DeltaChi t > 0)%Q /\ (DeltaKappa t > 0)%Q /\
    (DeltaDEff t <= 0)%Q /\ (DeltaREx t <= 0)%Q /\ (DeltaPInd t <= 0)%Q.
End EQ_015__H_48_v1_sec.
