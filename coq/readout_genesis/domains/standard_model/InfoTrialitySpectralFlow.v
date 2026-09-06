(* ================================================================= *)
(*  InfoTrialitySpectralFlow.v                               *)
(*  Triality Spectral Flow v0.6 -- the RG variable is rho_t (triality *)
(*  retention), NOT kappa. Serial/convolution blocking is EXACT and    *)
(*  the block-scale existence theorem holds over Q.                   *)
(*                                                                     *)
(*  Over Q (qpow a n = a^n by nat recursion; a_R^(m)=a_R^m is the      *)
(*  Peter-Weyl/convolution law, rho_t(b)=rho_t^(b^2) with m=b^2):     *)
(*    (serial)  qpow a (m+n) = qpow a m * qpow a n   (composition)     *)
(*    (pos)     0<a  =>  0 < qpow a n                                  *)
(*    (contract) 0<a<1  =>  qpow a (S n) < qpow a n  (more blocking    *)
(*               contracts more -- info cost grows with block size)    *)
(*    (exists)  a concrete block scale passes: 55 * qpow (1/2) 6 < 1   *)
(*              (mu_4 ~ 55, rho=1/2, b^2=6 already certifies)          *)
(*    (ctrl1)   qpow 1 n = 1  (no spectral loss => no contraction,     *)
(*               FAIL_NO_TRIALITY_CONTRACTION; also the trivial        *)
(*               sector t=0 has rho_0=1 => sigma_0=0, correct)         *)
(*                                                                     *)
(*  HONEST FENCE. EXACT for serial/convolution blocking + the         *)
(*  existence mechanism (spectral contraction b^2 beats finite surface *)
(*  entropy log mu_4). The full 4D result is CONDITIONAL: real blocks   *)
(*  are correlated, with a defect eps_t(b); a block scale still exists  *)
(*  iff eps_* < -log rho_t. Convolution/character blocking is STANDARD  *)
(*  (Peter-Weyl; strong-coupling; spin-foam duals) -- the reading as    *)
(*  retained-triality contraction is ours. OPEN: K_b from the full      *)
(*  block integral, eps_t(b) of the real action for b=2, a               *)
(*  representation-tail bound, and continuum scale calibration.         *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.Arith.Arith.

Module InfoTrialitySpectralFlow.
Open Scope Q_scope.

Fixpoint qpow (a : Q) (n : nat) : Q :=
  match n with O => 1 | S k => a * qpow a k end.

(* (serial) convolution composition: a_R^(m+n) = a_R^m * a_R^n *)
Theorem serial_blocking_law : forall (a : Q) (m n : nat),
  qpow a (m + n) == qpow a m * qpow a n.
Proof.
  intros a m n. induction m as [|k IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

(* (pos) positivity of the retention factor *)
Theorem qpow_pos : forall (a : Q) (n : nat), 0 < a -> 0 < qpow a n.
Proof.
  intros a n Ha. induction n as [|k IH]; simpl.
  - lra.
  - apply Qmult_lt_0_compat; assumption.
Qed.

(* (contract) 0<a<1 => one more block cell strictly contracts retention *)
Theorem block_contraction : forall (a : Q) (n : nat),
  0 < a -> a < 1 -> qpow a (S n) < qpow a n.
Proof.
  intros a n H0 H1. simpl.
  assert (Hp : 0 < qpow a n) by (apply qpow_pos; assumption).
  nra.
Qed.

(* (exists) a concrete certified block scale: mu_4(~55) * rho^(b^2) < 1 with rho=1/2, b^2=6 *)
Theorem block_scale_exists_witness : 55 * qpow (1#2) 6 < 1.
Proof.
  assert (E : qpow (1#2) 6 == (1#64)) by (vm_compute; reflexivity).
  rewrite E. lra.
Qed.

(* (ctrl1) no spectral loss (rho=1) => retention never contracts (=1 for all b) *)
Theorem no_contraction_if_rho_one : forall n : nat, qpow 1 n == 1.
Proof.
  intro n. induction n as [|k IH]; simpl.
  - reflexivity.
  - rewrite IH. ring.
Qed.

End InfoTrialitySpectralFlow.

Print Assumptions InfoTrialitySpectralFlow.serial_blocking_law.
Print Assumptions InfoTrialitySpectralFlow.qpow_pos.
Print Assumptions InfoTrialitySpectralFlow.block_contraction.
Print Assumptions InfoTrialitySpectralFlow.block_scale_exists_witness.
Print Assumptions InfoTrialitySpectralFlow.no_contraction_if_rho_one.
