(* A.8/M.11.v1 — CAN-187 — Definition — parents: A.8/M.01.v1 — occurrences 6 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-187 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 6 *)
(** An explicitly-disclaimed diagnostic analogy (source: "not a physical
    law"), formalised purely as typed [Q]-valued bookkeeping. *)
Section CAN187_ReactorAnalogy.
  Variables nu_t f_coh L_g187 p_int m_leg u_conv P_NL : Q.
  Definition CAN187_k_t : Q := nu_t * f_coh * L_g187 * p_int * m_leg * u_conv * P_NL.

  Variables w_d E_d w_p E_p eps187 : Q.
  Definition CAN187_beta_D : Q := (w_d * E_d) / (w_d * E_d + w_p * E_p + eps187).

  Variable beta_min : Q.
  Variables IntegrityClean XenonLow ConversionLogOn : bool.
  Definition CAN187_increase_mint_rate : Prop :=
    beta_min <= CAN187_beta_D /\ IntegrityClean = true /\ XenonLow = true /\ ConversionLogOn = true.

  Variables Nind Ncit : Q.
  Definition CAN187_rho_R : Q := Nind / Ncit.

  Variables Osub Eknown Cstale : bool.
  Definition CAN187_X_t : Q :=
    (if Osub then 1 else 0) + 2 * (if Eknown then 1 else 0) + 3 * (if Cstale then 1 else 0).

  Variables Nindreuse Nterminal : Q.
  Definition CAN187_BR_t : Q := Nindreuse / Nterminal.
End CAN187_ReactorAnalogy.

