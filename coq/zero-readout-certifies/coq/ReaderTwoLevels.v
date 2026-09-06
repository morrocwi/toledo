(* SPDX-License-Identifier: MIT *)
(*
  Two levels of reader composition.

  The algebraic observation is that one carrier element may be a unit for
  one operation and an absorber for another without collapsing the carrier.
  That observation alone does not identify the element semantically with
  unresolved failure.  The typed refinement below therefore distinguishes
  an accumulator's initial state, an accumulator failure, a resolved value,
  and a pipeline-level unresolved verdict.
*)

Require Import QArith.
Open Scope Q_scope.

(* ------------------------------------------------------------------ *)
(* A single operation cannot give one element both roles nontrivially. *)
(* ------------------------------------------------------------------ *)

Section SingleOperation.

Variable M : Type.
Variable op : M -> M -> M.
Variable e : M.

Definition rr_is_identity : Prop :=
  forall x, op e x = x /\ op x e = x.

Definition rr_is_absorbing : Prop :=
  forall x, op e x = e /\ op x e = e.

Theorem rr_identity_and_absorbing_collapses :
  rr_is_identity -> rr_is_absorbing -> forall x y : M, x = y.
Proof.
  intros Hid Habs x y.
  destruct (Hid x) as [Hid_l _].
  destruct (Habs x) as [Habs_l _].
  destruct (Hid y) as [Hid_y_l _].
  destruct (Habs y) as [Habs_y_l _].
  assert (Hx : x = e).
  { rewrite <- Hid_l. exact Habs_l. }
  assert (Hy : y = e).
  { rewrite <- Hid_y_l. exact Habs_y_l. }
  now rewrite Hx, Hy.
Qed.

End SingleOperation.

(* ------------------------------------------------------------------ *)
(* Algebraic witness: the same boundary element, two operations.       *)
(* This proves compatibility of the roles, not their semantic identity. *)
(* ------------------------------------------------------------------ *)

Inductive BoundaryRecord : Type :=
| Boundary : BoundaryRecord
| Recorded : Q -> BoundaryRecord.

Definition boundary_acc (a b : BoundaryRecord) : BoundaryRecord :=
  match a, b with
  | Boundary, y => y
  | x, Boundary => x
  | Recorded p, Recorded q => Recorded (p + q)
  end.

Definition boundary_seq (a b : BoundaryRecord) : BoundaryRecord :=
  match a, b with
  | Boundary, _ => Boundary
  | _, Boundary => Boundary
  | Recorded _, Recorded q => Recorded q
  end.

Theorem boundary_acc_left_unit :
  forall x, boundary_acc Boundary x = x.
Proof. intros [|q]; reflexivity. Qed.

Theorem boundary_acc_right_unit :
  forall x, boundary_acc x Boundary = x.
Proof. intros [|q]; reflexivity. Qed.

Theorem boundary_seq_left_absorbing :
  forall x, boundary_seq Boundary x = Boundary.
Proof. intros [|q]; reflexivity. Qed.

Theorem boundary_seq_right_absorbing :
  forall x, boundary_seq x Boundary = Boundary.
Proof. intros [|q]; reflexivity. Qed.

Theorem boundary_seq_associative :
  forall x y z,
    boundary_seq (boundary_seq x y) z =
    boundary_seq x (boundary_seq y z).
Proof. intros [|p] [|q] [|r]; reflexivity. Qed.

Theorem boundary_two_roles_no_collapse :
  (forall x, boundary_acc Boundary x = x) /\
  (forall x, boundary_seq Boundary x = Boundary) /\
  (exists x y : BoundaryRecord, x <> y).
Proof.
  split.
  - exact boundary_acc_left_unit.
  - split.
    + exact boundary_seq_left_absorbing.
    + exists Boundary, (Recorded 0). discriminate.
Qed.

Theorem recorded_zero_differs_from_boundary :
  Recorded 0 <> Boundary.
Proof. discriminate. Qed.

Theorem recorded_zero_allows_next_stage :
  forall q, boundary_seq (Recorded 0) (Recorded q) = Recorded q.
