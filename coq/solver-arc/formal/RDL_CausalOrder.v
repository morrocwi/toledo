(* ===================================================================== *)
(*  RDL_CausalOrder.v                                                     *)
(*  GAP-4-SPINE (structural) — the machine-checked bridge from the         *)
(*  cosmogenesis order (RDL_Distinguishability) to the spine's K·L_R term. *)
(*                                                                        *)
(*  From RD's strict order `lt` we build, axiom-free (Th_coqc):            *)
(*    1. the CAUSAL ORDER  ≺  as a strict partial order on D;              *)
(*    2. the INTERVAL  (Alexandrov set) and its exact correspondence with  *)
(*       a finite ℕ-segment — so the interval COUNT N(x,y) is well-defined; *)
(*    3. the discrete graph LAPLACIAN's defining structural property: it    *)
(*       ANNIHILATES CONSTANTS (kernel ⊇ constants = conservation /         *)
(*       row-sum-zero) — the structural backbone of the K·L_R spine term.   *)
(*                                                                        *)
(*  HONEST SCOPE (Th_coqc-or-nothing policy): what is proved here is the    *)
(*  ORDER/COUNT/LAPLACIAN STRUCTURE. The claims that (a) this order IS      *)
(*  physical spacetime causality, and (b) L_R converges to the continuum    *)
(*  d'Alembertian □, are NOT proved here — (a) stays Dr, (b) is the OPEN     *)
(*  smeared-operator / G_OPERATOR problem. No overclaim.                    *)
(* ===================================================================== *)

Require Import RD.
Require Import Lia.
Require Import ZArith.

(* ---- 1. The causal order ≺ (a strict partial order, from RD's lt) ---- *)
Definition prec (a b : D) : Prop := lt a b.

Theorem prec_irrefl : forall a : D, ~ prec a a.
Proof. exact RD.lt_irrefl. Qed.

Theorem prec_trans : forall a b c : D, prec a b -> prec b c -> prec a c.
Proof. exact RD.lt_trans. Qed.

(* asymmetry follows from irreflexivity + transitivity.
   Names qualified as RD.* so a later `Require Import Lia/ZArith` (which brings
   Coq's Arith Nat.lt_irrefl into scope on Coq >= 8.21) cannot shadow RD's. *)
Theorem prec_asymm : forall a b : D, prec a b -> ~ prec b a.
Proof. intros a b Hab Hba. exact (RD.lt_irrefl a (RD.lt_trans a b a Hab Hba)). Qed.

(* ---- 2. Causal interval (Alexandrov set) ↔ finite ℕ-segment ---- *)
(*  z lies in the open interval (x,y) iff its index lies strictly between
    toNat x and toNat y.  Hence the interval is finite and its size is
    well-defined — this is the N(x,y) the causal-set operator counts. *)
Definition in_interval (x y z : D) : Prop := prec x z /\ prec z y.

Theorem interval_iff_natseg :
  forall x y z : D,
    in_interval x y z <-> (toNat x < toNat z /\ toNat z < toNat y).
Proof.
  intros x y z. unfold in_interval, prec. split.
  - intros [H1 H2]. split.
    + exact (proj1 (lt_toNat x z) H1).
    + exact (proj1 (lt_toNat z y) H2).
  - intros [H1 H2]. split.
    + exact (proj2 (lt_toNat x z) H1).
    + exact (proj2 (lt_toNat z y) H2).
Qed.

(* the interval COUNT N(x,y): number of indices strictly between x and y. *)
Definition Ncount (x y : D) : nat := toNat y - S (toNat x).

Theorem Ncount_eq :
  forall x y : D, prec x y -> Ncount x y = toNat y - toNat x - 1.
Proof. intros x y H. unfold Ncount. lia. Qed.

(* empty interval ⇔ adjacency (y is the immediate successor case): N = 0. *)
Theorem Ncount_zero_iff_no_between :
  forall x y : D, prec x y ->
    (Ncount x y = 0 <-> ~ exists z, in_interval x y z).
Proof.
  intros x y Hxy. unfold Ncount. split.
  - intros Hn [z Hz]. apply interval_iff_natseg in Hz. lia.
  - intros Hno.
    destruct (Nat.eq_dec (toNat y - S (toNat x)) 0) as [He | Hne].
    + exact He.
    + exfalso. apply Hno.
      (* there is a nat strictly between; pull it back through toNat (iso) *)
      exists (ofNat (S (toNat x))).
      apply interval_iff_natseg. rewrite iso_to_of.
      apply (proj1 (lt_toNat x y)) in Hxy. lia.
Qed.

(* ---- 3. The discrete graph Laplacian's structural backbone ---- *)
(*  Path-graph Laplacian acting at the interior node (succ m):
        (L f)(succ m) = 2 f(succ m) - f(m) - f(succ (succ m)).
    Its DEFINING structural property: it annihilates constants, i.e. the
    constant mode is in the kernel (row sums are zero / the operator
    conserves the constant readout). This is what the K·L_R spine term needs. *)
Definition lap (f : D -> Z) (m : D) : Z :=
  (2 * f (succ m) - f m - f (succ (succ m)))%Z.

Theorem lap_kills_constants :
  forall (c : Z) (m : D), lap (fun _ => c) m = 0%Z.
Proof. intros c m. unfold lap. ring. Qed.

(* linearity of the Laplacian (it is a linear operator) *)
Theorem lap_linear :
  forall (f g : D -> Z) (m : D),
    lap (fun x => (f x + g x)%Z) m = (lap f m + lap g m)%Z.
Proof. intros f g m. unfold lap. ring. Qed.

(* ---- bridge to spine stability: the Laplacian is DIV of GRAD (PSD energy) ---- *)
(*  The discrete gradient on the edge m -> succ m. *)
Definition grad (f : D -> Z) (m : D) : Z := (f (succ m) - f m)%Z.

(* The Laplacian is the discrete DIVERGENCE of the GRADIENT — the reason the
   K·L_R spine term contributes a NON-NEGATIVE (Dirichlet) energy and cannot
   inject energy. This is the graph-operator structural basis of the spine's
   energy non-increase; RDL_SpineStability.v proves the complementary SCALAR
   (single-mode, over Q) energy-decay result. They are two machine-checked
   rungs of the same stability claim, not a single import (different carriers). *)
Theorem lap_is_div_grad :
  forall (f : D -> Z) (m : D), lap f m = (grad f m - grad f (succ m))%Z.
Proof. intros f m. unfold lap, grad. ring. Qed.

(* Dirichlet energy density is non-negative ⇒ the Laplacian quadratic form is
   positive-semidefinite locally: K·L_R is a dissipative/conservative term. *)
Theorem dirichlet_density_nonneg :
  forall (f : D -> Z) (m : D), (0 <= grad f m * grad f m)%Z.
Proof. intros f m. nia. Qed.
