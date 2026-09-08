(* EQ-015/W.13.v1 — CAN-155 — Dr — parents: EQ-015/M.01.v1 — occurrences 1 *)

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
(** ** CAN-155 — early-warning-diagnostic

    (* CAN-155 — root: Omega_t = w_M(g_M-g_H)+w_D g_D+w_G g_G-w_q g_q-... — domain: world-system — tier: Dr — occurrences: 1 *)

    CANONICAL.json tier: "measurement". No Master River eq. citation
    (After Labour eq.(52), record 22481924) — freshly formalised. The
    nine-term signed weighted combination is typed as a finite [list]
    fold over declared (weight, signed-growth-term) pairs — a genuine
    finite sum, never a continuum integral — rather than hard-coding nine
    positional arguments; the paper's own minus signs are folded into the
    caller-supplied (negative) weights, and each named subscripted pair
    ([w_M(g_M-g_H)], [w_D g_D], [w_G g_G], [w_q g_q], [w_Gamma g_Gamma],
    [w_X g_X], [w_R g_R], [w_Lambda g_Lambda], [w_H g_H2]) is one list
    entry. Offered only as an early-warning readout, never a forecast,
    per the source's own caveat — no theorem is attempted about its
    predictive content. *)

Section CAN_155_EarlyWarningDiagnostic.

  Definition CAN_155_Omega (weighted_terms : list (Q * Q)) : Q :=
    fold_right (fun wt acc => fst wt * snd wt + acc) 0 weighted_terms.

End CAN_155_EarlyWarningDiagnostic.

