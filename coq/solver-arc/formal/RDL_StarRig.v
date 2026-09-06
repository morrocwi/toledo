(* ===================================================================== *)
(*  RDL_StarRig.v  —  involutive semiring + a resolution-of-identity      *)
(*  completeness relation.  Pure algebra, axiom-free.                      *)
(*                                                                        *)
(*  A `StarRig` is a (possibly noncommutative) semiring with an involution *)
(*  `adj` satisfying adj∘adj = id and adj(a·b) = adj b · adj a.  The       *)
(*  involution `adj` has the SAME signature as the kernel's `dual`         *)
(*  (RDL_Phase.dual_invol: dual(dual X)=X) — one shared involution root.   *)
(*                                                                        *)
(*  MAIN THEOREM (kraus_completeness): for an isometry-like U (adj U·U=1)  *)
(*  and a family {Pⱼ} of self-adjoint-projection-like elements that        *)
(*  RESOLVE THE IDENTITY (Σⱼ Pⱼ = 1, adj Pⱼ·Pⱼ = Pⱼ), the induced family   *)
(*  Kⱼ := Pⱼ·U satisfies the completeness / trace-preservation relation    *)
(*       Σⱼ adj(Kⱼ)·Kⱼ = 1.                                                *)
(*  Proven generically; instantiated on a concrete model.   coqc 8.18.0.  *)
(* ===================================================================== *)

Require Import Coq.Lists.List. Import ListNotations.
Require Import Coq.Arith.PeanoNat.

Record StarRig := {
  A     : Type ;
  zero  : A ;
  one   : A ;
  add   : A -> A -> A ;
  mul   : A -> A -> A ;
  adj   : A -> A ;
  add_0_l   : forall a, add zero a = a ;
  add_comm  : forall a b, add a b = add b a ;
  add_assoc : forall a b c, add a (add b c) = add (add a b) c ;
  mul_1_l   : forall a, mul one a = a ;
  mul_1_r   : forall a, mul a one = a ;
  mul_assoc : forall a b c, mul a (mul b c) = mul (mul a b) c ;
  mul_add_l : forall a b c, mul a (add b c) = add (mul a b) (mul a c) ;
  mul_add_r : forall a b c, mul (add a b) c = add (mul a c) (mul b c) ;
  mul_0_l   : forall a, mul zero a = zero ;
  mul_0_r   : forall a, mul a zero = zero ;
  adj_invol : forall a, adj (adj a) = a ;
  adj_add   : forall a b, adj (add a b) = add (adj a) (adj b) ;
  adj_mul   : forall a b, adj (mul a b) = mul (adj b) (adj a) ;
  adj_one   : adj one = one
}.

Definition sumA (S:StarRig) : list (A S) -> A S := fold_right (add S) (zero S).

(* the involution is shared with the kernel's `dual` (same law) *)
Lemma adj_is_involution : forall (S:StarRig) a, adj S (adj S a) = a.
Proof. intros S a. apply adj_invol. Qed.

(* sum factors through a two-sided multiplication *)
Lemma sum_mul_lr : forall (S:StarRig) (a b:A S) (l:list (A S)),
  sumA S (map (fun p => mul S a (mul S p b)) l)
  = mul S a (mul S (sumA S l) b).
Proof.
  intros S a b l. induction l as [|p ps IH]; unfold sumA in *; simpl.
  - rewrite (mul_0_l S). rewrite (mul_0_r S). reflexivity.
  - rewrite IH. rewrite (mul_add_r S). rewrite (mul_add_l S). reflexivity.
Qed.

Section Resolution.
  Variable S : StarRig.
  Variable U : A S.
  Variable Ps : list (A S).
  Hypothesis HU    : mul S (adj S U) U = one S.
  Hypothesis Hsum  : sumA S Ps = one S.
  Hypothesis Hidem : forall p, In p Ps -> mul S (adj S p) p = p.

  (* each Kraus term adj(P·U)·(P·U) collapses to adj U · (P · U) *)
  Lemma term_eq : forall p, mul S (adj S p) p = p ->
    mul S (adj S (mul S p U)) (mul S p U) = mul S (adj S U) (mul S p U).
  Proof.
    intros p Hp.
    rewrite (adj_mul S p U).
    rewrite <- (mul_assoc S (adj S U) (adj S p) (mul S p U)).
    rewrite (mul_assoc S (adj S p) p U).
    rewrite Hp. reflexivity.
  Qed.

  Theorem kraus_completeness :
    sumA S (map (fun p => mul S (adj S (mul S p U)) (mul S p U)) Ps) = one S.
  Proof.
    assert (Hmap :
      map (fun p => mul S (adj S (mul S p U)) (mul S p U)) Ps
      = map (fun p => mul S (adj S U) (mul S p U)) Ps).
    { apply map_ext_in. intros p Hin. apply term_eq. apply Hidem; exact Hin. }
    rewrite Hmap.
    rewrite (sum_mul_lr S (adj S U) U Ps).
    rewrite Hsum.
    rewrite (mul_1_l S U).
    exact HU.
  Qed.
End Resolution.

(* ===== a concrete model (axiom-free): (nat, +, ·, id) ===== *)
Definition natStarRig : StarRig :=
  {| A := nat; zero := 0; one := 1; add := Nat.add; mul := Nat.mul; adj := fun n => n;
     add_0_l := Nat.add_0_l; add_comm := Nat.add_comm; add_assoc := Nat.add_assoc;
     mul_1_l := Nat.mul_1_l; mul_1_r := Nat.mul_1_r; mul_assoc := Nat.mul_assoc;
     mul_add_l := Nat.mul_add_distr_l; mul_add_r := Nat.mul_add_distr_r;
     mul_0_l := Nat.mul_0_l; mul_0_r := Nat.mul_0_r;
     adj_invol := fun _ => eq_refl; adj_add := fun _ _ => eq_refl;
     adj_mul := Nat.mul_comm; adj_one := eq_refl |}.

(* the completeness relation is non-vacuous: a single projector P=1, U=1 *)
Example nat_resolution_complete :
  sumA natStarRig
    (map (fun p => mul natStarRig (adj natStarRig (mul natStarRig p 1))
                                  (mul natStarRig p 1)) (1 :: nil)) = 1.
Proof.
  apply (kraus_completeness natStarRig 1 (1 :: nil)).
  - reflexivity.
  - reflexivity.
  - intros p Hin; destruct Hin as [E|[]]; rewrite <- E; reflexivity.
Qed.

(* --------------------------------------------------------------------- *)
Print Assumptions kraus_completeness.
Print Assumptions adj_is_involution.
Print Assumptions natStarRig.
Print Assumptions nat_resolution_complete.
