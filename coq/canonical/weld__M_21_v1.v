(* weld/M.21.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.15: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* CDOL_Q(\mathcal{R}\to D) = \mathsf{PASS} \iff \exists\, T_{R\to D} : \text{Eq.\ (14) holds} *)
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

Section weld__M_21_v1_sec.
  Parameter RSpace DSpace Out J_Q : Type.
  Parameter F_R : RSpace -> RSpace.
  Parameter F_D : DSpace -> DSpace.
  Parameter O_R : RSpace -> Out.
  Parameter O_D : DSpace -> Out.
  Parameter W_R_Q : J_Q -> RSpace -> Out.
  Parameter W_D_Q : J_Q -> DSpace -> Out.
  Parameter CDOL_Q : Verdict.
  Definition weld__M_21_v1_def : Prop :=
    CDOL_Q = PASS <->
      exists T : RSpace -> DSpace,
        (forall r, T (F_R r) = F_D (T r)) /\
        (forall r, O_D (T r) = O_R r) /\
        (forall (j : J_Q) (r : RSpace), W_D_Q j (T r) = W_R_Q j r).
End weld__M_21_v1_sec.
