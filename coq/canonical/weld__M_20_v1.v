(* weld/M.20.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.14: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* T_{R\to D}\circ F_R = F_D\circ T_{R\to D},\quad O_D\circ T_{R\to D}=O_R,\quad W^D_{Q,j}\circ T_{R\to D}=W^R_{Q,j}\ \ \forall j\in J_Q *)
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

Section weld__M_20_v1_sec.
  Parameter RSpace DSpace Out J_Q : Type.
  Parameter T_RtoD : RSpace -> DSpace.
  Parameter F_R : RSpace -> RSpace.
  Parameter F_D : DSpace -> DSpace.
  Parameter O_R : RSpace -> Out.
  Parameter O_D : DSpace -> Out.
  Parameter W_R_Q : J_Q -> RSpace -> Out.
  Parameter W_D_Q : J_Q -> DSpace -> Out.
  Definition weld__M_20_v1_hyp : Prop :=
    (forall r, T_RtoD (F_R r) = F_D (T_RtoD r)) /\
    (forall r, O_D (T_RtoD r) = O_R r) /\
    (forall (j : J_Q) (r : RSpace), W_D_Q j (T_RtoD r) = W_R_Q j r).
End weld__M_20_v1_sec.
