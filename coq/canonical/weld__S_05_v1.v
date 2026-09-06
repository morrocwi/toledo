(* weld/S.05.v1 — CAN-123 — Definition — parents: weld/M.03.v1 — occurrences 4 *)

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
(** ** CAN-123 — collective-readout

    (* CAN-123 — root: Z_G=<{Z_Ai},T_G,A_G,C_G>; m^G_{t+1}=rho m^G_t+sigma_t(e) — domain: social — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition". A group's retained state and
    semantic readout, without positing a group mind: the group state is
    typed as an explicit aggregate structure over a finite list of
    individual states, and its "readout" a declared function of that
    structure — never a shared internal state of its own. *)

Section CAN_123_CollectiveReadout.

  Variables IndZ TimeT AggT CouplT SemVal EventT : Type.

  Record CAN_123_GroupState : Type := mkGroupState
    { gs_individuals : list IndZ
    ; gs_time        : TimeT
    ; gs_aggregator  : AggT
    ; gs_coupling    : CouplT
    }.

  Variable q_sem_G : CAN_123_GroupState -> SemVal.

  Definition CAN_123_group_readout (Z : CAN_123_GroupState) : SemVal := q_sem_G Z.

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

