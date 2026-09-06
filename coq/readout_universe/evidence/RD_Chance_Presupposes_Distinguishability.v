(* ============================================================================
   RD_Chance_Presupposes_Distinguishability.v
   target tier: Th_coqc, axiom-free over Q (no Reals, no continuum measure
   theory -- discrete, finite, list-based, per this project's own
   information-discrete-math floor)

   Formalizes the NARROW, provable core of:
     Lahtee, Y., "The Explanatory Insufficiency of Randomness"
       (preprint, doi:10.5281/zenodo.20473230, 2026-05-31)
     Lahtee, Y., "Objective Chance and the Priority of Modal Difference"
       (preprint, doi:10.5281/zenodo.20537309, 2026-06-04)
   both currently tagged `Dr` in this book's own ledger (logic.md; philosophy.md
   S9.8a) -- this file does not raise that tag for the full essays, which make
   an explanatory-priority claim beyond what a Coq file can adjudicate. It
   raises to `Th_coqc` only the specific formal fact below.

   NOT proved here (explicitly out of scope, remains Dr / philosophical):
     - that the world's fundamental dynamics are deterministic
     - that objective chance is unreal or never fundamental
     - that "retained difference" explains quantum indeterminacy
   Both cited papers themselves "explicitly grant indeterminism throughout
   and take no position on it" (philosophy.md S9.8a) -- this file inherits
   that same restraint.

   WHAT IS PROVED, axiom-free over Q:
     A finite chance attribution -- nonnegative weights over a list of
     candidate possibilities summing to exactly 1 -- can only be READ as
     "each of N DISTINCT possibilities gets its own share of unit mass" when
     the possibility list is duplicate-free (NoDup). If a possibility is
     listed more than once and carries positive weight, the list-sum strictly
     overcounts relative to the sum over the underlying set of genuinely
     distinct possibilities (T3). Consequently (T4) a well-formed chance
     attribution (list-sum exactly 1) whose possibility list is NOT
     duplicate-free at a positive-weight element cannot coherently be read
     as assigning unit probability mass across its distinct possibilities --
     the distinct-possibility sum is then strictly below 1. This is the
     formal core of "retained-distinguishable alternatives" (Objective
     Chance and the Priority of Modal Difference): a chance-fact, read as
     apportioning certainty across alternatives, presupposes those
     alternatives already being pairwise distinct -- distinguishability is
     a precondition of a coherent chance attribution, not a consequence of
     one. T2 (nonemptiness) is the companion, even more basic fact: the
     empty list can never carry a well-formed chance attribution at all
     (0 <> 1 in Q) -- a chance-fact presupposes SOME domain, before it can
     presuppose a distinguishable one.
   ============================================================================ *)

Require Import List.
Require Import QArith.
Require Import Lqa.
Require Import Lia.
Import ListNotations.

