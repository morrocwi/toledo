(* weld/W.07.v1 -- not_yet_formalised -> open_prop -- AI comparative statics on the backlog and the AI-induced epistemic scarcity shift condition (Proposition 2) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \frac{\partial B^*}{\partial A_g} = \frac{\partial \Lambda/\partial A_g}{\delta_B} >0 \\ \frac{\partial B^*}{\partial A_v} = -\frac{\partial \mu/\partial A_v}{\delta_B} <0 \\ \frac{\partial B^*}{\partial z} = \frac{\partial \Lambda/\partial z - \partial \mu/\partial z}{\delta_B} \\ \frac{\partial \Lambda}{\partial z} > \frac{\partial \mu}{\partial z} \;\Longleftrightarrow\; \frac{\partial B^*}{\partial z}>0 *)
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

Section weld__W_07_v1_sec.
  Parameter dBstar_dAg dLambda_dAg delta_B : Q.
  Parameter dBstar_dAv dmu_dAv : Q.
  Parameter dBstar_dz dLambda_dz dmu_dz : Q.
  Definition weld__W_07_v1_hyp : Prop :=
    delta_B <> 0%Q /\
    dBstar_dAg = (dLambda_dAg / delta_B)%Q /\ (dBstar_dAg > 0)%Q /\
    dBstar_dAv = (- dmu_dAv / delta_B)%Q /\ (dBstar_dAv < 0)%Q /\
    dBstar_dz = ((dLambda_dz - dmu_dz) / delta_B)%Q /\
    ((dLambda_dz > dmu_dz)%Q <-> (dBstar_dz > 0)%Q).
End weld__W_07_v1_sec.
