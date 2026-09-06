(* ===================================================================== *)
(*  RDL_RetentionCenter.v                                                  *)
(*  PROOF-OF-CONCEPT: the physics native-state  R^◇ = (Γ,D,T,L,Π,A,𝔊)     *)
(*  (RAR canon v1.4) as a SINGLE Coq center object, with the (T,𝔊) heart   *)
(*  realized by a REAL transport-monoid-up-to-gauge, and the record/      *)
(*  accessibility layer (A) proven to be a strict, gauge-invariant         *)
(*  (= readout-invariant) lossy map.  Hub-and-spoke unification, axiom-free.*)
(*                                                                        *)
(*  WHAT IS FULLY DISCHARGED HERE (no funext / no classical / no admit):  *)
(*    - T  transport  = commutative monoid UP TO a gauge equivalence       *)
(*    - 𝔊  consistency = a pole + orthogonality with the IDEMPOTENT        *)
(*           double-orthogonal closure (orth^3 = orth) — the no-creation /  *)
(*           obstruction-O=0 structure, proven generically                 *)
(*    - L  propagation = a preorder (reflexive+transitive = the S4 seed)    *)
(*    - A  accessibility/record: gauge-invariant (readout-invariant, A8)    *)
(*           AND strictly lossy (R_O ≠ D_O, A4 observability≠existence)     *)
(*  PRESENT AS TYPED FIELDS, minimally constrained (future work to fully    *)
(*  weld): Γ graph edges, Π resolution tower.  The Γ-spectral (ℚ) spoke and *)
(*  the continuum limit L_R→−Δ_g remain genuinely open (hard analysis).    *)
(*                                                                        *)
(*  The concrete transport monoid here — (list nat, ++, [], Permutation) — *)
(*  is EXACTLY the context monoid that RDL_PhaseSetoid.context_phase_       *)
(*  soundness runs over, so MALL soundness + cut-elimination is the         *)
(*  (T,𝔊)-projection of this very center.   coqc 8.18.0.                   *)
(* ===================================================================== *)

Require Import Coq.Lists.List. Import ListNotations.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.Setoids.Setoid.

(* --------------------------------------------------------------------- *)
(*  THE CENTER : R^◇ = (Γ, D, T, L, Π, A, 𝔊)                              *)
(* --------------------------------------------------------------------- *)
Record RetentionSystem := {
  (* D : distinctions *)
  Dist  : Type ;
  (* Γ : graph on distinctions *)
  edge  : Dist -> Dist -> Prop ;
  (* T : transport — configurations of distinctions, composed, UP TO gauge *)
  Tcar  : Type ;
  gauge : Tcar -> Tcar -> Prop ;     (* admissible relabeling / reordering *)
  tunit : Tcar ;
  tcomp : Tcar -> Tcar -> Tcar ;
  (* L : propagation preorder on distinctions *)
  prop_le : Dist -> Dist -> Prop ;
  (* Π : retention threshold — resolution index + retained-at-resolution *)
  Res      : Type ;
  retained : Res -> Tcar -> Prop ;
  (* A : accessibility / record (lossy readout of a configuration) *)
  Rec    : Type ;
  record : Tcar -> Rec ;
  (* 𝔊 : consistency pole on configurations *)
  pole   : Tcar -> Prop ;
  (* ---- coherence laws (the minimum that makes this ONE object) ---- *)
  gauge_equiv  : Equivalence gauge ;
  tcomp_proper : forall a a' b b', gauge a a' -> gauge b b' ->
                                   gauge (tcomp a b) (tcomp a' b') ;
  tcomp_comm   : forall a b, gauge (tcomp a b) (tcomp b a) ;
  tcomp_assoc  : forall a b c, gauge (tcomp a (tcomp b c)) (tcomp (tcomp a b) c) ;
  tcomp_unit   : forall a, gauge (tcomp tunit a) a ;
  prop_le_preorder : PreOrder prop_le ;
  pole_proper  : forall a b, gauge a b -> (pole a <-> pole b) ;
  (* THE unifying law: the record reads ONLY gauge-invariant content       *)
  (* = readout-invariance (canon A8 'lens that does not distort')          *)
  record_gauge_invariant : forall a b, gauge a b -> record a = record b
}.

(* --------------------------------------------------------------------- *)
(*  𝔊 : the consistency closure is the no-creation / obstruction-O=0 core *)
(*       (Girard double-orthogonal), proven for EVERY center generically. *)
(* --------------------------------------------------------------------- *)
Section Consistency.
  Variable R : RetentionSystem.

  Definition orth (S : Tcar R -> Prop) : Tcar R -> Prop :=
    fun x => forall y, S y -> pole R (tcomp R x y).

  Lemma orth_antitone : forall (S T : Tcar R -> Prop),
      (forall z, S z -> T z) -> (forall x, orth T x -> orth S x).
  Proof. intros S T HST x Hx y Hy. apply Hx, HST, Hy. Qed.

  Lemma orth_expand : forall (S : Tcar R -> Prop) x, S x -> orth (orth S) x.
  Proof.
    intros S x Hx z Hz. specialize (Hz x Hx).            (* pole (z∘x) *)
    apply (proj1 (pole_proper R (tcomp R z x) (tcomp R x z)
                              (tcomp_comm R z x))).
    exact Hz.
  Qed.

  (* the closure is idempotent: orth∘orth∘orth = orth — physical content  *)
  (* lives at the fixed point (zero-SECTION of the obstruction bundle).    *)
  Theorem orth_triple : forall (S : Tcar R -> Prop) x,
      orth (orth (orth S)) x <-> orth S x.
  Proof.
    intros S x; split.
    - apply orth_antitone. intros z Hz. apply orth_expand; exact Hz.
    - apply orth_expand.
  Qed.
