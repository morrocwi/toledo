(* weld/M.30.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.39: NEW SYNTHESIS *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* D_{n+1} = \begin{cases} \mathsf{HOLD}, & \mathrm{Route}_Q(e_n)=\mathsf{HOLD},\\ \mathsf{STOP}, & \mathcal{U}_{n+1}^{safe}=\varnothing,\\ \mathcal{D}_n^{\star}, & \text{otherwise.} \end{cases} *)
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

Section weld__M_30_v1_sec.
  Parameter Event RouteLabel Action Decision : Type.
  Parameter e_n : nat -> Event.
  Parameter Route_Q : Event -> RouteLabel.
  Parameter HOLD_route : RouteLabel.
  Parameter U_safe : nat -> Action -> Prop.
  Parameter D_star : nat -> Decision.
  Parameter HOLD_dec STOP_dec : Decision.
  Parameter D : nat -> Decision.
  Definition weld__M_30_v1_def (n : nat) : Prop :=
    (Route_Q (e_n n) = HOLD_route -> D (S n) = HOLD_dec) /\
    (Route_Q (e_n n) <> HOLD_route -> (~ exists u, U_safe (S n) u) -> D (S n) = STOP_dec) /\
    (Route_Q (e_n n) <> HOLD_route -> (exists u, U_safe (S n) u) -> D (S n) = D_star n).
End weld__M_30_v1_sec.
