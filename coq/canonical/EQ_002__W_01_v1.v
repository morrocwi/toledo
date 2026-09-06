(* EQ-002/W.01.v1 — CAN-164 — Definition — parents: EQ-002/M.03.v1 — occurrences 3 *)

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
(** ** CAN-164 — distributional-conversion

    (* CAN-164 — root: C^10,C^50,C^90; I^H = C^90-C^10 — domain: world-system — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition (Proposition 4 Open)". No Master
    River eq. citation (The Human Conversion Imperative Section 10,
    record 22481926) — freshly formalised. The inter-decile range is a
    plain [Q] subtraction of two declared percentile readouts (never a
    continuum quantile function). Proposition 4 ("broad human expansion
    requires conversion gains across the distribution, not only the
    mean") is the source's own tagged-Open claim, typed as a [Prop]-valued
    Definition over one discrete step of the 10th/90th-percentile
    readouts, deliberately un-proved. *)

Section CAN_164_DistributionalConversion.

  Definition CAN_164_I_H (C_10 C_90 : Q) : Q := C_90 - C_10.

  Definition CAN_164_Open_proposition4_broad_expansion
             (C_10_t C_10_t' C_90_t C_90_t' : Q) : Prop :=
    (0 < C_10_t' - C_10_t) /\ (0 < C_90_t' - C_90_t).

End CAN_164_DistributionalConversion.