End Consistency.

(* A : the record of any center is a readout-invariant (sees only gauge).  *)
Theorem readout_invariant :
  forall (R : RetentionSystem) a b, gauge R a b -> record R a = record R b.
Proof. intros R a b H. exact (record_gauge_invariant R a b H). Qed.

(* --------------------------------------------------------------------- *)
(*  ONE SPOKE REALIZED : the canonical instance.                          *)
(*  Γ = simple graph on ℕ ; D = ℕ ; T = (list ℕ, ++, [], Permutation)     *)
(*  = transport up to relabeling/reorder (the graph-gauge, PGFT Table 10);*)
(*  L = (≤) preorder ; Π = (ℕ, length ≤ n) ; A = length (lossy count) ;    *)
(*  𝔊 = nonempty (a config is consistent iff it retains ≥1 distinction).   *)
(* --------------------------------------------------------------------- *)
Lemma perm_equiv : Equivalence (@Permutation nat).
Proof.
  constructor.
  - exact (@Permutation_refl nat).
  - exact (@Permutation_sym nat).
  - exact (@Permutation_trans nat).
Qed.

Lemma app_perm_proper : forall a a' b b' : list nat,
    Permutation a a' -> Permutation b b' -> Permutation (a ++ b) (a' ++ b').
Proof. intros; apply Permutation_app; assumption. Qed.

Lemma app_perm_comm : forall a b : list nat, Permutation (a ++ b) (b ++ a).
Proof. intros; apply Permutation_app_comm. Qed.

Lemma app_perm_assoc : forall a b c : list nat,
    Permutation (a ++ (b ++ c)) ((a ++ b) ++ c).
Proof. intros a b c; rewrite app_assoc; apply Permutation_refl. Qed.

Lemma app_perm_unit : forall a : list nat, Permutation ([] ++ a) a.
Proof. intros a; simpl; apply Permutation_refl. Qed.

Lemma nat_le_preorder : PreOrder le.
Proof.
  constructor.
  - intro x; apply Nat.le_refl.
  - intros x y z Hxy Hyz; exact (Nat.le_trans _ _ _ Hxy Hyz).
Qed.

Lemma pole_perm : forall a b : list nat,
    Permutation a b -> ((a <> []) <-> (b <> [])).
Proof.
  intros a b Hp; split.
  - intros Hne Heq; subst b.
    apply Permutation_sym in Hp; apply Permutation_nil in Hp; contradiction.
  - intros Hne Heq; subst a.
    apply Permutation_nil in Hp; contradiction.
Qed.

Lemma length_perm_inv : forall a b : list nat,
    Permutation a b -> length a = length b.
Proof. intros; apply Permutation_length; assumption. Qed.

Definition R_canonical : RetentionSystem :=
  {| Dist     := nat ;
     edge     := fun x y => x <> y ;
     Tcar     := list nat ;
     gauge    := @Permutation nat ;
     tunit    := [] ;
     tcomp    := @app nat ;
     prop_le  := le ;
     Res      := nat ;
     retained := fun n l => length l <= n ;
     Rec      := nat ;
     record   := @length nat ;
     pole     := fun l => l <> [] ;
     gauge_equiv  := perm_equiv ;
     tcomp_proper := app_perm_proper ;
     tcomp_comm   := app_perm_comm ;
     tcomp_assoc  := app_perm_assoc ;
     tcomp_unit   := app_perm_unit ;
     prop_le_preorder := nat_le_preorder ;
     pole_proper  := pole_perm ;
     record_gauge_invariant := length_perm_inv |}.

(* A8 lens: the record is a readout-invariant — relabeling cannot change it *)
Theorem canonical_readout_invariant :
  forall l l', Permutation l l' -> record R_canonical l = record R_canonical l'.
Proof. exact (record_gauge_invariant R_canonical). Qed.

(* A4 observability≠existence: the record is STRICTLY lossy — R_O ≠ D_O.    *)
(* Two distinct latent configs (different distinctions) share one record    *)
(* yet are NOT gauge-equivalent.                                            *)
Theorem canonical_record_lossy :
  exists x y, record R_canonical x = record R_canonical y
              /\ ~ gauge R_canonical x y.
Proof.
  exists [0;0], [1;1]. split.
  - reflexivity.                                  (* length = 2 = length *)
  - intro H.                                      (* H : Permutation [0;0] [1;1] *)
    assert (HC : In 0 [1;1]).
    { eapply Permutation_in; [exact H | simpl; auto]. }
    destruct HC as [E | [E | []]]; discriminate.
Qed.

(* --------------------------------------------------------------------- *)
(*  AXIOM-FREEDOM CHECK                                                    *)
(* --------------------------------------------------------------------- *)
Print Assumptions R_canonical.
Print Assumptions orth_triple.
Print Assumptions readout_invariant.
Print Assumptions canonical_readout_invariant.
Print Assumptions canonical_record_lossy.
