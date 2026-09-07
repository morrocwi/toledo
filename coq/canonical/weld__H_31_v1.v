(* weld/H.31.v1 -- not_yet_formalised -> definition -- AI model set of a project *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathcal{M}_p^{AI} = \{M_1, M_2, \ldots, M_k\} *)
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

Section weld__H_31_v1_sec.
  Parameter AIModel : Type.
  Parameter M_p_AI : list AIModel.
  Definition weld__H_31_v1_def : Prop := M_p_AI <> nil.
End weld__H_31_v1_sec.
