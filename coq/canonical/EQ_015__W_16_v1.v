(* EQ-015/W.16.v1 — CAN-159 — Definition — parents: EQ-015/M.01.v1 — occurrences 7 *)

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
(** ** CAN-159 — human-conversion-vector

    (* CAN-159 — root: Machine expansion =/=> Human expansion; C^H_t=<9 coordinates>; eta^HC=dlnC/dlnM — domain: world-system — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition (elasticities/thresholds require
    per-study declaration)". Master River v1.4 eq.(60)-(62)
    [human_conversion_imperative]. Direct reuse of [MR_WorldSystem.v]'s
    [eq60_machine_expansion_not_human_expansion] (Th_coqc, eq.60),
    [HumanConversionVector]/[mk_human_conversion_vector] (Definition,
    eq.61), and [eta_HC] (Definition, discrete finite-difference
    elasticity surrogate, eq.62) — no redefinition. This id's own
    [canonical_text] "Machine expansion =/=> Human expansion" is verbatim
    HCI's own framing inequality, i.e. exactly eq.(60). *)

Definition CAN_159_machine_expansion_not_human_expansion :=
  MR_WorldSystem.eq60_machine_expansion_not_human_expansion.
Definition CAN_159_HumanConversionVector := MR_WorldSystem.HumanConversionVector.
Definition CAN_159_mk_human_conversion_vector := MR_WorldSystem.mk_human_conversion_vector.
Definition CAN_159_eta_HC := MR_WorldSystem.eta_HC.

