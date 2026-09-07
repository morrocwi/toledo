(******************************************************************************)
(* InfoSharedReadoutForcesSharedMemory_attempt.v -- EXPLORATORY, single-attempt  *)
(*  file (not part of the build). Standalone; Requires only Coq QArith (no       *)
(*  Reals). Mirrored byte-identically intosolver-arc-privateformal/,    *)
(*  where the readout-physics arc CI audit (scripts/ci_attempts_audit.py) guards *)
(*  it; this public-twin copy has no CI of its own.                              *)
(*                                                                            *)
(* MOTIVATION -- the CONVERSE of Face XI (canonical witness: causal-quantum-      *)
(*  gravity/formal/InfoMemoryBeforeMass.v, theorem memory_before_mass; copied as  *)
(* solver-arc-privateformal/InfoMemoryBeforeMass_attempt.v). Face XI    *)
(*  proves the FORWARD direction: equal memory                                   *)
(*  tau_c = M/D forces an identical discrete decay ratio, whatever the separate   *)
(*  (M,D). This file closes the REVERSE direction: if two systems return the SAME *)
(*  decay readout at ONE nonzero step dt, they SHARE tau_c -- a single agreeing   *)
(*  readout is enough to force shared memory. Together: tau_c-equality and        *)
(*  readout-equality are the SAME statement (memory_iff_readout).                 *)
(*                                                                            *)
(* LINEAGE (attribution, binding) -- the question was seeded 2026-08-29 by an     *)
(*  EXTERNAL proposal relayed by the founder (not this program's own): 'under the *)
(*  same sky g reads the same; under the same CMB c, h, Lambda read the same; if  *)
(*  they differed the CMB would look different.' That proposal is an ANALOGY and  *)
(*  contributes NO evidence, constant, or equation here (EPIS-KNOWLEDGE-          *)
(*  VALIDATION: external input enters as a hint at reviewer level, never as       *)
(*  certification). What is imported is only the DIRECTION of inference --        *)
(*  shared readout => shared retained memory -- which Face XI had left unproven.  *)
(*  The physical constants themselves stay exactly where the forcing ledger puts  *)
(*  them: c, hbar, G borrowed; alpha and mass ratios REJECTED/[Open]; Lambda has   *)
(*  no node in the core at all. Nothing about them is claimed here.               *)
(*                                                                            *)
(* RESULT (all over Q, axiom-free):                                               *)
(*   (1) tau_eq_of_rate_eq: equal observable rate forces equal memory (mirror of  *)
(*       Face XI's rate_eq_of_tau_eq).                                            *)
(*   (2) rate_eq_of_ratio_eq: ONE agreeing decay readout at a nonzero step dt     *)
(*       forces equal rate (dt cancels; dt = 0 would read nothing and is excluded *)
(*       -- a zero-size step is the non-readout the discrete rule forbids).       *)
(*   (3) shared_readout_forces_shared_memory: the converse of memory_before_mass  *)
(*       -- identical dynamics readout => identical tau_c, whatever (M,D).        *)
(*   (4) memory_iff_readout: Face XI upgraded to an equivalence.                  *)
(*   (5) readout_cannot_split_mass: the disclosed LIMIT -- shared readout does    *)
(*       NOT force shared M (witness (2,1) vs (4,2), same tau_c = 2). The readout *)
(*       retains tau_c and nothing finer. This is the same 'mass is not observable *)
(*       apart from memory' fact as Face XI, now stated from the readout side.    *)
(*                                                                            *)
(* SCOPE -- TIER = Th_coqc (Q, axiom-free) for the discrete structural facts.       *)
(*  OFF this tier: any identification of 'ratio' with a physical measurement      *)
(*  (Dr); any claim that agreement at one dt implies agreement at other dt beyond  *)
(*  what (3)+(forward) give; any continuum limit; any statement about c, h,       *)
(*  Lambda, alpha, or the CMB. No Reals; no axiom.                                *)
(******************************************************************************)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Open Scope Q_scope.

Module InfoSharedReadoutForcesSharedMemory.

  (* Same primitives as the canonical Face XI file, restated so this file stands *)
  (* alone in either twin.                                                      *)
  Definition tau_c (M D : Q) : Q := M / D.
  Definition rate  (M D : Q) : Q := D / M.
  Definition ratio (M D dt : Q) : Q := 1 - dt * rate M D.

  Lemma rate_times_tau :
    forall M D : Q, ~ (M == 0) -> ~ (D == 0) -> rate M D * tau_c M D == 1.
  Proof. intros M D HM HD. unfold rate, tau_c. field. split; assumption. Qed.

  Lemma rate_nonzero :
    forall M D : Q, ~ (M == 0) -> ~ (D == 0) -> ~ (rate M D == 0).
  Proof.
    intros M D HM HD Hr.
    assert (H := rate_times_tau M D HM HD).
    rewrite Hr in H. lra.
  Qed.

  (* (1) equal rate => equal memory. *)
  Theorem tau_eq_of_rate_eq :
    forall M1 D1 M2 D2 : Q,
      ~ (M1 == 0) -> ~ (D1 == 0) -> ~ (M2 == 0) -> ~ (D2 == 0) ->
      rate M1 D1 == rate M2 D2 -> tau_c M1 D1 == tau_c M2 D2.
  Proof.
    intros M1 D1 M2 D2 H1 HD1 H2 HD2 Hrate.
    assert (R1 : rate M1 D1 * tau_c M1 D1 == 1) by (apply rate_times_tau; assumption).
    assert (R2 : rate M2 D2 * tau_c M2 D2 == 1) by (apply rate_times_tau; assumption).
    assert (Hr2 : ~ (rate M2 D2 == 0)) by (apply rate_nonzero; assumption).
    rewrite Hrate in R1.
    assert (Hzero : rate M2 D2 * (tau_c M1 D1 - tau_c M2 D2) == 0).
    { assert (Ht : rate M2 D2 * (tau_c M1 D1 - tau_c M2 D2)
                   == rate M2 D2 * tau_c M1 D1 - rate M2 D2 * tau_c M2 D2) by ring.
      rewrite Ht. rewrite R1. rewrite R2. ring. }
    apply Qmult_integral in Hzero. destruct Hzero as [Hz | Hz].
    - exfalso. apply Hr2. exact Hz.
    - lra.
  Qed.

  (* (2) ONE agreeing readout at a nonzero step forces equal rate. *)
  Theorem rate_eq_of_ratio_eq :
    forall M1 D1 M2 D2 dt : Q,
      ~ (dt == 0) ->
      ratio M1 D1 dt == ratio M2 D2 dt -> rate M1 D1 == rate M2 D2.
  Proof.
    intros M1 D1 M2 D2 dt Hdt Hratio. unfold ratio in Hratio.
    assert (Hzero : dt * (rate M1 D1 - rate M2 D2) == 0).
    { assert (Ht : dt * (rate M1 D1 - rate M2 D2)
                   == (1 - dt * rate M2 D2) - (1 - dt * rate M1 D1)) by ring.
      rewrite Ht. rewrite Hratio. ring. }
    apply Qmult_integral in Hzero. destruct Hzero as [Hz | Hz].
    - exfalso. apply Hdt. exact Hz.
    - lra.
  Qed.

  (* (3) SHARED READOUT FORCES SHARED MEMORY: converse of memory_before_mass. *)
  Theorem shared_readout_forces_shared_memory :
    forall M1 D1 M2 D2 dt : Q,
      ~ (M1 == 0) -> ~ (D1 == 0) -> ~ (M2 == 0) -> ~ (D2 == 0) -> ~ (dt == 0) ->
      ratio M1 D1 dt == ratio M2 D2 dt -> tau_c M1 D1 == tau_c M2 D2.
  Proof.
    intros M1 D1 M2 D2 dt H1 HD1 H2 HD2 Hdt Hratio.
    apply tau_eq_of_rate_eq; try assumption.
    apply (rate_eq_of_ratio_eq M1 D1 M2 D2 dt Hdt Hratio).
  Qed.

  (* forward direction, re-proved here so the iff is self-contained. *)
  Lemma ratio_eq_of_tau_eq :
    forall M1 D1 M2 D2 dt : Q,
      ~ (M1 == 0) -> ~ (D1 == 0) -> ~ (M2 == 0) -> ~ (D2 == 0) ->
      tau_c M1 D1 == tau_c M2 D2 -> ratio M1 D1 dt == ratio M2 D2 dt.
  Proof.
    intros M1 D1 M2 D2 dt H1 HD1 H2 HD2 Htau. unfold ratio.
    assert (R1 : rate M1 D1 * tau_c M1 D1 == 1) by (apply rate_times_tau; assumption).
    assert (R2 : rate M2 D2 * tau_c M2 D2 == 1) by (apply rate_times_tau; assumption).
    assert (Ht2 : ~ (tau_c M2 D2 == 0)).
    { intro Hc. rewrite Hc in R2. lra. }
    rewrite Htau in R1.
    assert (Hzero : (rate M1 D1 - rate M2 D2) * tau_c M2 D2 == 0).
    { assert (Ht : (rate M1 D1 - rate M2 D2) * tau_c M2 D2
                   == rate M1 D1 * tau_c M2 D2 - rate M2 D2 * tau_c M2 D2) by ring.
      rewrite Ht. rewrite R1. rewrite R2. ring. }
    apply Qmult_integral in Hzero. destruct Hzero as [Hz | Hz].
    - assert (Hr : rate M1 D1 == rate M2 D2) by lra. rewrite Hr. reflexivity.
    - exfalso. apply Ht2. exact Hz.
  Qed.

  (* (4) Face XI as an equivalence: memory equality IS readout equality. *)
  Theorem memory_iff_readout :
    forall M1 D1 M2 D2 dt : Q,
      ~ (M1 == 0) -> ~ (D1 == 0) -> ~ (M2 == 0) -> ~ (D2 == 0) -> ~ (dt == 0) ->
      (tau_c M1 D1 == tau_c M2 D2 <-> ratio M1 D1 dt == ratio M2 D2 dt).
  Proof.
    intros M1 D1 M2 D2 dt H1 HD1 H2 HD2 Hdt. split.
    - apply ratio_eq_of_tau_eq; assumption.
    - apply shared_readout_forces_shared_memory; assumption.
  Qed.

  (* (5) THE LIMIT, disclosed: a shared readout does NOT force a shared mass. *)
  Theorem readout_cannot_split_mass :
    exists M1 D1 M2 D2 : Q,
      ~ (M1 == 0) /\ ~ (D1 == 0) /\ ~ (M2 == 0) /\ ~ (D2 == 0) /\
      (forall dt : Q, ratio M1 D1 dt == ratio M2 D2 dt) /\
      ~ (M1 == M2).
  Proof.
    exists 2, 1, 4, 2.
    split. { intro H. inversion H. }
    split. { intro H. inversion H. }
    split. { intro H. inversion H. }
    split. { intro H. inversion H. }
    split.
    - intro dt. unfold ratio, rate.
      assert (H : (1 / 2 : Q) == 2 / 4) by reflexivity.
      rewrite H. reflexivity.
    - intro H. inversion H.
  Qed.

End InfoSharedReadoutForcesSharedMemory.

(* Axiom audit (the arc CI counts these; every line must print                *)
(* "Closed under the global context").                                        *)
Print Assumptions InfoSharedReadoutForcesSharedMemory.tau_eq_of_rate_eq.
Print Assumptions InfoSharedReadoutForcesSharedMemory.rate_eq_of_ratio_eq.
Print Assumptions InfoSharedReadoutForcesSharedMemory.shared_readout_forces_shared_memory.
Print Assumptions InfoSharedReadoutForcesSharedMemory.memory_iff_readout.
Print Assumptions InfoSharedReadoutForcesSharedMemory.readout_cannot_split_mass.

(* PRIMARY TARGETS: InfoSharedReadoutForcesSharedMemory.shared_readout_forces_    *)
(* shared_memory (ONE agreeing decay readout at a nonzero step forces equal        *)
(* tau_c, whatever the separate M and D) and .memory_iff_readout (Face XI upgraded *)
(* to an equivalence), resting on .tau_eq_of_rate_eq and .rate_eq_of_ratio_eq;     *)
(* .readout_cannot_split_mass discloses the limit (tau_c is all the readout          *)
(* retains -- mass is not separately observable, from the readout side too).       *)
(* External-proposal lineage disclosed above; no evidence imported. No continuum,   *)
(* no Reals, no axiom. *)
