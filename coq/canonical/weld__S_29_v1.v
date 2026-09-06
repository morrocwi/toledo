(* weld/S.29.v1 — Ax — parents: weld/M.02.v1, weld/S.02.v1 *)
(* also proves joint satisfiability of CE-01 (weld/S.10.v1) and CE-02 (weld/S.11.v1) together with this axiom -- the witness needs all three, so it is carried here (the last of the three defining children) rather than duplicated three times. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section CAN_116_EthAxiom.

  Variable Event : Type.

  Definition CAN_116_ManifestedRecord : Type := list Event.

  Definition CAN_116_is_agency (A M : CAN_116_ManifestedRecord) : Prop :=
    incl A M.

  (* Axiom IV: Collective as Coupled Agencies — G(t') := {A_1,...,A_N}
     subseteq M(t'); a collective is a finite list of agencies, each
     itself included in the shared record. *)
  Definition CAN_116_is_collective
             (G : list CAN_116_ManifestedRecord) (M : CAN_116_ManifestedRecord) : Prop :=
    Forall (fun A => CAN_116_is_agency A M) G.

  (* Witness (tier: Th_coqc): the axioms are jointly satisfiable by a
     genuinely non-trivial finite instance — a two-agency collective
     properly included in a three-event record, on any [Event] carrier
     with two distinguishable events. *)
  Theorem CAN_116_axioms_satisfiable :
    forall e1 e2 : Event, e1 <> e2 ->
      exists (M : CAN_116_ManifestedRecord) (A1 A2 : CAN_116_ManifestedRecord),
        CAN_116_is_agency A1 M /\ CAN_116_is_agency A2 M /\
        CAN_116_is_collective [A1; A2] M /\ A1 <> A2.
  Proof.
    intros e1 e2 Hne.
    exists [e1; e2], [e1], [e2].
    assert (Hin1 : CAN_116_is_agency [e1] [e1; e2]).
    { intros x Hx. simpl in Hx. destruct Hx as [<- | []]. simpl. left. reflexivity. }
    assert (Hin2 : CAN_116_is_agency [e2] [e1; e2]).
    { intros x Hx. simpl in Hx. destruct Hx as [<- | []]. simpl. right. left. reflexivity. }
    repeat split.
    - exact Hin1.
    - exact Hin2.
    - apply Forall_cons; [exact Hin1 | apply Forall_cons; [exact Hin2 | apply Forall_nil]].
    - intro Hc. injection Hc as Hc. congruence.
  Qed.

End CAN_116_EthAxiom.
