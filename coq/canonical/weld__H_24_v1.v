(* weld/H.24.v1 -- not_yet_formalised -> definition -- Three ideal-type expertise states indexed by person, question, domain, time *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \chi_i(Q,D,t)\in\{N,I,C\} *)
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

Section weld__H_24_v1_sec.
  Parameter Person Question Domain : Type.
  Inductive ExpertiseIdealType := N_type | I_type | C_type.
  Parameter chi : Person -> Question -> Domain -> nat -> ExpertiseIdealType.
  Definition weld__H_24_v1_def (i : Person) (Qq : Question) (D : Domain) (t : nat) : Prop :=
    chi i Qq D t = N_type \/ chi i Qq D t = I_type \/ chi i Qq D t = C_type.
End weld__H_24_v1_sec.
