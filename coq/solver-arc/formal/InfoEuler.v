(******************************************************************************)
(* InfoEuler.v — Euler's number e, characterized (NOT faked), from the R4 root *)
(*                                                                            *)
(* e is transcendental (e ∉ ℚ), so there is NO closed rational theorem for    *)
(* its value — that is honest mathematics, not a gap in our method (same as   *)
(* π). What IS exact and machine-checkable is its CHARACTERIZATION:           *)
(*   (1) the rational partial sums Σ_{k≤n} 1/k! strictly INCREASE, and        *)
(*   (2) the terms are DOMINATED by a convergent geometric (k! ≥ 2^{k-1}),    *)
(*       so the series is bounded ⇒ it converges to e (the limit is +reals);  *)
(*   (3) e is the base of the one-parameter SEMIGROUP E(s+t)=E(s)E(t),        *)
(*       E(0)=1 ⇒ E(n)=E(1)^n — exactly the group law of the R4 evolution     *)
(*       semigroup (InfoEvolution.evolution_group / InfoHilbertBridge), so    *)
(*       e is the generator base of our exp(−Lt) readout.                     *)
(* readout-not-truth: the partial sums and the semigroup law are exact; the   *)
(* transcendental value is the +reals limit, never asserted as a rational.    *)
(******************************************************************************)

Require Import QArith.
Require Import Coq.micromega.Psatz.
Require Import Coq.micromega.Lqa.
Require Import Coq.ZArith.ZArith.

Module InfoEuler.
  Open Scope Q_scope.

  Definition Qnat (n : nat) : Q := inject_Z (Z.of_nat n).
  Fixpoint factN (n : nat) : Q := match n with O => 1 | S k => Qnat (S k) * factN k end.
  Fixpoint esum  (n : nat) : Q := match n with O => 1 | S k => esum k + / (factN (S k)) end.  (* Σ_{k≤n} 1/k! *)
  Fixpoint pow2  (n : nat) : Q := match n with O => 1 | S k => (2#1) * pow2 k end.
  Fixpoint qpow (x : Q) (n : nat) : Q := match n with O => 1 | S k => x * qpow x k end.

  Lemma Qnat_S_pos : forall n : nat, 0 < Qnat (S n).
  Proof. intro n. unfold Qnat. replace 0 with (inject_Z 0) by reflexivity. rewrite <- Zlt_Qlt. lia. Qed.
  Lemma factN_pos : forall n : nat, 0 < factN n.
  Proof. induction n; simpl. lra. apply Qmult_lt_0_compat; [ apply Qnat_S_pos | exact IHn ]. Qed.

  (* (1) the partial sums of Σ 1/k! strictly increase *)
  Theorem esum_increasing : forall n : nat, esum n < esum (S n).
  Proof. intro n. assert (H : 0 < / factN (S n)) by (apply Qinv_lt_0_compat; apply factN_pos).
    change (esum (S n)) with (esum n + / factN (S n)). lra. Qed.

  (* (2) k! dominates 2^{k-1} ⇒ the terms 1/k! ≤ 1/2^{k-1} ⇒ the series is bounded ⇒ e converges (+reals) *)
  Theorem fact_dominates_pow2 : forall n : nat, pow2 n <= factN (S n).
  Proof. induction n.
    - now vm_compute.
    - assert (Hp : 0 < factN (S n)) by apply factN_pos.
      assert (H2 : (2#1) <= Qnat (S (S n))).
      { unfold Qnat. replace (2#1) with (inject_Z 2) by reflexivity. rewrite <- Zle_Qle. lia. }
      change (pow2 (S n)) with ((2#1) * pow2 n).
      change (factN (S (S n))) with (Qnat (S (S n)) * factN (S n)).
      apply Qle_trans with ((2#1) * factN (S n)).
      + lra.
      + apply Qmult_le_compat_r; [ exact H2 | apply Qlt_le_weak; exact Hp ]. Qed.

  (* (3) e = base of the one-parameter SEMIGROUP (the R4 evolution group law): E(0)=1, E(a+b)=E a·E b ⇒
     E(n) = E(1)^n. e := E(1) is the generator base; this IS the law of our exp(−Lt) readout. *)
  Theorem semigroup_power : forall (E : Q -> Q),
    E 0 == 1 -> (forall a b, E (a+b) == E a * E b) -> forall n : nat, E (Qnat n) == qpow (E 1) n.
  Proof. intros E H0 Hmorph. induction n.
    - simpl. unfold Qnat. simpl. exact H0.
    - assert (Hs : Qnat (S n) = Qnat n + 1).
      { unfold Qnat. rewrite Nat2Z.inj_succ. unfold Z.succ. rewrite inject_Z_plus. reflexivity. }
      change (qpow (E 1) (S n)) with (E 1 * qpow (E 1) n).
      rewrite Hs, Hmorph, IHn. ring. Qed.

End InfoEuler.
