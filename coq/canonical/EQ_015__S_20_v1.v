(* EQ-015/S.20.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.02.v1 *)
(* also carries the witness that V/tau_c/Delta_spec (CE-09/10/11, weld/S.17-19... -- see EQ-015/S.17-19.v1) are jointly satisfiable, since the witness proves the composite CAN_118_Ethical, not any one conjunct alone. *)

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

Section CAN_118_EthLoad.

  Variable V : nat -> Q.       (* ethical-load ledger, one value per tick *)
  Variable tau_c : Q.          (* causal-memory admissibility parameter *)
  Variable Delta_spec : Q.     (* spectral-stability margin *)

  Definition CAN_118_non_increasing : Prop :=
    forall n : nat, V (S n) <= V n.

  Definition CAN_118_Ethical : Prop :=
    CAN_118_non_increasing /\ tau_c > 0 /\ Delta_spec > 0.

  (* Witness (tier: Th_coqc): satisfiable by the trivially-flat ledger
     V=0, with both admissibility parameters positive — the locked
     definition is not vacuous. *)
  Theorem CAN_118_ethical_satisfiable :
    exists (V' : nat -> Q) (tau_c' Delta_spec' : Q),
      (forall n, V' (S n) <= V' n) /\ tau_c' > 0 /\ Delta_spec' > 0.
  Proof.
    exists (fun _ => 0), 1, 1.
    split; [| split].
    - intro n. apply Qle_refl.
    - lra.
    - lra.
  Qed.

End CAN_118_EthLoad.
