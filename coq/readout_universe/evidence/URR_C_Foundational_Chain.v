(* ===================================================================== *)
(* URR_C_Foundational_Chain.v                                             *)
(*                                                                       *)
(* Conditional machine-checked bridge from the retained-difference root  *)
(* to the typed URR-C 0.4 master architecture.                            *)
(*                                                                       *)
(* This file DOES prove:                                                  *)
(*  F0  RD4 successor injectivity is the formal retained-distinction root.*)
(*  F1  RD dimensions reflect retained distinctions.                     *)
(*  F2  Reader-record doubling and selectors are exact product typing.    *)
(*  F3  A declared readout split lifts coherently to doubled state.       *)
(*  F4  A full master equality implies reader and mirror component laws.  *)
(*  F5  The balanced O/H/T cut conserves its declared integer total.      *)
(*  F6  Append-only tape preserves the old prefix and distinguishes cells.*)
(*  F7  The return kernel is typed composition; a left decoder recovers.  *)
(*  F8  Existing DRL EL and general-N D-cancellation theorems are anchors. *)
(*                                                                       *)
(* This file DOES NOT prove:                                              *)
(*  - that philosophical interpretations are uniquely forced by logic;   *)
(*  - that Psi is an ontic physical record in every adapter;              *)
(*  - a unified DRL-cut-tape action;                                      *)
(*  - universal nonlinear, Gaussian, or gravitational claims.            *)
(* ===================================================================== *)

From Coq Require Import List ZArith QArith Ring.
Import ListNotations.

From URR Require Import RD.
From URR Require Import DRL_Discrete.
From URR Require Import DRL_General_Legendre.

Open Scope Q_scope.

Module URRC_Foundational_Chain.

(* --------------------------------------------------------------------- *)
(* F0-F1: retained distinction and finite dimension anchor.               *)
(* --------------------------------------------------------------------- *)

Theorem F0_RD4_retained_difference_injective :
  forall x y : D, succ x = succ y -> x = y.
Proof.
  exact RD4_succ_inj.
Qed.

Definition rd_dimension (d : D) : nat := toNat d.

Theorem F1_dimension_reflects_retained_distinction :
  forall x y : D, rd_dimension x = rd_dimension y -> x = y.
Proof.
  intros x y H.
  apply toNat_inj.
  exact H.
Qed.

(* --------------------------------------------------------------------- *)
(* F2: the doubled reader-record state used by DRL and URR-C.             *)
(* --------------------------------------------------------------------- *)

Definition RRState (V : Type) : Type := (V * V)%type.

Definition P_Phi {V : Type} (x : RRState V) : V := fst x.
Definition P_Psi {V : Type} (x : RRState V) : V := snd x.
Definition pair_state {V : Type} (phi psi : V) : RRState V := (phi, psi).

Theorem F2_reader_selector_exact :
  forall (V : Type) (phi psi : V), P_Phi (pair_state phi psi) = phi.
Proof. reflexivity. Qed.

Theorem F2_mirror_selector_exact :
  forall (V : Type) (phi psi : V), P_Psi (pair_state phi psi) = psi.
Proof. reflexivity. Qed.

Theorem F2_reader_record_eta :
  forall (V : Type) (x : RRState V),
    pair_state (P_Phi x) (P_Psi x) = x.
Proof.
  intros V [phi psi].
  reflexivity.
Qed.

(* --------------------------------------------------------------------- *)
(* F3: abstract readout split and its lift to the doubled state.          *)
(* The split laws are declared adapter obligations, not derived physics.  *)
(* --------------------------------------------------------------------- *)

Record ReadoutSplit (A : Type) : Type := mkReadoutSplit {
  split_zero : A;
  split_merge : A -> A -> A;
  split_O : A -> A;
  split_H : A -> A;
  split_O_idempotent : forall x, split_O (split_O x) = split_O x;
  split_H_idempotent : forall x, split_H (split_H x) = split_H x;
  split_O_after_H_zero : forall x, split_O (split_H x) = split_zero;
  split_H_after_O_zero : forall x, split_H (split_O x) = split_zero;
  split_recompose : forall x, split_merge (split_O x) (split_H x) = x
}.

Arguments split_zero {A} _.
Arguments split_merge {A} _ _ _.
Arguments split_O {A} _ _.
Arguments split_H {A} _ _.
Arguments split_O_idempotent {A} _ _.
Arguments split_H_idempotent {A} _ _.
Arguments split_O_after_H_zero {A} _ _.
Arguments split_H_after_O_zero {A} _ _.
Arguments split_recompose {A} _ _.

Definition lifted_O {A : Type} (s : ReadoutSplit A)
  (x : RRState A) : RRState A :=
  (split_O s (P_Phi x), split_O s (P_Psi x)).

