(* weld/M.27.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.36: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathbf{C}_n(u) = \big(C_n^{int}(u),\, C_n^{ext}(u),\, C_n^{opp}(u),\, C_n^{risk}(u)\big) *)
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

Section weld__M_27_v1_sec.
  Parameter Action : Type.
  Parameter C_int C_ext C_opp C_risk : nat -> Action -> Q.
  Parameter C_vec : nat -> Action -> (Q * Q * Q * Q).
  Definition weld__M_27_v1_def (n : nat) (u : Action) : Prop :=
    C_vec n u = (C_int n u, C_ext n u, C_opp n u, C_risk n u).
End weld__M_27_v1_sec.
