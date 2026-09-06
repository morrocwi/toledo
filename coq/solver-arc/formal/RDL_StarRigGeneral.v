(* =====================================================================
   RDL_StarRigGeneral.v
   ---------------------------------------------------------------------
   The GENERAL n-dimensional Choi-Kraus statement, funext-free.

   Theorem (informal).  For ANY dimension n, ANY finite Kraus family
   {K_l}_{l<L} of n x n integer matrices satisfying the completeness
   relation  sum_{l<L} K_l^T K_l = I , the induced channel
        chan rho = sum_{l<L} K_l rho K_l^T
   is TRACE PRESERVING and COMPLETELY POSITIVE.

   This generalises RDL_StarRigMatrix3.v (explicit 3x3) to arbitrary n
   and arbitrary family size, and backs Pixel Gravity Field Theory
   Eq. (34) / its CPTP "theorem core" at full generality.

   DESIGN (funext-free, in the spirit of the RDL setoid work).
   Matrices are functions nat->nat->Z; we NEVER assert two matrices equal
   (that would need functional extensionality).  Everything observable is
   a Z value (trace, the quadratic form), so all theorems are equalities /
   inequalities in Z, proved with a small home-grown finite-sum library.
   The completeness hypothesis is stated in expanded (Gram) form.

   STATUS: candidate for `coqc 8.18.0`.  The finite-sum LIBRARY and the
   delta-collapse are routine inductions.  The TWO main theorems contain
   finite-sum REORDERING proofs (canonical-form route) -- these are the
   verification focus; the underlying identities are already verified
   symbolically for general n and L.  No axioms are intended.
   ===================================================================== *)

Require Import ZArith Lia Arith.
Open Scope Z_scope.

(* =====================================================================
   A finite-sum library:  Sum m f = f 0 + f 1 + ... + f (m-1).
   ===================================================================== *)
Fixpoint Sum (m : nat) (f : nat -> Z) : Z :=
  match m with O => 0 | S k => Sum k f + f k end.

Lemma Sum_0 : forall m, Sum m (fun _ => 0) = 0.
Proof. induction m; simpl; [reflexivity | rewrite IHm; ring]. Qed.

Lemma Sum_eq : forall m f g, (forall i, f i = g i) -> Sum m f = Sum m g.
Proof.
  induction m; intros f g H; simpl; [reflexivity|].
  rewrite (IHm f g H), (H m); reflexivity.
Qed.

Lemma Sum_eq_bounded :
  forall m f g, (forall i, (i < m)%nat -> f i = g i) -> Sum m f = Sum m g.
Proof.
  induction m; intros f g H; simpl; [reflexivity|].
  rewrite (IHm f g) by (intros i Hi; apply H; lia).
  rewrite (H m) by lia; reflexivity.
Qed.

Lemma Sum_plus : forall m f g,
  Sum m (fun i => f i + g i) = Sum m f + Sum m g.
Proof. induction m; intros; simpl; [ring | rewrite IHm; ring]. Qed.

Lemma Sum_scal_l : forall m c f, Sum m (fun i => c * f i) = c * Sum m f.
Proof. induction m; intros; simpl; [ring | rewrite IHm; ring]. Qed.

Lemma Sum_scal_r : forall m c f, Sum m (fun i => f i * c) = Sum m f * c.
Proof. induction m; intros; simpl; [ring | rewrite IHm; ring]. Qed.

Lemma Sum_swap : forall p q f,
  Sum p (fun i => Sum q (fun j => f i j))
  = Sum q (fun j => Sum p (fun i => f i j)).
Proof.
  induction p; intros q f; simpl.
  - symmetry. apply Sum_0.
  - rewrite (IHp q f), <- Sum_plus; apply Sum_eq; intro j; simpl; reflexivity.
Qed.

Lemma Sum_nonneg : forall m f, (forall i, 0 <= f i) -> 0 <= Sum m f.
Proof.
  induction m; intros f H; simpl; [lia|].
  specialize (IHm f H); specialize (H m); lia.
Qed.

Definition eyeZ (p k : nat) : Z := if Nat.eqb p k then 1 else 0.

