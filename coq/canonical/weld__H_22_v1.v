(* weld/H.22.v1 -- not_yet_formalised -> definition -- Credential is not expertise (methodological non-collapse) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{credential} \neq \text{expertise} *)
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

Section weld__H_22_v1_sec.
  Parameter Notion : Type.
  Parameter Credential Expertise : Notion.
  Definition weld__H_22_v1_def : Prop := Credential <> Expertise.
End weld__H_22_v1_sec.
