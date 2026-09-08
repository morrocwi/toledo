(* weld/E.09.v1 — CAN-205 — Definition — parents: weld/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-205 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** S_n : X_n -> Z_n; z_n = Pi_n S_n(X_n) + eta_n; z~_n = sum_{j<h_n}
    a_{n,j} z_{n-j}: a raw noisy reading smoothed by a finite trailing
    window into a weighted average — a finite weighted sum over an
    explicit list of (weight, reading) pairs, proved that a length-1
    window with unit weight returns the single reading exactly. *)
Definition CAN205_windowed_avg (window : list (Q * Q)) : Q :=
  fold_right (fun p acc => fst p * snd p + acc) 0 window.

Theorem CAN205_window_of_one_exact :
  forall z : Q, CAN205_windowed_avg [(1, z)] == z.
Proof. intro z. unfold CAN205_windowed_avg. simpl. ring. Qed.

