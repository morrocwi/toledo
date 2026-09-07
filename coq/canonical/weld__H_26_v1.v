(* weld/H.26.v1 -- not_yet_formalised -> open_prop -- H1 - Interactional Compression hypothesis *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* C_{N\rightarrow I}^{AI} < C_{N\rightarrow I}^{baseline} *)
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

Section weld__H_26_v1_sec.
  Parameter C_NtoI_AI C_NtoI_baseline : Q.
  Definition weld__H_26_v1_hyp : Prop := (C_NtoI_AI < C_NtoI_baseline)%Q.
End weld__H_26_v1_sec.
