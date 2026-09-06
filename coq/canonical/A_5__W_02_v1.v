(* A.5/W.02.v1 — CAN-154 — Definition — parents: A.5/M.01.v1 — occurrences 6 *)

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
(** ** CAN-154 — power-channels

    (* CAN-154 — root: P_t=<P^econ,P^info,P^coerc>; P^B prop Gamma^eff A^corr Lambda^live X^H r^H; Idot=F_I(...); ownership<>informational power<>coercive power — domain: world-system — tier: Th_coqc — occurrences: 6 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River eq.
    citation (After Labour eq.(45)-(50), record 22481924) — freshly
    formalised. The three-channel power vector is a typed triple; the
    recursive institutional-loop update [F_I] is left as an abstractly-
    declared Section function (the source itself does not give it a
    closed form) with the "not predetermined" reading typed as a [Prop]
    left un-proved. The channel non-collapse is discharged via the shared
    generic witness. *)

Section CAN_154_PowerChannels.

  Variables PEcon PInfo PCoerc State3 : Type.

  Definition PowerVector : Type := PEcon * PInfo * PCoerc.

  Definition CAN_154_mk_power_vector
             (p_econ : PEcon) (p_info : PInfo) (p_coerc : PCoerc)
    : PowerVector := (p_econ, p_info, p_coerc).

  Variable F_I : State3 -> PowerVector -> State3.

  (* Idot_t = F_I(P^B_t, P^E_t, state capacity, rules, shocks): the
     institutional trajectory is not predetermined by the power vector
     alone — typed and left un-proved, per the source's own framing. *)
  Definition CAN_154_Open_not_predetermined (s : State3) (p : PowerVector) : Prop :=
    exists s' : State3, F_I s p = s' /\ s' <> s.

End CAN_154_PowerChannels.

Definition CAN_154_channel_noncollapse_witness :=
  CAN_ws_generic_rise_not_entail_rise.

