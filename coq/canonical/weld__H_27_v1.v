(* weld/H.27.v1 -- not_yet_formalised -> open_prop -- H2 - Contributory Persistence hypothesis *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* |\Delta C_{I\rightarrow C}^{AI}| < |\Delta C_{N\rightarrow I}^{AI}| *)
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

Section weld__H_27_v1_sec.
  Parameter DeltaC_ItoC_AI DeltaC_NtoI_AI : Q.
  Definition weld__H_27_v1_hyp : Prop := (Qabs DeltaC_ItoC_AI < Qabs DeltaC_NtoI_AI)%Q.
End weld__H_27_v1_sec.
