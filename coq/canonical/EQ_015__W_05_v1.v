(* EQ-015/W.05.v1 — CAN-144 — Definition — parents: EQ-015/M.01.v1 — occurrences 5 *)

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
(** ** CAN-144 — claim-constitution

    (* CAN-144 — root: q_t=o_t+tau_t(1-o_t); Gamma_t=s^L+q_t(1-s^L); q^min=(Gammabar-s^L)/(1-s^L) — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". Master River v1.4 eq.(54)
    [after_labour]. The minimum-conversion half is direct reuse of
    [MR_WorldSystem.v]'s [q_min]/[eq54_citizen_claim_threshold_identity]
    (Th_coqc). The two remaining accounting formulas in this id's own
    [canonical_text] — [q_t = o_t + tau_t(1-o_t)] and
    [Gamma_t = s^L_t + q_t(1-s^L_t)] — share one algebraic shape (a
    convex-combination-style update "a + b(1-a)"); that shared shape is
    formalised once as [CAN_144_convex_combine] and its own genuine ring
    identity ("a + b(1-a) = 1-(1-a)(1-b)") is proved once and read as both
    [q_t] and [Gamma_t] below (never re-proved). [D^rent]/[Gamma^net] are
    the accompanying accounting components named in the source prose;
    they carry no further equation of their own in this id's occurrence
    range and are not separately typed here. *)

Definition CAN_144_q_min := MR_WorldSystem.q_min.
Definition CAN_144_citizen_claim_threshold_identity :=
  MR_WorldSystem.eq54_citizen_claim_threshold_identity.

Section CAN_144_ClaimConstitution.

  Definition CAN_144_convex_combine (a b : Q) : Q := a + b * (1 - a).

  Theorem CAN_144_convex_combine_identity :
    forall a b : Q, CAN_144_convex_combine a b == 1 - (1 - a) * (1 - b).
  Proof. intros a b. unfold CAN_144_convex_combine. ring. Qed.

  (* q_t = o_t + tau_t (1 - o_t) *)
  Definition CAN_144_q_t (o_t tau_t : Q) : Q := CAN_144_convex_combine o_t tau_t.

  (* Gamma_t = s^L_t + q_t (1 - s^L_t) *)
  Definition CAN_144_Gamma_t (s_L_t q_t : Q) : Q := CAN_144_convex_combine s_L_t q_t.

End CAN_144_ClaimConstitution.

