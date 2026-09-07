(* A.5/H.23.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.35: NEW NON-COLLAPSE *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* V_n^{learn}(u) \not\equiv V_n^{act}(u) *)
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

Section A_5__H_23_v1_sec.
  Parameter Action : Type.
  Parameter V_learn V_act : nat -> Action -> Q.
  Definition A_5__H_23_v1_hyp (n : nat) (u : Action) : Prop :=
    V_learn n u <> V_act n u.
End A_5__H_23_v1_sec.
