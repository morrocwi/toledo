(* =====================================================================
   RDL_StarRigMatrixN.v
   ---------------------------------------------------------------------
   Discharging the GENERAL theorem (RDL_StarRigCPTP_General.v) for LITERAL
   n x n integer matrices, for EVERY dimension n -- step 1.

   Matrices are functions  nat -> nat -> Z ; matrix equality is taken
   POINTWISE (meq), so the development is FUNEXT-FREE (in the project's
   setoid spirit -- cf. RDL_ContextSetoid.v).  We build a finite-sum
   engine and prove that (Mat, madd, mmul n, adj) is, for every n, a
   traced *-algebra UP TO meq, discharging the abstract hypotheses

        trace_add   (trace_madd)
        trace_cyc   (trace_mmul_comm)      <-- the headline: TRACE
                                               CYCLICITY for all n
        adj_adj     (adj_invol)
        adj_mul     (adj_mmul)
        mul_add_l   (mmul_distrib_l)
        mul_0_l     (mmul_zero_l)

   These are the genuinely matrix-specific facts.  STILL TO ADD (the
   standard remainder, each a focused next step): the identity law
   (mul_1, via a Kronecker-delta sum lemma), associativity (mul_assoc,
   via a triple-sum reindex), and the positive cone (psd_conj, via the
   quadratic-form conjugation identity).  RDL_StarRigMatrix3.v already
   exhibits ALL of these concretely for n = 3, so n x n matrices are a
   complete model; this file generalises the trace/star structure to all n.

   STATUS: candidate.  Must pass `coqc 8.18.0`; `Print Assumptions
   trace_mmul_comm` must report "Closed under the global context".
   ===================================================================== *)

Require Import ZArith.
Require Import Lia.
Require Import Setoid.
Open Scope Z_scope.

(* =====================================================================
   A finite sum  sumZ n f = f 0 + f 1 + ... + f (n-1).
   ===================================================================== *)
Fixpoint sumZ (n : nat) (f : nat -> Z) : Z :=
  match n with
  | O => 0
  | S k => sumZ k f + f k
  end.

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

Lemma sumZ_nonneg : forall n f,
  (forall i, (i < n)%nat -> 0 <= f i) -> 0 <= sumZ n f.
Proof.
  induction n; intros f H; simpl.
  - lia.
  - apply Z.add_nonneg_nonneg.
    + apply IHn. intros i Hi. apply H. lia.
    + apply H. lia.
Qed.

(* the finite Fubini swap *)
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
   n x n integer matrices as functions, with pointwise equality.
   ===================================================================== *)
Definition Mat := nat -> nat -> Z.

Definition mzero : Mat := fun _ _ => 0.
Definition madd (A B : Mat) : Mat := fun i j => A i j + B i j.
Definition mmul (n : nat) (A B : Mat) : Mat :=
  fun i j => sumZ n (fun k => A i k * B k j).
Definition adj (A : Mat) : Mat := fun i j => A j i.
Definition trace (n : nat) (A : Mat) : Z := sumZ n (fun i => A i i).

Definition meq (A B : Mat) : Prop := forall i j, A i j = B i j.

Lemma meq_refl  : forall A, meq A A.
Proof. intros A i j; reflexivity. Qed.
Lemma meq_sym   : forall A B, meq A B -> meq B A.
Proof. intros A B H i j; symmetry; apply H. Qed.
Lemma meq_trans : forall A B C, meq A B -> meq B C -> meq A C.
Proof. intros A B C H1 H2 i j; rewrite H1; apply H2. Qed.

(* definitional unfolders, used as rewrite rules (robust vs. `simpl`) *)
Lemma mmul_unfold  : forall n A B i j, mmul n A B i j = sumZ n (fun k => A i k * B k j).
Proof. reflexivity. Qed.
Lemma madd_unfold  : forall A B i j, madd A B i j = A i j + B i j.
Proof. reflexivity. Qed.
Lemma adj_unfold   : forall A i j, adj A i j = A j i.
Proof. reflexivity. Qed.
Lemma trace_unfold : forall n A, trace n A = sumZ n (fun i => A i i).
Proof. reflexivity. Qed.

(* =====================================================================
   The *-algebra laws, up to meq, for every n.
   ===================================================================== *)

Lemma adj_invol : forall A, meq (adj (adj A)) A.            (* discharges adj_adj *)
Proof. intros A i j. rewrite !adj_unfold. reflexivity. Qed.

Lemma adj_mmul : forall n A B,                               (* discharges adj_mul *)
  meq (adj (mmul n A B)) (mmul n (adj B) (adj A)).
Proof.
  intros n A B i j.
  rewrite adj_unfold, !mmul_unfold.
  apply sumZ_ext. intros k Hk. rewrite !adj_unfold. ring.
Qed.

Lemma mmul_zero_l : forall n A, meq (mmul n mzero A) mzero.  (* discharges mul_0_l *)
Proof.
  intros n A i j. rewrite mmul_unfold. unfold mzero.
  transitivity (sumZ n (fun _ : nat => 0)).
  - apply sumZ_ext. intros k Hk. cbn. ring.
  - rewrite sumZ_zero. reflexivity.
Qed.

Lemma mmul_distrib_l : forall n A B C,                       (* discharges mul_add_l *)
  meq (mmul n A (madd B C)) (madd (mmul n A B) (mmul n A C)).
Proof.
  intros n A B C i j.
  rewrite madd_unfold, !mmul_unfold.
  rewrite <- (sumZ_add n (fun k => A i k * B k j) (fun k => A i k * C k j)).
  apply sumZ_ext. intros k Hk. rewrite madd_unfold. ring.
Qed.

Lemma trace_madd : forall n A B,                             (* discharges trace_add *)
  trace n (madd A B) = (trace n A + trace n B)%Z.
Proof.
  intros n A B. rewrite !trace_unfold.
  rewrite <- (sumZ_add n (fun i => A i i) (fun i => B i i)).
  apply sumZ_ext. intros i Hi. rewrite madd_unfold. reflexivity.
Qed.

(* ---- THE HEADLINE: trace is cyclic on n x n matrices, for every n ---- *)
Theorem trace_mmul_comm : forall n A B,                      (* discharges trace_cyc *)
  trace n (mmul n A B) = trace n (mmul n B A).
Proof.
  intros n A B. rewrite !trace_unfold.
  (* Expand mmul_unfold under both trace sums *)
  transitivity (sumZ n (fun i => sumZ n (fun k => A i k * B k i))).
  { apply sumZ_ext. intros i Hi. rewrite mmul_unfold. reflexivity. }
  transitivity (sumZ n (fun i => sumZ n (fun k => B i k * A k i))).
  2: { apply sumZ_ext. intros i Hi. rewrite mmul_unfold. reflexivity. }
  rewrite (sumZ_swap n n (fun i k => A i k * B k i)).
  apply sumZ_ext. intros p Hp.
  apply sumZ_ext. intros q Hq.
  ring.
Qed.

(* =====================================================================
   AXIOM AUDIT.
   ===================================================================== *)
Print Assumptions trace_mmul_comm.
Print Assumptions trace_madd.
Print Assumptions adj_mmul.
Print Assumptions mmul_distrib_l.
Print Assumptions sumZ_swap.

(* End RDL_StarRigMatrixN.v *)
