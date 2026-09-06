(* EQ-015/W.03.v1 — CAN-142 — Definition — parents: EQ-015/M.01.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-142 — machine-capacity-block

    (* CAN-142 — root: B^RB=N^RB q^RB; M_t=(K^M)^k(A^AI)^a(B^RB)^b; rho=(sigma-1)/sigma; s^L=... — domain: world-system — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(5)-(7),(9)-(10), record 22481924) — freshly
    formalised. Discrete-readout replacement: the Cobb-Douglas-style index
    and the CES labour share use declared [nat] exponents via the
    already-defined [MR_WorldSystem.Qpow_nat] (finite repeated
    multiplication), never a continuum real exponent; the CES elasticity
    [rho_CES] itself is kept as an uninterpreted [Q] ratio and is never
    used as a fractional power (the growth-decomposition identity
    [Bdot/B = Ndot/N + qdot/q] is a continuum log-derivative product rule
    with no exact discrete counterpart, so it is recorded here only in
    the header prose, not asserted as a Coq theorem — a refused
    non-readout rather than a silently-completed approximation). *)

Section CAN_142_MachineCapacityBlock.

  Definition CAN_142_B_RB (N_RB q_RB : Q) : Q := N_RB * q_RB.

  (* eq.(5): B^RB_t = N^RB_t q^RB_t, a genuine definitional identity. *)
  Theorem CAN_142_B_RB_identity :
    forall N_RB q_RB : Q, CAN_142_B_RB N_RB q_RB == N_RB * q_RB.
  Proof. intros. unfold CAN_142_B_RB. reflexivity. Qed.

  Definition CAN_142_M_index (K_M A_AI B_RB_val : Q) (kappa alpha beta : nat) : Q :=
    MR_WorldSystem.Qpow_nat K_M kappa
    * MR_WorldSystem.Qpow_nat A_AI alpha
    * MR_WorldSystem.Qpow_nat B_RB_val beta.

  Definition CAN_142_rho_CES (sigma : Q) : Q := (sigma - 1) / sigma.

  Definition CAN_142_labour_share
             (omega_H omega_M H_t M_t : Q) (rho_exp : nat) : Q :=
    (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp)
    / (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp
       + omega_M * MR_WorldSystem.Qpow_nat M_t rho_exp).

End CAN_142_MachineCapacityBlock.

