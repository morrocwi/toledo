(* ===================================================================== *)
(*  DRL_Finite_Cut_Balance.v -- finite-matrix cut-balance with a declared *)
(*  retention covector (C3 of v2/urr/URR_C_COQ_FORMAL_CHAIN.yaml's        *)
(*  next_formal_targets, target:                                          *)
(*  finite_matrix_cut_balance_with_declared_retention_covector).          *)
(*                                                                        *)
(*  Ground truth: evidence/URR_C_Foundational_Chain.v's F5_cut_balance,   *)
(*  which proves EXACT conservation for a fixed 3 NAMED sectors (visible, *)
(*  hidden, tape): visible-next + hidden-next + tape-next = visible +     *)
(*  hidden + tape.                                                        *)
(*  This file removes the "3 named sectors, unspecified dynamics" scope:  *)
(*  the state is an arbitrary finite Q-VECTOR (n sectors, n a variable    *)
(*  nat), the dynamics is an EXPLICIT linear flow x' = x - dt.L.x driven  *)
(*  by a symmetric row-sum-zero coupling matrix L (a graph Laplacian --   *)
(*  same shape as evidence/DRL_General_EL.v's Lap, in matrix form), and   *)
(*  the conserved quantity is stated for a DECLARED "retention covector"  *)
(*  r (any left-null-vector of L, i.e. r.L = 0), not assumed to be the    *)
(*  all-ones vector -- with the all-ones case then derived as the         *)
(*  canonical instance a symmetric row-sum-zero L always admits.          *)
(*                                                                        *)
(*  Reuses the finite-sum/matrix vocabulary (Sum n f, Mat, transpose,     *)
(*  the graph-Laplacian symmetric/row-sum-zero construction) from the     *)
(*  author's own information-discrete-math skill's IDM_Matrix.v (MIT,     *)
(*  Yaoharee Lahtee, https://github.com/morrocwi/information-discrete-    *)
(*  math) -- copied and adapted in Section 1 below rather than a cross-   *)
(*  repo Require (this repo must stay buildable standalone); Section 1's  *)
(*  lemma names/statements are deliberately kept identical to that file's *)
(*  so the correspondence is checkable by inspection.                     *)
(*                                                                        *)
(*  WHAT IT PROVES: (1) GENERAL conservation -- for ANY n, ANY dt, ANY    *)
(*  matrix L, and ANY covector r that left-annihilates L (Sum r_i L_ij =  *)
(*  0 for every j), the flow x' = x - dt.L.x exactly conserves r.x, by    *)
(*  pure algebra (ring), no approximation, no symmetry/row-sum needed for *)
(*  THIS direction. (2) the all-ones covector is always such a left-      *)
(*  annihilator when L is a symmetric row-sum-zero graph Laplacian (using *)
(*  symmetry to turn "row-sum zero" into "column-sum zero", which is      *)
(*  exactly left-annihilation by 1). (3) Corollary: total conservation    *)
(*  Sum x' == Sum x for that canonical case -- the direct N-sector        *)
(*  generalization of F5_cut_balance's 3-named-sector identity, now for   *)
(*  an explicit dynamics rather than an unconstrained relabeling.         *)
(*                                                                        *)
(*  WHAT IT DOES NOT PROVE: that this L / this linear flow is literally   *)
(*  what any specific DRL/URR construction uses dynamically (F5 itself is *)
(*  agnostic about the update rule, only the identity across a relabeling *)
(*  step); positivity of any sector (not claimed, matches F5's own        *)
(*  disclaimed scope); non-symmetric or non-row-sum-zero L (out of scope, *)
(*  the whole point of the retention-covector generality is that OTHER    *)
(*  covectors could be conserved for such an L too, just not derived      *)
(*  here for the general case beyond the one explicit hypothesis given).  *)
(*                                                                        *)
(*  Over Q, axiom-free target (check Print Assumptions).                  *)
(* ===================================================================== *)

Require Import QArith.
Require Import Lia.

Open Scope Q_scope.

(* ===================================================================== *)
(*  Section 1: finite sums and matrices -- copied/adapted from the       *)
(*  author's information-discrete-math skill's IDM_Matrix.v (MIT).       *)
(* ===================================================================== *)

Fixpoint Sum (n : nat) (f : nat -> Q) : Q :=
  match n with O => 0 | S k => Sum k f + f k end.

Lemma Sum_plus : forall n f g, Sum n (fun k => f k + g k) == Sum n f + Sum n g.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_opp : forall n f, Sum n (fun k => - f k) == - Sum n f.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_zero : forall n, Sum n (fun _ => 0) == 0.
Proof. induction n; simpl; [ reflexivity | rewrite IHn; ring ]. Qed.

Lemma Sum_sub : forall n f g, Sum n (fun k => f k - g k) == Sum n f - Sum n g.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_scale : forall n c f, Sum n (fun k => c * f k) == c * Sum n f.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_ext : forall n f g, (forall k, f k == g k) -> Sum n f == Sum n g.
Proof. induction n; intros f g H; simpl; [ reflexivity | rewrite (IHn f g H), H; reflexivity ]. Qed.

Lemma Sum_ext_lt : forall n f g, (forall k, (k < n)%nat -> f k == g k) -> Sum n f == Sum n g.
Proof.
  induction n as [| m IH]; intros f g H; simpl.
  - reflexivity.
  - rewrite (IH f g); [ rewrite (H m) by lia; reflexivity | intros k Hk; apply H; lia ].
Qed.

Lemma Sum_delta : forall n i f,
  (i < n)%nat -> Sum n (fun k => if Nat.eqb i k then f k else 0) == f i.
Proof.
  induction n as [| m IH]; intros i f Hi; simpl.
  - inversion Hi.
  - destruct (Nat.eq_dec i m) as [He | Hne].
    + subst m. rewrite Nat.eqb_refl.
      rewrite (Sum_ext_lt _ _ (fun _ => 0)); [ rewrite Sum_zero; ring | ].
      intros k Hk. assert (Nat.eqb i k = false) as E by (apply Nat.eqb_neq; lia).
      rewrite E. reflexivity.
    + rewrite (proj2 (Nat.eqb_neq i m) Hne).
      rewrite IH by lia. ring.
Qed.

(* Double-sum reordering: needed below for the general conservation
   theorem's core algebraic step (distributing r over L.x and swapping
   which index is summed first) -- not present verbatim in IDM_Matrix.v
   (that file didn't need it), proved the same way as
   DRL_General_EL.v's qsum_idx_double_swap, specialized to nat-bound Sum. *)
Lemma Sum_double_swap :
  forall n (f : nat -> nat -> Q),
  Sum n (fun i => Sum n (fun j => f i j)) == Sum n (fun j => Sum n (fun i => f i j)).
Proof.
  intros n f. induction n as [| m IH]; simpl.
  - reflexivity.
  - rewrite (Sum_plus m (fun i => Sum m (fun j => f i j)) (fun i => f i m)).
    rewrite (Sum_plus m (fun j => Sum m (fun i => f i j)) (fun j => f m j)).
    rewrite IH. ring.
Qed.

Definition Mat := nat -> nat -> Q.
Definition mmul (n : nat) (A B : Mat) : Mat := fun i j => Sum n (fun k => A i k * B k j).

(* ---- Graph Laplacian over Q (identical construction to IDM_Matrix.v) ---- *)
Section Laplacian.
  Variable n : nat.
  Variable w : nat -> nat -> Q.
  Hypothesis w_sym  : forall i j, w i j == w j i.
  Hypothesis w_diag0 : forall i, w i i == 0.

  Definition deg (i : nat) : Q := Sum n (fun k => w i k).
  Definition Lap : Mat := fun i j => if Nat.eqb i j then deg i else - (w i j).

  Theorem laplacian_symmetric : forall i j, Lap i j == Lap j i.
  Proof.
    intros i j. unfold Lap.
    destruct (Nat.eqb i j) eqn:E.
    - apply Nat.eqb_eq in E. subst j. rewrite Nat.eqb_refl. reflexivity.
    - rewrite (Nat.eqb_sym j i), E. rewrite w_sym. reflexivity.
  Qed.

  Theorem laplacian_rowsum_zero : forall i, (i < n)%nat -> Sum n (fun j => Lap i j) == 0.
  Proof.
    intros i Hi.
    assert (Hoff : Sum n (fun j => if Nat.eqb i j then 0 else - w i j) == - deg i).
    { transitivity (Sum n (fun j => - w i j)).
      - apply Sum_ext_lt. intros j Hj. destruct (Nat.eqb i j) eqn:E.
        + apply Nat.eqb_eq in E; subst j. rewrite w_diag0. ring.
        + reflexivity.
      - unfold deg. rewrite Sum_opp. reflexivity. }
    unfold Lap.
    rewrite (Sum_ext_lt n (fun j => if Nat.eqb i j then deg i else - w i j)
                          (fun j => (if Nat.eqb i j then deg i else 0)
                                  + (if Nat.eqb i j then 0 else - w i j))).
    - rewrite Sum_plus, (Sum_delta n i (fun _ => deg i) Hi), Hoff. ring.
    - intros j Hj. destruct (Nat.eqb i j); ring.
  Qed.
End Laplacian.

(* ===================================================================== *)
(*  Section 2: cut-balance -- general conservation for any left-null     *)
(*  covector of ANY matrix, then the canonical all-ones instance for a   *)
(*  symmetric row-sum-zero Laplacian.                                    *)
(* ===================================================================== *)

Section CutBalance.

Variable n : nat.
Variable L : Mat.
Variable dt : Q.
Variable x : nat -> Q.

(* one explicit linear step: x' = x - dt . L . x *)
Definition step (i : nat) : Q := x i - dt * Sum n (fun j => L i j * x j).

(* THE GENERAL THEOREM: any covector r that left-annihilates L (its
   weighted row-sum against L's COLUMNS is zero, at every column j) has
   r.x exactly conserved by `step`, for ANY n, dt, L, x -- pure algebra,
   no symmetry or row-sum-zero hypothesis needed for this direction. *)
Theorem cut_balance_general :
  forall r : nat -> Q,
  (forall j, (j < n)%nat -> Sum n (fun i => r i * L i j) == 0) ->
  Sum n (fun i => r i * step i) == Sum n (fun i => r i * x i).
Proof.
  intros r Hnull.
  unfold step.
  transitivity
    (Sum n (fun i => r i * x i)
     - dt * Sum n (fun i => r i * Sum n (fun j => L i j * x j))).
  { transitivity
      (Sum n (fun i => r i * x i)
       - Sum n (fun i => dt * (r i * Sum n (fun j => L i j * x j)))).
    { rewrite <- Sum_sub. apply Sum_ext. intro i. ring. }
    rewrite (Sum_scale n dt (fun i => r i * Sum n (fun j => L i j * x j))).
    reflexivity. }
  assert (Hswap :
    Sum n (fun i => r i * Sum n (fun j => L i j * x j))
    == Sum n (fun j => x j * Sum n (fun i => r i * L i j))).
  { transitivity (Sum n (fun i => Sum n (fun j => r i * (L i j * x j)))).
    { apply Sum_ext. intro i. rewrite (Sum_scale n (r i) (fun j => L i j * x j)). reflexivity. }
    transitivity (Sum n (fun j => Sum n (fun i => r i * (L i j * x j)))).
    { apply Sum_double_swap. }
    apply Sum_ext. intro j.
    transitivity (Sum n (fun i => x j * (r i * L i j))).
    { apply Sum_ext. intro i. ring. }
    rewrite (Sum_scale n (x j) (fun i => r i * L i j)). reflexivity. }
  rewrite Hswap.
  assert (Hzero : Sum n (fun j => x j * Sum n (fun i => r i * L i j)) == 0).
  { transitivity (Sum n (fun j : nat => 0)).
    { apply Sum_ext_lt. intros j Hj. rewrite (Hnull j Hj). ring. }
    apply Sum_zero. }
  rewrite Hzero. ring.
Qed.

End CutBalance.

(* ===================================================================== *)
(*  Section 3: the canonical instance -- for a symmetric row-sum-zero     *)
(*  graph Laplacian, the all-ones covector is always a left-annihilator,  *)
(*  so total mass Sum x is exactly conserved by the flow. This is the      *)
(*  direct N-sector generalization of F5_cut_balance's fixed 3-named-     *)
(*  sector identity (visible-next + hidden-next + tape-next = visible +   *)
(*  hidden + tape) -- now for an explicit dynamics and any sector count.  *)
(* ===================================================================== *)

Theorem all_ones_annihilates_laplacian :
  forall n w, (forall i j, w i j == w j i) -> (forall i, w i i == 0) ->
  forall j, (j < n)%nat -> Sum n (fun i => (fun _ => 1) i * Lap n w i j) == 0.
Proof.
  intros n w Hsym Hdiag0 j Hj.
  transitivity (Sum n (fun i => Lap n w i j)).
  { apply Sum_ext. intro i. ring. }
  transitivity (Sum n (fun i => Lap n w j i)).
  { apply Sum_ext. intro i. apply (laplacian_symmetric n w Hsym i j). }
  apply (laplacian_rowsum_zero n w Hdiag0 j Hj).
Qed.

Corollary total_mass_conserved :
  forall n w dt x, (forall i j, w i j == w j i) -> (forall i, w i i == 0) ->
  Sum n (fun i => step n (Lap n w) dt x i) == Sum n x.
Proof.
  intros n w dt x Hsym Hdiag0.
  transitivity (Sum n (fun i => (fun _ => 1) i * step n (Lap n w) dt x i)).
  { apply Sum_ext. intro i. ring. }
  rewrite (cut_balance_general n (Lap n w) dt x (fun _ => 1)
             (all_ones_annihilates_laplacian n w Hsym Hdiag0)).
  apply Sum_ext. intro i. ring.
Qed.

Print Assumptions cut_balance_general.
Print Assumptions all_ones_annihilates_laplacian.
Print Assumptions total_mass_conserved.

(* ===================================================================== *)
(*  Section 4: non-vacuousness -- total_mass_conserved is genuinely       *)
(*  invocable at a concrete N=3 instance (the same ring weight used as    *)
(*  DRL_General_EL.v's sanity check), giving an explicit numeric witness  *)
(*  that the theorem's hypotheses are jointly satisfiable, not vacuous.   *)
(* ===================================================================== *)

Definition Wring3 (i j : nat) : Q :=
  if orb (andb (Nat.eqb i 0) (Nat.eqb j 1))
     (orb (andb (Nat.eqb i 1) (Nat.eqb j 0))
     (orb (andb (Nat.eqb i 1) (Nat.eqb j 2))
     (orb (andb (Nat.eqb i 2) (Nat.eqb j 1))
     (orb (andb (Nat.eqb i 0) (Nat.eqb j 2))
          (andb (Nat.eqb i 2) (Nat.eqb j 0))))))
  then 1 else 0.

Lemma Wring3_sym : forall i j, Wring3 i j == Wring3 j i.
Proof.
  intros i j. unfold Wring3.
  destruct i as [|[|[|i]]]; destruct j as [|[|[|j]]]; simpl; reflexivity.
Qed.

Lemma Wring3_diag0 : forall i, Wring3 i i == 0.
Proof. intro i. destruct i as [|[|[|i]]]; unfold Wring3; simpl; reflexivity. Qed.

(* concrete witness: total mass of a 3-sector state is conserved under
   one ring-Laplacian step, for actual numeric x = (5,2,1), dt = 1#2. *)
Example total_mass_conserved_witness :
  Sum 3 (step 3 (Lap 3 Wring3) (1#2)
           (fun i => match i with 0%nat => 5 | 1%nat => 2 | _ => 1 end))
  == Sum 3 (fun i => match i with 0%nat => 5 | 1%nat => 2 | _ => 1 end).
Proof.
  apply (total_mass_conserved 3 Wring3 (1#2)
           (fun i => match i with 0%nat => 5 | 1%nat => 2 | _ => 1 end)
           Wring3_sym Wring3_diag0).
Qed.

Print Assumptions total_mass_conserved_witness.
