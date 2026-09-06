(* EQ-002/E.09.v1 — CAN-203 — Definition — parents: EQ-002/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-203 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** x_{i,n} = Access(A_n; O_i, L_i, T_i, R_i, C_i): an agent's realized
    exposure to a source, indexed by outlet/channel/timing/relation/
    context — a typed 6-argument function. *)
Section CAN203_AccessExposure.
  Variables Agent Outlet Channel Timing Relation Ctx Exposure : Type.
  Variable Access : Agent -> Outlet -> Channel -> Timing -> Relation -> Ctx -> Exposure.
  Definition CAN203_x := Access.
End CAN203_AccessExposure.

