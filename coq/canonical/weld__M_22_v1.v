(* weld/M.22.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.16: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* ECT_Q(e_n) \in \{E_0, E_1, E_2, E_3, E_4, \mathsf{HOLD}\} *)
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

Section weld__M_22_v1_sec.
  Parameter Event : Type.
  Parameter e_n : nat -> Event.
  Parameter ECT_Q : Event -> Verdict.
  Definition weld__M_22_v1_def (n : nat) : Prop :=
    ECT_Q (e_n n) = E0 \/ ECT_Q (e_n n) = E1 \/ ECT_Q (e_n n) = E2 \/
    ECT_Q (e_n n) = E3 \/ ECT_Q (e_n n) = E4 \/ ECT_Q (e_n n) = HOLD.
End weld__M_22_v1_sec.
