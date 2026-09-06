(* EQ-015/W.14.v1 — CAN-157 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

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
(** ** CAN-157 — corrigible-agency-worldsystem

    (* CAN-157 — root: A^corr_{H,i,t}(g) = max_{pi in Pi^live_{i,t}(g)} Pr^pi(R_g cap D_g cap X_g cap F_g) — domain: world-system — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(56)
    [after_labour eq.34]. Direct reuse of [MR_WorldSystem.v]'s
    [corrigible_agency_ws]/[corrigible_agency_ws_upper_bound] — no
    redefinition. Per CANONICAL.json's own note, this parallels but is not
    identical to [corrigible-agency-witnessed] (CAN-060, a different,
    human-AI-family id) — the same envelope *form*, restated over the
    live set at world-system granularity, kept under its own name. *)

Definition CAN_157_corrigible_agency_ws := MR_WorldSystem.corrigible_agency_ws.
Definition CAN_157_corrigible_agency_ws_upper_bound :=
  MR_WorldSystem.corrigible_agency_ws_upper_bound.

