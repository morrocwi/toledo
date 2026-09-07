(* A.8/M.21.v1 -- not_yet_formalised -> open_prop -- AI-Independent Consequence Requirement *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* H \Rightarrow y \quad\text{such that}\quad CausalAncestry(y) \not\subseteq \mathcal G^{recursive}_{\le \tau} *)
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

Section A_8__M_21_v1_sec.
  Parameter Hyp_ Consequence Node : Type.
  Parameter entails : Hyp_ -> Consequence -> Prop.
  Parameter CausalAncestry : Consequence -> Node -> Prop.
  Parameter RecursiveNetworkUpTo : nat -> Node -> Prop.
  Parameter tau : nat.
  Definition A_8__M_21_v1_hyp (H : Hyp_) : Prop :=
    exists y : Consequence,
      entails H y /\
      exists n : Node, CausalAncestry y n /\ ~ RecursiveNetworkUpTo tau n.
End A_8__M_21_v1_sec.
