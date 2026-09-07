(* weld/H.25.v1 -- not_yet_formalised -> open_prop -- Expertise-state transition probability conditional on AI assistance, practice, world feedback, resources *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* P\!\left(\chi_{i,t+1}=b \mid \chi_{i,t}=a, A_t, P_t, W_t, R_t\right) *)
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

Section weld__H_25_v1_sec.
  Parameter AI Practice World Resource : Type.
  Inductive ExpertiseIdealType25 := N25 | I25 | C25.
  Parameter TransProb : ExpertiseIdealType25 -> ExpertiseIdealType25 -> AI -> Practice -> World -> Resource -> Q.
  Definition weld__H_25_v1_hyp (a b : ExpertiseIdealType25) (At : AI) (Pt : Practice) (Wt : World) (Rt : Resource) : Prop :=
    (0 <= TransProb a b At Pt Wt Rt <= 1)%Q.
End weld__H_25_v1_sec.
