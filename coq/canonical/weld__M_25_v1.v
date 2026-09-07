(* weld/M.25.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.33: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* ERG_D = \mathsf{PASS} \iff \exists\, u_a,u_b \in \mathcal{U}_D^{adm} : d_Q\big(R_D(s,u_a), R_D(s,u_b)\big) > \tau_E *)
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

Section weld__M_25_v1_sec.
  Parameter DState Action Out : Type.
  Parameter U_D_adm : Action -> Prop.
  Parameter R_D : DState -> Action -> Out.
  Parameter d_Q : Out -> Out -> Q.
  Parameter tau_E : Q.
  Parameter s : DState.
  Parameter ERG_D : Verdict.
  Definition weld__M_25_v1_hyp : Prop :=
    ERG_D = PASS <->
      exists ua ub : Action, U_D_adm ua /\ U_D_adm ub /\
        (d_Q (R_D s ua) (R_D s ub) > tau_E)%Q.
End weld__M_25_v1_sec.
