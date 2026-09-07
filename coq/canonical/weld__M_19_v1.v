(* weld/M.19.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.13: NEW NON-COLLAPSE *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* CSML_Q(M) = \mathsf{PASS} \;\not\Rightarrow\; SAL_Q^{strong}(n) = \mathsf{PASS} *)
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

Section weld__M_19_v1_sec.
  Parameter Mech : Type.
  Parameter CSML_Q : Mech -> Verdict.
  Parameter SAL_Q_strong_m : Mech -> Verdict.
  Definition weld__M_19_v1_hyp : Prop :=
    ~ (forall m : Mech, CSML_Q m = PASS -> SAL_Q_strong_m m = PASS).
End weld__M_19_v1_sec.