Definition lifted_H {A : Type} (s : ReadoutSplit A)
  (x : RRState A) : RRState A :=
  (split_H s (P_Phi x), split_H s (P_Psi x)).

Definition lifted_zero {A : Type} (s : ReadoutSplit A) : RRState A :=
  (split_zero s, split_zero s).

Definition lifted_merge {A : Type} (s : ReadoutSplit A)
  (x y : RRState A) : RRState A :=
  (split_merge s (P_Phi x) (P_Phi y),
   split_merge s (P_Psi x) (P_Psi y)).

Theorem F3_lifted_O_idempotent :
  forall (A : Type) (s : ReadoutSplit A) (x : RRState A),
    lifted_O s (lifted_O s x) = lifted_O s x.
Proof.
  intros A s [phi psi].
  unfold lifted_O, P_Phi, P_Psi.
  simpl.
  rewrite (split_O_idempotent s phi).
  rewrite (split_O_idempotent s psi).
  reflexivity.
Qed.

Theorem F3_lifted_H_idempotent :
  forall (A : Type) (s : ReadoutSplit A) (x : RRState A),
    lifted_H s (lifted_H s x) = lifted_H s x.
Proof.
  intros A s [phi psi].
  unfold lifted_H, P_Phi, P_Psi.
  simpl.
  rewrite (split_H_idempotent s phi).
  rewrite (split_H_idempotent s psi).
  reflexivity.
Qed.

Theorem F3_lifted_O_after_H_zero :
  forall (A : Type) (s : ReadoutSplit A) (x : RRState A),
    lifted_O s (lifted_H s x) = lifted_zero s.
Proof.
  intros A s [phi psi].
  unfold lifted_O, lifted_H, lifted_zero, P_Phi, P_Psi.
  simpl.
  rewrite (split_O_after_H_zero s phi).
  rewrite (split_O_after_H_zero s psi).
  reflexivity.
Qed.

Theorem F3_lifted_H_after_O_zero :
  forall (A : Type) (s : ReadoutSplit A) (x : RRState A),
    lifted_H s (lifted_O s x) = lifted_zero s.
Proof.
  intros A s [phi psi].
  unfold lifted_O, lifted_H, lifted_zero, P_Phi, P_Psi.
  simpl.
  rewrite (split_H_after_O_zero s phi).
  rewrite (split_H_after_O_zero s psi).
  reflexivity.
Qed.

Theorem F3_lifted_recompose :
  forall (A : Type) (s : ReadoutSplit A) (x : RRState A),
    lifted_merge s (lifted_O s x) (lifted_H s x) = x.
Proof.
  intros A s [phi psi].
  unfold lifted_merge, lifted_O, lifted_H, P_Phi, P_Psi.
  simpl.
  rewrite (split_recompose s phi).
  rewrite (split_recompose s psi).
  reflexivity.
Qed.

(* --------------------------------------------------------------------- *)
(* F4: master equality projects to reader and mirror equations.           *)
(* --------------------------------------------------------------------- *)

Definition MasterEquation {V : Type}
  (E_DRL J_C : RRState V -> RRState V) : Prop :=
  forall x, E_DRL x = J_C x.

Theorem F4_master_implies_component_equations :
  forall (V : Type) (E_DRL J_C : RRState V -> RRState V),
    MasterEquation E_DRL J_C ->
    forall x,
      P_Phi (E_DRL x) = P_Phi (J_C x) /\
      P_Psi (E_DRL x) = P_Psi (J_C x).
Proof.
  intros V E_DRL J_C Hmaster x.
  rewrite (Hmaster x).
  split; reflexivity.
Qed.

(* --------------------------------------------------------------------- *)
(* F5: exact balance of the declared visible-hidden-tape cut.             *)
(* This is the algebraic AP15 balance law, separated from positivity.     *)
(* --------------------------------------------------------------------- *)

Open Scope Z_scope.

Record FlowState : Type := mkFlowState {
  flow_visible : Z;
  flow_hidden : Z;
  flow_tape : Z
}.

Definition flow_total (s : FlowState) : Z :=
  flow_visible s + flow_hidden s + flow_tape s.

Definition balanced_cut_step
  (s : FlowState) (write ret tape : Z) : FlowState :=
  mkFlowState
    (flow_visible s - write + ret)
    (flow_hidden s + write - ret - tape)
    (flow_tape s + tape).

Theorem F5_balanced_cut_conserves_declared_total :
  forall s write ret tape,
    flow_total (balanced_cut_step s write ret tape) = flow_total s.
Proof.
  intros [visible hidden stored] write ret tape.
  unfold flow_total, balanced_cut_step.
  simpl.
  ring.
Qed.

Close Scope Z_scope.

