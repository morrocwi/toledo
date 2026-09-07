(* weld/M.28.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.37: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathcal{U}_{n+1}^{safe} := \Big\{ u \in \mathcal{U}_D^{adm} : \mathbf{C}_n(u) \preceq \mathbf{B}_n,\ \mathbb{P}\big(\tau_{V_D^c} \le H \mid \mathcal{F}_n, u\big) \le \alpha \Big\} *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr/Open source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__M_28_v1_sec.
  Parameter Action Filtration : Type.
  Parameter U_D_adm : Action -> Prop.
  Parameter C_vec : Action -> (Q * Q * Q * Q).
  Parameter le_budget : (Q * Q * Q * Q) -> (Q * Q * Q * Q) -> Prop.
  Parameter B_n : (Q * Q * Q * Q).
  Parameter P_exit : Filtration -> Action -> Q.
  Parameter F_n : Filtration.
  Parameter alpha : Q.
  Definition weld__M_28_v1_hyp (u : Action) : Prop :=
    U_D_adm u /\ le_budget (C_vec u) B_n /\ (P_exit F_n u <= alpha)%Q.
End weld__M_28_v1_sec.
