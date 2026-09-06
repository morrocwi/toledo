(* =====================================================================
   RDL_LaplaceBeltrami.v
   ---------------------------------------------------------------------
   The discrete Laplace-Beltrami operator and its positive-semidefiniteness,
   in arbitrary dimension. This addresses the standing OPEN gap
   ("n-dimensional Laplace-Beltrami") at the level a pixel/lattice field
   theory actually uses.

   WHAT THIS IS. The standard discretisation of the Laplace-Beltrami
   operator on a Riemannian manifold is the WEIGHTED GRAPH LAPLACIAN
   (the finite-element / cotangent Laplacian of geometry processing):
   on a finite vertex set with symmetric nonnegative edge weights
   w_ij >= 0 -- the weights encoding the discrete metric -- the operator is

       (L f)_i  =  sum_j w_ij (f_i - f_j)   =   (D f)_i - (W f)_i,

   with Dirichlet energy  E(f) = sum_{i,j} w_ij (f_i - f_j)^2.  This is
   dimension-agnostic: a 1-D path, a 2-D pixel grid, or a 3-D lattice are
   just particular weight patterns.  We prove, for ALL such operators:

     lap_is_D_minus_W            L = D - W (the standard decomposition)
     laplacian_energy_identity   2 <f, L f> = E(f)      (the energy identity)
     energy_nonneg               0 <= E(f)              (Dirichlet energy >= 0)
     laplacian_psd               0 <= <f, L f>          (POSITIVE SEMIDEFINITE)

   The PSD proof is the honest engine: positivity is a sum of squares,
   so it holds in every dimension with no eigenvalue machinery.

   CONCRETE WITNESS. The 1-D path graph (the [1,-2,1] line Laplacian) is
   instantiated (path_laplacian_psd); the d-dimensional grid is the d-fold
   Cartesian product of paths, and a 2-D pixel grid (the PGFT setting) has,
   at every interior pixel, exactly the negative axis-wise second
   differences -((f_{r,c-1}-2f_{r,c}+f_{r,c+1}) + (f_{r-1,c}-2f_{r,c}+f_{r+1,c})),
   i.e. the 5-point stencil = the sum over axes of the [1,-2,1] stencil of
   RDL_TelescopeCore (telescope_second). Energy splits as the sum of the
   per-axis path energies. (These grid facts are pre-verified numerically;
   the general PSD theorem below covers all of them uniformly.)

   HONEST CAVEAT. This is the DISCRETE (combinatorial / finite-element)
   Laplace-Beltrami operator -- the operator a pixel theory is built on.
   The convergence of this discrete operator to the smooth Riemannian
   Delta_g on a curved manifold (the spectral-convergence theorem) is a
   separate analytic limit and remains OPEN here; the metric is encoded
   combinatorially in the weights w.

   Over Z; induction + ring + lia/nia; FUNEXT-FREE; axiom-free by
   construction. STATUS: candidate; each Print Assumptions must report
   "Closed under the global context".
   ===================================================================== *)

Require Import ZArith.
Require Import Arith.
Require Import Bool.
Require Import Lia.
Open Scope Z_scope.

(* ===================== finite-sum engine ===================== *)
Fixpoint sumZ (n : nat) (f : nat -> Z) : Z :=
  match n with O => 0 | S k => sumZ k f + f k end.

Lemma sumZ_ext : forall n f g, (forall k, f k = g k) -> sumZ n f = sumZ n g.
Proof. induction n; intros f g H; simpl. - reflexivity. - rewrite (IHn f g H), H. reflexivity. Qed.

Lemma sumZ_zero : forall n, sumZ n (fun _ => 0) = 0.
Proof. induction n; simpl. - reflexivity. - rewrite IHn. reflexivity. Qed.

Lemma sumZ_add : forall n f g, sumZ n (fun k => f k + g k) = sumZ n f + sumZ n g.
Proof. induction n; intros; simpl. - reflexivity. - rewrite IHn. ring. Qed.

Lemma sumZ_sub : forall n f g, sumZ n (fun k => f k - g k) = sumZ n f - sumZ n g.
Proof. induction n; intros; simpl. - reflexivity. - rewrite IHn. ring. Qed.

Lemma sumZ_mul_l : forall n c f, c * sumZ n f = sumZ n (fun k => c * f k).
Proof. induction n; intros; simpl. - ring. - rewrite <- IHn. ring. Qed.

