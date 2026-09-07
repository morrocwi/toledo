(* weld/H.30.v1 -- not_yet_formalised -> definition -- Core Epistemic Structure of a project *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* E_p = \left\langle X_p^{exp}, X_p^{int}, \mathcal{M}_p^{AI} \right\rangle *)
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

Section weld__H_30_v1_sec.
  Parameter ExpHolder AIModel : Type.
  Parameter X_p_exp : ExpHolder.
  Parameter X_p_int : option ExpHolder.
  Parameter M_p_AI : list AIModel.
  Definition weld__H_30_v1_def : (ExpHolder * option ExpHolder * list AIModel) :=
    (X_p_exp, X_p_int, M_p_AI).
End weld__H_30_v1_sec.
