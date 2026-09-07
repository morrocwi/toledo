(* weld/M.29.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.38: NEW SYNTHESIS *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathrm{Route}_Q(e_n) = \begin{cases} \mathcal{A}_M, & ECT_Q(e_n)=E_0,\\ \mathcal{A}_B, & ECT_Q(e_n)=E_1,\\ \mathcal{A}_P, & ECT_Q(e_n)=E_2,\\ \mathcal{A}_G, & ECT_Q(e_n)=E_3,\\ \mathcal{A}_X, & ECT_Q(e_n)=E_4,\\ \mathsf{HOLD}, & ECT_Q(e_n)=\mathsf{HOLD}. \end{cases} *)
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

Section weld__M_29_v1_sec.
  Parameter Event RouteLabel : Type.
  Parameter e_n : nat -> Event.
  Parameter ECT_Q : Event -> Verdict.
  Parameter A_M A_B A_P A_G A_X HOLD_route : RouteLabel.
  Parameter Route_Q : Event -> RouteLabel.
  Definition weld__M_29_v1_def (n : nat) : Prop :=
    (ECT_Q (e_n n) = E0 -> Route_Q (e_n n) = A_M) /\
    (ECT_Q (e_n n) = E1 -> Route_Q (e_n n) = A_B) /\
    (ECT_Q (e_n n) = E2 -> Route_Q (e_n n) = A_P) /\
    (ECT_Q (e_n n) = E3 -> Route_Q (e_n n) = A_G) /\
    (ECT_Q (e_n n) = E4 -> Route_Q (e_n n) = A_X) /\
    (ECT_Q (e_n n) = HOLD -> Route_Q (e_n n) = HOLD_route).
End weld__M_29_v1_sec.
