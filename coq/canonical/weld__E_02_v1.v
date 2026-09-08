(* weld/E.02.v1 — CAN-029 — Definition — parents: weld/M.03.v1 — occurrences 6 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-029 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** SC: K(S,p) -> Subject(S) is the rejected collapse (Possession-
    Constitution Collapse); HSC: Epi(X,p) -> Knower(X,p) restates it.
    Witnessed non-collapse: a finite model where a structure carries
    epistemically significant content without its bearer being a
    recognised Knower — the collapse does not hold as a general
    identity. *)
Theorem CAN029_possession_constitution_non_collapse :
  exists (X : Type) (p : Type) (Epi : X -> p -> Prop) (Knower : X -> p -> Prop)
         (x : X) (pp : p), Epi x pp /\ ~ Knower x pp.
Proof.
  exists bool, bool, (fun _ _ => True), (fun _ _ => False), true, true.
  split; [exact I | intro H; exact H].
Qed.

