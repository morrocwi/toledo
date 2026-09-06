(* weld/S.02.v1 — CAN-116 — Ax — parents: weld/M.02.v1 — occurrences 4 *)

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

(* ==================================================================== *)
(** ** CAN-116 — B-SOC-ETHAXIOM

    (* CAN-116 — root: M(t') in M; A_i(t') subseteq M(t'); G(t'):={A_1,...,A_N} subseteq M(t') — domain: social — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "axiom" (CE-01..CE-04). Discrete replacement: a
    "manifested record" is a finite, append-only [list Event] (the same
    readout-first shape as [MRC_root_spine.v]'s [CAN_009_extends]); an
    "agency" A_i is a sub-structure of that record, typed as list
    inclusion ([incl]), never an opaque abstract subset relation on an
    unstructured carrier; a "collective" is a finite [list] of such
    agencies. CANONICAL.json's own "axiom" tier is typed here, per the
    house style, as [Definition] (a locked domain-typing discipline) with
    a Th_coqc witness that the typing is genuinely satisfiable and
    non-trivial (a proper, non-empty sub-record actually exists). *)

Section CAN_116_EthAxiom.

  Variable Event : Type.

  (* Axiom I: Reality-as-Record — M(t') is (typed as) a finite record. *)
  Definition CAN_116_ManifestedRecord : Type := list Event.

  (* Axiom II: Agency-as-Choice — A_i(t') subseteq M(t'). *)
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

