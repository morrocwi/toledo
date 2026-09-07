(* weld/H.32.v1 -- not_yet_formalised -> definition -- Interactional-expert slot empty when the role is unheld *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* X_p^{int} = \varnothing \quad \text{(role unheld, not a zero score)} *)
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

Section weld__H_32_v1_sec.
  Parameter ExpHolder : Type.
  Parameter X_p_int : option ExpHolder.
  Definition weld__H_32_v1_def : Prop := X_p_int = None.
End weld__H_32_v1_sec.
