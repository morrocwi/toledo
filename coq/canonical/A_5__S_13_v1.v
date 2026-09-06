(* A.5/S.13.v1 — Definition — parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* also carries the joint witness that Proto-Agency (A.5/S.10.v1), State-Constraint-Coupling (A.5/S.08.v1) and this Level-5 meta-update are simultaneously exhibitable -- the witness needs all three, so it is duplicated onto this, the capping level, rather than the two earlier siblings. *)

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

Section CAN_121_AgencyHierarchy.

  Variables X C H : Type.
  Variable F : X -> C -> X.

  (* Level 0/1 (Proto-Agency): the constraint update does not depend on
     the state at all — "partial C / partial x = 0" discretely replaced
     as: the update function ignores its state argument. *)
  Definition CAN_121_ProtoAgency (G : X -> C -> C) : Prop :=
    forall (x1 x2 : X) (c : C), G x1 c = G x2 c.

  (* Level 2 (Agency-Condition, necessary not sufficient): the update
     function genuinely does depend on the state — "partial C/partial x
     <> 0" discretely replaced as: some state pair changes the update. *)
  Definition CAN_121_StateConstraintCoupling (G : X -> C -> C) : Prop :=
    exists (x1 x2 : X) (c : C), G x1 c <> G x2 c.

  Definition CAN_121_L5_meta (M : (X -> C -> C) -> (X -> C -> C)) : Type :=
    (X -> C -> C) -> (X -> C -> C).

End CAN_121_AgencyHierarchy.

(* Witness (tier: Th_coqc): the hierarchy is non-vacuous at every level on
   a small finite model ([X:=bool], [C:=bool]) — Proto-Agency, genuine
   State-Constraint-Coupling, and a genuine Level-5 meta-update (M flips
   the rule's output) are all simultaneously exhibitable, no level
   collapsing into another. Stated OUTSIDE [CAN_121_AgencyHierarchy] so
   its own [X]/[C] are the concrete witness types, never the section's
   abstract ones. *)
  Theorem CAN_121_hierarchy_levels_satisfiable :
    exists (G_proto G_coupled : bool -> bool -> bool) (M5 : (bool -> bool -> bool) -> (bool -> bool -> bool)),
      CAN_121_ProtoAgency G_proto
      /\ CAN_121_StateConstraintCoupling G_coupled
      /\ (forall x : bool, M5 G_coupled x x = negb (G_coupled x x)) (* a genuine, non-identity meta-update *)
      /\ (exists x : bool, M5 G_coupled x x <> G_coupled x x).
  Proof.
    exists (fun _ c => c), (fun x _ => x), (fun G x y => negb (G x y)).
    split; [| split; [| split]].
    - intros x1 x2 c. reflexivity.
    - exists true, false, true. simpl. discriminate.
    - intro x. reflexivity.
    - exists true. simpl. discriminate.
  Qed.
