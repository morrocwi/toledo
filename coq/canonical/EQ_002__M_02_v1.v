(* EQ-002/M.02.v1 — CAN-183 — finite_diagnostic — parents: EQ-002/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-183 — root: root-readout-gate (CAN-201) — domain: method —
   tier: finite_diagnostic — occurrences: 3 *)
(** Coh_effective = Coh_latent * L_g: a genuine bound follows given
    0<=L_g<=1 and Coh_latent nonnegative, offered here as Th_coqc-grade
    scaffolding for a Definition-tier id (matching the "supporting lemma,
    not a re-tagging" style already used for similar ids). *)
Section CAN183_ProgrammeLegibility.
  Variables Coh_latent L_g : Q.
  Definition CAN183_Coh_effective : Q := Coh_latent * L_g.
  Theorem CAN183_effective_le_latent :
    0 <= Coh_latent -> 0 <= L_g <= 1 -> CAN183_Coh_effective <= Coh_latent.
  Proof.
    intros Hnn [Hnn2 Hle1]. unfold CAN183_Coh_effective.
    rewrite (Qmult_comm Coh_latent L_g).
    rewrite <- (Qmult_1_l Coh_latent) at 2.
    apply Qmult_le_compat_r; assumption.
  Qed.
End CAN183_ProgrammeLegibility.

