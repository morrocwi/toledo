(* weld/S.49.v1 — Definition — parents: weld/M.03.v1, weld/S.05.v1 *)

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

Section CAN_123_CollectiveReadout.

  Variables IndZ TimeT AggT CouplT SemVal EventT : Type.

  (* m^G_{t+1} = rho * m^G_t + sigma_t(e) — a genuinely finite [Q]-valued
     recurrence, one memory-trace update per event. *)
  Definition CAN_123_memory_update (rho m_t : Q) (sigma_t_e : Q) : Q :=
    rho * m_t + sigma_t_e.

  (* Witness (tier: Th_coqc): a sanity specialisation — with zero incoming
     signal the memory trace update is exactly the decayed prior trace,
     confirming the recurrence is genuinely the declared linear shape and
     not a silently-different update. *)
  Theorem CAN_123_memory_update_zero_signal :
    forall rho m_t : Q, CAN_123_memory_update rho m_t 0 == rho * m_t.
  Proof. intros. unfold CAN_123_memory_update. ring. Qed.

End CAN_123_CollectiveReadout.