Section ChancePresupposesDistinguishability.

  Variable A : Type.
  Variable eq_dec : forall x y : A, {x = y} + {x <> y}.

  (* -- The object level: a finite chance attribution ----------------------- *)

  Definition sum_weights (w : A -> Q) (xs : list A) : Q :=
    fold_right (fun x acc => w x + acc) 0 xs.

  Definition WellFormedChance (w : A -> Q) (xs : list A) : Prop :=
    (forall x, In x xs -> 0 <= w x) /\ sum_weights w xs == 1.

  (* -- T1: sum_weights over an append splits additively --------------------- *)

  Lemma sum_weights_app :
    forall w xs ys, sum_weights w (xs ++ ys) == sum_weights w xs + sum_weights w ys.
  Proof.
    intros w xs ys. induction xs as [| x xs' IH]; simpl.
    - ring.
    - rewrite IH. ring.
  Qed.

  (* -- T2: nonemptiness. A chance attribution presupposes SOME domain ------ *)

  Theorem chance_requires_nonempty_domain :
    forall w, ~ WellFormedChance w [].
  Proof.
    intros w [_ Hsum]. simpl in Hsum. lra.
  Qed.

  (* -- Nonnegative-weight sums only decrease when an element is dropped ---- *)

  Lemma sum_weights_drop_le :
    forall w x xs,
      (forall y, In y (x :: xs) -> 0 <= w y) ->
      sum_weights w xs <= sum_weights w (x :: xs).
  Proof.
    intros w x xs Hnonneg. simpl.
    assert (0 <= w x) by (apply Hnonneg; left; reflexivity).
    lra.
  Qed.

  (* -- nodup never increases the sum, given nonnegative weights ------------ *)

  Lemma nodup_sum_le :
    forall w xs, (forall x, In x xs -> 0 <= w x) ->
      sum_weights w (nodup eq_dec xs) <= sum_weights w xs.
  Proof.
    intros w xs. induction xs as [| x xs' IH]; intro Hnonneg.
    - simpl. lra.
    - simpl. destruct (in_dec eq_dec x xs') as [Hin | Hnin].
      + (* x already occurs later: nodup drops this occurrence *)
        assert (Hnonneg' : forall y, In y xs' -> 0 <= w y).
        { intros y Hy. apply Hnonneg. right. exact Hy. }
        specialize (IH Hnonneg').
        assert (0 <= w x) by (apply Hnonneg; left; reflexivity).
        lra.
      + (* x is genuinely new: nodup keeps it *)
        assert (Hnonneg' : forall y, In y xs' -> 0 <= w y).
        { intros y Hy. apply Hnonneg. right. exact Hy. }
        specialize (IH Hnonneg'). simpl. lra.
  Qed.

  (* -- T3: a positive-weight duplicate strictly inflates the list-sum ------ *)

  Theorem duplicate_inflates_sum :
    forall w xs x,
      In x xs ->
      (count_occ eq_dec xs x >= 2)%nat ->
      0 < w x ->
      (forall y, In y xs -> 0 <= w y) ->
      sum_weights w (nodup eq_dec xs) < sum_weights w xs.
  Proof.
    intros w xs x Hin Hcount Hpos Hnonneg.
    induction xs as [| a xs' IH].
    - simpl in Hin. contradiction.
    - simpl in Hcount. destruct (eq_dec a x) as [Heq | Hneq].
      + (* the head IS x; x must also occur later, since count_occ >= 2 *)
        subst a.
        assert (Hcount' : (count_occ eq_dec xs' x >= 1)%nat) by lia.
        assert (Hin' : In x xs').
        { destruct (in_dec eq_dec x xs') as [Hy | Hn]; [exact Hy |].
          exfalso. rewrite (count_occ_not_In eq_dec) in Hn. lia. }
        simpl. destruct (in_dec eq_dec x xs') as [_ | Hcontra]; [ | contradiction].
        assert (Hnonneg' : forall y, In y xs' -> 0 <= w y).
        { intros y Hy. apply Hnonneg. right. exact Hy. }
        assert (Hle : sum_weights w (nodup eq_dec xs') <= sum_weights w xs')
          by (apply nodup_sum_le; exact Hnonneg').
        simpl. lra.
      + (* the head is not x: recurse, x's duplicate is entirely inside xs' *)
        assert (Hin2 : In x xs').
        { destruct Hin as [Habs | Hgood]; [contradiction (Hneq Habs) | exact Hgood]. }
        assert (Hcount2 : (count_occ eq_dec xs' x >= 2)%nat) by lia.
        assert (Hnonneg' : forall y, In y xs' -> 0 <= w y).
        { intros y Hy. apply Hnonneg. right. exact Hy. }
        assert (IHr := IH Hin2 Hcount2 Hnonneg').
        assert (Ha_nonneg : 0 <= w a) by (apply Hnonneg; left; reflexivity).
        simpl. destruct (in_dec eq_dec a xs') as [Hy | Hn]; simpl; lra.
  Qed.

  (* -- T4: the punchline. A well-formed (sum = 1) chance attribution whose --
        possibility list has a positive-weight duplicate does NOT sum to 1
        over its genuinely distinct possibilities -- the "1" only holds
        relative to a list that already presupposes distinguishability. --- *)

  Theorem chance_presupposes_distinguishability :
    forall w xs x,
      WellFormedChance w xs ->
      In x xs ->
      (count_occ eq_dec xs x >= 2)%nat ->
      0 < w x ->
      sum_weights w (nodup eq_dec xs) < 1.
  Proof.
    intros w xs x [Hnonneg Hsum] Hin Hcount Hpos.
    assert (Hlt := duplicate_inflates_sum w xs x Hin Hcount Hpos Hnonneg).
    lra.
  Qed.

End ChancePresupposesDistinguishability.
