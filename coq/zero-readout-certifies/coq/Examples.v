Require Import List.
Require Import QArith.
Require Import PeanoNat.
Require Import IDM_KeystoneKernel.
Import ListNotations.
Open Scope Q_scope.

Definition constant_seventeen : Phi := fun _ => 17.

Example constant_nonzero_has_zero_readout :
  forall g, I_form constant_seventeen g == 0.
Proof.
  intro g. induction g as [| e es IH].
  - reflexivity.
  - destruct e as [[i j] w]. simpl.
    setoid_replace (I_edge constant_seventeen (i, j, w)) with 0.
    + rewrite Qplus_0_l. exact IH.
    + unfold I_edge, constant_seventeen. ring.
Qed.

Definition separates_zero_one : Phi :=
  fun n => if Nat.eqb n 0 then 0 else 1.

Example zero_weight_edge_has_zero_readout :
  I_form separates_zero_one [(0%nat, 1%nat, 0)] == 0.
Proof. reflexivity. Qed.

Example zero_weight_edge_endpoints_differ :
  ~ separates_zero_one 0%nat == separates_zero_one 1%nat.
Proof.
  unfold separates_zero_one. simpl.
  intro H. unfold Qeq in H. simpl in H. discriminate H.
Qed.

Definition disconnected_self_loops : list edge :=
  [(0%nat, 0%nat, 1); (1%nat, 1%nat, 1)].

Example disconnected_readout_zero :
  I_form separates_zero_one disconnected_self_loops == 0.
Proof. reflexivity. Qed.

Example disconnected_values_differ :
  ~ separates_zero_one 0%nat == separates_zero_one 1%nat.
Proof.
  unfold separates_zero_one. simpl.
  intro H. unfold Qeq in H. simpl in H. discriminate H.
Qed.
