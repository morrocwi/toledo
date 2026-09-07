(* weld/M.18.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.12: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathfrak{M}_Q(r_n)\cap\mathfrak{M}_Q^{stoch}\neq\varnothing,\quad \mathfrak{M}_Q(r_n)\cap\mathfrak{M}_Q^{nonstoch}\neq\varnothing \;\Rightarrow\; SAL_Q^{strong}(n)=\mathsf{HOLD} *)
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

Section weld__M_18_v1_sec.
  Parameter Mech : Type.
  Parameter M_Q_r : nat -> Mech -> Prop.
  Parameter M_Q_stoch M_Q_nonstoch : Mech -> Prop.
  Parameter SAL_Q_strong : nat -> Verdict.
  Definition weld__M_18_v1_hyp (n : nat) : Prop :=
    ((exists m, M_Q_r n m /\ M_Q_stoch m) /\
     (exists m, M_Q_r n m /\ M_Q_nonstoch m)) ->
    SAL_Q_strong n = HOLD.
End weld__M_18_v1_sec.
