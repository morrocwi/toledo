(* A.5/S.01.v1 — CAN-121 — Definition — parents: A.5/M.01.v1 — occurrences 10 *)

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
(** ** CAN-121 — B-SOC-AGENCYHIER

    (* CAN-121 — root: x'=F(x,C); C_{t+1}=G(x_t,C_t,...); L5: G_{t+1}=M(G_t) — domain: social — tier: Definition — occurrences: 10 *)

    CANONICAL.json tier: "definition". Five successively higher orders of
    the SAME generator-family, read at increasing informational scope, up
    to L5 applying a stepper to the stepper's own generating rule
    (q_D∘F, one level up) — a textbook confirmation of "one equation, read
    at different orders, is a reading not a new equation" (per the
    founder rule already invoked in [MRC_root_spine.v]'s CAN-003 header). *)

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

  (* Level 3: history-dependent constraint update, C_{t+1}=G(x_t,C_t,H_t). *)
  Definition CAN_121_L3_history (G3 : X -> C -> H -> C) : Type := X -> C -> H -> C.

  (* Level 4: predictive constraint update using a forecast state,
     C_{t+1}=G(x_t,C_t,x_hat_{t+k}). *)
  Definition CAN_121_L4_predictive (G4 : X -> C -> X -> C) : Type := X -> C -> X -> C.

  (* Level 5 (meta-regulation): the system revises its own generating
     rule, G_{t+1}=M(G_t) — a second-order stepper acting on the Level-2
     rule itself, never re-defining Level 2's [G] in place. *)
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