(* --------------------------------------------------------------------- *)
(* F6: append-only tape properties.                                       *)
(* --------------------------------------------------------------------- *)

Definition Tape (A : Type) : Type := list A.

Definition append_record {A : Type} (t : Tape A) (cell : A) : Tape A :=
  t ++ [cell].

Theorem F6_append_preserves_old_history_as_prefix :
  forall (A : Type) (t : Tape A) (cell : A),
    exists suffix, append_record t cell = t ++ suffix.
Proof.
  intros A t cell.
  exists [cell].
  reflexivity.
Qed.

Theorem F6_append_cell_injective :
  forall (A : Type) (t : Tape A) (x y : A),
    append_record t x = append_record t y -> x = y.
Proof.
  intros A t x y H.
  unfold append_record in H.
  apply app_inv_head in H.
  inversion H.
  reflexivity.
Qed.

Theorem F6_distinct_cells_make_distinct_histories :
  forall (A : Type) (t : Tape A) (x y : A),
    x <> y -> append_record t x <> append_record t y.
Proof.
  intros A t x y Hxy Heq.
  apply Hxy.
  apply (F6_append_cell_injective A t x y).
  exact Heq.
Qed.

(* --------------------------------------------------------------------- *)
(* F7: typed return-transformation composition and decoder gate.          *)
(* --------------------------------------------------------------------- *)

Section ReturnKernel.

Variables Message Accessible Hidden Observation : Type.
Variables E_beta : Message -> Accessible.
Variables O_write : Accessible -> Accessible.
Variables W_beta : Accessible -> Hidden.
Variables H_hidden : Hidden -> Hidden.
Variables U_H : Hidden -> Hidden.
Variables R_alpha : Hidden -> Accessible.
Variables O_read : Accessible -> Accessible.
Variables A_alpha : Accessible -> Observation.

Definition K_return (z : Message) : Observation :=
  A_alpha
    (O_read
      (R_alpha
        (U_H
          (H_hidden
            (W_beta
              (O_write
                (E_beta z))))))).

Theorem F7_return_kernel_is_declared_composition :
  forall z,
    K_return z =
    A_alpha
      (O_read
        (R_alpha
          (U_H
            (H_hidden
              (W_beta
                (O_write
                  (E_beta z))))))).
Proof. reflexivity. Qed.

Variable Decode : Observation -> Message.
Hypothesis decoder_left_inverse : forall z, Decode (K_return z) = z.

Theorem F7_declared_left_decoder_recovers_message :
  forall z, Decode (K_return z) = z.
Proof.
  exact decoder_left_inverse.
Qed.

Variable zero_observation : Observation.
Hypothesis return_readout_zero :
  forall h, A_alpha (O_read (R_alpha h)) = zero_observation.

Theorem F7_zero_return_readout_forces_zero_direct_kernel :
  forall z, K_return z = zero_observation.
Proof.
  intro z.
  unfold K_return.
  apply return_readout_zero.
Qed.

End ReturnKernel.

(* --------------------------------------------------------------------- *)
(* F8: direct anchors into the existing DRL Coq evidence.                 *)
(* These aliases ensure the formal chain depends on the original proofs.  *)
(* --------------------------------------------------------------------- *)

Definition F8_native_reader_EL_anchor := T1_el_psi_node1.
Definition F8_native_reader_EL_second_node_anchor := T1_el_psi_node2.
Definition F8_native_mirror_EL_anchor := T1_el_phi_node1.
Definition F8_native_three_ring_D_cancellation_anchor := T2_D_cancellation.
Definition F8_native_general_N_D_cancellation_anchor :=
  general_legendre_D_cancellation.

(* A compact theorem containing three independently checked load-bearing   *)
(* links: retained distinction, general-N DRL D-cancellation, and cut      *)
(* balance. The other generic typing theorems remain reusable separately.  *)
Theorem foundational_master_chain_core :
  (forall x y : D, succ x = succ y -> x = y) /\
  (forall (l : list node) (GB : Q),
      Hfull l GB == qsum pairing_node l + GB) /\
  (forall s write ret tape,
      flow_total (balanced_cut_step s write ret tape) = flow_total s).
Proof.
  split.
  - exact F0_RD4_retained_difference_injective.
  - split.
    + exact general_legendre_D_cancellation.
    + exact F5_balanced_cut_conserves_declared_total.
Qed.

Print Assumptions F0_RD4_retained_difference_injective.
Print Assumptions F3_lifted_recompose.
Print Assumptions F4_master_implies_component_equations.
Print Assumptions F5_balanced_cut_conserves_declared_total.
Print Assumptions F6_append_cell_injective.
Print Assumptions F7_declared_left_decoder_recovers_message.
Print Assumptions foundational_master_chain_core.

End URRC_Foundational_Chain.
