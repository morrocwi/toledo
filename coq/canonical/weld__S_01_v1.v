(* weld/S.01.v1 — CAN-115 — Definition — parents: weld/M.01.v1 — occurrences 18 *)

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
(** ** CAN-115 — B-SOC-LRSTEPPER

    (* CAN-115 — root: A:=L_R+Gamma; s[n+1]=s[n]+dt(-A s[n]+J) — domain: social — tier: Definition — occurrences: 18 *)

    CANONICAL.json tier: "definition (PAR-stepper); theorem [paper-internal,
    not Coq-verified] (L1-L4, and the earlier No-Go Theorem)". Reads CAN-001
    (root-weld) directly, by the same symbol L_R = D_W - W, onto a social-
    tension field: nodes are social units (a finite [list nat], never an
    unbounded/continuum vertex set), edges are [Q]-valued couplings, and
    [Gamma] is a per-node dissipation/repair-rate diagonal. The stepper
    [CAN_115_step] is the discrete Euler update s[n+1]=s[n]+dt(-A s[n]+J) —
    a genuinely finite recurrence, never a continuum ODE. PAR-stepper itself
    (the object) is typed and witnessed non-trivial at tier Th_coqc; L1-L4
    (fixed-point invariance, cost lower bound, operator-change escape route,
    mutation-to-neighbour) are the paper's own theorems, not independently
    machine-checked here, so each is typed as a [Prop]-valued [Definition]
    and deliberately left un-proved (tier: Open), per the house rule. *)

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
Section CAN_115_L1_L4_Open.

  Variables verts' : list nat.
  Variable W' Gamma' : nat -> Q.
  Variable J' : nat -> Q.
  Variable dt' : Q.
  Variable s_star : nat -> Q.          (* the fixed point s* = A^{-1} J, left abstract *)
  Variable intervention : (nat -> Q) -> nat -> (nat -> Q).  (* bounded, amplitude-only, ticks-held *)

  (* L1: a bounded amplitude-only intervention cannot move the fixed point,
     and the state returns above threshold after a finite number of ticks
     once the intervention ends. *)
  Variable CAN_115_L1_invariance_recurrence : Prop.

  (* L2: holding the state at threshold requires a non-vanishing per-tick
     force, cost growing linearly in time held. *)
  Variable CAN_115_L2_the_bill : Prop.

  (* L3: raising dissipation gamma_i (operator-level, not amplitude
     suppression) can push the fixed point permanently below threshold at
     zero ongoing force. *)
  Variable CAN_115_L3_operator_change : Prop.

  (* L4: suppressing one node under permanent resets produces a strictly
     positive long-run floor in a coupled neighbour node. *)
  Variable CAN_115_L4_mutation : Prop.

End CAN_115_L1_L4_Open.

