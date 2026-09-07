(* EQ-002/H.05.v1 -- not_yet_formalised -> open_prop -- Agent-level network readout *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* z_{i,t} = R_{i,t}\left(q_D(S_t), m_{-i,t}, c_{i,t}\right) *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section EQ_002__H_05_v1_sec.
  Parameter State Msg Ctx Readout Agent : Type.
  Parameter q_D : State -> State.
  Parameter S_t : nat -> State.
  Parameter m_others : nat -> Agent -> Msg.
  Parameter c_it : nat -> Agent -> Ctx.
  Parameter R : nat -> Agent -> State -> Msg -> Ctx -> Readout.
  Parameter z : nat -> Agent -> Readout.
  Definition EQ_002__H_05_v1_hyp (t : nat) (i : Agent) : Prop :=
    z t i = R t i (q_D (S_t t)) (m_others t i) (c_it t i).
End EQ_002__H_05_v1_sec.