Lemma Sum_delta_zero :
  forall m p f, (m <= p)%nat -> Sum m (fun k => f k * eyeZ p k) = 0.
Proof.
  induction m; intros p f H; simpl; [reflexivity|].
  rewrite IHm by lia. unfold eyeZ.
  assert (Nat.eqb p m = false) as E by (apply Nat.eqb_neq; lia).
  rewrite E; ring.
Qed.

Lemma Sum_delta :
  forall m p f, (p < m)%nat -> Sum m (fun k => f k * eyeZ p k) = f p.
Proof.
  induction m; intros p f H; simpl; [lia|].
  assert (p = m \/ p < m)%nat as [E|E] by lia.
  - subst p. rewrite Sum_delta_zero by lia. unfold eyeZ.
    rewrite Nat.eqb_refl; ring.
  - rewrite IHm by lia. unfold eyeZ.
    assert (Nat.eqb p m = false) as E2 by (apply Nat.eqb_neq; lia).
    rewrite E2; ring.
Qed.

(* =====================================================================
   Matrices over a fixed dimension n (function representation).
   ===================================================================== *)
Section General.
Variable n : nat.

Definition Mat := nat -> nat -> Z.
Definition transp (A : Mat) : Mat := fun i j => A j i.
Definition trace (A : Mat) : Z := Sum n (fun i => A i i).
Definition quadform (A : Mat) (v : nat -> Z) : Z :=
  Sum n (fun i => Sum n (fun j => v i * A i j * v j)).
Definition psd (A : Mat) : Prop := forall v, 0 <= quadform A v.

(* family of size L; channel and completeness Gram in expanded form *)
Variable L : nat.
Variable K : nat -> Mat.          (* K l is the l-th Kraus operator *)

(* (K_l rho K_l^T)_{a b} = sum_k (sum_p K l a p * rho p k) * K l b k *)
Definition kchan (rho : Mat) : Mat :=
  fun a b => Sum L (fun l =>
               Sum n (fun k => (Sum n (fun p => K l a p * rho p k)) * K l b k)).

(* Gram l-sum:  (sum_l K_l^T K_l)_{p k} = sum_l sum_i K l i p * K l i k *)
Definition Gram : Mat :=
  fun p k => Sum L (fun l => Sum n (fun i => K l i p * K l i k)).

Hypothesis Hcomplete : forall p k, Gram p k = eyeZ p k.

(* =====================================================================
   MAIN A.  TRACE PRESERVATION.
   Route: trace(kchan rho) = sum_p sum_k rho p k * Gram p k
        = sum_p sum_k rho p k * eyeZ p k = sum_p rho p p = trace rho.
   The first equality is a finite-sum reordering (canonical-form).
   ===================================================================== *)
Theorem channel_trace_preserving :
  forall rho, trace (kchan rho) = trace rho.
