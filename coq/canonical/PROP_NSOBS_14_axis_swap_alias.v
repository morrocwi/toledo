(* ===================================================================== *)
(*  PROP_NSOBS_14_axis_swap_alias.v                                       *)
(*  Explicit N=1 cubic-symmetry shell-energy alias beyond translations    *)
(*  (Toledo proposal PROP-NSOBS-14, code weld/P.??.v1, family NSOBS).      *)
(*                                                                         *)
(*  Statement mechanized (registry/proposals/                             *)
(*  ns_energy_observability_symmetry_alias.json):                         *)
(*    exists x_a, x_b in X_1 (the N=1 truncated one-mode state space):     *)
(*    x_b is NOT in the T^3-translation orbit of x_a, yet the shell-       *)
(*    energy derivative record I^(n)(x_a) = I^(n)(x_b) for every finite n. *)
(*    The witnesses are the two one-mode states supported at wavevectors  *)
(*    (1,0,0) and (0,1,0).                                                *)
(*                                                                         *)
(*  The underlying physics (from this task's how_to_check, itself the     *)
(*  closed-form solution of the standard damped-mode ODE dE/dt=-2*nu*     *)
(*  kappa*E that a single N=1 Fourier mode obeys once its own quadratic    *)
(*  self-interaction is exactly annihilated by Galerkin truncation --     *)
(*  the self-term lands at wavevector 2k, which for |k|=1 axis-aligned     *)
(*  wavevectors as here already leaves the {-1,0,1}^3 cutoff cube, so no   *)
(*  external nonlinear-closure argument is needed for this specific        *)
(*  witness pair): for a one-mode state x with wavevector k and initial    *)
(*  shell energy E0, the n-th derivative of the shell-energy reader at      *)
(*  t=0 is the closed form I^(n)(x) = (-2*nu*kappa(k))^n * E0, where        *)
(*  kappa(k) := |k|^2. This file takes that closed form as its definition  *)
(*  of I (it is direct algebra from an exponential, not additional          *)
(*  physical content requiring further mechanization) and mechanizes the   *)
(*  two things the proposal actually asserts:                              *)
(*    1. kappa(1,0,0) = kappa(0,1,0) = 1, so I^(n) agrees for the two       *)
(*       witnesses (same amplitude) at every finite n -- direct              *)
(*       computation/substitution.                                          *)
(*    2. (0,1,0) is not reachable from (1,0,0) by any translation, given    *)
(*       only the one property of a translation used by the proposal's     *)
(*       own argument: a translation preserves which wavevector is          *)
(*       excited (it only shifts Fourier phase). This is formalized          *)
(*       generically over an abstract group G acting on one-mode states,    *)
(*       with that single "preserves wavevector" hypothesis, exactly the    *)
(*       weld-hypothesis idiom already used in this repo's other proofs     *)
(*       (see PROP_CONF_03_union_bound.v, PROP_NS_TAPE_CLOSED_DOMAIN_01.v). *)
(*                                                                          *)
(*  What this does NOT prove: it does not mechanize the Navier-Stokes       *)
(*  Galerkin-truncation argument itself (that the quadratic self-term of   *)
(*  a single axis-aligned unit mode is exactly annihilated by the N=1        *)
(*  cutoff, hence the closed-form I above is the TRUE truncated-dynamics     *)
(*  solution) -- that is the physical content cited from the how_to_check   *)
(*  reasoning and taken as the definition of I, not re-derived from a         *)
(*  Navier-Stokes PDE or a Galerkin projection formalized in Coq. It also    *)
(*  does not classify translations in general (e.g. it never constructs      *)
(*  a concrete torus-translation group action) -- it assumes only the one    *)
(*  property of ANY translation action that the proposal's own argument      *)
(*  actually needs (wavevector preservation), as an abstract hypothesis      *)
(*  on an abstract group G, matching the "Dr" (hand-derivation) tier this    *)
(*  proposal already carries. It also does not classify every discrete       *)
(*  symmetry at arbitrary finite N (per this proposal's own claim_boundary,  *)
(*  it is a fixed, explicit N=1 counterexample only).                        *)
(*                                                                            *)
(*  Rational/integer-native (no Coq.Reals): wavevectors are Z*Z*Z,            *)
(*  kappa and shell energies are Q, matching this repo's Q-over-R              *)
(*  precedent (PROP_NS_TAPE_CLOSED_DOMAIN_01.v: merely `Require`-ing            *)
(*  Coq.Reals.Reals pulls in a classical axiom in this Coq version even        *)
(*  for a trivial fact, and nothing about this claim needs the reals).         *)
(*                                                                              *)
(*  Expected: Print Assumptions nsobs14_axis_swap_alias                        *)
(*    => Closed under the global context (axiom-free).                         *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.ZArith.ZArith.

Local Open Scope Q_scope.

(* ===================================================================== *)
(*  1. One-mode states, kappa, and the closed-form shell-energy record.  *)
(* ===================================================================== *)

(* A one-mode N=1 Fourier-Galerkin state: which integer wavevector is    *)
(* excited, and the (real, here rational) amplitude / initial shell      *)
(* energy carried by that single mode.                                   *)
Record OneMode : Type := mkOneMode
  { wv  : (Z * Z * Z)%type
  ; amp : Q
  }.

(* kappa(k) := |k|^2, computed over Z then embedded into Q. *)
Definition kappa_of (k : Z * Z * Z) : Q :=
  match k with
  | (a, b, c) => inject_Z (a * a + b * b + c * c)
  end.

Definition shellE0 (x : OneMode) : Q := amp x.

(* Plain natural-number power on Q, defined directly (no dependency on   *)
(* QArith's own Qpower, to keep the axiom surface minimal and obvious).  *)
Fixpoint qpow_nat (q : Q) (n : nat) : Q :=
  match n with
  | O => 1
  | S n' => q * qpow_nat q n'
  end.

(* The closed-form shell-energy derivative record of a one-mode state:   *)
(* I^(n)(x) = (-2*nu*kappa(wv x))^n * shellE0(x), the exact solution of   *)
(* the purely-linear damped-mode equation this proposal's how_to_check    *)
(* derives for an N=1-truncated single axis-aligned unit mode.            *)
Definition I (nu : Q) (x : OneMode) (n : nat) : Q :=
  qpow_nat (- (2 * nu * kappa_of (wv x))) n * shellE0 x.

(* ===================================================================== *)
(*  2. The two explicit witnesses: wavevectors (1,0,0) and (0,1,0).       *)
(* ===================================================================== *)

Definition k_a : Z * Z * Z := (1, 0, 0)%Z.
Definition k_b : Z * Z * Z := (0, 1, 0)%Z.

Lemma kappa_k_a : kappa_of k_a = 1.
Proof. reflexivity. Qed.

Lemma kappa_k_b : kappa_of k_b = 1.
Proof. reflexivity. Qed.

Lemma kappa_agree : kappa_of k_a = kappa_of k_b.
Proof. rewrite kappa_k_a, kappa_k_b. reflexivity. Qed.

Lemma k_a_ne_k_b : k_a <> k_b.
Proof. discriminate. Qed.

(* ===================================================================== *)
(*  3. Derivative-record equality: same kappa + same initial energy      *)
(*     forces I^(n) to agree for the two witnesses, at every finite n.    *)
(* ===================================================================== *)

Section DerivativeAgreement.

  Variable c  : Q.  (* the common amplitude / initial shell energy *)

  Definition x_a : OneMode := mkOneMode k_a c.
  Definition x_b : OneMode := mkOneMode k_b c.

  Lemma shellE0_agree : shellE0 x_a = shellE0 x_b.
  Proof. reflexivity. Qed.

  Theorem I_agree : forall nu : Q, forall n : nat, I nu x_a n = I nu x_b n.
  Proof.
    intros nu n.
    unfold I, x_a, x_b; simpl.
    reflexivity.
  Qed.

End DerivativeAgreement.

(* ===================================================================== *)
(*  4. Translation orbit: an abstract group action that preserves        *)
(*     wavevector cannot carry x_a to x_b, since k_a <> k_b.              *)
(* ===================================================================== *)

Section TranslationOrbit.

  (* An abstract translation group G acting on one-mode states, with the *)
  (* single property the proposal's own argument uses: a translation      *)
  (* only shifts Fourier phase, never which wavevector is excited.        *)
  Variable G : Type.
  Variable act : G -> OneMode -> OneMode.
  Hypothesis act_preserves_wv : forall (g : G) (x : OneMode), wv (act g x) = wv x.

  Definition in_orbit (x y : OneMode) : Prop :=
    exists g : G, act g x = y.

  Lemma not_in_orbit_of_distinct_wv :
    forall x y : OneMode, wv x <> wv y -> ~ in_orbit x y.
  Proof.
    intros x y Hne [g Heq].
    apply Hne.
    rewrite <- Heq.
    symmetry.
    apply act_preserves_wv.
  Qed.

  Theorem x_b_not_in_orbit_of_x_a :
    forall c : Q, ~ in_orbit (x_a c) (x_b c).
  Proof.
    intro c.
    apply not_in_orbit_of_distinct_wv.
    simpl; unfold k_a, k_b.
    apply k_a_ne_k_b.
  Qed.

End TranslationOrbit.

(* ===================================================================== *)
(*  5. Main theorem: the full PROP-NSOBS-14 existential claim, for any   *)
(*     abstract translation action G and any common nu/amplitude.        *)
(* ===================================================================== *)

Theorem nsobs14_axis_swap_alias :
  forall (G : Type) (act : G -> OneMode -> OneMode),
    (forall (g : G) (x : OneMode), wv (act g x) = wv x) ->
  forall nu c : Q,
    ~ in_orbit G act (x_a c) (x_b c)
    /\ (forall n : nat, I nu (x_a c) n = I nu (x_b c) n).
Proof.
  intros G act Hpreserve nu c.
  split.
  - apply x_b_not_in_orbit_of_x_a; exact Hpreserve.
  - apply I_agree.
Qed.