Lemma sumZ_nonneg : forall n f, (forall k, 0 <= f k) -> 0 <= sumZ n f.
Proof.
  induction n; intros f H; simpl. - lia.
  - assert (0 <= sumZ n f) by (apply IHn; exact H). specialize (H n). lia.
Qed.

Lemma sumZ_swap : forall m n g,
  sumZ n (fun i => sumZ m (fun j => g i j)) = sumZ m (fun j => sumZ n (fun i => g i j)).
Proof.
  intros m. induction n; intro g; simpl.
  - rewrite sumZ_zero. reflexivity.
  - rewrite IHn. rewrite <- sumZ_add. apply sumZ_ext. intro j. simpl. reflexivity.
Qed.

(* ===================== double sum ===================== *)
Definition dsum (n : nat) (g : nat -> nat -> Z) : Z :=
  sumZ n (fun i => sumZ n (fun j => g i j)).

Lemma dsum_ext : forall n g h, (forall i j, g i j = h i j) -> dsum n g = dsum n h.
Proof. intros n g h H. unfold dsum. apply sumZ_ext; intro i. apply sumZ_ext; intro j. apply H. Qed.

Lemma dsum_add : forall n g h, dsum n (fun i j => g i j + h i j) = dsum n g + dsum n h.
Proof. intros n g h. unfold dsum. rewrite <- sumZ_add. apply sumZ_ext. intro i. apply sumZ_add. Qed.

Lemma dsum_sub : forall n g h, dsum n (fun i j => g i j - h i j) = dsum n g - dsum n h.
Proof. intros n g h. unfold dsum. rewrite <- sumZ_sub. apply sumZ_ext. intro i. apply sumZ_sub. Qed.

Lemma dsum_scale : forall n c g, c * dsum n g = dsum n (fun i j => c * g i j).
Proof.
  intros n c g. unfold dsum.
  rewrite (sumZ_mul_l n c (fun i => sumZ n (fun j => g i j))).
  apply sumZ_ext. intro i. apply sumZ_mul_l.
Qed.

Lemma dsum_swap : forall n g, dsum n g = dsum n (fun i j => g j i).
Proof.
  intros n g. unfold dsum. rewrite (sumZ_swap n n g).
  apply sumZ_ext; intro i. apply sumZ_ext; intro j. reflexivity.
Qed.

Lemma dsum_zero : forall n, dsum n (fun _ _ => 0) = 0.
Proof.
  intro n. unfold dsum.
  transitivity (sumZ n (fun _ : nat => 0)).
  - apply sumZ_ext. intro i. apply sumZ_zero.
  - apply sumZ_zero.
Qed.

(* ===================== the operator ===================== *)
Section LaplaceBeltrami.
Variable n : nat.
Variable w : nat -> nat -> Z.
Hypothesis w_sym    : forall i j, w i j = w j i.
Hypothesis w_nonneg : forall i j, 0 <= w i j.

(* Dirichlet energy E(f) = sum_{i,j} w_ij (f_i - f_j)^2 *)
Definition energy (f : nat -> Z) : Z :=
  dsum n (fun i j => w i j * ((f i - f j) * (f i - f j))).

(* Laplacian action (L f)_i = sum_j w_ij (f_i - f_j) *)
Definition lap (f : nat -> Z) (i : nat) : Z :=
  sumZ n (fun j => w i j * (f i - f j)).

(* quadratic form <f, L f> = sum_i f_i (L f)_i *)
Definition quadform (f : nat -> Z) : Z :=
  sumZ n (fun i => f i * lap f i).

Lemma lap_sum : forall f i, lap f i = sumZ n (fun j => w i j * (f i - f j)).
Proof. reflexivity. Qed.

(* L = D - W : the Laplacian splits into the degree term and the adjacency term. *)
Lemma lap_is_D_minus_W : forall f i,
  lap f i = sumZ n (fun j => w i j * f i) - sumZ n (fun j => w i j * f j).
Proof.
  intros f i. rewrite lap_sum. rewrite <- sumZ_sub.
  apply sumZ_ext. intro j. ring.
Qed.

Lemma quadform_dsum : forall f,
  quadform f = dsum n (fun i j => f i * (w i j * (f i - f j))).
Proof.
  intro f. unfold quadform, dsum. apply sumZ_ext. intro i.
  rewrite lap_sum. rewrite (sumZ_mul_l n (f i) (fun j => w i j * (f i - f j))).
  reflexivity.
Qed.