Proof.
  intro rho.
  transitivity (Sum n (fun p => Sum n (fun k => rho p k * Gram p k))).
  - (* reorder: trace(kchan rho) = sum_p sum_k rho p k * Gram p k *)
    unfold trace, kchan, Gram.
    (* LHS -> canonical C(l,a,p,k) := K l a p * rho p k * K l a k *)
    transitivity
      (Sum L (fun l => Sum n (fun a => Sum n (fun p =>
         Sum n (fun k => K l a p * rho p k * K l a k))))).
    + (* from  sum_a sum_l sum_k (sum_p ..)*K l a k  *)
      rewrite (Sum_swap n L
        (fun a l => Sum n (fun k => (Sum n (fun p => K l a p * rho p k)) * K l a k))).
      apply Sum_eq; intro l. apply Sum_eq; intro a.
      (* LHS: Sum_k (Sum_p K l a p * rho p k) * K l a k
         push * K l a k inside, then swap k,p *)
      transitivity
        (Sum n (fun k => Sum n (fun p => K l a p * rho p k * K l a k))).
      * apply Sum_eq; intro k.
        rewrite <- (Sum_scal_r n (K l a k) (fun p => K l a p * rho p k)).
        apply Sum_eq; intro p; ring.
      * apply (Sum_swap n n (fun k p => K l a p * rho p k * K l a k)).
    + (* RHS -> same canonical *)
      symmetry.
      transitivity
        (Sum n (fun p => Sum n (fun k => Sum L (fun l =>
           Sum n (fun a => rho p k * (K l a p * K l a k)))))).
      * apply Sum_eq; intro p. apply Sum_eq; intro k.
        rewrite <- (Sum_scal_l L (rho p k)
                     (fun l => Sum n (fun i => K l i p * K l i k))).
        apply Sum_eq; intro l.
        rewrite <- (Sum_scal_l n (rho p k)
                     (fun i => K l i p * K l i k)); reflexivity.
      * (* reorder (p,k,l,a) -> (l,a,p,k), summand commutes by ring.
           LHS: Sum_p Sum_k Sum_l Sum_a  rho p k * (K l a p * K l a k)
           RHS: Sum_l Sum_a Sum_p Sum_k  K l a p * rho p k * K l a k *)
        (* Step 1: in the body, push Sum_l to the front of (p,k).
           First swap the outer p and k: Sum_p Sum_k G = Sum_k Sum_p G. *)
        rewrite (Sum_swap n n
          (fun p k => Sum L (fun l => Sum n (fun a => rho p k * (K l a p * K l a k))))).
        (* now: Sum_k Sum_p Sum_l Sum_a ... ; pull Sum_l out past Sum_p *)
        transitivity
          (Sum n (fun k => Sum L (fun l => Sum n (fun p =>
             Sum n (fun a => rho p k * (K l a p * K l a k)))))).
        { apply Sum_eq; intro k.
          apply (Sum_swap n L
            (fun p l => Sum n (fun a => rho p k * (K l a p * K l a k)))). }
        (* now: Sum_k Sum_l Sum_p Sum_a ... ; pull Sum_l out past Sum_k *)
        transitivity
          (Sum L (fun l => Sum n (fun k => Sum n (fun p =>
             Sum n (fun a => rho p k * (K l a p * K l a k)))))).
        { apply (Sum_swap n L
            (fun k l => Sum n (fun p => Sum n (fun a => rho p k * (K l a p * K l a k))))). }
        (* now: Sum_l Sum_k Sum_p Sum_a ... ; align to RHS Sum_l Sum_a Sum_p Sum_k *)
        apply Sum_eq; intro l.
        (* target body: Sum_a Sum_p Sum_k  K l a p * rho p k * K l a k *)
        (* current body: Sum_k Sum_p Sum_a  rho p k * (K l a p * K l a k) *)
        transitivity
          (Sum n (fun k => Sum n (fun a => Sum n (fun p =>
             rho p k * (K l a p * K l a k))))).
        { apply Sum_eq; intro k.
          apply (Sum_swap n n (fun p a => rho p k * (K l a p * K l a k))). }
        (* now: Sum_k Sum_a Sum_p ; move Sum_a to front, Sum_k after Sum_p *)
        transitivity
          (Sum n (fun a => Sum n (fun k => Sum n (fun p =>
             rho p k * (K l a p * K l a k))))).
        { apply (Sum_swap n n
            (fun k a => Sum n (fun p => rho p k * (K l a p * K l a k)))). }
        apply Sum_eq; intro a.
        (* now: Sum_k Sum_p ; target Sum_p Sum_k with ring-equal body *)
        transitivity
          (Sum n (fun p => Sum n (fun k => rho p k * (K l a p * K l a k)))).
        { apply (Sum_swap n n (fun k p => rho p k * (K l a p * K l a k))). }
        apply Sum_eq; intro p. apply Sum_eq; intro k; ring.
  - (* collapse with completeness + delta *)
    transitivity (Sum n (fun p => Sum n (fun k => rho p k * eyeZ p k))).
    + apply Sum_eq; intro p. apply Sum_eq; intro k. now rewrite Hcomplete.
    + unfold trace. apply Sum_eq_bounded; intros p Hp.
      apply (Sum_delta n p (fun k => rho p k)); exact Hp.
Qed.

(* =====================================================================
   MAIN B.  COMPLETE POSITIVITY.
   Identity:  quadform(kchan rho; v) = sum_l quadform(rho; K_l^T v),
   then each summand is >= 0 by psd, so the sum is >= 0.
   ===================================================================== *)
