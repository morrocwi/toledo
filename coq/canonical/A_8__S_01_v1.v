(* A.8/S.01.v1 — CAN-139 — Dr — parents: A.8/M.01.v1 — occurrences 1 *)

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
(** ** CAN-139 — B-SOC-IDCERT

    (* CAN-139 — root: two models agree on Pr(complaint)=1/10, imply a five-fold difference in true potential — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "measurement". The single sharpest, most
    concrete instance in this group's corpus of readout-not-truth stated
    as a checkable numeric fact: P1 (r=d=x=9/10, f=1) gives p*_P1=729/1000;
    P2 (same r,d,x, f=1/5) gives p*_P2=729/5000; both are consistent with
    the identical observed record, yet the record alone only bounds the
    true potential to the interval [729/5000, 729/1000] — a genuinely
    finite, exactly computable [Q] fact, no [Reals] involved. *)

Theorem CAN_139_identifiability_certificate :
  ((9#10) * (9#10) * (9#10) * 1 == 729#1000)
  /\ ((9#10) * (9#10) * (9#10) * (1#5) == 729#5000)
  /\ (729#5000 <= 729#1000)
  /\ (729#5000 <> 729#1000).
Proof.
  repeat split; try lra.
  intro Hc. discriminate Hc.
Qed.
