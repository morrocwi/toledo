(* weld/H.34.v1 -- not_yet_formalised -> definition -- Experience-holder decomposition (lived experience, selection, interpretation) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* X_p^{exp} = \left\langle \text{Exp}, \text{Sel}, \text{Int} \right\rangle *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_34_v1_sec.
  Parameter LivedExperience Selection Interpretation : Type.
  Parameter Exp : LivedExperience.
  Parameter Sel : Selection.
  Parameter Int : Interpretation.
  Definition weld__H_34_v1_def : (LivedExperience * Selection * Interpretation) :=
    (Exp, Sel, Int).
End weld__H_34_v1_sec.
