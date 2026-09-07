(* weld/H.18.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.24: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* ISW_Q(\mathcal{G},A,A';c) = \mathsf{PASS} \iff d_I^Q\big(O_I^Q\,\mathfrak{I}_Q(\mathcal{G},A,c),\, O_I^Q\,\mathfrak{I}_Q(\mathcal{G},A',c)\big) > \tau_I *)
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

Section weld__H_18_v1_sec.
  Parameter GState AgentState Context IdSpace : Type.
  Parameter I_Q : GState -> AgentState -> Context -> IdSpace.
  Parameter O_I_Q : IdSpace -> IdSpace.
  Parameter d_I_Q : IdSpace -> IdSpace -> Q.
  Parameter tau_I : Q.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Definition weld__H_18_v1_def (g : GState) (a a' : AgentState) (c : Context) : Prop :=
    ISW_Q g a a' c = PASS <->
      (d_I_Q (O_I_Q (I_Q g a c)) (O_I_Q (I_Q g a' c)) > tau_I)%Q.
End weld__H_18_v1_sec.
