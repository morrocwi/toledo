(* ===================================================================== *)
(*  RDL_Distinguishability.v                                              *)
(*  Machine-checked COSMOGENESIS: the genesis edges that the canon states  *)
(*  only as narrative (ASSERTED, Dr) are here DERIVED, axiom-free, from    *)
(*  the Retained-Difference object system RD.v:                            *)
(*                                                                        *)
(*     δ_R (primordial difference)  →  distinguishability                  *)
(*                                  →  asymmetry                           *)
(*                                  →  temporal ordering (arrow / clock)    *)
(*                                  →  a nonzero seed (the τ tick)          *)
(*                                                                        *)
(*  Each step becomes a Tier-0 theorem witnessed by RD's existing lemmas   *)
(*  (RD3_succ_ne_zero, lt_trichotomy, lt_trans, lt_irrefl, lt_wf).         *)
(*  This upgrades the canon's growth-ladder labels from [Dr] to [Th_coqc]. *)
(* ===================================================================== *)

Require Import RD.
Require Import Lia.

(* δ_R — distinguishability is non-identity of retained differences in D. *)
Definition Distinguishable (a b : D) : Prop := a <> b.

(* GENESIS step 1 — δ_R is REALIZED: primordial difference exists.
   (canon §2 step 1: "difference → distinguishability", was ASSERTED.) *)
Theorem primordial_difference_exists : exists a b : D, Distinguishable a b.
Proof.
  exists zero. exists (succ zero). unfold Distinguishable. intro H.
  exact (RD3_succ_ne_zero zero (eq_sym H)).
Qed.

(* GENESIS step 2 — distinguishability ENTAILS asymmetry: any two distinct
   retained differences are strictly ordered one way and not the other.
   (canon §2 step 2: "distinguishability → asymmetry", was ASSERTED.) *)
Theorem distinguishable_implies_asymmetry :
  forall a b : D, Distinguishable a b ->
    (lt a b /\ ~ lt b a) \/ (lt b a /\ ~ lt a b).
Proof.
  intros a b Hd. destruct (lt_trichotomy a b) as [Hab | [Heq | Hba]].
  - left. split.
    + exact Hab.
    + intro Hba. exact (RD.lt_irrefl a (RD.lt_trans a b a Hab Hba)).
  - exfalso. apply Hd. exact Heq.
  - right. split.
    + exact Hba.
    + intro Hab. exact (RD.lt_irrefl a (RD.lt_trans a b a Hab Hba)).
Qed.

(* GENESIS step 3 — asymmetry GIVES a temporal ordering: the strict order is
   WELL-FOUNDED, i.e. there is a genuine arrow / discrete clock with no
   infinite descent. (canon §2 step 3: "asymmetry → temporal ordering".) *)
Theorem temporal_ordering_well_founded : well_founded lt.
Proof. exact lt_wf. Qed.

(* GENESIS step 4 (seed) — a NONZERO retained difference exists: the first
   tick, the seed of τ_c (canon §5b: τ_c discrete primitive). *)
Theorem nonzero_seed_exists : exists tau : D, tau <> zero.
Proof. exists (succ zero). exact (RD3_succ_ne_zero zero). Qed.

(* Convenience: the asymmetry is irreflexive (no self-precedence) — the
   logical floor of "an event does not cause itself". *)
Theorem no_self_precedence : forall a : D, ~ lt a a.
Proof. exact RD.lt_irrefl. Qed.

(* GENESIS step 5 — the temporal order advances by a DISCRETE TICK: every
   element strictly precedes its successor (the Θ_R stepper / discrete clock).
   (canon §2 step 6: "finite causal graph → discrete stepper", was ASSERTED.) *)
Theorem discrete_clock_tick : forall x : D, lt x (succ x).
Proof. intro x. unfold lt, le. exists zero. apply add_zero. Qed.

(* GENESIS step 6 — LOCAL FINITENESS (MLCD DL-2): every causal interval embeds
   into a FINITE ℕ-segment (toNat x , toNat y), so it has finitely many events.
   This is the machine-checked backbone of the G_LOCAL_FINITE gate / the
   τ_c → finite-causal-graph edge (canon §2 step 5), was ASSERTED. *)
Theorem causal_interval_bounded :
  forall x y z : D, lt x z -> lt z y -> toNat x < toNat z /\ toNat z < toNat y.
Proof.
  intros x y z Hxz Hzy. split.
  - exact (proj1 (lt_toNat x z) Hxz).
  - exact (proj1 (lt_toNat z y) Hzy).
Qed.

(* GENESIS step 7 — ATOMICITY / the DISCRETE FLOOR: there is NO element strictly
   between x and its successor. The order is DISCRETE, NOT DENSE — no infinitesimal,
   no continuum between ticks. This is the machine-checked backbone of:
     (a) the τ_c discrete-step floor (the framework's paradigm-neutral falsifier:
         τ_c ≥ one tick; the continuum QSL has no such floor), and
     (b) the "no real continuum, only like-continuum" doctrine — density (a root
         continuum) is provably ABSENT at the foundation. *)
Theorem atomicity : forall x : D, ~ (exists z : D, lt x z /\ lt z (succ x)).
Proof.
  intros x [z [H1 H2]].
  apply (proj1 (lt_toNat x z)) in H1.
  apply (proj1 (lt_toNat z (succ x))) in H2. simpl in H2.
  lia.
Qed.

(* The floor at the origin: nothing strictly between 0 and the first tick (one). *)
Corollary discrete_floor : ~ (exists z : D, lt zero z /\ lt z (succ zero)).
Proof. exact (atomicity zero). Qed.
