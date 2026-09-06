(* =====================================================================
   RDL_StarRigMatrixN_Step3.v
   ---------------------------------------------------------------------
   Discharging the GENERAL theorem (RDL_StarRigCPTP_General.v) for LITERAL
   n x n integer matrices -- step 3: the POSITIVE CONE.  This COMPLETES
   the concrete n x n model: every abstract hypothesis is now discharged
   for all n.

   Steps 1-2 gave a traced *-ring up to meq for all n (mul_0, mul_1,
   mul_assoc, mul_add, adj_mul, adj_adj, trace_add, trace_cyc).  This file
   adds the positive cone:

        psd_zero   (psd_zero)
        psd_add    (psd_add)
        psd_conj   (psd_conj)   <-- complete positivity: psd preservation
                                    under *-conjugation, the "CP" of CPTP.

   The positive cone is the QUADRATIC FORM  quadform A v = <v, A v> ; we
   define  quadform A v := dot v (A.v)  and route psd_conj through three
   bilinear-algebra lemmas:

        mv_mmul   (A B).v = A.(B.v)
        dot_adj   <u, A v> = <adj A . u, v>      (adjoint moves across <.,.>)
        quadform_conj   <v, (K rho Kadj) v> = <Kadj v, rho (Kadj v)>

   so that  psd rho  =>  0 <= quadform rho (Kadj v)  =>  psd (K rho Kadj).
   (Here Kadj = adj K = K-dagger = K^*; the notation avoids closing comment delimiters.)
   This is dimension-independent and uses NO minors.

   SELF-CONTAINED; FUNEXT-FREE (pointwise meq / scalar statements).  All
   proofs descend with sumZ_ext and use only plain `rewrite` at fixed
   indices -- NO `setoid_rewrite` under binders -- for robustness.

   STATUS: candidate.  Must pass `coqc 8.18.0`; each `Print Assumptions`
   must report "Closed under the global context".
   ===================================================================== *)

Require Import ZArith.
Require Import Lia.
Open Scope Z_scope.

(* =====================================================================
   Finite-sum engine.
   ===================================================================== *)
Fixpoint sumZ (n : nat) (f : nat -> Z) : Z :=
  match n with O => 0 | S k => sumZ k f + f k end.

Lemma sumZ_ext : forall n f g,
  (forall i, (i < n)%nat -> f i = g i) -> sumZ n f = sumZ n g.
Proof.
  induction n; intros f g H; simpl.
  - reflexivity.
  - rewrite (H n) by lia. f_equal. apply IHn. intros i Hi. apply H. lia.
Qed.

Lemma sumZ_zero : forall n, sumZ n (fun _ => 0) = 0.
Proof. induction n; simpl; [reflexivity | rewrite IHn; ring]. Qed.

Lemma sumZ_add : forall n f g,
  sumZ n (fun i => f i + g i) = sumZ n f + sumZ n g.
Proof. induction n; intros; simpl; [ring | rewrite IHn; ring]. Qed.

Lemma sumZ_mul_l : forall n c f,
  sumZ n (fun k => c * f k) = (c * sumZ n f)%Z.
Proof. intros n c f. induction n; simpl; [ring | rewrite IHn; ring]. Qed.

Lemma sumZ_mul_r : forall n c f,
  sumZ n (fun k => f k * c) = (sumZ n f * c)%Z.
Proof. intros n c f. induction n; simpl; [ring | rewrite IHn; ring]. Qed.

Lemma sumZ_swap : forall n m f,
  sumZ n (fun i => sumZ m (fun j => f i j))
  = sumZ m (fun j => sumZ n (fun i => f i j)).
Proof.
  induction n; intros m f; simpl.
  - symmetry. apply sumZ_zero.
  - rewrite (IHn m f).
    rewrite <- (sumZ_add m (fun j => sumZ n (fun i => f i j)) (fun j => f n j)).
    apply sumZ_ext. intros j Hj. reflexivity.
Qed.

(* =====================================================================
   n x n integer matrices, vectors, and the inner-product gadgets.
   ===================================================================== *)
Definition Mat := nat -> nat -> Z.
Definition Vec := nat -> Z.

Definition mmul (n : nat) (A B : Mat) : Mat :=
  fun i j => sumZ n (fun k => A i k * B k j).
Definition madd (A B : Mat) : Mat := fun i j => A i j + B i j.
Definition mzero : Mat := fun _ _ => 0.
Definition adj (A : Mat) : Mat := fun i j => A j i.

Lemma mmul_unfold : forall n A B i j,
  mmul n A B i j = sumZ n (fun k => A i k * B k j).
Proof. reflexivity. Qed.
Lemma madd_unfold : forall A B i j, madd A B i j = A i j + B i j.
Proof. reflexivity. Qed.
Lemma adj_unfold : forall A i j, adj A i j = A j i.
Proof. reflexivity. Qed.

(* matrix-vector product, dot product, quadratic form, positive cone *)
Definition mv (n : nat) (A : Mat) (v : Vec) : Vec :=
  fun i => sumZ n (fun j => A i j * v j).
Definition dot (n : nat) (u v : Vec) : Z := sumZ n (fun i => u i * v i).
Definition quadform (n : nat) (A : Mat) (v : Vec) : Z := dot n v (mv n A v).
Definition psd (n : nat) (A : Mat) : Prop := forall v : Vec, 0 <= quadform n A v.

