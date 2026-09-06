(* weld/S.22.v1 — Definition — parents: weld/M.01.v1, weld/S.01.v1 *)

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

Section CAN_115_SocialLRStepper.

  Variable verts : list nat.
  Variable W     : nat -> nat -> Q.   (* pairwise coupling / retained-distinction weight *)
  Variable Gamma : nat -> Q.          (* per-node dissipation / repair rate *)
  Variable J     : nat -> Q.          (* sustained load / inequality forcing *)
  Variable dt    : Q.

  Definition CAN_115_degree (i : nat) : Q :=
    fold_right Qplus 0 (map (W i) verts).

  Definition CAN_115_L_R (i j : nat) : Q :=
    if Nat.eqb i j then CAN_115_degree i else - W i j.

  (* A := L_R + Gamma (diagonal repair-rate addition). *)
  Definition CAN_115_A (i j : nat) : Q :=
    CAN_115_L_R i j + (if Nat.eqb i j then Gamma i else 0).

  (* s[n+1] = s[n] + dt(-A s[n] + J), one coordinate i at a time, the row
     i of [A] applied to [s] as a finite sum over [verts]. *)
  Definition CAN_115_step (s : nat -> Q) (i : nat) : Q :=
    s i + dt * ( - (fold_right Qplus 0 (map (fun j => CAN_115_A i j * s j) verts))
                 + J i ).

End CAN_115_SocialLRStepper.

(* Witness (tier: Th_coqc): PAR-stepper is not definitionally idle — a
   concrete, self-contained finite model (one node, zero coupling and
   zero dissipation, unit time step, non-zero load 1): the stepper moves
   the state by exactly the load, exactly the [../coq/MR_Foundation.v]
   eq.(8)/[MRC_root_spine.v] [CAN_003_stepper_can_move_state] technique
   specialised to this stepper's own shape. *)
Remark CAN_115_par_stepper_moves_state :
  CAN_115_step [0%nat] (fun _ _ => 0) (fun _ => 0) (fun _ => 1) 1
               (fun _ => 0) 0%nat <> 0.
Proof.
  unfold CAN_115_step, CAN_115_A, CAN_115_L_R, CAN_115_degree.
  vm_compute. discriminate.
Qed.

(* L1 (invariance/recurrence), L2 (the bill), L3 (operator change), L4
   (mutation) — the paper's own theorems (record 22361830 / 18383439),
   NOT independently machine-checked here. Typed as abstract, Section-
   discharged [Prop]-valued objects and deliberately left un-proved — tier:
   Open, per the house rule "never upgrade (Open -> Prop, no proof)". *)