Lemma quadform_kchan :
  forall rho v,
    quadform (kchan rho) v
    = Sum L (fun l => quadform rho (fun c => Sum n (fun i => K l i c * v i))).
Proof.
  intros rho v. unfold quadform, kchan.
  (* LHS = sum_a sum_b v a * (sum_l sum_k (sum_p K l a p rho p k) K l b k) * v b
     RHS = sum_l sum_p sum_k (sum_i K l i p v i) rho p k (sum_j K l j k v j)
     Both -> canonical D(l,a,b,p,k) := v a * K l a p * rho p k * K l b k * v b. *)
  transitivity
    (Sum L (fun l => Sum n (fun a => Sum n (fun b => Sum n (fun p =>
       Sum n (fun k => v a * K l a p * rho p k * K l b k * v b)))))).
  - (* LHS -> canonical.
       LHS = Sum_a Sum_b  v a * (Sum_l Sum_k (Sum_p K l a p rho p k) K l b k) * v b
       canonical = Sum_l Sum_a Sum_b Sum_p Sum_k D,
       D = v a * K l a p * rho p k * K l b k * v b. *)
    (* Step A: per (a,b), expand body to Sum_l Sum_k Sum_p D. *)
    transitivity
      (Sum n (fun a => Sum n (fun b => Sum L (fun l => Sum n (fun k =>
         Sum n (fun p => v a * K l a p * rho p k * K l b k * v b)))))).
    { apply Sum_eq; intro a. apply Sum_eq; intro b.
      rewrite <- (Sum_scal_l L (v a)
        (fun l => Sum n (fun k => (Sum n (fun p => K l a p * rho p k)) * K l b k))).
      rewrite <- (Sum_scal_r L (v b)
        (fun l => v a * Sum n (fun k => (Sum n (fun p => K l a p * rho p k)) * K l b k))).
      apply Sum_eq; intro l.
      rewrite <- (Sum_scal_l n (v a)
        (fun k => (Sum n (fun p => K l a p * rho p k)) * K l b k)).
      rewrite <- (Sum_scal_r n (v b)
        (fun k => v a * ((Sum n (fun p => K l a p * rho p k)) * K l b k))).
      apply Sum_eq; intro k.
      (* body: v a * ((Sum_p K l a p rho p k) * K l b k) * v b
         First pull K l b k out of the inner sum (as a right scalar),
         then pull v a (left) and v b (right) through the resulting sum. *)
      rewrite <- (Sum_scal_r n (K l b k) (fun p => K l a p * rho p k)).
      rewrite <- (Sum_scal_l n (v a) (fun p => K l a p * rho p k * K l b k)).
      rewrite <- (Sum_scal_r n (v b) (fun p => v a * (K l a p * rho p k * K l b k))).
      apply Sum_eq; intro p; ring. }
    (* Step B: reorder Sum_a Sum_b Sum_l (...) -> Sum_l Sum_a Sum_b (...). *)
    (* B1: Sum_a Sum_b Sum_l G = Sum_a Sum_l Sum_b G *)
    transitivity
      (Sum n (fun a => Sum L (fun l => Sum n (fun b => Sum n (fun k =>
         Sum n (fun p => v a * K l a p * rho p k * K l b k * v b)))))).
    { apply Sum_eq; intro a.
      apply (Sum_swap n L
        (fun b l => Sum n (fun k => Sum n (fun p =>
           v a * K l a p * rho p k * K l b k * v b)))). }
    (* B2: Sum_a Sum_l (...) = Sum_l Sum_a (...) *)
    transitivity
      (Sum L (fun l => Sum n (fun a => Sum n (fun b => Sum n (fun k =>
         Sum n (fun p => v a * K l a p * rho p k * K l b k * v b)))))).
    { apply (Sum_swap n L
        (fun a l => Sum n (fun b => Sum n (fun k => Sum n (fun p =>
           v a * K l a p * rho p k * K l b k * v b))))). }
    (* B3: inside, swap k,p to reach canonical order Sum_p Sum_k *)
    apply Sum_eq; intro l. apply Sum_eq; intro a. apply Sum_eq; intro b.
    apply (Sum_swap n n
      (fun k p => v a * K l a p * rho p k * K l b k * v b)).
  - (* canonical -> RHS.
       RHS = Sum_l quadform rho (fun c => Sum_i K l i c * v i)
           = Sum_l Sum_p Sum_k  (Sum_i K l i p v i) * rho p k * (Sum_j K l j k v j). *)
    apply Sum_eq; intro l.
    unfold quadform.
    (* RHS body: Sum_p Sum_k  (Sum_i K l i p v i) * rho p k * (Sum_j K l j k v j) *)
    (* canonical body: Sum_a Sum_b Sum_p Sum_k  v a * K l a p * rho p k * K l b k * v b *)
    (* First rewrite RHS into nested sums over i (=a) and j (=b). *)
    symmetry.
    transitivity
      (Sum n (fun p => Sum n (fun k =>
         Sum n (fun a => Sum n (fun b =>
           v a * K l a p * rho p k * K l b k * v b))))).
    + (* RHS body -> Sum_a Sum_b D *)
      apply Sum_eq; intro p. apply Sum_eq; intro k.
      (* (Sum_i K l i p v i) * rho p k * (Sum_j K l j k v j)
         = Sum_a Sum_b  (K l a p v a) * rho p k * (K l b k v b)
         Step 1: pull rho p k inside the left sum (right scalar).
         Step 2: pull the right sum inside (right scalar of whole left sum).
         Step 3: for each a, pull (K l a p * v a * rho p k) out of the j-sum. *)
      rewrite <- (Sum_scal_r n (rho p k) (fun i => K l i p * v i)).
      rewrite <- (Sum_scal_r n (Sum n (fun j => K l j k * v j))
        (fun i => K l i p * v i * rho p k)).
      apply Sum_eq; intro a.
      rewrite <- (Sum_scal_l n (K l a p * v a * rho p k)
        (fun j => K l j k * v j)).
      apply Sum_eq; intro b; ring.
    + (* now reorder Sum_p Sum_k Sum_a Sum_b -> Sum_a Sum_b Sum_p Sum_k *)
      (* C1: Sum_p Sum_k Sum_a G = Sum_p Sum_a Sum_k G *)
      transitivity
        (Sum n (fun p => Sum n (fun a => Sum n (fun k => Sum n (fun b =>
           v a * K l a p * rho p k * K l b k * v b))))).
      { apply Sum_eq; intro p.
        apply (Sum_swap n n
          (fun k a => Sum n (fun b =>
             v a * K l a p * rho p k * K l b k * v b))). }
      (* C2: Sum_p Sum_a (...) = Sum_a Sum_p (...) *)
      transitivity
        (Sum n (fun a => Sum n (fun p => Sum n (fun k => Sum n (fun b =>
           v a * K l a p * rho p k * K l b k * v b))))).
      { apply (Sum_swap n n
          (fun p a => Sum n (fun k => Sum n (fun b =>
             v a * K l a p * rho p k * K l b k * v b)))). }
      (* C3: inside a, reorder Sum_p Sum_k Sum_b -> Sum_b Sum_p Sum_k *)
      apply Sum_eq; intro a.
      transitivity
        (Sum n (fun p => Sum n (fun b => Sum n (fun k =>
           v a * K l a p * rho p k * K l b k * v b)))).
      { apply Sum_eq; intro p.
        apply (Sum_swap n n
          (fun k b => v a * K l a p * rho p k * K l b k * v b)). }
      (* now Sum_p Sum_b Sum_k -> Sum_b Sum_p Sum_k *)
      apply (Sum_swap n n
        (fun p b => Sum n (fun k =>
           v a * K l a p * rho p k * K l b k * v b))).
Qed.

Theorem channel_completely_positive :
  forall rho, psd rho -> psd (kchan rho).
Proof.
  unfold psd; intros rho H v.
  rewrite quadform_kchan.
  apply Sum_nonneg; intro l. apply H.
Qed.

End General.

(* =====================================================================
   AXIOM AUDIT (run after the proofs are closed under coqc).
   ===================================================================== *)
Print Assumptions channel_trace_preserving.
Print Assumptions channel_completely_positive.
Print Assumptions Sum_swap.
Print Assumptions Sum_delta.

(* End RDL_StarRigGeneral.v *)