Proof. intro q. reflexivity. Qed.

Theorem boundary_blocks_next_stage :
  forall q, boundary_seq Boundary (Recorded q) = Boundary.
Proof. intro q. reflexivity. Qed.

(* ------------------------------------------------------------------ *)
(* Typed refinement: process state and verdict are not conflated.      *)
(* ------------------------------------------------------------------ *)

Inductive Accumulator : Type :=
| Init : Accumulator
| AccFailed : Accumulator
| Accumulated : Q -> Accumulator.

Definition combine_acc (a b : Accumulator) : Accumulator :=
  match a, b with
  | AccFailed, _ => AccFailed
  | _, AccFailed => AccFailed
  | Init, y => y
  | x, Init => x
  | Accumulated p, Accumulated q => Accumulated (p + q)
  end.

Theorem init_left_unit : forall x, combine_acc Init x = x.
Proof. intros [| |q]; reflexivity. Qed.

Theorem init_right_unit : forall x, combine_acc x Init = x.
Proof. intros [| |q]; reflexivity. Qed.

Theorem accumulator_failure_left_absorbing :
  forall x, combine_acc AccFailed x = AccFailed.
Proof. intros [| |q]; reflexivity. Qed.

Theorem accumulator_failure_right_absorbing :
  forall x, combine_acc x AccFailed = AccFailed.
Proof. intros [| |q]; reflexivity. Qed.

Theorem accumulator_states_are_distinct :
  Init <> AccFailed /\
  Init <> Accumulated 0 /\
  AccFailed <> Accumulated 0.
Proof.
  repeat split; discriminate.
Qed.

Inductive Verdict : Type :=
| Unresolved : Verdict
| Resolved : Q -> Verdict.

Definition pipeline_seq (a b : Verdict) : Verdict :=
  match a, b with
  | Unresolved, _ => Unresolved
  | _, Unresolved => Unresolved
  | Resolved _, Resolved q => Resolved q
  end.

Theorem pipeline_unresolved_left_absorbing :
  forall x, pipeline_seq Unresolved x = Unresolved.
Proof. intros [|q]; reflexivity. Qed.

Theorem pipeline_unresolved_right_absorbing :
  forall x, pipeline_seq x Unresolved = Unresolved.
Proof. intros [|q]; reflexivity. Qed.

Theorem pipeline_seq_associative :
  forall x y z,
    pipeline_seq (pipeline_seq x y) z =
    pipeline_seq x (pipeline_seq y z).
Proof. intros [|p] [|q] [|r]; reflexivity. Qed.

Theorem resolved_zero_is_not_unresolved :
  Resolved 0 <> Unresolved.
Proof. discriminate. Qed.

Theorem resolved_zero_continues_pipeline :
  forall q, pipeline_seq (Resolved 0) (Resolved q) = Resolved q.
Proof. intro q. reflexivity. Qed.

Theorem unresolved_stops_pipeline :
  forall q, pipeline_seq Unresolved (Resolved q) = Unresolved.
Proof. intro q. reflexivity. Qed.

(* The empty-input case is fixed by the reading contract, not by the
   accumulation operation alone. *)

Definition finalize_total (a : Accumulator) : Verdict :=
  match a with
  | Init => Resolved 0
  | AccFailed => Unresolved
  | Accumulated q => Resolved q
  end.

Definition finalize_strict (a : Accumulator) : Verdict :=
  match a with
  | Init => Unresolved
  | AccFailed => Unresolved
  | Accumulated q => Resolved q
  end.

Theorem total_contract_empty_is_zero :
  finalize_total Init = Resolved 0.
Proof. reflexivity. Qed.

Theorem strict_contract_empty_is_unresolved :
  finalize_strict Init = Unresolved.
Proof. reflexivity. Qed.

Theorem empty_case_depends_on_contract :
  finalize_total Init <> finalize_strict Init.
Proof. simpl. discriminate. Qed.

Theorem failed_accumulator_finalizes_unresolved :
  finalize_total AccFailed = Unresolved.
Proof. reflexivity. Qed.