(* THE ENERGY IDENTITY: 2 <f, L f> = E(f).  Uses symmetry of w (reindex). *)
Lemma laplacian_energy_identity : forall f, 2 * quadform f = energy f.
Proof.
  intro f. rewrite quadform_dsum. unfold energy.
  rewrite (dsum_scale n 2 (fun i j => f i * (w i j * (f i - f j)))).
  assert (Hsw : dsum n (fun i j => w i j * (f j * f j))
              = dsum n (fun i j => w i j * (f i * f i))).
  { rewrite (dsum_swap n (fun i j => w i j * (f j * f j))).
    apply dsum_ext. intros i j. cbv beta. rewrite (w_sym j i). reflexivity. }
  transitivity (dsum n (fun i j =>
      2 * (f i * (w i j * (f i - f j))) + w i j * (f j * f j) - w i j * (f i * f i))).
  - rewrite dsum_sub. rewrite dsum_add. rewrite Hsw. ring.
  - apply dsum_ext. intros i j. ring.
Qed.

Lemma energy_nonneg : forall f, 0 <= energy f.
Proof.
  intro f. unfold energy, dsum.
  apply sumZ_nonneg; intro i. apply sumZ_nonneg; intro j.
  pose proof (w_nonneg i j).
  assert (Hsq : 0 <= (f i - f j) * (f i - f j)) by apply Z.square_nonneg.
  nia.
Qed.

(* POSITIVE SEMIDEFINITE: 0 <= <f, L f>, in every dimension. *)
Theorem laplacian_psd : forall f, 0 <= quadform f.
Proof.
  intro f.
  pose proof (laplacian_energy_identity f) as H.
  pose proof (energy_nonneg f) as He.
  lia.
Qed.

(* The constant function is harmonic: it is the null mode (lambda_0 = 0).
   This is the conservation / gauge-constant mode -- in PGFT terms the
   zero-obstruction mode O = 0: a globally constant readout costs no energy. *)
Lemma lap_const : forall c i, lap (fun _ => c) i = 0.
Proof.
  intros c i. rewrite lap_sum.
  transitivity (sumZ n (fun _ : nat => 0)).
  - apply sumZ_ext. intro j. cbv beta. ring.
  - apply sumZ_zero.
Qed.

Lemma energy_const : forall c, energy (fun _ => c) = 0.
Proof.
  intro c. unfold energy.
  transitivity (dsum n (fun _ _ : nat => 0)).
  - apply dsum_ext. intros i j. cbv beta. ring.
  - apply dsum_zero.
Qed.

Lemma quadform_const : forall c, quadform (fun _ => c) = 0.
Proof.
  intro c. pose proof (laplacian_energy_identity (fun _ => c)) as H.
  rewrite (energy_const c) in H. lia.
Qed.

End LaplaceBeltrami.

(* =====================================================================
   CONCRETE WITNESS: the 1-D path graph (line of nodes) -- the standard
   [1,-2,1] line Laplacian.  Unit weights on |i-j| = 1 edges, symmetric.
   The d-dimensional grid is the d-fold Cartesian product of these.
   ===================================================================== *)
Definition wpath (i j : nat) : Z :=
  if orb (Nat.eqb (S i) j) (Nat.eqb (S j) i) then 1 else 0.

Lemma wpath_sym : forall i j, wpath i j = wpath j i.
Proof. intros i j. unfold wpath. rewrite orb_comm. reflexivity. Qed.

Lemma wpath_nonneg : forall i j, 0 <= wpath i j.
Proof. intros i j. unfold wpath. destruct (orb (Nat.eqb (S i) j) (Nat.eqb (S j) i)); lia. Qed.

(* PSD of the 1-D path Laplacian, for any number of nodes -- an instance
   of the general theorem. The d-dim grid and the 2-D pixel grid follow
   the same way (symmetric, nonnegative weights). *)
Theorem path_laplacian_psd : forall len f, 0 <= quadform len wpath f.
Proof. intros len f. apply (laplacian_psd len wpath wpath_sym wpath_nonneg). Qed.

(* =====================================================================
   AXIOM AUDIT.  Each must report "Closed under the global context".
   ===================================================================== *)
Print Assumptions laplacian_energy_identity.
Print Assumptions energy_nonneg.
Print Assumptions laplacian_psd.
Print Assumptions quadform_const.
Print Assumptions path_laplacian_psd.

(* End RDL_LaplaceBeltrami.v *)
