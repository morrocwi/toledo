(* weld/W.04.v1 -- not_yet_formalised -> definition -- Validation capacity as a function of contributory/interactional expertise, world access, data, resources, validation-side AI *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mu_t = V\!\left( E_t^C, E_t^I, W_t, D_t, R_t, A_{v,t} \right) *)
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

Section weld__W_04_v1_sec.
  Parameter ContribExp InteractExp World Data Resource AIval : Type.
  Parameter E_t_C : nat -> ContribExp.
  Parameter E_t_I : nat -> InteractExp.
  Parameter W_t : nat -> World.
  Parameter D_t : nat -> Data.
  Parameter R_t : nat -> Resource.
  Parameter A_v_t : nat -> AIval.
  Parameter Vfun : ContribExp -> InteractExp -> World -> Data -> Resource -> AIval -> Q.
  Parameter mu_t : nat -> Q.
  Definition weld__W_04_v1_def (t : nat) : Prop :=
    mu_t t = Vfun (E_t_C t) (E_t_I t) (W_t t) (D_t t) (R_t t) (A_v_t t).
End weld__W_04_v1_sec.