(* dot respects pointwise equality of its right argument on [0,n) *)
Lemma dot_ext_r : forall n u v v',
  (forall i, (i < n)%nat -> v i = v' i) -> dot n u v = dot n u v'.
Proof.
  intros n u v v' H. unfold dot. apply sumZ_ext. intros i Hi.
  rewrite (H i Hi). reflexivity.
Qed.

Lemma dot_zero_r : forall n u, dot n u (fun _ => 0) = 0.
Proof.
  intros n u. unfold dot.
  transitivity (sumZ n (fun _ : nat => 0)).
  - apply sumZ_ext. intros i Hi. cbn. ring.
  - apply sumZ_zero.
Qed.

(* =====================================================================
   (A B) . v = A . (B . v)
   ===================================================================== *)
Lemma mv_mmul : forall n A B v i,
  mv n (mmul n A B) v i = mv n A (mv n B v) i.
Proof.
  intros n A B v i. unfold mv.
  transitivity (sumZ n (fun k => sumZ n (fun l => A i l * B l k * v k))).
  - apply sumZ_ext. intros k Hk.
    rewrite mmul_unfold. rewrite <- sumZ_mul_r.
    apply sumZ_ext. intros l Hl. ring.
  - rewrite (sumZ_swap n n (fun k l => A i l * B l k * v k)).
    apply sumZ_ext. intros l Hl.
    rewrite <- sumZ_mul_l.
    apply sumZ_ext. intros k Hk. ring.
Qed.

(* =====================================================================
   <u, A v> = <adj A . u, v>   (the adjoint moves across the inner product)
   ===================================================================== *)
Lemma dot_adj : forall n A u v,
  dot n u (mv n A v) = dot n (mv n (adj A) u) v.
Proof.
  intros n A u v. unfold dot, mv.
  transitivity (sumZ n (fun i => sumZ n (fun j => u i * (A i j * v j)))).
  - apply sumZ_ext. intros i Hi.
    rewrite <- sumZ_mul_l. apply sumZ_ext. intros j Hj. ring.
  - rewrite (sumZ_swap n n (fun i j => u i * (A i j * v j))).
    apply sumZ_ext. intros j Hj.
    rewrite <- sumZ_mul_r. apply sumZ_ext. intros i Hi.
    rewrite adj_unfold. ring.
Qed.

(* =====================================================================
   linearity gadgets for the cone
   ===================================================================== *)
Lemma mv_madd : forall n A B v i,
  mv n (madd A B) v i = mv n A v i + mv n B v i.
Proof.
  intros n A B v i. unfold mv.
  rewrite <- (sumZ_add n (fun j => A i j * v j) (fun j => B i j * v j)).
  apply sumZ_ext. intros j Hj. rewrite madd_unfold. ring.
Qed.

Lemma mv_zero : forall n v i, mv n mzero v i = 0.
Proof.
  intros n v i. unfold mv.
  transitivity (sumZ n (fun _ : nat => 0)).
  - apply sumZ_ext. intros j Hj. unfold mzero. cbn. ring.
  - apply sumZ_zero.
Qed.

(* =====================================================================
   THE CONJUGATION IDENTITY:  <v, (K rho Kadj) v> = <Kadj v, rho (Kadj v)>
   where Kadj = adj K  (K-dagger, written K^-star to avoid comment delimiters).
   ===================================================================== *)
Theorem quadform_conj : forall n K rho v,
  quadform n (mmul n (mmul n K rho) (adj K)) v
  = quadform n rho (mv n (adj K) v).
Proof.
  intros n K rho v. unfold quadform.
  rewrite (dot_ext_r n v (mv n (mmul n (mmul n K rho) (adj K)) v)
                         (mv n K (mv n rho (mv n (adj K) v)))).
  - rewrite (dot_adj n K v (mv n rho (mv n (adj K) v))). reflexivity.
  - intros i Hi.
    rewrite (mv_mmul n (mmul n K rho) (adj K) v i).
    rewrite (mv_mmul n K rho (mv n (adj K) v) i).
    reflexivity.
Qed.

Theorem quadform_madd : forall n A B v,
  quadform n (madd A B) v = quadform n A v + quadform n B v.
Proof.
  intros n A B v. unfold quadform.
  rewrite (dot_ext_r n v (mv n (madd A B) v)
                         (fun i => mv n A v i + mv n B v i)).
  - unfold dot.
    rewrite <- (sumZ_add n (fun i => v i * mv n A v i)
                           (fun i => v i * mv n B v i)).
    apply sumZ_ext. intros i Hi. ring.
  - intros i Hi. apply mv_madd.
Qed.

(* =====================================================================
   THE POSITIVE CONE (discharges psd_zero, psd_add, psd_conj).
   ===================================================================== *)
Theorem psd_zero : forall n, psd n mzero.
Proof.
  intros n. unfold psd. intros v. unfold quadform.
  rewrite (dot_ext_r n v (mv n mzero v) (fun _ => 0)).
  - rewrite dot_zero_r. lia.
  - intros i Hi. apply mv_zero.
Qed.

Theorem psd_add : forall n A B, psd n A -> psd n B -> psd n (madd A B).
Proof.
  intros n A B HA HB v.
  rewrite quadform_madd.
  apply Z.add_nonneg_nonneg; [apply HA | apply HB].
Qed.

Theorem psd_conj : forall n K rho,
  psd n rho -> psd n (mmul n (mmul n K rho) (adj K)).
Proof.
  intros n K rho H. unfold psd in H. unfold psd. intros v.
  rewrite quadform_conj. apply H.
Qed.

(* =====================================================================
   AXIOM AUDIT.  The concrete n x n model now discharges the FULL
   positive cone of RDL_StarRigCPTP_General.v.
   ===================================================================== *)
Print Assumptions psd_conj.
Print Assumptions quadform_conj.
Print Assumptions psd_add.
Print Assumptions psd_zero.

(* End RDL_StarRigMatrixN_Step3.v *)
