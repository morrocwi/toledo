(* EQ-015/S.09.v1 — CAN-135 — Definition — parents: EQ-015/M.03.v1 — occurrences 1 *)

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
(** ** CAN-135 — B-SOC-CORRIG

    (* CAN-135 — root: Delta_spec(R_i)>0 iff channel_i=open and Rdot_i<>0 — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". Uses the symbol Delta_spec also
    used, with a DIFFERENT formal meaning, in CAN-118 (B-SOC-ETHLOAD) —
    per rule 1 these are NOT merged, kept as two separate CAN identifiers
    over two separate typed objects (flagged here, not silently unified,
    matching CANONICAL.json's own note). *)

Inductive CAN_135_Channel : Type := Chan135_Open | Chan135_Closed.

Definition CAN_135_corrigible (channel : CAN_135_Channel) (repair_rate : Q) : Prop :=
  channel = Chan135_Open /\ ~ (repair_rate == 0).

(* Witness (tier: Th_coqc): the biconditional shape is satisfiable both
   ways — a genuinely corrigible instance (open channel, non-zero repair
   rate) and a genuinely non-corrigible one (closed channel). *)
Theorem CAN_135_corrigible_satisfiable :
  CAN_135_corrigible Chan135_Open 1
  /\ ~ CAN_135_corrigible Chan135_Closed 1.
Proof.
  split.
  - split. reflexivity. intro Hc. discriminate Hc.
  - intros [Hc _]. discriminate Hc.
Qed.

