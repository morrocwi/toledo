(* ===================================================================== *)
(*  RD.v  —  The Retained-Difference object system, machine-checked.      *)
(*  Object stratum of "The Roots of Mathematics and Geometry" (Book Zero).*)
(*                                                                        *)
(*  Axiom map: RD1 zero, RD2 succ, RD5 induction = Inductive D + elim;     *)
(*             RD3 succ<>zero, RD4 succ injective = theorems;              *)
(*             RD6,RD7 add ; RD8,RD9 mul = recursive definitions.          *)
(*                                                                        *)
(*  Machine-checked, axiom-free results:                                  *)
(*   (1) Peano successor axioms (RD3, RD4).                               *)
(*   (2) (D,add,mul,zero,one) is a COMMUTATIVE SEMIRING.                  *)
(*   (3) (D,le) is a TOTAL ORDER (refl, trans, antisym, totality) with    *)
(*       additive cancellation.                                           *)
(*   (4) toNat : D -> nat is a SEMIRING ISOMORPHISM D ~= nat              *)
(*       (bijection + add/mul homomorphism) and order isomorphism.        *)
(*   (5) INTERPRETATION HOMOMORPHISM for a deep-embedded arithmetic term  *)
(*       language Tm: D-evaluation and nat-evaluation agree under toNat,   *)
(*       giving EQUATIONAL TRANSFER between RD and the standard model of   *)
(*       Peano arithmetic (a verified core of the RD<->PA interpretation). *)
(* ===================================================================== *)

Require Import PeanoNat.
Require Import Wf_nat.
Require Import Lia.
Require Import ZArith.
Require Import QArith.
Require Import Field.
Require Import Qabs.
Require Import Qminmax.
Require Import Qround.
Require Import Coq.micromega.Lqa.
Open Scope nat_scope.

(* ---- RD1, RD2, RD5 ---- *)
Inductive D : Type :=
  | zero : D
  | succ : D -> D.

(* ---- RD3, RD4 ---- *)
Theorem RD3_succ_ne_zero : forall x : D, succ x <> zero.
Proof. intros x H. discriminate H. Qed.
Theorem RD4_succ_inj : forall x y : D, succ x = succ y -> x = y.
Proof. intros x y H. congruence. Qed.

(* ---- RD6, RD7 : addition ---- *)
Fixpoint add (x y : D) : D :=
  match y with zero => x | succ y' => succ (add x y') end.

Lemma add_zero : forall x, add x zero = x. Proof. reflexivity. Qed.
Lemma add_succ : forall x y, add x (succ y) = succ (add x y). Proof. reflexivity. Qed.
Lemma zero_add : forall x, add zero x = x.
Proof. induction x as [| x IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Lemma succ_add : forall x y, add (succ x) y = succ (add x y).
Proof. intros x y. induction y as [| y IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem add_assoc : forall x y z, add (add x y) z = add x (add y z).
Proof. intros x y z. induction z as [| z IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem add_comm : forall x y, add x y = add y x.
Proof. intros x y. induction y as [| y IH].
  - rewrite add_zero, zero_add. reflexivity.
  - rewrite add_succ, IH, succ_add. reflexivity. Qed.

(* ---- RD8, RD9 : multiplication ---- *)
Fixpoint mul (x y : D) : D :=
  match y with zero => zero | succ y' => add (mul x y') x end.

Lemma mul_zero : forall x, mul x zero = zero. Proof. reflexivity. Qed.
Lemma mul_succ : forall x y, mul x (succ y) = add (mul x y) x. Proof. reflexivity. Qed.
Lemma zero_mul : forall x, mul zero x = zero.
Proof. induction x as [| x IH]. - reflexivity. - rewrite mul_succ, IH, add_zero. reflexivity. Qed.
Theorem mul_add : forall x y z, mul x (add y z) = add (mul x y) (mul x z).
Proof. intros x y z. induction z as [| z IH].
  - rewrite add_zero, mul_zero, add_zero. reflexivity.
  - rewrite add_succ, mul_succ, IH, mul_succ, add_assoc. reflexivity. Qed.

(* ---- isomorphism D <-> nat ---- *)
Fixpoint toNat (x : D) : nat := match x with zero => O | succ x' => S (toNat x') end.
Fixpoint ofNat (n : nat) : D := match n with O => zero | S n' => succ (ofNat n') end.

Theorem iso_to_of : forall n, toNat (ofNat n) = n.
Proof. induction n as [| n IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem iso_of_to : forall x, ofNat (toNat x) = x.
Proof. induction x as [| x IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.

Theorem toNat_inj : forall x y, toNat x = toNat y -> x = y.
Proof. intros x y H. rewrite <- (iso_of_to x), <- (iso_of_to y), H. reflexivity. Qed.

Theorem toNat_add : forall x y, toNat (add x y) = toNat x + toNat y.
Proof. intros x y. induction y as [| y IH].
  - simpl. rewrite Nat.add_0_r. reflexivity.
  - simpl. rewrite IH, Nat.add_succ_r. reflexivity. Qed.
Theorem toNat_mul : forall x y, toNat (mul x y) = toNat x * toNat y.
Proof. intros x y. induction y as [| y IH].
  - simpl. rewrite Nat.mul_0_r. reflexivity.
  - simpl. rewrite toNat_add, IH, Nat.mul_succ_r. reflexivity. Qed.

(* ---- mul laws by transport along the verified isomorphism ---- *)
Theorem mul_comm : forall x y, mul x y = mul y x.
Proof. intros x y. rewrite <- (iso_of_to (mul x y)), <- (iso_of_to (mul y x)).
  rewrite !toNat_mul, (Nat.mul_comm (toNat x) (toNat y)). reflexivity. Qed.
Theorem mul_assoc : forall x y z, mul (mul x y) z = mul x (mul y z).
Proof. intros x y z. rewrite <- (iso_of_to (mul (mul x y) z)), <- (iso_of_to (mul x (mul y z))).
  rewrite !toNat_mul, (Nat.mul_assoc (toNat x) (toNat y) (toNat z)). reflexivity. Qed.

Definition one : D := succ zero.
Theorem mul_one : forall x, mul x one = x.
Proof. intro x. unfold one. rewrite mul_succ, mul_zero, zero_add. reflexivity. Qed.
Theorem one_mul : forall x, mul one x = x.
Proof. intro x. rewrite mul_comm. apply mul_one. Qed.
Theorem add_mul : forall x y z, mul (add x y) z = add (mul x z) (mul y z).
Proof. intros x y z. rewrite (mul_comm (add x y) z), mul_add, (mul_comm z x), (mul_comm z y). reflexivity. Qed.

(* ===================================================================== *)
(*  Order le, and proof that (D,le) is a TOTAL ORDER with cancellation.   *)
(* ===================================================================== *)
Definition le (x y : D) : Prop := exists z, add x z = y.

Theorem le_refl : forall x, le x x.
Proof. intro x. exists zero. apply add_zero. Qed.
Theorem le_trans : forall x y z, le x y -> le y z -> le x z.
Proof. intros x y z [a Ha] [b Hb]. exists (add a b).
  rewrite <- add_assoc, Ha, Hb. reflexivity. Qed.

Theorem le_toNat : forall x y, le x y -> toNat x <= toNat y.
Proof. intros x y [z Hz]. rewrite <- Hz, toNat_add. apply Nat.le_add_r. Qed.
Theorem toNat_le : forall x y, toNat x <= toNat y -> le x y.
Proof. intros x y H. exists (ofNat (toNat y - toNat x)). apply toNat_inj.
  rewrite toNat_add, iso_to_of, Nat.add_comm. apply Nat.sub_add. exact H. Qed.

Theorem le_antisym : forall x y, le x y -> le y x -> x = y.
Proof. intros x y Hxy Hyx. apply toNat_inj. apply Nat.le_antisymm.
  - apply le_toNat, Hxy. - apply le_toNat, Hyx. Qed.
Theorem le_total : forall x y, le x y \/ le y x.
Proof. intros x y. destruct (Nat.le_ge_cases (toNat x) (toNat y)) as [H | H].
  - left. apply toNat_le, H. - right. apply toNat_le, H. Qed.

Theorem add_cancel_r : forall x y z, add x z = add y z -> x = y.
Proof. intros x y z H. apply toNat_inj.
  apply (proj1 (Nat.add_cancel_r (toNat x) (toNat y) (toNat z))).
  rewrite <- !toNat_add, H. reflexivity. Qed.


(* ===================================================================== *)
(*  Strict order, WELL-ORDERING (well-foundedness / no infinite descent), *)
(*  and STRONG (course-of-values) INDUCTION -- cornerstones of the        *)
(*  natural-number foundation, obtained by transport along toNat.         *)
(* ===================================================================== *)
Definition lt (x y : D) : Prop := le (succ x) y.

Theorem lt_toNat : forall x y, lt x y <-> toNat x < toNat y.
Proof.
  intros x y. unfold lt. split.
  - intro H. apply le_toNat in H. simpl in H. exact H.
  - intro H. apply toNat_le. simpl. exact H.
Qed.

Theorem lt_irrefl : forall x, ~ lt x x.
Proof. intros x H. destruct (lt_toNat x x) as [f _]. exact (Nat.lt_irrefl _ (f H)). Qed.

Theorem lt_trans : forall x y z, lt x y -> lt y z -> lt x z.
Proof.
  intros x y z Hxy Hyz.
  destruct (lt_toNat x y) as [f1 _]. destruct (lt_toNat y z) as [f2 _].
  destruct (lt_toNat x z) as [_ g]. apply g. exact (Nat.lt_trans _ _ _ (f1 Hxy) (f2 Hyz)).
Qed.

Theorem lt_trichotomy : forall x y, lt x y \/ x = y \/ lt y x.
Proof.
  intros x y. destruct (Nat.lt_trichotomy (toNat x) (toNat y)) as [H | [H | H]].
  - left. destruct (lt_toNat x y) as [_ g]. apply g. exact H.
  - right. left. apply toNat_inj. exact H.
  - right. right. destruct (lt_toNat y x) as [_ g]. apply g. exact H.
Qed.

(* Well-ordering principle, well-foundedness form: there is NO infinite
   strictly descending chain  ... lt x2 x1, lt x1 x0. *)
Theorem lt_wf : well_founded lt.
Proof.
  apply (well_founded_lt_compat D toNat lt).
  intros x y H. destruct (lt_toNat x y) as [f _]. exact (f H).
Qed.

(* Strong (course-of-values) induction, derived from well-foundedness. *)
Theorem strong_induction :
  forall P : D -> Prop,
    (forall x, (forall y, lt y x -> P y) -> P x) -> forall x, P x.
Proof. intros P H. exact (well_founded_ind lt_wf P H). Qed.

(* ===================================================================== *)
(*  (5) INTERPRETATION HOMOMORPHISM (concrete core of the RD<->PA          *)
(*      interpretation): a deep-embedded arithmetic term language whose    *)
(*      D-evaluation and nat-evaluation agree under toNat, yielding        *)
(*      equational transfer between RD and the standard model of PA.       *)
(* ===================================================================== *)
Inductive Tm : Type :=
  | tvar  : nat -> Tm
  | tzero : Tm
  | tsucc : Tm -> Tm
  | tadd  : Tm -> Tm -> Tm
  | tmul  : Tm -> Tm -> Tm.

Fixpoint evD (env : nat -> D) (t : Tm) : D :=
  match t with
  | tvar v   => env v
  | tzero    => zero
  | tsucc t' => succ (evD env t')
  | tadd a b => add (evD env a) (evD env b)
  | tmul a b => mul (evD env a) (evD env b)
  end.

Fixpoint evN (env : nat -> nat) (t : Tm) : nat :=
  match t with
  | tvar v   => env v
  | tzero    => O
  | tsucc t' => S (evN env t')
  | tadd a b => evN env a + evN env b
  | tmul a b => evN env a * evN env b
  end.

Theorem eval_hom : forall (env : nat -> D) (t : Tm),
  toNat (evD env t) = evN (fun v => toNat (env v)) t.
Proof.
  intros env t.
  induction t as [v | | t' IH | a IHa b IHb | a IHa b IHb]; simpl.
  - reflexivity.
  - reflexivity.
  - rewrite IH. reflexivity.
  - rewrite toNat_add, IHa, IHb. reflexivity.
  - rewrite toNat_mul, IHa, IHb. reflexivity.
Qed.

Theorem eqn_transfer : forall (env : nat -> D) (s t : Tm),
  evN (fun v => toNat (env v)) s = evN (fun v => toNat (env v)) t ->
  evD env s = evD env t.
Proof.
  intros env s t H. apply toNat_inj.
  rewrite (eval_hom env s), (eval_hom env t). exact H.
Qed.

(* ---- Axiom audit (all must be: Closed under the global context) ---- *)

(* ===================================================================== *)
(*  FULL FIRST-ORDER INTERPRETATION (semantic level).                     *)
(*  A deep-embedded first-order language over arithmetic (connectives and *)
(*  QUANTIFIERS, de Bruijn variables) with satisfaction in both models D  *)
(*  and nat. Theorem sat_transfer proves that EVERY first-order formula    *)
(*  is satisfied in D iff in nat under toNat-related environments;         *)
(*  sentence_transfer specialises this to ELEMENTARY EQUIVALENCE  D == nat *)
(*  (same first-order truths). Axiom-free.  Note: the order atom Fle uses  *)
(*  D's intrinsic order  le. This is the SEMANTIC interpretation; a        *)
(*  syntactic Hilbert-style provability-predicate transfer is a separate   *)
(*  (larger) development and is NOT claimed here.                          *)
(* ===================================================================== *)

Inductive Fm :=
| Feq  : Tm -> Tm -> Fm
| Fle  : Tm -> Tm -> Fm
| Fand : Fm -> Fm -> Fm
| For  : Fm -> Fm -> Fm
| Fimp : Fm -> Fm -> Fm
| Fnot : Fm -> Fm
| Fall : Fm -> Fm        (* binds de Bruijn variable 0 *)
| Fex  : Fm -> Fm.

Definition consD (d:D)(e:nat->D):nat->D := fun n => match n with 0 => d | S k => e k end.
Definition consN (m:nat)(e:nat->nat):nat->nat := fun n => match n with 0 => m | S k => e k end.

Fixpoint satD (env:nat->D)(f:Fm){struct f}:Prop :=
 match f with
 | Feq a b => evD env a = evD env b
 | Fle a b => le (evD env a) (evD env b)
 | Fand p q => satD env p /\ satD env q
 | For p q  => satD env p \/ satD env q
 | Fimp p q => satD env p -> satD env q
 | Fnot p   => ~ satD env p
 | Fall p   => forall d:D, satD (consD d env) p
 | Fex p    => exists d:D, satD (consD d env) p
 end.

Fixpoint satN (env:nat->nat)(f:Fm){struct f}:Prop :=
 match f with
 | Feq a b => evN env a = evN env b
 | Fle a b => evN env a <= evN env b
 | Fand p q => satN env p /\ satN env q
 | For p q  => satN env p \/ satN env q
 | Fimp p q => satN env p -> satN env q
 | Fnot p   => ~ satN env p
 | Fall p   => forall m:nat, satN (consN m env) p
 | Fex p    => exists m:nat, satN (consN m env) p
 end.

Lemma evN_ext : forall t e1 e2, (forall v, e1 v = e2 v) -> evN e1 t = evN e2 t.
Proof.
  induction t as [v| |a IH|a IHa b IHb|a IHa b IHb]; intros e1 e2 H; simpl.
  - apply H.
  - reflexivity.
  - rewrite (IH e1 e2 H); reflexivity.
  - rewrite (IHa e1 e2 H),(IHb e1 e2 H); reflexivity.
  - rewrite (IHa e1 e2 H),(IHb e1 e2 H); reflexivity.
Qed.

Lemma evD_evN : forall a envD envN,
  (forall v, toNat (envD v) = envN v) -> toNat (evD envD a) = evN envN a.
Proof. intros a envD envN H. rewrite eval_hom. apply evN_ext. intro v. apply H. Qed.

(* satisfaction transfers across the isomorphism for ALL first-order
   formulas (quantifiers included). *)
Theorem sat_transfer : forall f envD envN,
  (forall v, toNat (envD v) = envN v) -> (satD envD f <-> satN envN f).
Proof.
  induction f as [a b|a b|p IHp q IHq|p IHp q IHq|p IHp q IHq|p IHp|p IHp|p IHp];
    intros envD envN Hrel; simpl.
  - split.
    + intro H. apply f_equal with (f:=toNat) in H.
      rewrite (evD_evN a envD envN Hrel),(evD_evN b envD envN Hrel) in H. exact H.
    + intro H. apply toNat_inj.
      rewrite (evD_evN a envD envN Hrel),(evD_evN b envD envN Hrel). exact H.
  - split.
    + intro H. apply le_toNat in H.
      rewrite (evD_evN a envD envN Hrel),(evD_evN b envD envN Hrel) in H. exact H.
    + intro H. apply toNat_le.
      rewrite (evD_evN a envD envN Hrel),(evD_evN b envD envN Hrel). exact H.
  - rewrite (IHp envD envN Hrel),(IHq envD envN Hrel). reflexivity.
  - rewrite (IHp envD envN Hrel),(IHq envD envN Hrel). reflexivity.
  - rewrite (IHp envD envN Hrel),(IHq envD envN Hrel). reflexivity.
  - rewrite (IHp envD envN Hrel). reflexivity.
  - split.
    + intros H m. apply (IHp (consD (ofNat m) envD) (consN m envN)).
      * intro v. destruct v as [|k]; simpl. rewrite iso_to_of; reflexivity. apply Hrel.
      * apply H.
    + intros H d. apply (IHp (consD d envD) (consN (toNat d) envN)).
      * intro v. destruct v as [|k]; simpl. reflexivity. apply Hrel.
      * apply H.
  - split.
    + intros [d H]. exists (toNat d).
      apply (IHp (consD d envD) (consN (toNat d) envN)).
      * intro v. destruct v as [|k]; simpl. reflexivity. apply Hrel.
      * exact H.
    + intros [m H]. exists (ofNat m).
      apply (IHp (consD (ofNat m) envD) (consN m envN)).
      * intro v. destruct v as [|k]; simpl. rewrite iso_to_of; reflexivity. apply Hrel.
      * exact H.
Qed.

(* Elementary equivalence: D and the standard model nat satisfy exactly the
   same first-order formulas (in particular, the same sentences). *)
Definition env0D : nat -> D   := fun _ => zero.
Definition env0N : nat -> nat := fun _ => O.
Theorem sentence_transfer : forall f, satD env0D f <-> satN env0N f.
Proof. intro f. apply sat_transfer. intro v. reflexivity. Qed.



(* ===================================================================== *)
(*  SYNTACTIC LAYER: de Bruijn substitution lemma, a Hilbert-style first- *)
(*  order proof system, SOUNDNESS, and CONSISTENCY-from-a-model.          *)
(*  satD_subst is the capture-correct substitution lemma; soundness shows  *)
(*  the calculus is sound w.r.t. the D-semantics (axioms assumed closed,   *)
(*  i.e. env-independent, which validates generalisation); consistency     *)
(*  then follows from D being a model. prov_sound_N transports every       *)
(*  provable theorem to the standard model nat via sentence_transfer.      *)
(*  Axiom-free; no classical logic, no functional extensionality.          *)
(* ===================================================================== *)

(* de Bruijn shifting and parallel substitution *)
Fixpoint shift_tm (t:Tm):Tm :=
 match t with tvar v=>tvar (S v)|tzero=>tzero|tsucc a=>tsucc (shift_tm a)
 |tadd a b=>tadd (shift_tm a)(shift_tm b)|tmul a b=>tmul (shift_tm a)(shift_tm b) end.
Fixpoint subst_tm (s:nat->Tm)(t:Tm):Tm :=
 match t with tvar v=>s v|tzero=>tzero|tsucc a=>tsucc (subst_tm s a)
 |tadd a b=>tadd (subst_tm s a)(subst_tm s b)|tmul a b=>tmul (subst_tm s a)(subst_tm s b) end.
Definition up (s:nat->Tm):nat->Tm := fun n=>match n with 0=>tvar 0|S k=>shift_tm (s k) end.
Fixpoint subst_fm (s:nat->Tm)(f:Fm):Fm :=
 match f with
 | Feq a b=>Feq (subst_tm s a)(subst_tm s b) | Fle a b=>Fle (subst_tm s a)(subst_tm s b)
 | Fand p q=>Fand (subst_fm s p)(subst_fm s q) | For p q=>For (subst_fm s p)(subst_fm s q)
 | Fimp p q=>Fimp (subst_fm s p)(subst_fm s q) | Fnot p=>Fnot (subst_fm s p)
 | Fall p=>Fall (subst_fm (up s) p) | Fex p=>Fex (subst_fm (up s) p) end.

Lemma evD_ext: forall t e1 e2, (forall v, e1 v=e2 v)-> evD e1 t=evD e2 t.
Proof. induction t as [v| |a IH|a IHa b IHb|a IHa b IHb]; intros e1 e2 H; simpl.
 - apply H. - reflexivity. - rewrite (IH e1 e2 H); reflexivity.
 - rewrite (IHa e1 e2 H),(IHb e1 e2 H); reflexivity.
 - rewrite (IHa e1 e2 H),(IHb e1 e2 H); reflexivity. Qed.

Lemma evD_shift: forall t d env, evD (consD d env)(shift_tm t)= evD env t.
Proof. induction t as [v| |a IH|a IHa b IHb|a IHa b IHb]; intros d env; simpl.
 - reflexivity. - reflexivity. - rewrite IH; reflexivity.
 - rewrite IHa, IHb; reflexivity. - rewrite IHa, IHb; reflexivity. Qed.

Lemma evD_subst: forall t s env, evD env (subst_tm s t)= evD (fun v=>evD env (s v)) t.
Proof. induction t as [v| |a IH|a IHa b IHb|a IHa b IHb]; intros s env; simpl.
 - reflexivity. - reflexivity. - rewrite IH; reflexivity.
 - rewrite IHa, IHb; reflexivity. - rewrite IHa, IHb; reflexivity. Qed.

Lemma satD_ext: forall f e1 e2, (forall v, e1 v=e2 v)-> (satD e1 f <-> satD e2 f).
Proof.
 induction f as [a b|a b|p IHp q IHq|p IHp q IHq|p IHp q IHq|p IHp|p IHp|p IHp];
   intros e1 e2 H; simpl.
 - rewrite (evD_ext a e1 e2 H),(evD_ext b e1 e2 H); reflexivity.
 - rewrite (evD_ext a e1 e2 H),(evD_ext b e1 e2 H); reflexivity.
 - rewrite (IHp e1 e2 H),(IHq e1 e2 H); reflexivity.
 - rewrite (IHp e1 e2 H),(IHq e1 e2 H); reflexivity.
 - rewrite (IHp e1 e2 H),(IHq e1 e2 H); reflexivity.
 - rewrite (IHp e1 e2 H); reflexivity.
 - split; intros K d; [ apply (IHp (consD d e1)(consD d e2)) | apply (IHp (consD d e2)(consD d e1)) ];
     try (intro v; destruct v as [|k]; simpl; [reflexivity| (rewrite H; reflexivity) || (rewrite <- H; reflexivity)]);
     [ apply K | apply K ].
 - split; intros [d K]; exists d;
     [ apply (IHp (consD d e1)(consD d e2)) | apply (IHp (consD d e2)(consD d e1)) ];
     try (intro v; destruct v as [|k]; simpl; [reflexivity| (rewrite H; reflexivity) || (rewrite <- H; reflexivity)]);
     [ exact K | exact K ].
Qed.

(* THE SUBSTITUTION LEMMA *)
Lemma satD_subst: forall f s env, satD env (subst_fm s f) <-> satD (fun v=>evD env (s v)) f.
Proof.
 induction f as [a b|a b|p IHp q IHq|p IHp q IHq|p IHp q IHq|p IHp|p IHp|p IHp];
   intros s env; simpl.
 - rewrite (evD_subst a s env),(evD_subst b s env); reflexivity.
 - rewrite (evD_subst a s env),(evD_subst b s env); reflexivity.
 - rewrite (IHp s env),(IHq s env); reflexivity.
 - rewrite (IHp s env),(IHq s env); reflexivity.
 - rewrite (IHp s env),(IHq s env); reflexivity.
 - rewrite (IHp s env); reflexivity.
 - (* Fall *) split.
   + intros H d.
     pose proof (proj1 (IHp (up s) (consD d env)) (H d)) as H1.
     apply (proj1 (satD_ext p (fun v=>evD (consD d env)(up s v))
                              (consD d (fun v=>evD env (s v)))
                   (fun v => match v with 0=>eq_refl | S k=>evD_shift (s k) d env end))).
     exact H1.
   + intros H d.
     apply (proj2 (IHp (up s) (consD d env))).
     apply (proj1 (satD_ext p (consD d (fun v=>evD env (s v)))
                              (fun v=>evD (consD d env)(up s v))
                   (fun v => match v with 0=>eq_refl | S k=>eq_sym (evD_shift (s k) d env) end))).
     exact (H d).
 - (* Fex *) split.
   + intros [d H]. exists d.
     pose proof (proj1 (IHp (up s) (consD d env)) H) as H1.
     apply (proj1 (satD_ext p (fun v=>evD (consD d env)(up s v))
                              (consD d (fun v=>evD env (s v)))
                   (fun v => match v with 0=>eq_refl | S k=>evD_shift (s k) d env end))).
     exact H1.
   + intros [d H]. exists d.
     apply (proj2 (IHp (up s) (consD d env))).
     apply (proj1 (satD_ext p (consD d (fun v=>evD env (s v)))
                              (fun v=>evD (consD d env)(up s v))
                   (fun v => match v with 0=>eq_refl | S k=>eq_sym (evD_shift (s k) d env) end))).
     exact H.
Qed.




(* single-variable instantiation substitution  (0 := t, identity elsewhere) *)
Definition scons (t:Tm)(s:nat->Tm):nat->Tm := fun n=>match n with 0=>t|S k=>s k end.

(* canonical false sentence *)
Definition Fbot : Fm := Fnot (Feq tzero tzero).

(* ---- a Hilbert-style first-order proof system (intuitionistic core) ---- *)
Inductive Prov (T:Fm->Prop) : Fm -> Prop :=
| P_ax  : forall f, T f -> Prov T f
| P_mp  : forall p q, Prov T (Fimp p q) -> Prov T p -> Prov T q
| P_K   : forall p q, Prov T (Fimp p (Fimp q p))
| P_S   : forall p q r, Prov T (Fimp (Fimp p (Fimp q r)) (Fimp (Fimp p q) (Fimp p r)))
| P_refl: forall t, Prov T (Feq t t)
| P_notE: forall p q, Prov T (Fimp (Fnot p) (Fimp p q))
| P_allE: forall p t, Prov T (Fall p) -> Prov T (subst_fm (scons t tvar) p)
| P_exI : forall p t, Prov T (subst_fm (scons t tvar) p) -> Prov T (Fex p)
| P_gen : forall p, Prov T p -> Prov T (Fall p).

(* SOUNDNESS w.r.t. the D-semantics. Hypothesis Hclosed: the non-logical
   axioms are env-independent (closed / sentences), which makes the
   generalization rule sound without free-variable bookkeeping. *)
Theorem soundness:
  forall (T:Fm->Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    forall f, Prov T f ->
    forall env, (forall a, T a -> satD env a) -> satD env f.
Proof.
  intros T Hclosed f Hp.
  induction Hp as
    [g Hg | p q Hpq IHpq Hp2 IHp2 | p q | p q r | t | p q
    | p t Hall IHall | p t Hsub IHsub | p Hgen IHgen ];
    intros env Henv; simpl in *.
  - apply Henv; exact Hg.
  - exact (IHpq env Henv (IHp2 env Henv)).
  - intros H1 H2; exact H1.
  - intros H1 H2 H3; apply H1; [exact H3 | apply H2; exact H3].
  - reflexivity.
  - intros H1 H2; destruct (H1 H2).
  - (* allE : uses satD_subst + satD_ext *)
    apply (proj2 (satD_subst p (scons t tvar) env)).
    apply (proj1 (satD_ext p (consD (evD env t) env)
                            (fun v=>evD env (scons t tvar v))
                  (fun v => match v with 0=>eq_refl | S k=>eq_refl end))).
    exact (IHall env Henv (evD env t)).
  - (* exI : uses satD_subst + satD_ext *)
    specialize (IHsub env Henv).
    apply (proj1 (satD_subst p (scons t tvar) env)) in IHsub.
    apply (proj1 (satD_ext p (fun v=>evD env (scons t tvar v))
                            (consD (evD env t) env)
                  (fun v => match v with 0=>eq_refl | S k=>eq_refl end))) in IHsub.
    exists (evD env t); exact IHsub.
  - (* gen : uses Hclosed *)
    intro d. apply (IHgen (consD d env)). intros a Ha.
    apply (proj1 (Hclosed a env (consD d env) Ha)). exact (Henv a Ha).
Qed.

(* Consistency: a theory with a D-model proves no falsehood. *)
Theorem consistency:
  forall (T:Fm->Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    (exists env, forall a, T a -> satD env a) ->
    ~ Prov T Fbot.
Proof.
  intros T Hclosed [env Henv] Hpr.
  pose proof (soundness T Hclosed Fbot Hpr env Henv) as Hb.
  simpl in Hb. apply Hb. reflexivity.
Qed.

Corollary prov_sound_N:
  forall (T:Fm->Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    forall f, Prov T f ->
    (forall a, T a -> satD env0D a) -> satN env0N f.
Proof.
  intros T Hc f Hp Hmod. apply sentence_transfer.
  exact (soundness T Hc f Hp env0D Hmod).
Qed.


(* ===================================================================== *)
(*  D IS A MODEL OF FIRST-ORDER PEANO ARITHMETIC.                          *)
(*  D_validates_induction proves D satisfies every first-order INDUCTION   *)
(*  instance (all formulas, all environments); together with the finite    *)
(*  Peano axioms (written as explicit embedded sentences) this gives        *)
(*  D_models_PA : D |= PA. Because induction is valid under every env, PA   *)
(*  is env-independent up to <-> (PA_closed), so the verified consistency   *)
(*  theorem applies and yields Con_PA : ~ Prov PA Fbot -- CONSISTENCY OF    *)
(*  PA witnessed by the RD model. PA_true_in_N transports D |= PA to the    *)
(*  standard model nat. Axiom-free.                                         *)
(* ===================================================================== *)

(* de Bruijn substitutions for the induction axiom *)
Definition tau_step : nat -> Tm := fun n => match n with 0 => tsucc (tvar 0) | S k => tvar (S k) end.
Definition ax_base (phi:Fm) : Fm := subst_fm (scons tzero tvar) phi.
Definition ax_step (phi:Fm) : Fm := subst_fm tau_step phi.
Definition IndAx (phi:Fm) : Fm :=
  Fimp (ax_base phi) (Fimp (Fall (Fimp phi (ax_step phi))) (Fall phi)).

Theorem D_validates_induction : forall phi env, satD env (IndAx phi).
Proof.
  intros phi env. unfold IndAx, ax_base, ax_step; simpl.
  intro Hbase. intro Hstep.
  apply (proj1 (satD_subst phi (scons tzero tvar) env)) in Hbase.
  apply (proj1 (satD_ext phi (fun v=>evD env (scons tzero tvar v)) (consD zero env)
                (fun v => match v with 0=>eq_refl | S k=>eq_refl end))) in Hbase.
  intro d. induction d as [|d IHd].
  - exact Hbase.
  - specialize (Hstep d IHd).
    apply (proj1 (satD_subst phi tau_step (consD d env))) in Hstep.
    apply (proj1 (satD_ext phi (fun v=>evD (consD d env)(tau_step v)) (consD (succ d) env)
                  (fun v => match v with 0=>eq_refl | S k=>eq_refl end))) in Hstep.
    exact Hstep.
Qed.

(* finite Peano axioms as embedded sentences *)
Definition A_snz : Fm := Fall (Fnot (Feq (tsucc (tvar 0)) tzero)).
Definition A_sinj: Fm := Fall (Fall (Fimp (Feq (tsucc (tvar 1)) (tsucc (tvar 0))) (Feq (tvar 1) (tvar 0)))).
Definition A_add0: Fm := Fall (Feq (tadd (tvar 0) tzero) (tvar 0)).
Definition A_addS: Fm := Fall (Fall (Feq (tadd (tvar 1) (tsucc (tvar 0))) (tsucc (tadd (tvar 1) (tvar 0))))).
Definition A_mul0: Fm := Fall (Feq (tmul (tvar 0) tzero) tzero).
Definition A_mulS: Fm := Fall (Fall (Feq (tmul (tvar 1) (tsucc (tvar 0))) (tadd (tmul (tvar 1) (tvar 0)) (tvar 1)))).

Inductive PA : Fm -> Prop :=
| PA_snz  : PA A_snz
| PA_sinj : PA A_sinj
| PA_add0 : PA A_add0
| PA_addS : PA A_addS
| PA_mul0 : PA A_mul0
| PA_mulS : PA A_mulS
| PA_Ind  : forall phi, PA (IndAx phi).

Theorem D_models_PA : forall env a, PA a -> satD env a.
Proof.
  intros env a H; destruct H; simpl.
  - intros d K; discriminate K.
  - intros d1 d0 K; exact (RD4_succ_inj _ _ K).
  - intro d; reflexivity.
  - intros d1 d0; reflexivity.
  - intro d; reflexivity.
  - intros d1 d0; reflexivity.
  - apply D_validates_induction.
Qed.

Theorem PA_closed : forall a e1 e2, PA a -> (satD e1 a <-> satD e2 a).
Proof.
  intros a e1 e2 H; destruct H; simpl.
  - tauto.
  - tauto.
  - tauto.
  - tauto.
  - tauto.
  - tauto.
  - split; intro K; apply D_validates_induction.
Qed.

(* CONSISTENCY OF PA, witnessed by the RD model D *)
Theorem Con_PA : ~ Prov PA Fbot.
Proof.
  apply (consistency PA PA_closed).
  exists (fun _ => zero). intros a Ha. exact (D_models_PA (fun _ => zero) a Ha).
Qed.

(* the standard model nat also satisfies PA, via elementary equivalence *)
Corollary PA_true_in_N : forall a, PA a -> satN env0N a.
Proof. intros a Ha. apply sentence_transfer. exact (D_models_PA env0D a Ha). Qed.



(* ===================================================================== *)
(*  SECOND-ORDER CATEGORICITY (Dedekind's theorem).                       *)
(*  Any structure (M, zM, sM) satisfying the SECOND-ORDER Peano axioms     *)
(*  (sM injective, zM not a successor, and induction over ALL predicates)  *)
(*  is isomorphic to the object stratum D: the canonical embedding emb is  *)
(*  a structure-preserving bijection. Hence full (second-order) induction  *)
(*  pins D down uniquely -- there are NO non-standard second-order models. *)
(*  Axiom-free. (First-order PA still has non-standard models, by          *)
(*  Loewenheim-Skolem; that is a feature of first-order logic, not a gap.) *)
(* ===================================================================== *)
Section Categoricity.
  Variable M : Type.
  Variable zM : M.
  Variable sM : M -> M.
  Hypothesis sM_inj  : forall x y, sM x = sM y -> x = y.
  Hypothesis sM_ne_z : forall x, sM x <> zM.
  Hypothesis M_ind   : forall (P:M->Prop), P zM -> (forall x, P x -> P (sM x)) -> forall x, P x.

  Fixpoint emb (n:D) : M := match n with zero => zM | succ n' => sM (emb n') end.

  Lemma emb_surj : forall m, exists n, emb n = m.
  Proof.
    apply (M_ind (fun m => exists n, emb n = m)).
    - exists zero. reflexivity.
    - intros x [n Hn]. exists (succ n). simpl. rewrite Hn. reflexivity.
  Qed.

  Lemma emb_inj : forall n1 n2, emb n1 = emb n2 -> n1 = n2.
  Proof.
    intros n1 n2; revert n2; induction n1 as [|n1 IH]; intros [|n2] H; simpl in H.
    - reflexivity.
    - exfalso; symmetry in H; exact (sM_ne_z _ H).
    - exfalso; exact (sM_ne_z _ H).
    - f_equal; apply IH; apply sM_inj; exact H.
  Qed.

  Theorem categoricity :
    (emb zero = zM)
    /\ (forall n, emb (succ n) = sM (emb n))
    /\ (forall n1 n2, emb n1 = emb n2 -> n1 = n2)
    /\ (forall m, exists n, emb n = m).
  Proof.
    repeat split.
    - intros n1 n2 H. apply emb_inj. exact H.
    - apply emb_surj.
  Qed.
End Categoricity.


(* ===================================================================== *)
(*  GEOMETRY FROM THE DISCRETE ROOT (machine-checked core).               *)
(*  Distance is a readout of the retained-difference ledger: dist x y is   *)
(*  the absolute gap between the retained counts. We prove the full        *)
(*  METRIC-SPACE axioms, a Tarski-style BETWEENNESS relation with its      *)
(*  identity/symmetry axioms, and the L1 (taxicab) PRODUCT METRIC giving    *)
(*  2-D discrete geometry (iterating to any finite dimension). Axiom-free.  *)
(*  (This is the metric/affine CORE; continuum geometry -- manifolds,       *)
(*  curvature, real-analytic structure -- lives in the analytic stratum     *)
(*  and is imported, not reconstructed here.)                              *)
(* ===================================================================== *)
Definition dist (x y:D) : nat := (toNat x - toNat y) + (toNat y - toNat x).

Theorem dist_self : forall x, dist x x = 0.
Proof. intro x; unfold dist; lia. Qed.
Theorem dist_eq0  : forall x y, dist x y = 0 -> x = y.
Proof. intros x y H; apply toNat_inj; unfold dist in H; lia. Qed.
Theorem dist_pos  : forall x y, x <> y -> 0 < dist x y.
Proof. intros x y H; unfold dist; assert (toNat x <> toNat y) by (intro K; apply H, toNat_inj, K); lia. Qed.
Theorem dist_sym  : forall x y, dist x y = dist y x.
Proof. intros x y; unfold dist; lia. Qed.
Theorem dist_tri  : forall x y z, dist x z <= dist x y + dist y z.
Proof. intros x y z; unfold dist; lia. Qed.

Definition Betw (x y z:D) : Prop := dist x y + dist y z = dist x z.
Theorem Betw_id     : forall x y, Betw x y x -> x = y.
Proof. intros x y H; apply dist_eq0; unfold Betw in H; rewrite (dist_self x) in H; lia. Qed.
Theorem Betw_sym    : forall x y z, Betw x y z -> Betw z y x.
Proof. intros x y z H; unfold Betw in *.
  rewrite (dist_sym z y), (dist_sym y x), (dist_sym z x); lia. Qed.
Theorem Betw_refl_l : forall x z, Betw x x z.
Proof. intros x z; unfold Betw; rewrite (dist_self x); lia. Qed.

Definition dist2 (p q : D*D) : nat := dist (fst p)(fst q) + dist (snd p)(snd q).
Theorem dist2_self : forall p, dist2 p p = 0.
Proof. intros [a b]; unfold dist2; simpl; rewrite !dist_self; reflexivity. Qed.
Theorem dist2_eq0  : forall p q, dist2 p q = 0 -> p = q.
Proof. intros [a b][c d] H; unfold dist2 in H; simpl in H.
  assert (dist a c = 0) by lia. assert (dist b d = 0) by lia.
  rewrite (dist_eq0 a c), (dist_eq0 b d); auto. Qed.
Theorem dist2_sym  : forall p q, dist2 p q = dist2 q p.
Proof. intros [a b][c d]; unfold dist2; simpl; rewrite (dist_sym a c),(dist_sym b d); reflexivity. Qed.
Theorem dist2_tri  : forall p q r, dist2 p r <= dist2 p q + dist2 q r.
Proof. intros [a b][c d][e f]; unfold dist2; simpl.
  pose proof (dist_tri a c e); pose proof (dist_tri b d f); lia. Qed.



(* ===================================================================== *)
(*  ALGEBRA: the integer RING Z, built from the discrete root D, and       *)
(*  DISCRETE CALCULUS over Z-valued sequences.                             *)
(*  Z is the Grothendieck completion of (D,+): a pair (a,b) denotes a-b.    *)
(*  We prove Z is a COMMUTATIVE RING up to the relation zeq (additive       *)
(*  inverse zneg upgrades the semiring D to a ring), exhibiting the value   *)
(*  homomorphism zval : Zr -> standard-integers with zeq z w <-> zval z =   *)
(*  zval w. Then the DIFFERENCE operator Delta and SUM operator Sum satisfy  *)
(*  the DISCRETE FUNDAMENTAL THEOREM OF CALCULUS (FTC, telescoping) in both  *)
(*  directions, and the discrete LEIBNIZ product rule. This is the          *)
(*  machine-checked CORE of PART II (calculus from retained difference);    *)
(*  it needs no real numbers. Axiom-free.                                   *)
(* ===================================================================== *)

(* ===== Z as the Grothendieck completion of (D,+):  (a,b) represents a-b ===== *)
Definition Zr := (D * D)%type.
Definition zeq (z w:Zr) : Prop :=
  toNat (fst z) + toNat (snd w) = toNat (snd z) + toNat (fst w).
Definition z0 : Zr := (zero, zero).
Definition z1 : Zr := (succ zero, zero).
Definition zadd (z w:Zr) : Zr := (add (fst z)(fst w), add (snd z)(snd w)).
Definition zneg (z:Zr) : Zr := (snd z, fst z).
Definition zmul (z w:Zr) : Zr :=
  (add (mul (fst z)(fst w)) (mul (snd z)(snd w)),
   add (mul (fst z)(snd w)) (mul (snd z)(fst w))).
Definition zsub (z w:Zr) : Zr := zadd z (zneg w).

(* value homomorphism into the standard integers: proves Zr/zeq ~= Z (a ring) *)
Definition zval (z:Zr) : Z := (Z.of_nat (toNat (fst z)) - Z.of_nat (toNat (snd z)))%Z.

Lemma zeq_zval : forall z w, zeq z w <-> zval z = zval w.
Proof.
  intros z w; unfold zeq, zval; split; intro H.
  - assert (Z.of_nat (toNat (fst z) + toNat (snd w)) = Z.of_nat (toNat (snd z) + toNat (fst w))) by (rewrite H; reflexivity).
    rewrite !Nat2Z.inj_add in *; lia.
  - apply Nat2Z.inj; rewrite !Nat2Z.inj_add; lia.
Qed.
Lemma zval_z0 : zval z0 = 0%Z. Proof. reflexivity. Qed.
Lemma zval_z1 : zval z1 = 1%Z. Proof. reflexivity. Qed.
Lemma zval_add : forall z w, zval (zadd z w) = (zval z + zval w)%Z.
Proof. intros z w; unfold zval, zadd; simpl; rewrite !toNat_add, !Nat2Z.inj_add; lia. Qed.
Lemma zval_neg : forall z, zval (zneg z) = (- zval z)%Z.
Proof. intros z; unfold zval, zneg; simpl; lia. Qed.
Lemma zval_mul : forall z w, zval (zmul z w) = (zval z * zval w)%Z.
Proof. intros z w; unfold zval, zmul; simpl; rewrite !toNat_add, !toNat_mul, !Nat2Z.inj_add, !Nat2Z.inj_mul; ring. Qed.

Ltac zE := apply (proj2 (zeq_zval _ _));
  repeat (rewrite zval_add || rewrite zval_mul || rewrite zval_neg || rewrite zval_z0 || rewrite zval_z1).

(* equivalence *)
Theorem zeq_refl : forall z, zeq z z. Proof. intro z; apply zeq_zval; reflexivity. Qed.
Theorem zeq_sym  : forall z w, zeq z w -> zeq w z. Proof. intros z w; rewrite !zeq_zval; intro H; symmetry; exact H. Qed.
Theorem zeq_trans: forall z w u, zeq z w -> zeq w u -> zeq z u. Proof. intros z w u; rewrite !zeq_zval; intros H1 H2; rewrite H1; exact H2. Qed.

(* congruences *)
Theorem zadd_cong: forall z z' w w', zeq z z' -> zeq w w' -> zeq (zadd z w)(zadd z' w').
Proof. intros z z' w w'; rewrite !zeq_zval; intros H1 H2; rewrite !zval_add, H1, H2; reflexivity. Qed.
Theorem zneg_cong: forall z z', zeq z z' -> zeq (zneg z)(zneg z').
Proof. intros z z'; rewrite !zeq_zval; intro H; rewrite !zval_neg, H; reflexivity. Qed.
Theorem zmul_cong: forall z z' w w', zeq z z' -> zeq w w' -> zeq (zmul z w)(zmul z' w').
Proof. intros z z' w w'; rewrite !zeq_zval; intros H1 H2; rewrite !zval_mul, H1, H2; reflexivity. Qed.

(* commutative RING axioms (up to zeq) *)
Theorem zadd_comm : forall z w, zeq (zadd z w)(zadd w z). Proof. intros; zE; ring. Qed.
Theorem zadd_assoc: forall z w u, zeq (zadd (zadd z w) u)(zadd z (zadd w u)). Proof. intros; zE; ring. Qed.
Theorem zadd_0_l  : forall z, zeq (zadd z0 z) z. Proof. intros; zE; ring. Qed.
Theorem zadd_neg  : forall z, zeq (zadd z (zneg z)) z0. Proof. intros; zE; ring. Qed.
Theorem zmul_comm : forall z w, zeq (zmul z w)(zmul w z). Proof. intros; zE; ring. Qed.
Theorem zmul_assoc: forall z w u, zeq (zmul (zmul z w) u)(zmul z (zmul w u)). Proof. intros; zE; ring. Qed.
Theorem zmul_1_l  : forall z, zeq (zmul z1 z) z. Proof. intros; zE; ring. Qed.
Theorem zmul_distrib_l : forall z w u, zeq (zmul z (zadd w u)) (zadd (zmul z w)(zmul z u)).
Proof. intros; zE; ring. Qed.







(* ===== DISCRETE CALCULUS over Z-valued sequences  f : D -> Zr ===== *)
Definition Delta (f:D->Zr)(n:D) : Zr := zsub (f (succ n)) (f n).
Fixpoint Sum (f:D->Zr)(n:D) : Zr :=
  match n with zero => z0 | succ n' => zadd (Sum f n') (f n') end.

Lemma Sum_zero : forall f, Sum f zero = z0. Proof. reflexivity. Qed.
Lemma Sum_succ : forall f n, Sum f (succ n) = zadd (Sum f n) (f n). Proof. reflexivity. Qed.
Lemma zval_sub : forall z w, zval (zsub z w) = (zval z - zval w)%Z.
Proof. intros z w; unfold zsub; rewrite zval_add, zval_neg; ring. Qed.
Lemma zval_Delta : forall f n, zval (Delta f n) = (zval (f (succ n)) - zval (f n))%Z.
Proof. intros f n; unfold Delta; apply zval_sub. Qed.

(* DISCRETE FUNDAMENTAL THEOREM OF CALCULUS (telescoping):
   sum of the differences of f from 0 to n-1 equals f(n) - f(0). *)
Lemma FTC_Z : forall f n, zval (Sum (Delta f) n) = (zval (f n) - zval (f zero))%Z.
Proof.
  intros f n; induction n as [|n IH].
  - rewrite Sum_zero, zval_z0; ring.
  - rewrite (Sum_succ (Delta f) n), zval_add, IH, zval_Delta; ring.
Qed.
Theorem FTC : forall f n, zeq (Sum (Delta f) n) (zsub (f n) (f zero)).
Proof. intros f n; apply (proj2 (zeq_zval _ _)); rewrite FTC_Z, zval_sub; reflexivity. Qed.

(* reverse direction: the difference of the running sum recovers f *)
Theorem FTC_inverse : forall f n, zeq (Delta (Sum f) n) (f n).
Proof.
  intros f n; apply (proj2 (zeq_zval _ _)); unfold Delta;
  rewrite zval_sub, (Sum_succ f n), zval_add; ring.
Qed.

(* discrete LEIBNIZ (product) rule *)
Theorem Leibniz :
  forall f g n,
    zeq (Delta (fun k => zmul (f k) (g k)) n)
        (zadd (zmul (f (succ n)) (Delta g n)) (zmul (Delta f n) (g n))).
Proof.
  intros f g n; apply (proj2 (zeq_zval _ _)).
  rewrite (zval_Delta (fun k => zmul (f k) (g k)) n).
  rewrite !zval_mul. rewrite zval_add, !zval_mul, !zval_Delta. ring.
Qed.



(* ===================================================================== *)
(*  ALGEBRA, cont'd: the rational FIELD Q, built from the integer ring Z.  *)
(*  Q is the field of fractions of Z: a pair (p,q) with q<>0 denotes p/q.   *)
(*  We prove the full commutative-FIELD axioms up to the relation qeq,      *)
(*  including the MULTIPLICATIVE INVERSE qmul_inv (which upgrades the ring   *)
(*  Z to a field), via a value homomorphism qval into Coq's standard         *)
(*  rationals. This completes the ladder D -> Z -> Q at the algebraic level;  *)
(*  the real line R (Cauchy completion of Q) is the next, larger step.       *)
(*  Axiom-free.                                                             *)
(* ===================================================================== *)
Open Scope Z_scope.

(* ===== Q from Z: pair (p,q) with q<>0 represents p/q (field of fractions) ===== *)
Definition Qf := (Z * Z)%type.
Definition qok (x:Qf) : Prop := snd x <> 0.
Definition q0 : Qf := (0, 1).
Definition q1 : Qf := (1, 1).
Definition qadd (x y:Qf) : Qf := (fst x * snd y + fst y * snd x, snd x * snd y).
Definition qmul (x y:Qf) : Qf := (fst x * fst y, snd x * snd y).
Definition qneg (x:Qf) : Qf := (- fst x, snd x).
Definition qinv (x:Qf) : Qf := (snd x, fst x).

Definition qval (x:Qf) : Q := inject_Z (fst x) / inject_Z (snd x).
Definition qeq (x y:Qf) : Prop := qval x == qval y.

Lemma injZ_neq0 : forall z:Z, z <> 0 -> ~ (inject_Z z == 0).
Proof. intros z H C. apply H. apply inject_Z_injective. rewrite C. reflexivity. Qed.

(* qok is closed under the operations (Z is an integral domain) *)
Lemma qok_add : forall x y, qok x -> qok y -> qok (qadd x y).
Proof. intros x y Hx Hy; unfold qok, qadd; simpl; intro H; apply Zmult_integral in H; destruct H; auto. Qed.
Lemma qok_mul : forall x y, qok x -> qok y -> qok (qmul x y).
Proof. intros x y Hx Hy; unfold qok, qmul; simpl; intro H; apply Zmult_integral in H; destruct H; auto. Qed.
Lemma qok_neg : forall x, qok x -> qok (qneg x).
Proof. intros x Hx; unfold qok, qneg; simpl; exact Hx. Qed.
Lemma qok_inv : forall x, fst x <> 0 -> qok (qinv x).
Proof. intros x Hx; unfold qok, qinv; simpl; exact Hx. Qed.

(* value homomorphism into Coq's standard rationals *)
Lemma qval_q0 : qval q0 == 0. Proof. reflexivity. Qed.
Lemma qval_q1 : qval q1 == 1. Proof. reflexivity. Qed.
Lemma qval_add : forall x y, qok x -> qok y -> qval (qadd x y) == qval x + qval y.
Proof. intros [a b][c d] Hb Hd; unfold qval, qadd; simpl in *.
  rewrite inject_Z_plus, !inject_Z_mult; field; split; apply injZ_neq0; assumption. Qed.
Lemma qval_mul : forall x y, qok x -> qok y -> qval (qmul x y) == qval x * qval y.
Proof. intros [a b][c d] Hb Hd; unfold qval, qmul; simpl in *.
  rewrite !inject_Z_mult; field; split; apply injZ_neq0; assumption. Qed.
Lemma qval_neg : forall x, qok x -> qval (qneg x) == - qval x.
Proof. intros [a b] Hb; unfold qval, qneg; simpl in *.
  rewrite inject_Z_opp; field; apply injZ_neq0; assumption. Qed.
Ltac qE := unfold qeq.

(* equivalence *)
Theorem qeq_refl : forall x, qeq x x. Proof. intro; qE; reflexivity. Qed.
Theorem qeq_sym  : forall x y, qeq x y -> qeq y x. Proof. unfold qeq; intros x y H; symmetry; exact H. Qed.
Theorem qeq_trans: forall x y z, qeq x y -> qeq y z -> qeq x z. Proof. unfold qeq; intros x y z H1 H2; rewrite H1; exact H2. Qed.

(* commutative-ring axioms up to qeq (operands assumed qok) *)
Theorem qadd_comm : forall x y, qok x -> qok y -> qeq (qadd x y) (qadd y x).
Proof. intros x y Hx Hy; qE; rewrite (qval_add x y Hx Hy),(qval_add y x Hy Hx); ring. Qed.
Theorem qadd_assoc: forall x y z, qok x -> qok y -> qok z -> qeq (qadd (qadd x y) z)(qadd x (qadd y z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_add (qadd x y) z (qok_add x y Hx Hy) Hz),(qval_add x y Hx Hy),
          (qval_add x (qadd y z) Hx (qok_add y z Hy Hz)),(qval_add y z Hy Hz); ring. Qed.
Theorem qadd_0_l  : forall x, qok x -> qeq (qadd q0 x) x.
Proof. intros x Hx; qE; rewrite (qval_add q0 x (ltac:(unfold qok,q0;simpl;lia)) Hx), qval_q0; ring. Qed.
Theorem qadd_neg  : forall x, qok x -> qeq (qadd x (qneg x)) q0.
Proof. intros x Hx; qE; rewrite (qval_add x (qneg x) Hx (qok_neg x Hx)), (qval_neg x Hx), qval_q0; ring. Qed.
Theorem qmul_comm : forall x y, qok x -> qok y -> qeq (qmul x y)(qmul y x).
Proof. intros x y Hx Hy; qE; rewrite (qval_mul x y Hx Hy),(qval_mul y x Hy Hx); ring. Qed.
Theorem qmul_assoc: forall x y z, qok x -> qok y -> qok z -> qeq (qmul (qmul x y) z)(qmul x (qmul y z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_mul (qmul x y) z (qok_mul x y Hx Hy) Hz),(qval_mul x y Hx Hy),
          (qval_mul x (qmul y z) Hx (qok_mul y z Hy Hz)),(qval_mul y z Hy Hz); ring. Qed.
Theorem qmul_1_l  : forall x, qok x -> qeq (qmul q1 x) x.
Proof. intros x Hx; qE; rewrite (qval_mul q1 x (ltac:(unfold qok,q1;simpl;lia)) Hx), qval_q1; ring. Qed.
Theorem qmul_distrib_l : forall x y z, qok x -> qok y -> qok z -> qeq (qmul x (qadd y z))(qadd (qmul x y)(qmul x z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_mul x (qadd y z) Hx (qok_add y z Hy Hz)),(qval_add y z Hy Hz),
          (qval_add (qmul x y)(qmul x z)(qok_mul x y Hx Hy)(qok_mul x z Hx Hz)),
          (qval_mul x y Hx Hy),(qval_mul x z Hx Hz); ring. Qed.

(* FIELD axiom: every nonzero element has a multiplicative inverse *)
Theorem qmul_inv : forall x, qok x -> fst x <> 0 -> qeq (qmul x (qinv x)) q1.
Proof.
  intros [a b] Hb Ha; unfold qeq, qval, qmul, qinv, q1, qok in *; simpl in *.
  rewrite !inject_Z_mult; field; split; apply injZ_neq0; assumption.
Qed.

Open Scope nat_scope.


(* ===================================================================== *)
(*  THE REAL LINE R, constructed from Q as Bishop REGULAR CAUCHY SEQUENCES.*)
(*  This is the START of the continuum from the discrete root: a real is a *)
(*  sequence f:positive->Q with |f n - f m| <= 1/n + 1/m. We build the      *)
(*  carrier RR, the equality Req (an EQUIVALENCE, transitivity via an        *)
(*  Archimedean-limit lemma), the injection inj_Q : Q -> R, and the full     *)
(*  additive ABELIAN-GROUP structure (Radd, Ropp, comm, 0_l, opp) up to Req. *)
(*  All axiom-free. HONEST FRONTIER: multiplication (Rmul), order (Rlt/Rle),  *)
(*  and COMPLETENESS (least-upper-bound / Cauchy-completeness) are NOT yet    *)
(*  proved here; completeness is the bottleneck and the next major target.   *)
(* ===================================================================== *)
Open Scope Q_scope.

(* ===== rational helper lemmas (all axiom-free) ===== *)
Lemma two_halves : forall n:positive, (1 # (2*n)) + (1 # (2*n)) == (1 # n).
Proof. intro n. unfold Qeq, Qplus; simpl; nia. Qed.
Lemma two_halves' : forall n:positive, 2 * (1 # (2*n)) == (1 # n).
Proof. intro n. rewrite <- (two_halves n); ring. Qed.
Lemma inv_mono : forall n:positive, (1 # (2*n)) <= (1 # n).
Proof. intro n. unfold Qle; simpl; nia. Qed.
Lemma Qle_lim : forall a b:Q, (forall e:Q, 0 < e -> a <= b + e) -> a <= b.
Proof. intros a b H. apply Qnot_lt_le. intro C.
  assert (Hp: 0 < (a-b)*(1#2)) by lra. specialize (H _ Hp). lra. Qed.
Lemma Qle_lim2 : forall a b:Q, (forall k:positive, a <= b + 2*(1#k)) -> a <= b.
Proof. intros a b H. apply Qle_lim. intros e He.
  pose (k := (2 * Qden e)%positive). specialize (H k). revert H.
  assert (B: 2*(1#k) <= e).
  { unfold k. rewrite two_halves'. unfold Qle; simpl.
    unfold Qlt in He; simpl in He. nia. }
  lra. Qed.

(* ===================================================================== *)
(*  THE REAL LINE R, constructed as Bishop REGULAR CAUCHY SEQUENCES of Q. *)
(*  A real is a sequence f : positive -> Q with |f n - f m| <= 1/n + 1/m. *)
(*  (Q here is Coq's standard rationals, which we proved isomorphic to    *)
(*   the D-rooted field Qf via qval; so this is R built from the root.)    *)
(* ===================================================================== *)
Record RR : Type := mkRR {
  rseq :> positive -> Q ;
  rreg : forall n m, Qabs (rseq n - rseq m) <= (1#n) + (1#m)
}.

Definition Req (x y:RR) : Prop := forall n m, Qabs (rseq x n - rseq y m) <= (1#n) + (1#m).

Theorem Req_refl : forall x, Req x x.
Proof. intros x n m. apply rreg. Qed.
Theorem Req_sym : forall x y, Req x y -> Req y x.
Proof. intros x y H n m. rewrite Qabs_Qminus. specialize (H m n). lra. Qed.
Theorem Req_trans : forall x y z, Req x y -> Req y z -> Req x z.
Proof. intros x y z Hxy Hyz n m. apply Qle_lim2. intro k.
  apply (Qle_trans _ (Qabs (rseq x n - rseq y k) + Qabs (rseq y k - rseq z m))).
  - assert (E: rseq x n - rseq z m == (rseq x n - rseq y k)+(rseq y k - rseq z m)) by ring.
    rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
  - specialize (Hxy n k); specialize (Hyz k m). lra. Qed.

(* injection Q -> R as constant sequences; zero and one *)
Definition inj_Q (q:Q) : RR.
Proof. refine (mkRR (fun _ => q) _). intros n m.
  assert (E: q - q == 0) by ring. rewrite (Qabs_wd _ _ E).
  change (Qabs 0) with 0. unfold Qle; simpl; lia. Defined.
Definition Rzero : RR := inj_Q 0.
Definition Rone  : RR := inj_Q 1.

(* addition: sample both arguments at 2n so the sum stays regular at modulus 1/n *)
Definition Radd (x y:RR) : RR.
Proof. refine (mkRR (fun n => rseq x (2*n)%positive + rseq y (2*n)%positive) _). intros n m.
  apply (Qle_trans _ (Qabs (rseq x (2*n) - rseq x (2*m)) + Qabs (rseq y (2*n) - rseq y (2*m)))).
  - assert (E: (rseq x (2*n)+rseq y (2*n)) - (rseq x (2*m)+rseq y (2*m))
              == (rseq x (2*n)-rseq x (2*m))+(rseq y (2*n)-rseq y (2*m))) by ring.
    rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
  - pose proof (rreg x (2*n)%positive (2*m)%positive) as Hx.
    pose proof (rreg y (2*n)%positive (2*m)%positive) as Hy.
    assert (S: (1#(2*n))+(1#(2*m)) + ((1#(2*n))+(1#(2*m))) == (1#n)+(1#m)).
    { rewrite <- (two_halves n), <- (two_halves m). ring. }
    apply (Qle_trans _ ((1#(2*n))+(1#(2*m)) + ((1#(2*n))+(1#(2*m))))).
    + apply Qplus_le_compat; assumption.
    + rewrite S. apply Qle_refl. Defined.

Definition Ropp (x:RR) : RR.
Proof. refine (mkRR (fun n => - rseq x n) _). intros n m.
  assert (E: - rseq x n - - rseq x m == -(rseq x n - rseq x m)) by ring.
  rewrite (Qabs_wd _ _ E), Qabs_opp. apply rreg. Defined.

(* additive abelian-group laws, up to Req *)
Theorem Radd_comm : forall x y, Req (Radd x y) (Radd y x).
Proof. intros x y n m. cbn [rseq Radd].
  assert (E: (rseq x (2*n)+rseq y (2*n)) - (rseq y (2*m)+rseq x (2*m))
            == (rseq x (2*n)+rseq y (2*n)) - (rseq x (2*m)+rseq y (2*m))) by ring.
  rewrite (Qabs_wd _ _ E). exact (rreg (Radd x y) n m). Qed.
Theorem Radd_0_l : forall x, Req (Radd Rzero x) x.
Proof. intros x n m. cbn [rseq Radd Rzero inj_Q].
  pose proof (rreg x (2*n)%positive m) as H. pose proof (inv_mono n) as Hm.
  assert (E: (0 + rseq x (2*n)) - rseq x m == rseq x (2*n) - rseq x m) by ring.
  rewrite (Qabs_wd _ _ E). lra. Qed.
Theorem Radd_opp : forall x, Req (Radd x (Ropp x)) Rzero.
Proof. intros x n m. cbn [rseq Radd Ropp Rzero inj_Q].
  assert (E: (rseq x (2*n) + - rseq x (2*n)) - 0 == 0) by ring.
  rewrite (Qabs_wd _ _ E). change (Qabs 0) with 0.
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia).
  assert (0 <= (1#m)) by (unfold Qle; simpl; lia). lra. Qed.

Open Scope nat_scope.
Open Scope Q_scope.

(* ===== Archimedean witness + general constant-modulus limit lemma ===== *)
Lemma Qarch1 : forall r:Q, 0 < r -> (1 # Qden r) <= r.
Proof. intros r H. unfold Qle, Qlt in *; simpl in *. nia. Qed.
Lemma Qle_limc : forall (c:Q) a b, 0 <= c -> (forall k:positive, a <= b + c*(1#k)) -> a <= b.
Proof. intros c a b Hc H. apply Qle_lim. intros e He.
  destruct (Qlt_le_dec 0 c) as [Hcpos|Hcz].
  - pose (r := e / c). assert (Hr: 0 < r) by (unfold r; apply Qlt_shift_div_l; lra).
    pose (k := Qden r). specialize (H k).
    assert (Hk: c * (1 # k) <= e).
    { apply (Qle_trans _ (c * r)).
      - apply (proj2 (Qmult_le_l (1#k) r c Hcpos)). apply Qarch1; exact Hr.
      - unfold r. rewrite Qmult_div_r; [ apply Qle_refl | lra ]. }
    lra.
  - assert (c == 0) by lra. specialize (H 1%positive). rewrite H0 in H. lra. Qed.

(* ===================================================================== *)
(*  ORDER on R: the non-strict order Rle and strict order Rlt.            *)
(*  Rle is a partial order up to Req (refl, trans via the limit lemma,     *)
(*  antisymmetric: Rle both ways gives Req). inj_Q and Radd are monotone.  *)
(* ===================================================================== *)
Definition Rle (x y:RR) : Prop := forall n, rseq x n <= rseq y n + (2#1)*(1#n).
Definition Rlt (x y:RR) : Prop := exists n:positive, (2#1)*(1#n) < rseq y n - rseq x n.

Theorem Rle_refl : forall x, Rle x x.
Proof. intros x n. assert (0 <= (2#1)*(1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Rle_trans : forall x y z, Rle x y -> Rle y z -> Rle x z.
Proof. intros x y z Hxy Hyz n. apply (Qle_limc (6#1)). { unfold Qle; simpl; lia. } intro k.
  destruct (proj1 (Qabs_Qle_condition _ _) (rreg x n k)) as [_ Hxk].
  destruct (proj1 (Qabs_Qle_condition _ _) (rreg z n k)) as [Hzk _].
  pose proof (Hxy k) as A. pose proof (Hyz k) as B. lra. Qed.

(* pointwise-2/n-close sequences are Req-equal *)
Lemma close_Req : forall x y, (forall i, Qabs (rseq x i - rseq y i) <= (2#1)*(1#i)) -> Req x y.
Proof. intros x y H n m. apply (Qle_limc (4#1)). { unfold Qle; simpl; lia. } intro i.
  apply (Qle_trans _ (Qabs (rseq x n - rseq x i)
                    + (Qabs (rseq x i - rseq y i) + Qabs (rseq y i - rseq y m)))).
  - assert (E: rseq x n - rseq y m
       == (rseq x n - rseq x i) + ((rseq x i - rseq y i) + (rseq y i - rseq y m))) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (rseq x n - rseq x i)
              + Qabs ((rseq x i - rseq y i) + (rseq y i - rseq y m)))).
    + apply Qabs_triangle.
    + apply Qplus_le_compat. apply Qle_refl. apply Qabs_triangle.
  - pose proof (rreg x n i) as Hx. pose proof (rreg y i m) as Hy. pose proof (H i) as Hi.
    apply (Qle_trans _ (((1#n) + (1#i)) + ((2#1)*(1#i) + ((1#i) + (1#m))))).
    + apply Qplus_le_compat. exact Hx. apply Qplus_le_compat. exact Hi. exact Hy.
    + assert (Eq4: ((1#n)+(1#i)) + ((2#1)*(1#i) + ((1#i)+(1#m)))
                == ((1#n)+(1#m)) + (4#1)*(1#i)) by ring.
      rewrite Eq4. apply Qle_refl. Qed.

Theorem Rle_antisym : forall x y, Rle x y -> Rle y x -> Req x y.
Proof. intros x y Hxy Hyx. apply close_Req. intro i.
  apply Qabs_Qle_condition. split.
  - pose proof (Hyx i). lra.
  - pose proof (Hxy i). lra. Qed.

Theorem inj_Q_le : forall p q:Q, p <= q -> Rle (inj_Q p) (inj_Q q).
Proof. intros p q H n. cbn [rseq inj_Q].
  assert (0 <= (2#1)*(1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Radd_le_mono_r : forall x y z, Rle x y -> Rle (Radd x z) (Radd y z).
Proof. intros x y z H n. cbn [rseq Radd]. pose proof (H (2*n)%positive) as Hn.
  assert (E1: (2#1)*(1#(2*n)) == (1#n)) by (unfold Qeq, Qmult; simpl; nia).
  assert (E2: (1#n) <= (2#1)*(1#n)) by (unfold Qle, Qmult; simpl; nia). lra. Qed.

Theorem Rlt_irrefl : forall x, ~ Rlt x x.
Proof. intros x [n Hn]. assert (E: rseq x n - rseq x n == 0) by ring. rewrite E in Hn.
  assert (0 < (2#1)*(1#n)) by (unfold Qlt; simpl; lia). lra. Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  MULTIPLICATION on R (toward an ordered field).  The product of two      *)
(*  regular sequences needs a CANONICAL BOUND on each factor (|x n| is      *)
(*  bounded by ceil(|x 1|)+2) and SCALED SAMPLING at (Bnd x + Bnd y)*n so    *)
(*  the product stays regular at modulus 1/n. We construct Rmul, prove it    *)
(*  regular, and prove it COMMUTATIVE and LEFT-UNITAL (Rmul Rone x ~ x) up   *)
(*  to Req. Axiom-free. HONEST FRONTIER: full well-definedness of Rmul as a  *)
(*  congruence for Req, associativity, distributivity, the multiplicative    *)
(*  inverse, and COMPLETENESS are NOT yet proved; completeness is the         *)
(*  bottleneck and the next major target.                                    *)
(* ===================================================================== *)
(* ===== multiplication on R: canonical bound + scaled sampling ===== *)
Lemma scaleN : forall (N n:positive), inject_Z (Z.pos N) * (1 # (N*n)) == 1#n.
Proof. intros N n. unfold Qeq, Qmult, inject_Z; simpl. nia. Qed.

Definition Bnd (x:RR) : positive := (Z.to_pos (Qceiling (Qabs (rseq x 1))) + 2)%positive.

Lemma Rbound : forall (x:RR) n, Qabs (rseq x n) <= inject_Z (Z.pos (Bnd x)).
Proof. intros x n.
  pose proof (Qle_ceiling (Qabs (rseq x 1))) as Hcl.
  pose proof (rreg x n 1%positive) as Hr.
  apply (Qle_trans _ (Qabs (rseq x n - rseq x 1) + Qabs (rseq x 1))).
  - assert (E: rseq x n == (rseq x n - rseq x 1) + rseq x 1) by ring.
    rewrite (Qabs_wd _ _ E) at 1. apply Qabs_triangle.
  - apply (Qle_trans _ (((1#n)+(1#1)) + Qabs (rseq x 1))).
    + apply Qplus_le_compat. exact Hr. apply Qle_refl.
    + assert (Hge: inject_Z (Qceiling (Qabs (rseq x 1))) + 2 <= inject_Z (Z.pos (Bnd x))).
      { unfold Bnd. rewrite Pos2Z.inj_add.
        assert (Hc: (Qceiling (Qabs (rseq x 1)) <= Z.pos (Z.to_pos (Qceiling (Qabs (rseq x 1)))))%Z)
          by (destruct (Qceiling (Qabs (rseq x 1))); simpl; lia).
        rewrite Zle_Qle in Hc. rewrite inject_Z_plus in *. change (inject_Z (Z.pos 2)) with 2.
        lra. }
      assert (H1n: (1#n) <= 1) by (unfold Qle; simpl; lia). lra. Qed.

Definition Rmul (x y:RR) : RR.
Proof.
  refine (mkRR (fun n => rseq x ((Bnd x + Bnd y)*n)%positive
                       * rseq y ((Bnd x + Bnd y)*n)%positive) _).
  intros n m. set (N := (Bnd x + Bnd y)%positive).
  pose proof (Rbound x (N*n)%positive) as Hax.
  pose proof (Rbound y (N*m)%positive) as Hdy.
  pose proof (rreg y (N*n)%positive (N*m)%positive) as Hbd.
  pose proof (rreg x (N*n)%positive (N*m)%positive) as Hac.
  set (a := rseq x (N*n)%positive). set (b := rseq y (N*n)%positive).
  set (c := rseq x (N*m)%positive). set (d := rseq y (N*m)%positive).
  set (Bx := inject_Z (Z.pos (Bnd x))). set (By := inject_Z (Z.pos (Bnd y))).
  set (S := (1#(N*n)) + (1#(N*m))).
  assert (HBx0: 0 < Bx) by (unfold Bx, inject_Z, Qlt; simpl; lia).
  assert (HBy0: 0 < By) by (unfold By, inject_Z, Qlt; simpl; lia).
  apply (Qle_trans _ (Qabs a * Qabs (b - d) + Qabs d * Qabs (a - c))).
  - assert (E: a*b - c*d == a*(b-d) + d*(a-c)) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (a*(b-d)) + Qabs (d*(a-c)))).
    + apply Qabs_triangle.
    + rewrite Qabs_Qmult, Qabs_Qmult. apply Qle_refl.
  - assert (P1: Qabs a * Qabs (b-d) <= Bx * S).
    { apply (Qle_trans _ (Bx * Qabs (b-d))).
      - apply Qmult_le_compat_r. exact Hax. apply Qabs_nonneg.
      - apply (proj2 (Qmult_le_l (Qabs (b-d)) S Bx HBx0)). exact Hbd. }
    assert (P2: Qabs d * Qabs (a-c) <= By * S).
    { apply (Qle_trans _ (By * Qabs (a-c))).
      - apply Qmult_le_compat_r. exact Hdy. apply Qabs_nonneg.
      - apply (proj2 (Qmult_le_l (Qabs (a-c)) S By HBy0)). exact Hac. }
    apply (Qle_trans _ (Bx*S + By*S)).
    + apply Qplus_le_compat; assumption.
    + assert (HB: Bx + By == inject_Z (Z.pos N)).
      { unfold Bx, By, N. rewrite <- inject_Z_plus, <- Pos2Z.inj_add. reflexivity. }
      assert (Hfin: Bx*S + By*S == (1#n) + (1#m)).
      { transitivity ((Bx+By) * S). ring. rewrite HB. unfold S.
        transitivity (inject_Z (Z.pos N)*(1#(N*n)) + inject_Z (Z.pos N)*(1#(N*m))). ring.
        rewrite (scaleN N n), (scaleN N m). reflexivity. }
      rewrite Hfin. apply Qle_refl.
Defined.


Theorem Rmul_comm : forall x y, Req (Rmul x y) (Rmul y x).
Proof. intros x y n m. cbn [rseq Rmul].
  rewrite (Pos.add_comm (Bnd y) (Bnd x)).
  assert (E: rseq x ((Bnd x+Bnd y)*n) * rseq y ((Bnd x+Bnd y)*n)
           - rseq y ((Bnd x+Bnd y)*m) * rseq x ((Bnd x+Bnd y)*m)
          == rseq x ((Bnd x+Bnd y)*n) * rseq y ((Bnd x+Bnd y)*n)
           - rseq x ((Bnd x+Bnd y)*m) * rseq y ((Bnd x+Bnd y)*m)) by ring.
  rewrite (Qabs_wd _ _ E). exact (rreg (Rmul x y) n m). Qed.

Theorem Rmul_1_l : forall x, Req (Rmul Rone x) x.
Proof. intros x n m. cbn [rseq Rmul Rone inj_Q].
  set (N := (Bnd Rone + Bnd x)%positive).
  assert (E: 1 * rseq x (N*n) - rseq x m == rseq x (N*n) - rseq x m) by ring.
  rewrite (Qabs_wd _ _ E).
  pose proof (rreg x (N*n)%positive m) as H.
  assert (Hle: (1#(N*n)) <= (1#n)) by (unfold Qle; simpl; nia). lra. Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  WELL-DEFINEDNESS of multiplication: Rmul is a CONGRUENCE for Req.       *)
(*  Using the canonical bound IB x := inject_Z (Bnd x), two product          *)
(*  estimates -- prod_reg (cross-term at arbitrary indices) and prod_mix     *)
(*  (difference of products at a common index) -- and the limit lemma, we    *)
(*  prove that x ~ x' and y ~ y' imply (x*y) ~ (x'*y'). So Rmul is a genuine  *)
(*  operation on R = RR/Req. Axiom-free. HONEST FRONTIER: associativity,      *)
(*  distributivity, the multiplicative inverse, and COMPLETENESS remain.      *)
(* ===================================================================== *)
Definition IB (x:RR) : Q := inject_Z (Z.pos (Bnd x)).
Lemma IB_pos : forall x, 0 < IB x. Proof. intro x. unfold IB, inject_Z, Qlt; simpl; lia. Qed.

Lemma prod_reg : forall (u v:RR) i j,
  Qabs (rseq u i * rseq v i - rseq u j * rseq v j) <= (IB u + IB v) * ((1#i)+(1#j)).
Proof. intros u v i j.
  set (a:=rseq u i). set (b:=rseq v i). set (c:=rseq u j). set (d:=rseq v j).
  pose proof (IB_pos u) as HBu0. pose proof (IB_pos v) as HBv0.
  apply (Qle_trans _ (Qabs a * Qabs (b-d) + Qabs d * Qabs (a-c))).
  - assert (E: a*b - c*d == a*(b-d) + d*(a-c)) by ring. rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (a*(b-d)) + Qabs (d*(a-c)))). apply Qabs_triangle.
    rewrite Qabs_Qmult, Qabs_Qmult. apply Qle_refl.
  - pose proof (Rbound u i) as Hau. pose proof (Rbound v j) as Hdv.
    pose proof (rreg v i j) as Hbd. pose proof (rreg u i j) as Hac.
    fold (IB u) in Hau. fold (IB v) in Hdv.
    assert (P1: Qabs a * Qabs (b-d) <= IB u * ((1#i)+(1#j))).
    { apply (Qle_trans _ (IB u * Qabs (b-d))).
      apply Qmult_le_compat_r. exact Hau. apply Qabs_nonneg.
      apply (proj2 (Qmult_le_l (Qabs (b-d)) _ (IB u) HBu0)). exact Hbd. }
    assert (P2: Qabs d * Qabs (a-c) <= IB v * ((1#i)+(1#j))).
    { apply (Qle_trans _ (IB v * Qabs (a-c))).
      apply Qmult_le_compat_r. exact Hdv. apply Qabs_nonneg.
      apply (proj2 (Qmult_le_l (Qabs (a-c)) _ (IB v) HBv0)). exact Hac. }
    apply (Qle_trans _ (IB u*((1#i)+(1#j)) + IB v*((1#i)+(1#j)))). apply Qplus_le_compat; assumption.
    assert (Ed: IB u*((1#i)+(1#j)) + IB v*((1#i)+(1#j)) == (IB u+IB v)*((1#i)+(1#j))) by ring.
    rewrite Ed. apply Qle_refl. Qed.

Lemma prod_mix : forall (u u' v v':RR) k,
  Qabs (rseq u k * rseq v k - rseq u' k * rseq v' k)
  <= IB u * Qabs (rseq v k - rseq v' k) + IB v' * Qabs (rseq u k - rseq u' k).
Proof. intros u u' v v' k.
  set (a:=rseq u k). set (b:=rseq v k). set (c:=rseq u' k). set (d:=rseq v' k).
  apply (Qle_trans _ (Qabs (a*(b-d)) + Qabs (d*(a-c)))).
  - assert (E: a*b - c*d == a*(b-d) + d*(a-c)) by ring. rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
  - rewrite Qabs_Qmult, Qabs_Qmult. apply Qplus_le_compat.
    + apply Qmult_le_compat_r. pose proof (Rbound u k) as H. fold (IB u) in H. exact H. apply Qabs_nonneg.
    + apply Qmult_le_compat_r. pose proof (Rbound v' k) as H. fold (IB v') in H. exact H. apply Qabs_nonneg. Qed.

Lemma IB_scale : forall (x y:RR) n, (IB x + IB y) * (1 # ((Bnd x + Bnd y)*n)) == 1#n.
Proof. intros x y n. unfold IB. rewrite <- inject_Z_plus, <- Pos2Z.inj_add. apply scaleN. Qed.

(* WELL-DEFINEDNESS of Rmul: the product respects Req (it is a congruence) *)
Theorem Rmul_wd : forall x x' y y', Req x x' -> Req y y' -> Req (Rmul x y) (Rmul x' y').
Proof. intros x x' y y' Hx Hy n m. cbn [rseq Rmul].
  set (N1 := (Bnd x + Bnd y)%positive). set (N2 := (Bnd x' + Bnd y')%positive).
  apply (Qle_limc ((IB x + IB y) + (2*IB x + 2*IB y') + (IB x' + IB y'))).
  { pose proof (IB_pos x). pose proof (IB_pos y). pose proof (IB_pos x').
    pose proof (IB_pos y'). lra. }
  intro k.
  pose proof (prod_reg x y (N1*n)%positive k) as T1.
  pose proof (prod_mix x x' y y' k) as T2.
  pose proof (prod_reg x' y' k (N2*m)%positive) as T3.
  pose proof (Hy k k) as Hyk. pose proof (Hx k k) as Hxk.
  pose proof (IB_pos x) as HBx. pose proof (IB_pos y') as HBy'.
  (* massage T1, T3 with the scaling identity *)
  assert (E1: (IB x + IB y)*((1#(N1*n))+(1#k)) == (1#n) + (IB x + IB y)*(1#k)).
  { assert (R := IB_scale x y n). fold N1 in R. rewrite <- R. ring. }
  rewrite E1 in T1.
  assert (E3: (IB x' + IB y')*((1#k)+(1#(N2*m))) == (IB x' + IB y')*(1#k) + (1#m)).
  { assert (R := IB_scale x' y' m). fold N2 in R. rewrite <- R. ring. }
  rewrite E3 in T3.
  (* massage T2 using Req-at-k *)
  assert (T2': Qabs (rseq x k * rseq y k - rseq x' k * rseq y' k)
            <= IB x*((1#k)+(1#k)) + IB y'*((1#k)+(1#k))).
  { eapply Qle_trans. exact T2. apply Qplus_le_compat.
    apply (proj2 (Qmult_le_l _ _ (IB x) HBx)). exact Hyk.
    apply (proj2 (Qmult_le_l _ _ (IB y') HBy')). exact Hxk. }
  (* 3-term triangle, then combine *)
  apply (Qle_trans _ (Qabs (rseq x (N1*n)*rseq y (N1*n) - rseq x k*rseq y k)
        + (Qabs (rseq x k*rseq y k - rseq x' k*rseq y' k)
           + Qabs (rseq x' k*rseq y' k - rseq x'(N2*m)*rseq y'(N2*m))))).
  - assert (E: rseq x (N1*n)*rseq y (N1*n) - rseq x'(N2*m)*rseq y'(N2*m)
            == (rseq x (N1*n)*rseq y (N1*n) - rseq x k*rseq y k)
             + ((rseq x k*rseq y k - rseq x' k*rseq y' k)
                + (rseq x' k*rseq y' k - rseq x'(N2*m)*rseq y'(N2*m)))) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (rseq x (N1*n)*rseq y (N1*n) - rseq x k*rseq y k)
          + Qabs ((rseq x k*rseq y k - rseq x' k*rseq y' k)
                  + (rseq x' k*rseq y' k - rseq x'(N2*m)*rseq y'(N2*m))))).
    apply Qabs_triangle. apply Qplus_le_compat. apply Qle_refl. apply Qabs_triangle.
  - apply (Qle_trans _ (((1#n) + (IB x+IB y)*(1#k))
          + ((IB x*((1#k)+(1#k)) + IB y'*((1#k)+(1#k)))
             + ((IB x'+IB y')*(1#k) + (1#m))))).
    apply Qplus_le_compat. exact T1. apply Qplus_le_compat. exact T2'. exact T3.
    assert (Efin: ((1#n) + (IB x+IB y)*(1#k))
          + ((IB x*((1#k)+(1#k)) + IB y'*((1#k)+(1#k))) + ((IB x'+IB y')*(1#k) + (1#m)))
       == ((1#n)+(1#m)) + ((IB x + IB y) + (2*IB x + 2*IB y') + (IB x' + IB y'))*(1#k)) by ring.
    rewrite Efin. apply Qle_refl. Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  RING LAWS for multiplication on R: DISTRIBUTIVITY and ASSOCIATIVITY.    *)
(*  With flexible product estimates (prod_reg2 for mismatched indices that   *)
(*  arise because Radd resamples at 2k, and the triple estimate prod_reg3_k), *)
(*  we reduce each law to a pointwise bound |A k - B k| <= C/k at a common     *)
(*  index and recover the equality modulus with the limit lemma. This gives   *)
(*  x*(y+z) ~ x*y + x*z (Rmul_distrib_l) and (x*y)*z ~ x*(y*z) (Rmul_assoc).   *)
(*  Together with the additive abelian group and the commutative, unital,     *)
(*  well-defined multiplication, R is now a COMMUTATIVE RING up to Req --      *)
(*  only the multiplicative inverse is missing for a field. Axiom-free.        *)
(*  HONEST FRONTIER: the inverse (needs apartness from 0) and COMPLETENESS.    *)
(* ===================================================================== *)
Lemma inv_idx_le : forall i k:positive, (k<=i)%positive -> (1#i) <= (1#k).
Proof. intros i k H. unfold Qle; simpl. lia. Qed.

Lemma prod_reg2 : forall (u v:RR) i j i' j',
  Qabs (rseq u i * rseq v j - rseq u i' * rseq v j')
  <= IB u * ((1#j)+(1#j')) + IB v * ((1#i)+(1#i')).
Proof. intros u v i j i' j'.
  set (a:=rseq u i). set (p:=rseq v j). set (c:=rseq u i'). set (q:=rseq v j').
  apply (Qle_trans _ (Qabs (a*(p-q)) + Qabs (q*(a-c)))).
  - assert (E: a*p - c*q == a*(p-q) + q*(a-c)) by ring. rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
  - rewrite Qabs_Qmult, Qabs_Qmult. apply Qplus_le_compat.
    + apply (Qle_trans _ (IB u * Qabs (p-q))).
      apply Qmult_le_compat_r. pose proof (Rbound u i) as H; fold (IB u) in H; exact H. apply Qabs_nonneg.
      apply (proj2 (Qmult_le_l _ _ (IB u) (IB_pos u))). exact (rreg v j j').
    + apply (Qle_trans _ (IB v * Qabs (a-c))).
      apply Qmult_le_compat_r. pose proof (Rbound v j') as H; fold (IB v) in H; exact H. apply Qabs_nonneg.
      apply (proj2 (Qmult_le_l _ _ (IB v) (IB_pos v))). exact (rreg u i i'). Qed.

Lemma prod_reg2_k : forall (u v:RR) i j i' j' k,
  (k<=i)%positive -> (k<=j)%positive -> (k<=i')%positive -> (k<=j')%positive ->
  Qabs (rseq u i * rseq v j - rseq u i' * rseq v j') <= (2*IB u + 2*IB v)*(1#k).
Proof. intros u v i j i' j' k Hi Hj Hi' Hj'.
  eapply Qle_trans. apply prod_reg2.
  pose proof (IB_pos u) as Hu. pose proof (IB_pos v) as Hv.
  apply (Qle_trans _ (IB u*((1#k)+(1#k)) + IB v*((1#k)+(1#k)))).
  - apply Qplus_le_compat.
    apply (proj2 (Qmult_le_l _ _ (IB u) Hu)). apply Qplus_le_compat; apply inv_idx_le; assumption.
    apply (proj2 (Qmult_le_l _ _ (IB v) Hv)). apply Qplus_le_compat; apply inv_idx_le; assumption.
  - assert (E: IB u*((1#k)+(1#k)) + IB v*((1#k)+(1#k)) == (2*IB u+2*IB v)*(1#k)) by ring.
    rewrite E. apply Qle_refl. Qed.


(* LEFT DISTRIBUTIVITY:  x*(y+z) ~ x*y + x*z  *)
Theorem Rmul_distrib_l : forall x y z, Req (Rmul x (Radd y z)) (Radd (Rmul x y) (Rmul x z)).
Proof. intros x y z n m.
  apply (Qle_limc (4*IB x + 2*IB y + 2*IB z + 2)).
  { pose proof (IB_pos x). pose proof (IB_pos y). pose proof (IB_pos z). lra. }
  intro k.
  pose proof (rreg (Rmul x (Radd y z)) n k) as RA.
  pose proof (rreg (Radd (Rmul x y) (Rmul x z)) k m) as RB.
  set (NP := (Bnd x + Bnd (Radd y z))%positive).
  set (N1 := (Bnd x + Bnd y)%positive). set (N2 := (Bnd x + Bnd z)%positive).
  assert (Hpt: Qabs (rseq (Rmul x (Radd y z)) k - rseq (Radd (Rmul x y) (Rmul x z)) k)
            <= (4*IB x + 2*IB y + 2*IB z)*(1#k)).
  { change (rseq (Rmul x (Radd y z)) k)
      with (rseq x (NP*k) * rseq (Radd y z) (NP*k)).
    change (rseq (Radd y z) (NP*k)) with (rseq y (2*(NP*k)) + rseq z (2*(NP*k))).
    change (rseq (Radd (Rmul x y) (Rmul x z)) k)
      with (rseq (Rmul x y) (2*k) + rseq (Rmul x z) (2*k)).
    change (rseq (Rmul x y) (2*k)) with (rseq x (N1*(2*k)) * rseq y (N1*(2*k))).
    change (rseq (Rmul x z) (2*k)) with (rseq x (N2*(2*k)) * rseq z (N2*(2*k))).
    apply (Qle_trans _
      (Qabs (rseq x (NP*k)*rseq y (2*(NP*k)) - rseq x (N1*(2*k))*rseq y (N1*(2*k)))
     + Qabs (rseq x (NP*k)*rseq z (2*(NP*k)) - rseq x (N2*(2*k))*rseq z (N2*(2*k))))).
    - assert (E:
        rseq x (NP*k)*(rseq y (2*(NP*k)) + rseq z (2*(NP*k)))
          - (rseq x (N1*(2*k))*rseq y (N1*(2*k)) + rseq x (N2*(2*k))*rseq z (N2*(2*k)))
        == (rseq x (NP*k)*rseq y (2*(NP*k)) - rseq x (N1*(2*k))*rseq y (N1*(2*k)))
         + (rseq x (NP*k)*rseq z (2*(NP*k)) - rseq x (N2*(2*k))*rseq z (N2*(2*k)))) by ring.
      rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
    - apply (Qle_trans _ ((2*IB x+2*IB y)*(1#k) + (2*IB x+2*IB z)*(1#k))).
      + apply Qplus_le_compat.
        * apply (prod_reg2_k x y (NP*k) (2*(NP*k)) (N1*(2*k)) (N1*(2*k)) k); nia.
        * apply (prod_reg2_k x z (NP*k) (2*(NP*k)) (N2*(2*k)) (N2*(2*k)) k); nia.
      + assert (E2: (2*IB x+2*IB y)*(1#k) + (2*IB x+2*IB z)*(1#k)
                 == (4*IB x+2*IB y+2*IB z)*(1#k)) by ring.
        rewrite E2. apply Qle_refl. }
  apply (Qle_trans _
    (Qabs (rseq (Rmul x (Radd y z)) n - rseq (Rmul x (Radd y z)) k)
   + (Qabs (rseq (Rmul x (Radd y z)) k - rseq (Radd (Rmul x y) (Rmul x z)) k)
      + Qabs (rseq (Radd (Rmul x y) (Rmul x z)) k - rseq (Radd (Rmul x y) (Rmul x z)) m)))).
  - assert (E:
      rseq (Rmul x (Radd y z)) n - rseq (Radd (Rmul x y) (Rmul x z)) m
      == (rseq (Rmul x (Radd y z)) n - rseq (Rmul x (Radd y z)) k)
       + ((rseq (Rmul x (Radd y z)) k - rseq (Radd (Rmul x y) (Rmul x z)) k)
          + (rseq (Radd (Rmul x y) (Rmul x z)) k - rseq (Radd (Rmul x y) (Rmul x z)) m))) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (rseq (Rmul x (Radd y z)) n - rseq (Rmul x (Radd y z)) k)
          + Qabs ((rseq (Rmul x (Radd y z)) k - rseq (Radd (Rmul x y) (Rmul x z)) k)
                  + (rseq (Radd (Rmul x y) (Rmul x z)) k - rseq (Radd (Rmul x y) (Rmul x z)) m)))).
    apply Qabs_triangle. apply Qplus_le_compat. apply Qle_refl. apply Qabs_triangle.
  - apply (Qle_trans _ (((1#n)+(1#k)) + ((4*IB x+2*IB y+2*IB z)*(1#k) + ((1#k)+(1#m))))).
    apply Qplus_le_compat. exact RA. apply Qplus_le_compat. exact Hpt. exact RB.
    assert (Efin: ((1#n)+(1#k)) + ((4*IB x+2*IB y+2*IB z)*(1#k) + ((1#k)+(1#m)))
       == ((1#n)+(1#m)) + (4*IB x+2*IB y+2*IB z+2)*(1#k)) by ring.
    rewrite Efin. apply Qle_refl. Qed.


Lemma kle1 : forall a k:positive, (k<=a*k)%positive. Proof. intros; nia. Qed.
Lemma kle3 : forall a b k:positive, (k<=a*(b*k))%positive.
Proof. intros a b k. apply (Pos.le_trans _ (b*k)). apply kle1. apply kle1. Qed.

Lemma pair_bound : forall e f E F:Q, 0<=e->0<=f->e<=E->f<=F-> e*f<=E*F.
Proof. intros e f E F He Hf HE HF. assert (0<=E) by lra.
  apply (Qle_trans _ (E*f)). apply Qmult_le_compat_r; assumption.
  rewrite (Qmult_comm E f), (Qmult_comm E F). apply Qmult_le_compat_r; assumption. Qed.
Lemma tri_bound : forall e f g E F G:Q, 0<=e->0<=f->0<=g-> e<=E->f<=F->g<=G -> e*f*g <= E*F*G.
Proof. intros e f g E F G He Hf Hg HE HF HG.
  apply pair_bound. apply Qmult_le_0_compat; assumption. assumption.
  apply pair_bound; assumption. assumption. Qed.

Lemma prod_reg3_k : forall (u v w:RR) i j l i' j' l' k,
  (k<=i)%positive->(k<=j)%positive->(k<=l)%positive->(k<=i')%positive->(k<=j')%positive->(k<=l')%positive->
  Qabs (rseq u i * rseq v j * rseq w l - rseq u i' * rseq v j' * rseq w l')
  <= (2*(IB v*IB w) + 2*(IB u*IB w) + 2*(IB u*IB v))*(1#k).
Proof. intros u v w i j l i' j' l' k Hi Hj Hl Hi' Hj' Hl'.
  set (a:=rseq u i). set (p:=rseq v j). set (s:=rseq w l).
  set (a':=rseq u i'). set (p':=rseq v j'). set (s':=rseq w l').
  assert (Da: Qabs (a-a') <= 2*(1#k)).
  { eapply Qle_trans. apply (rreg u i i').
    assert (1#i<=1#k) by (apply inv_idx_le; assumption).
    assert (1#i'<=1#k) by (apply inv_idx_le; assumption). lra. }
  assert (Dp: Qabs (p-p') <= 2*(1#k)).
  { eapply Qle_trans. apply (rreg v j j').
    assert (1#j<=1#k) by (apply inv_idx_le; assumption).
    assert (1#j'<=1#k) by (apply inv_idx_le; assumption). lra. }
  assert (Ds: Qabs (s-s') <= 2*(1#k)).
  { eapply Qle_trans. apply (rreg w l l').
    assert (1#l<=1#k) by (apply inv_idx_le; assumption).
    assert (1#l'<=1#k) by (apply inv_idx_le; assumption). lra. }
  assert (Bp:  Qabs p  <= IB v) by (pose proof (Rbound v j ) as H; fold (IB v) in H; exact H).
  assert (Bp': Qabs p' <= IB v) by (pose proof (Rbound v j') as H; fold (IB v) in H; exact H).
  assert (Bs:  Qabs s  <= IB w) by (pose proof (Rbound w l ) as H; fold (IB w) in H; exact H).
  assert (Ba': Qabs a' <= IB u) by (pose proof (Rbound u i') as H; fold (IB u) in H; exact H).
  assert (B1: Qabs ((a-a')*p*s) <= (2*(1#k))*IB v*IB w).
  { rewrite Qabs_Qmult, Qabs_Qmult. apply tri_bound.
    apply Qabs_nonneg. apply Qabs_nonneg. apply Qabs_nonneg. exact Da. exact Bp. exact Bs. }
  assert (B2: Qabs (a'*(p-p')*s) <= IB u*(2*(1#k))*IB w).
  { rewrite Qabs_Qmult, Qabs_Qmult. apply tri_bound.
    apply Qabs_nonneg. apply Qabs_nonneg. apply Qabs_nonneg. exact Ba'. exact Dp. exact Bs. }
  assert (B3: Qabs (a'*p'*(s-s')) <= IB u*IB v*(2*(1#k))).
  { rewrite Qabs_Qmult, Qabs_Qmult. apply tri_bound.
    apply Qabs_nonneg. apply Qabs_nonneg. apply Qabs_nonneg. exact Ba'. exact Bp'. exact Ds. }
  apply (Qle_trans _ (Qabs ((a-a')*p*s) + (Qabs (a'*(p-p')*s) + Qabs (a'*p'*(s-s'))))).
  - assert (E: a*p*s - a'*p'*s' == (a-a')*p*s + (a'*(p-p')*s + a'*p'*(s-s'))) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs ((a-a')*p*s) + Qabs (a'*(p-p')*s + a'*p'*(s-s')))).
    apply Qabs_triangle. apply Qplus_le_compat. apply Qle_refl. apply Qabs_triangle.
  - apply (Qle_trans _ ((2*(1#k))*IB v*IB w + (IB u*(2*(1#k))*IB w + IB u*IB v*(2*(1#k))))).
    apply Qplus_le_compat. exact B1. apply Qplus_le_compat. exact B2. exact B3.
    assert (Ef: (2*(1#k))*IB v*IB w + (IB u*(2*(1#k))*IB w + IB u*IB v*(2*(1#k)))
             == (2*(IB v*IB w) + 2*(IB u*IB w) + 2*(IB u*IB v))*(1#k)) by ring.
    rewrite Ef. apply Qle_refl. Qed.

(* ASSOCIATIVITY:  (x*y)*z ~ x*(y*z)  *)
Theorem Rmul_assoc : forall x y z, Req (Rmul (Rmul x y) z) (Rmul x (Rmul y z)).
Proof. intros x y z n m.
  apply (Qle_limc (2*(IB y*IB z) + 2*(IB x*IB z) + 2*(IB x*IB y) + 2)).
  { pose proof (IB_pos x). pose proof (IB_pos y). pose proof (IB_pos z).
    assert (0 <= IB x*IB y) by (apply Qmult_le_0_compat; lra).
    assert (0 <= IB x*IB z) by (apply Qmult_le_0_compat; lra).
    assert (0 <= IB y*IB z) by (apply Qmult_le_0_compat; lra). lra. }
  intro k.
  pose proof (rreg (Rmul (Rmul x y) z) n k) as RA.
  pose proof (rreg (Rmul x (Rmul y z)) k m) as RB.
  set (N1 := (Bnd x + Bnd y)%positive). set (N3 := (Bnd y + Bnd z)%positive).
  set (NA := (Bnd (Rmul x y) + Bnd z)%positive). set (NB := (Bnd x + Bnd (Rmul y z))%positive).
  assert (Hpt: Qabs (rseq (Rmul (Rmul x y) z) k - rseq (Rmul x (Rmul y z)) k)
            <= (2*(IB y*IB z) + 2*(IB x*IB z) + 2*(IB x*IB y))*(1#k)).
  { assert (E: rseq (Rmul (Rmul x y) z) k - rseq (Rmul x (Rmul y z)) k
      == rseq x (N1*(NA*k))*rseq y (N1*(NA*k))*rseq z (NA*k)
       - rseq x (NB*k)*rseq y (N3*(NB*k))*rseq z (N3*(NB*k))).
    { change (rseq (Rmul (Rmul x y) z) k)
        with (rseq x (N1*(NA*k))*rseq y (N1*(NA*k)) * rseq z (NA*k)).
      change (rseq (Rmul x (Rmul y z)) k)
        with (rseq x (NB*k) * (rseq y (N3*(NB*k))*rseq z (N3*(NB*k)))).
      ring. }
    rewrite (Qabs_wd _ _ E).
    apply prod_reg3_k; [apply kle3|apply kle3|apply kle1|apply kle1|apply kle3|apply kle3]. }
  apply (Qle_trans _
    (Qabs (rseq (Rmul (Rmul x y) z) n - rseq (Rmul (Rmul x y) z) k)
   + (Qabs (rseq (Rmul (Rmul x y) z) k - rseq (Rmul x (Rmul y z)) k)
      + Qabs (rseq (Rmul x (Rmul y z)) k - rseq (Rmul x (Rmul y z)) m)))).
  - assert (E:
      rseq (Rmul (Rmul x y) z) n - rseq (Rmul x (Rmul y z)) m
      == (rseq (Rmul (Rmul x y) z) n - rseq (Rmul (Rmul x y) z) k)
       + ((rseq (Rmul (Rmul x y) z) k - rseq (Rmul x (Rmul y z)) k)
          + (rseq (Rmul x (Rmul y z)) k - rseq (Rmul x (Rmul y z)) m))) by ring.
    rewrite (Qabs_wd _ _ E).
    apply (Qle_trans _ (Qabs (rseq (Rmul (Rmul x y) z) n - rseq (Rmul (Rmul x y) z) k)
          + Qabs ((rseq (Rmul (Rmul x y) z) k - rseq (Rmul x (Rmul y z)) k)
                  + (rseq (Rmul x (Rmul y z)) k - rseq (Rmul x (Rmul y z)) m)))).
    apply Qabs_triangle. apply Qplus_le_compat. apply Qle_refl. apply Qabs_triangle.
  - apply (Qle_trans _ (((1#n)+(1#k))
        + ((2*(IB y*IB z) + 2*(IB x*IB z) + 2*(IB x*IB y))*(1#k) + ((1#k)+(1#m))))).
    apply Qplus_le_compat. exact RA. apply Qplus_le_compat. exact Hpt. exact RB.
    assert (Ef: ((1#n)+(1#k)) + ((2*(IB y*IB z) + 2*(IB x*IB z) + 2*(IB x*IB y))*(1#k) + ((1#k)+(1#m)))
       == ((1#n)+(1#m)) + (2*(IB y*IB z) + 2*(IB x*IB z) + 2*(IB x*IB y) + 2)*(1#k)) by ring.
    rewrite Ef. apply Qle_refl. Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  CAUCHY-COMPLETENESS of R (constructive, axiom-free).                    *)
(*  This is the central target: the continuum as a READOUT of the discrete   *)
(*  root. Given a sequence X of reals that is Cauchy with the regular         *)
(*  modulus -- stated pointwise as |X i k - X j k| <= 1/i + 1/j + 2/k, the     *)
(*  operational content of Bishop regularity for a sequence of reals -- we    *)
(*  CONSTRUCT the limit real L EXPLICITLY by the diagonal L n := X(2n)(6n),    *)
(*  prove L is a genuine real (regular), and prove X i -> L with the explicit  *)
(*  modulus |X i k - L k| <= 1/i + 4/k. The limit point of the continuum is    *)
(*  literally read off the discrete rational approximants. No axioms.          *)
(*  HONEST RESIDUAL: the Cauchy/convergence moduli are in pointwise-rational    *)
(*  form (the computational heart); a fully metric-abstract restatement via a   *)
(*  real-valued |.| and Rle, and the multiplicative inverse, remain.            *)
(* ===================================================================== *)
Lemma frac_split : forall c n:positive, (1#(c*n)) == (1#c)*(1#n).
Proof. intros c n. unfold Qeq, Qmult; simpl; ring. Qed.

Definition R_complete
  (X : positive -> RR)
  (Hreg : forall i j k, Qabs (rseq (X i) k - rseq (X j) k) <= (1#i)+(1#j)+(2#1)*(1#k))
  : { L : RR | forall i k, Qabs (rseq (X i) k - rseq L k) <= (1#i) + (4#1)*(1#k) }.
Proof.
  set (Lseq := fun n => rseq (X (2*n)%positive) (6*n)%positive).
  assert (Lreg : forall n m, Qabs (Lseq n - Lseq m) <= (1#n)+(1#m)).
  { intros n m. unfold Lseq.
    apply (Qle_trans _ (((1#(6*n)%positive)+(1#(6*m)%positive))
                      + ((1#(2*n)%positive)+(1#(2*m)%positive)+(2#1)*(1#(6*m)%positive)))).
    - apply (Qle_trans _ (Qabs (rseq (X (2*n)%positive) (6*n)%positive - rseq (X (2*n)%positive) (6*m)%positive)
                        + Qabs (rseq (X (2*n)%positive) (6*m)%positive - rseq (X (2*m)%positive) (6*m)%positive))).
      + assert (E: rseq (X (2*n)%positive) (6*n)%positive - rseq (X (2*m)%positive) (6*m)%positive
                == (rseq (X (2*n)%positive) (6*n)%positive - rseq (X (2*n)%positive) (6*m)%positive)
                 + (rseq (X (2*n)%positive) (6*m)%positive - rseq (X (2*m)%positive) (6*m)%positive)) by ring.
        rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
      + apply Qplus_le_compat.
        apply (rreg (X (2*n)%positive) (6*n)%positive (6*m)%positive).
        apply (Hreg (2*n)%positive (2*m)%positive (6*m)%positive).
    - repeat rewrite frac_split.
      assert (0 <= (1#n)) by (unfold Qle; simpl; lia).
      assert (0 <= (1#m)) by (unfold Qle; simpl; lia). lra. }
  exists (mkRR Lseq Lreg). intros i k.
  change (rseq (mkRR Lseq Lreg) k) with (rseq (X (2*k)%positive) (6*k)%positive).
  apply (Qle_trans _ (((1#i)+(1#(2*k)%positive)+(2#1)*(1#k)) + ((1#k)+(1#(6*k)%positive)))).
  - apply (Qle_trans _ (Qabs (rseq (X i) k - rseq (X (2*k)%positive) k)
                      + Qabs (rseq (X (2*k)%positive) k - rseq (X (2*k)%positive) (6*k)%positive))).
    + assert (E: rseq (X i) k - rseq (X (2*k)%positive) (6*k)%positive
              == (rseq (X i) k - rseq (X (2*k)%positive) k)
               + (rseq (X (2*k)%positive) k - rseq (X (2*k)%positive) (6*k)%positive)) by ring.
      rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
    + apply Qplus_le_compat.
      apply (Hreg i (2*k)%positive k). apply (rreg (X (2*k)%positive) k (6*k)%positive).
  - repeat rewrite frac_split.
    assert (0 <= (1#i)) by (unfold Qle; simpl; lia).
    assert (0 <= (1#k)) by (unfold Qle; simpl; lia). lra.
Defined.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  COMPLETENESS, METRIC-ABSTRACT FORM (closing the pointwise residual).    *)
(*  We add the real absolute value Rabs (regular, hence a real) and real     *)
(*  subtraction Rsub := Radd x (Ropp y), and restate Cauchy-completeness      *)
(*  purely through the real order Rle and the embedding inj_Q: a sequence X   *)
(*  of reals that is Cauchy in the REAL metric, |X i - X j| <= inj_Q(1/i+1/j)  *)
(*  via Rle (Rabs (Rsub (X i)(X j))) (inj_Q (1/i+1/j)), has a real limit L      *)
(*  with |X i - L| <= inj_Q(1/i). The construction is the same explicit         *)
(*  diagonal; the delicate point is that Rle carries a fixed 2/n tolerance and  *)
(*  Rsub samples at 2n, so the crude triangle leaves an O(1/m) excess -- which   *)
(*  the limit lemma Qle_limc absorbs by pushing the estimate, via the distance   *)
(*  real's OWN regularity, to a large auxiliary index. Axiom-free. This is        *)
(*  textbook Cauchy-completeness of R, fully metric-abstract. HONEST RESIDUAL:    *)
(*  only the multiplicative inverse remains for an ordered field.                 *)
(* ===================================================================== *)
(* real absolute value: regular, hence a real *)
Definition Rabs (x:RR) : RR.
Proof. refine (mkRR (fun n => Qabs (rseq x n)) _).
  intros n m. apply (Qle_trans _ (Qabs (rseq x n - rseq x m))).
  - apply Qabs_Qle_condition. split.
    + pose proof (Qabs_triangle_reverse (rseq x m) (rseq x n)) as H.
      rewrite (Qabs_Qminus (rseq x m) (rseq x n)) in H. lra.
    + apply Qabs_triangle_reverse.
  - apply (rreg x n m). Defined.

Definition Rsub (x y:RR) : RR := Radd x (Ropp y).

(* CAUCHY-COMPLETENESS, metric-abstract form (via the real order Rle, the real
   absolute value Rabs, real subtraction Rsub, and the embedding inj_Q):
   a sequence of reals Cauchy with the regular modulus has a real limit. *)
Definition R_complete_metric
  (X : positive -> RR)
  (Hcau : forall i j, Rle (Rabs (Rsub (X i) (X j))) (inj_Q ((1#i)+(1#j))))
  : { L : RR | forall i, Rle (Rabs (Rsub (X i) L)) (inj_Q (1#i)) }.
Proof.
  assert (HC: forall i j n,
      Qabs (rseq (X i) (2*n)%positive - rseq (X j) (2*n)%positive) <= (1#i)+(1#j)+(2#1)*(1#n)).
  { intros i j n. pose proof (Hcau i j n) as H.
    change (rseq (Rabs (Rsub (X i) (X j))) n)
      with (Qabs (rseq (X i) (2*n)%positive + - rseq (X j) (2*n)%positive)) in H.
    change (rseq (inj_Q ((1#i)+(1#j))) n) with ((1#i)+(1#j)) in H.
    eapply Qle_trans; [ | apply H ].
    assert (E: rseq (X i) (2*n)%positive - rseq (X j) (2*n)%positive
            == rseq (X i) (2*n)%positive + - rseq (X j) (2*n)%positive) by ring.
    rewrite (Qabs_wd _ _ E). apply Qle_refl. }
  set (Lseq := fun n => rseq (X (2*n)%positive) (10*n)%positive).
  assert (Lreg : forall n m, Qabs (Lseq n - Lseq m) <= (1#n)+(1#m)).
  { intros n m. unfold Lseq.
    apply (Qle_trans _ (((1#(10*n)%positive)+(1#(10*m)%positive))
                      + ((1#(2*n)%positive)+(1#(2*m)%positive)+(2#1)*(1#(5*m)%positive)))).
    - apply (Qle_trans _ (Qabs (rseq (X (2*n)%positive) (10*n)%positive - rseq (X (2*n)%positive) (10*m)%positive)
                        + Qabs (rseq (X (2*n)%positive) (10*m)%positive - rseq (X (2*m)%positive) (10*m)%positive))).
      + assert (E: rseq (X (2*n)%positive) (10*n)%positive - rseq (X (2*m)%positive) (10*m)%positive
                == (rseq (X (2*n)%positive) (10*n)%positive - rseq (X (2*n)%positive) (10*m)%positive)
                 + (rseq (X (2*n)%positive) (10*m)%positive - rseq (X (2*m)%positive) (10*m)%positive)) by ring.
        rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
      + apply Qplus_le_compat.
        apply (rreg (X (2*n)%positive) (10*n)%positive (10*m)%positive).
        change (10*m)%positive with (2*(5*m))%positive.
        apply (HC (2*n)%positive (2*m)%positive (5*m)%positive).
    - repeat rewrite frac_split.
      assert (0 <= (1#n)) by (unfold Qle; simpl; lia).
      assert (0 <= (1#m)) by (unfold Qle; simpl; lia). lra. }
  exists (mkRR Lseq Lreg). intros i n.
  set (di := Rabs (Rsub (X i) (mkRR Lseq Lreg))).
  change (rseq (Rabs (Rsub (X i) (mkRR Lseq Lreg))) n) with (rseq di n).
  change (rseq (inj_Q (1#i)) n) with (1#i).
  apply (Qle_limc (19#5)).
  { unfold Qle; simpl; lia. }
  intro mm.
  pose proof (rreg di n mm) as Rd.
  assert (Hstep: rseq di n <= rseq di mm + ((1#n)+(1#mm))).
  { apply Qabs_Qle_condition in Rd. lra. }
  assert (Hcrude: rseq di mm <= (1#i) + (14#5)*(1#mm)).
  { unfold di.
    change (rseq (Rabs (Rsub (X i) (mkRR Lseq Lreg))) mm)
      with (Qabs (rseq (X i) (2*mm)%positive + - rseq (X (4*mm)%positive) (20*mm)%positive)).
    apply (Qle_trans _ (Qabs (rseq (X i) (2*mm)%positive - rseq (X (4*mm)%positive) (2*mm)%positive)
                      + Qabs (rseq (X (4*mm)%positive) (2*mm)%positive - rseq (X (4*mm)%positive) (20*mm)%positive))).
    - assert (E: rseq (X i) (2*mm)%positive + - rseq (X (4*mm)%positive) (20*mm)%positive
              == (rseq (X i) (2*mm)%positive - rseq (X (4*mm)%positive) (2*mm)%positive)
               + (rseq (X (4*mm)%positive) (2*mm)%positive - rseq (X (4*mm)%positive) (20*mm)%positive)) by ring.
      rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
    - apply (Qle_trans _ (((1#i)+(1#(4*mm)%positive)+(2#1)*(1#mm)) + ((1#(2*mm)%positive)+(1#(20*mm)%positive)))).
      + apply Qplus_le_compat.
        apply (HC i (4*mm)%positive mm).
        apply (rreg (X (4*mm)%positive) (2*mm)%positive (20*mm)%positive).
      + repeat rewrite frac_split.
        assert (0 <= (1#i)) by (unfold Qle; simpl; lia).
        assert (0 <= (1#mm)) by (unfold Qle; simpl; lia). lra. }
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia).
  assert (0 <= (1#mm)) by (unfold Qle; simpl; lia). lra.
Defined.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  MULTIPLICATIVE INVERSE of R (the last algebraic step to an ordered field).*)
(*  For a real x bounded below by a positive rational (Hlb: forall n, 1/c <=    *)
(*  x n -- i.e. x is positive and apart from 0), we build Rinv x, sampling at    *)
(*  (c*c)*n so the 1/x^2 error amplification is EXACTLY cancelled and 1/x stays   *)
(*  regular, and we prove the inverse law Rmul x (Rinv x) ~ 1. The product's      *)
(*  crude pointwise deviation from 1 is O(c/m); the limit lemma Qle_limc absorbs   *)
(*  it via the product real's OWN regularity. Axiom-free. With the commutative     *)
(*  ring and this inverse, R is an ORDERED FIELD up to Req (for its positive cone). *)
(*  HONEST RESIDUAL: a general nonzero x (allowing x<0) reduces to this case via    *)
(*  Rabs and sign-tracking -- routine bookkeeping, not yet mechanized.              *)
(* ===================================================================== *)
(* multiplicative inverse of a positive real bounded below by 1/c.
   Sampling at (c*c)*n exactly cancels the 1/x^2 error amplification. *)
Definition Rinv (x:RR) (c:positive) (Hlb : forall n, (1#c) <= rseq x n) : RR.
Proof.
  refine (mkRR (fun n => / rseq x ((c*c)*n)%positive) _).
  intros n m.
  set (a := rseq x ((c*c)*n)%positive). set (b := rseq x ((c*c)*m)%positive).
  assert (Ha : (1#c) <= a) by apply Hlb.
  assert (Hb : (1#c) <= b) by apply Hlb.
  assert (Hc0 : 0 < (1#c)) by (unfold Qlt; simpl; lia).
  assert (Ha0 : 0 < a) by (apply (Qlt_le_trans _ (1#c)); assumption).
  assert (Hb0 : 0 < b) by (apply (Qlt_le_trans _ (1#c)); assumption).
  assert (Hab0 : 0 < a*b) by (apply Qmult_lt_0_compat; assumption).
  rewrite <- (Qmult_le_r _ _ (a*b) Hab0).
  assert (Eab : a*b == Qabs (a*b)).
  { rewrite Qabs_pos; [ reflexivity | apply Qlt_le_weak; exact Hab0 ]. }
  assert (EL : Qabs (/a - /b) * (a*b) == Qabs (b - a)).
  { rewrite Eab. rewrite <- (Qabs_Qmult (/a - /b) (a*b)). apply Qabs_wd. field.
    split; (apply Qnot_eq_sym, Qlt_not_eq; assumption). }
  rewrite EL.
  apply (Qle_trans _ ((1#((c*c)*n)%positive)+(1#((c*c)*m)%positive))).
  - rewrite Qabs_Qminus. apply (rreg x ((c*c)*n)%positive ((c*c)*m)%positive).
  - assert (HS0 : 0 < (1#n)+(1#m)).
    { assert (0<(1#n)) by (unfold Qlt; simpl; lia).
      assert (0<(1#m)) by (unfold Qlt; simpl; lia). lra. }
    assert (E2 : (1#((c*c)*n)%positive)+(1#((c*c)*m)%positive) == ((1#n)+(1#m)) * (1#(c*c))).
    { repeat rewrite frac_split. ring. }
    rewrite E2.
    rewrite (Qmult_le_l (1#(c*c)) (a*b) ((1#n)+(1#m)) HS0).
    apply (Qle_trans _ ((1#c)*(1#c))).
    + rewrite frac_split. apply Qle_refl.
    + apply pair_bound; [ apply Qlt_le_weak; exact Hc0
                        | apply Qlt_le_weak; exact Hc0 | exact Ha | exact Hb ].
Defined.

(* x * (1/x) ~ 1 : the multiplicative inverse law, hence R is a FIELD up to Req
   (for positive reals bounded below; general apartness reduces to this via Rabs). *)
Definition Rmul_inv (x:RR) (c:positive) (Hlb : forall n, (1#c) <= rseq x n)
  : Req (Rmul x (Rinv x c Hlb)) (inj_Q 1).
Proof.
  set (v := Rinv x c Hlb).
  set (p := Rmul x v).
  set (NN := (Bnd x + Bnd v)%positive).
  assert (Hpn : forall n, Qabs (rseq p n - 1) <= (1#n)).
  { intro n.
    apply (Qle_limc (inject_Z (Z.pos c) * (2#1) + 1)).
    { assert (0 <= inject_Z (Z.pos c)) by (unfold Qle, inject_Z; simpl; lia). lra. }
    intro M.
    assert (Hcrude : Qabs (rseq p M - 1) <= inject_Z (Z.pos c) * (2#1) * (1#M)).
    { change (rseq p M)
        with (rseq x (NN*M)%positive * / rseq x ((c*c)*(NN*M))%positive).
      set (xa := rseq x (NN*M)%positive). set (xb := rseq x ((c*c)*(NN*M))%positive).
      assert (Hxb : (1#c) <= xb) by apply Hlb.
      assert (Hc0 : 0 < (1#c)) by (unfold Qlt; simpl; lia).
      assert (Hxb0 : 0 < xb) by (apply (Qlt_le_trans _ (1#c)); assumption).
      assert (Hxbne : ~ xb == 0) by (apply Qnot_eq_sym, Qlt_not_eq; exact Hxb0).
      assert (E1 : xa * /xb - 1 == (xa - xb) * /xb) by (field; exact Hxbne).
      rewrite (Qabs_wd _ _ E1). rewrite Qabs_Qmult.
      assert (Hinv : Qabs (/xb) <= inject_Z (Z.pos c)).
      { rewrite (Qabs_pos (/xb)); [ | apply Qlt_le_weak, Qinv_lt_0_compat; exact Hxb0 ].
        rewrite <- (Qmult_le_l (/xb) (inject_Z (Z.pos c)) xb Hxb0).
        assert (E3 : xb * /xb == 1) by (apply Qmult_inv_r; exact Hxbne).
        rewrite E3.
        apply (Qle_trans _ ((1#c) * inject_Z (Z.pos c))).
        - assert (E4 : (1#c) * inject_Z (Z.pos c) == 1)
            by (unfold Qeq, Qmult, inject_Z; simpl; lia).
          rewrite E4. apply Qle_refl.
        - apply Qmult_le_compat_r; [ exact Hxb | unfold Qle, inject_Z; simpl; lia ]. }
      assert (Hdiff : Qabs (xa - xb)
                <= (1#(NN*M)%positive) + (1#((c*c)*(NN*M))%positive))
        by apply (rreg x (NN*M)%positive ((c*c)*(NN*M))%positive).
      apply (Qle_trans _ (((1#(NN*M)%positive)+(1#((c*c)*(NN*M))%positive))
                          * inject_Z (Z.pos c))).
      - apply pair_bound;
          [ apply Qabs_nonneg | apply Qabs_nonneg | exact Hdiff | exact Hinv ].
      - apply (Qle_trans _ (((1#M)+(1#M)) * inject_Z (Z.pos c))).
        + apply Qmult_le_compat_r.
          * apply Qplus_le_compat.
            -- apply (inv_idx_le (NN*M)%positive M (kle1 NN M)).
            -- apply (inv_idx_le ((c*c)*(NN*M))%positive M (kle3 (c*c) NN M)).
          * unfold Qle, inject_Z; simpl; lia.
        + assert (EF : ((1#M)+(1#M)) * inject_Z (Z.pos c)
                    == inject_Z (Z.pos c) * (2#1) * (1#M)) by ring.
          rewrite EF. apply Qle_refl. }
    pose proof (rreg p n M) as Rp.
    apply (Qle_trans _ (Qabs (rseq p n - rseq p M) + Qabs (rseq p M - 1))).
    - assert (E : rseq p n - 1 == (rseq p n - rseq p M) + (rseq p M - 1)) by ring.
      rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
    - apply (Qle_trans _ (((1#n)+(1#M)) + inject_Z (Z.pos c)*(2#1)*(1#M))).
      + apply Qplus_le_compat; [ exact Rp | exact Hcrude ].
      + assert (EE : ((1#n)+(1#M)) + inject_Z (Z.pos c)*(2#1)*(1#M)
                  == (1#n) + (inject_Z (Z.pos c)*(2#1)+1)*(1#M)) by ring.
        rewrite EE. apply Qle_refl. }
  intros n m.
  change (rseq (inj_Q 1) m) with (1:Q).
  apply (Qle_trans _ (1#n)).
  - apply Hpn.
  - assert (0 <= (1#m)) by (unfold Qle; simpl; lia). lra.
Defined.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  GENERAL APARTNESS: the inverse for EVERY real apart from 0.               *)
(*  The positive-cone inverse above assumed 1/c <= x n. Genuine apartness only  *)
(*  gives 1/c <= |x n| (x may be negative, or of either sign). We close this:    *)
(*  Rinv_gen uses the SAME (c*c)*n sampling, and since every estimate routes      *)
(*  through Qabs -- |x(c^2 n) * x(c^2 m)| = |x(c^2 n)| |x(c^2 m)| >= 1/c^2, and     *)
(*  |1/x| = 1/|x| <= c -- the SIGN of x is irrelevant. Rmul_inv_gen proves the      *)
(*  inverse law Rmul x (Rinv_gen x) ~ 1 for any x with 1/c <= |x n|. So EVERY real  *)
(*  apart from 0 has a reciprocal: R is an ORDERED FIELD up to Req, full stop --     *)
(*  the positive-cone restriction is removed, axiom-free. This closes the last       *)
(*  algebraic residual of the number ladder D -> Z -> Q -> R.                         *)
(* ===================================================================== *)
(* GENERAL APARTNESS: inverse for ANY real apart from 0 (|x n| >= 1/c, either sign).
   Every estimate routes through Qabs, so the sign of x is irrelevant. *)
Definition Rinv_gen (x:RR) (c:positive) (Hap : forall n, (1#c) <= Qabs (rseq x n)) : RR.
Proof.
  refine (mkRR (fun n => / rseq x ((c*c)*n)%positive) _).
  intros n m.
  set (a := rseq x ((c*c)*n)%positive). set (b := rseq x ((c*c)*m)%positive).
  assert (Ha : (1#c) <= Qabs a) by apply Hap.
  assert (Hb : (1#c) <= Qabs b) by apply Hap.
  assert (Hc0 : 0 < (1#c)) by (unfold Qlt; simpl; lia).
  assert (Haabs0 : 0 < Qabs a) by (apply (Qlt_le_trans _ (1#c)); assumption).
  assert (Hbabs0 : 0 < Qabs b) by (apply (Qlt_le_trans _ (1#c)); assumption).
  assert (Hane : ~ a == 0).
  { intro Hz. apply (Qlt_irrefl 0). apply (Qlt_le_trans _ (Qabs a)); [exact Haabs0|].
    rewrite (Qabs_wd a 0 Hz). apply Qle_refl. }
  assert (Hbne : ~ b == 0).
  { intro Hz. apply (Qlt_irrefl 0). apply (Qlt_le_trans _ (Qabs b)); [exact Hbabs0|].
    rewrite (Qabs_wd b 0 Hz). apply Qle_refl. }
  assert (Habs_ab0 : 0 < Qabs (a*b)).
  { rewrite Qabs_Qmult. apply Qmult_lt_0_compat; assumption. }
  rewrite <- (Qmult_le_r _ _ (Qabs (a*b)) Habs_ab0).
  assert (EL : Qabs (/a - /b) * Qabs (a*b) == Qabs (b - a)).
  { rewrite <- (Qabs_Qmult (/a - /b) (a*b)). apply Qabs_wd. field. split; assumption. }
  rewrite EL.
  apply (Qle_trans _ ((1#((c*c)*n)%positive)+(1#((c*c)*m)%positive))).
  - rewrite Qabs_Qminus. apply (rreg x ((c*c)*n)%positive ((c*c)*m)%positive).
  - assert (HS0 : 0 < (1#n)+(1#m)).
    { assert (0<(1#n)) by (unfold Qlt; simpl; lia).
      assert (0<(1#m)) by (unfold Qlt; simpl; lia). lra. }
    assert (E2 : (1#((c*c)*n)%positive)+(1#((c*c)*m)%positive) == ((1#n)+(1#m)) * (1#(c*c))).
    { repeat rewrite frac_split. ring. }
    rewrite E2.
    rewrite (Qmult_le_l (1#(c*c)) (Qabs (a*b)) ((1#n)+(1#m)) HS0).
    apply (Qle_trans _ ((1#c)*(1#c))).
    + rewrite frac_split. apply Qle_refl.
    + rewrite Qabs_Qmult. apply pair_bound;
        [ apply Qlt_le_weak; exact Hc0 | apply Qlt_le_weak; exact Hc0 | exact Ha | exact Hb ].
Defined.

Definition Rmul_inv_gen (x:RR) (c:positive) (Hap : forall n, (1#c) <= Qabs (rseq x n))
  : Req (Rmul x (Rinv_gen x c Hap)) (inj_Q 1).
Proof.
  set (v := Rinv_gen x c Hap).
  set (p := Rmul x v).
  set (NN := (Bnd x + Bnd v)%positive).
  assert (Hpn : forall n, Qabs (rseq p n - 1) <= (1#n)).
  { intro n.
    apply (Qle_limc (inject_Z (Z.pos c) * (2#1) + 1)).
    { assert (0 <= inject_Z (Z.pos c)) by (unfold Qle, inject_Z; simpl; lia). lra. }
    intro M.
    assert (Hcrude : Qabs (rseq p M - 1) <= inject_Z (Z.pos c) * (2#1) * (1#M)).
    { change (rseq p M)
        with (rseq x (NN*M)%positive * / rseq x ((c*c)*(NN*M))%positive).
      set (xa := rseq x (NN*M)%positive). set (xb := rseq x ((c*c)*(NN*M))%positive).
      assert (Hxb : (1#c) <= Qabs xb) by apply Hap.
      assert (Hc0 : 0 < (1#c)) by (unfold Qlt; simpl; lia).
      assert (Hxbabs0 : 0 < Qabs xb) by (apply (Qlt_le_trans _ (1#c)); assumption).
      assert (Hxbne : ~ xb == 0).
      { intro Hz. apply (Qlt_irrefl 0). apply (Qlt_le_trans _ (Qabs xb)); [exact Hxbabs0|].
        rewrite (Qabs_wd xb 0 Hz). apply Qle_refl. }
      assert (E1 : xa * /xb - 1 == (xa - xb) * /xb) by (field; exact Hxbne).
      rewrite (Qabs_wd _ _ E1). rewrite Qabs_Qmult.
      assert (Hinv : Qabs (/xb) <= inject_Z (Z.pos c)).
      { rewrite Qabs_Qinv.
        rewrite <- (Qmult_le_l _ _ (Qabs xb) Hxbabs0).
        assert (E3 : Qabs xb * / Qabs xb == 1)
          by (apply Qmult_inv_r; apply Qnot_eq_sym, Qlt_not_eq; exact Hxbabs0).
        rewrite E3.
        apply (Qle_trans _ ((1#c) * inject_Z (Z.pos c))).
        - assert (E4 : (1#c) * inject_Z (Z.pos c) == 1)
            by (unfold Qeq, Qmult, inject_Z; simpl; lia).
          rewrite E4. apply Qle_refl.
        - apply Qmult_le_compat_r; [ exact Hxb | unfold Qle, inject_Z; simpl; lia ]. }
      assert (Hdiff : Qabs (xa - xb)
                <= (1#(NN*M)%positive) + (1#((c*c)*(NN*M))%positive))
        by apply (rreg x (NN*M)%positive ((c*c)*(NN*M))%positive).
      apply (Qle_trans _ (((1#(NN*M)%positive)+(1#((c*c)*(NN*M))%positive))
                          * inject_Z (Z.pos c))).
      - apply pair_bound;
          [ apply Qabs_nonneg | apply Qabs_nonneg | exact Hdiff | exact Hinv ].
      - apply (Qle_trans _ (((1#M)+(1#M)) * inject_Z (Z.pos c))).
        + apply Qmult_le_compat_r.
          * apply Qplus_le_compat.
            -- apply (inv_idx_le (NN*M)%positive M (kle1 NN M)).
            -- apply (inv_idx_le ((c*c)*(NN*M))%positive M (kle3 (c*c) NN M)).
          * unfold Qle, inject_Z; simpl; lia.
        + assert (EF : ((1#M)+(1#M)) * inject_Z (Z.pos c)
                    == inject_Z (Z.pos c) * (2#1) * (1#M)) by ring.
          rewrite EF. apply Qle_refl. }
    pose proof (rreg p n M) as Rp.
    apply (Qle_trans _ (Qabs (rseq p n - rseq p M) + Qabs (rseq p M - 1))).
    - assert (E : rseq p n - 1 == (rseq p n - rseq p M) + (rseq p M - 1)) by ring.
      rewrite (Qabs_wd _ _ E). apply Qabs_triangle.
    - apply (Qle_trans _ (((1#n)+(1#M)) + inject_Z (Z.pos c)*(2#1)*(1#M))).
      + apply Qplus_le_compat; [ exact Rp | exact Hcrude ].
      + assert (EE : ((1#n)+(1#M)) + inject_Z (Z.pos c)*(2#1)*(1#M)
                  == (1#n) + (inject_Z (Z.pos c)*(2#1)+1)*(1#M)) by ring.
        rewrite EE. apply Qle_refl. }
  intros n m.
  change (rseq (inj_Q 1) m) with (1:Q).
  apply (Qle_trans _ (1#n)).
  - apply Hpn.
  - assert (0 <= (1#m)) by (unfold Qle; simpl; lia). lra.
Defined.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  CONSTRUCTIVE ORDER STRUCTURE of R (strict order made robust).             *)
(*  NOTE: full TRICHOTOMY (x<y or x=y or x>y) and a total Rle (x<=y or y<=x)    *)
(*  and the classical least-upper-bound property are NOT constructively valid   *)
(*  -- each implies an omniscience principle (LPO/WLPO). The correct             *)
(*  constructive substitutes are COTRANSITIVITY of < and Cauchy-completeness     *)
(*  (the latter already proved: R_complete / R_complete_metric). Here we make     *)
(*  the strict order Rlt robust (margin strictly above the 2/n regularity drift)  *)
(*  and prove the constructive linear-order laws: strict-implies-nonstrict,        *)
(*  TRANSITIVITY, and COTRANSITIVITY (x<y -> for all z, x<z or z<y). With           *)
(*  Rlt_irrefl (above), Rlt is an irreflexive, transitive, cotransitive relation,   *)
(*  i.e. R is a constructive linearly ordered field. Axiom-free.                     *)
(* ===================================================================== *)
(* Archimedean witness selector: for g>0 and any coefficient c there is an index
   k with (c/k) < g.  Used to produce the witness index in transitivity/cotransitivity. *)
Lemma Qarch_c : forall (c:positive)(g:Q), 0 < g -> exists k:positive, (Z.pos c # 1)*(1#k) < g.
Proof. intros c g H. exists (c * Qden g + 1)%positive.
  unfold Qlt, Qmult in *; simpl in *. nia. Qed.

(* strict < implies non-strict <= (sound for the fixed 2/n tolerances). *)
Theorem Rlt_le_weak : forall x y, Rlt x y -> Rle x y.
Proof.
  intros x y [n Hn] m.
  pose proof (rreg x m n) as Rx. apply Qabs_Qle_condition in Rx.
  pose proof (rreg y m n) as Ry. apply Qabs_Qle_condition in Ry.
  lra.
Qed.

(* TRANSITIVITY of strict order: the two gaps add; pick a fine enough witness index. *)
Theorem Rlt_trans : forall x y z, Rlt x y -> Rlt y z -> Rlt x z.
Proof.
  intros x y z [n Hn] [m Hm].
  set (g := (rseq y n - rseq x n - (2#1)*(1#n)) + (rseq z m - rseq y m - (2#1)*(1#m))).
  assert (Hg : 0 < g) by (unfold g; lra).
  destruct (Qarch_c 4 g Hg) as [k Hk].
  exists k.
  pose proof (rreg x n k) as Rx. apply Qabs_Qle_condition in Rx.
  pose proof (rreg y m n) as Ry. apply Qabs_Qle_condition in Ry.
  pose proof (rreg z m k) as Rz. apply Qabs_Qle_condition in Rz.
  unfold g in Hk. lra.
Qed.

(* COTRANSITIVITY -- the constructive surrogate for trichotomy: from x<y, for ANY z
   at least one of x<z, z<y holds (decided by a rational comparison at a fine index). *)
Theorem Rlt_cotrans : forall x y, Rlt x y -> forall z, Rlt x z \/ Rlt z y.
Proof.
  intros x y [n Hn] z.
  set (g := rseq y n - rseq x n - (2#1)*(1#n)).
  assert (Hg : 0 < g) by (unfold g; lra).
  destruct (Qarch_c 6 g Hg) as [k Hk].
  pose proof (rreg x n k) as Rx. apply Qabs_Qle_condition in Rx.
  pose proof (rreg y n k) as Ry. apply Qabs_Qle_condition in Ry.
  destruct (Qlt_le_dec (rseq x k + rseq y k) ((2#1)*(rseq z k))) as [Hz | Hz].
  - left. exists k. unfold g in Hk. lra.
  - right. exists k. unfold g in Hk. lra.
Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  LATTICE / CONSTRUCTIVE FINITE SUPREMA on R (the honest LUB story).         *)
(*  The classical least-upper-bound property is NOT constructively valid (it    *)
(*  implies omniscience). What IS unconditionally constructive is the supremum   *)
(*  and infimum of FINITELY many reals: we build the binary join Rmax and meet    *)
(*  Rmin (pointwise Qmax/Qmin, regular hence reals) and prove their UNIVERSAL      *)
(*  PROPERTIES -- Rmax is the least upper bound of {x,y} (Rle_max_l, Rle_max_r,     *)
(*  Rmax_lub) and Rmin the greatest lower bound (Rmin_le_l, Rmin_le_r, Rmin_glb).    *)
(*  So R is a constructive LATTICE. Finite suprema are the located base case;        *)
(*  infinite suprema exist for LOCATED families (built on this together with the      *)
(*  Cauchy-completeness already proved), while the unrestricted LUB stays              *)
(*  non-constructive. Axiom-free.                                                       *)
(* ===================================================================== *)
(* binary supremum (lattice join): Rmax, regular hence a real. *)
Definition Rmax (x y:RR) : RR.
Proof. refine (mkRR (fun n => Qmax (rseq x n) (rseq y n)) _).
  intros n m.
  pose proof (rreg x n m) as Hx. apply Qabs_Qle_condition in Hx.
  pose proof (rreg y n m) as Hy. apply Qabs_Qle_condition in Hy.
  apply Qabs_Qle_condition. split.
  - assert (HB : Qmax (rseq x m) (rseq y m) <= Qmax (rseq x n) (rseq y n) + ((1#n)+(1#m))).
    { apply Q.max_lub.
      - pose proof (Q.le_max_l (rseq x n) (rseq y n)). lra.
      - pose proof (Q.le_max_r (rseq x n) (rseq y n)). lra. }
    lra.
  - assert (HB : Qmax (rseq x n) (rseq y n) <= Qmax (rseq x m) (rseq y m) + ((1#n)+(1#m))).
    { apply Q.max_lub.
      - pose proof (Q.le_max_l (rseq x m) (rseq y m)). lra.
      - pose proof (Q.le_max_r (rseq x m) (rseq y m)). lra. }
    lra.
Defined.

(* binary infimum (lattice meet): Rmin, regular hence a real. *)
Definition Rmin (x y:RR) : RR.
Proof. refine (mkRR (fun n => Qmin (rseq x n) (rseq y n)) _).
  intros n m.
  pose proof (rreg x n m) as Hx. apply Qabs_Qle_condition in Hx.
  pose proof (rreg y n m) as Hy. apply Qabs_Qle_condition in Hy.
  assert (A : Qmin (rseq x n) (rseq y n) - ((1#n)+(1#m)) <= Qmin (rseq x m) (rseq y m)).
  { apply Q.min_glb.
    - pose proof (Q.le_min_l (rseq x n) (rseq y n)). lra.
    - pose proof (Q.le_min_r (rseq x n) (rseq y n)). lra. }
  assert (B : Qmin (rseq x m) (rseq y m) - ((1#n)+(1#m)) <= Qmin (rseq x n) (rseq y n)).
  { apply Q.min_glb.
    - pose proof (Q.le_min_l (rseq x m) (rseq y m)). lra.
    - pose proof (Q.le_min_r (rseq x m) (rseq y m)). lra. }
  apply Qabs_Qle_condition. split; lra.
Defined.

(* universal property of Rmax: least upper bound of {x,y}. *)
Theorem Rle_max_l : forall x y, Rle x (Rmax x y).
Proof. intros x y n.
  change (rseq (Rmax x y) n) with (Qmax (rseq x n) (rseq y n)).
  pose proof (Q.le_max_l (rseq x n) (rseq y n)).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Rle_max_r : forall x y, Rle y (Rmax x y).
Proof. intros x y n.
  change (rseq (Rmax x y) n) with (Qmax (rseq x n) (rseq y n)).
  pose proof (Q.le_max_r (rseq x n) (rseq y n)).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Rmax_lub : forall x y z, Rle x z -> Rle y z -> Rle (Rmax x y) z.
Proof. intros x y z Hx Hy n. specialize (Hx n). specialize (Hy n).
  change (rseq (Rmax x y) n) with (Qmax (rseq x n) (rseq y n)).
  apply Q.max_lub; assumption. Qed.

(* universal property of Rmin: greatest lower bound of {x,y}. *)
Theorem Rmin_le_l : forall x y, Rle (Rmin x y) x.
Proof. intros x y n. pose proof (Q.le_min_l (rseq x n) (rseq y n)).
  change (rseq (Rmin x y) n) with (Qmin (rseq x n) (rseq y n)).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Rmin_le_r : forall x y, Rle (Rmin x y) y.
Proof. intros x y n. pose proof (Q.le_min_r (rseq x n) (rseq y n)).
  change (rseq (Rmin x y) n) with (Qmin (rseq x n) (rseq y n)).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra. Qed.

Theorem Rmin_glb : forall x y z, Rle z x -> Rle z y -> Rle z (Rmin x y).
Proof. intros x y z Hx Hy n. specialize (Hx n). specialize (Hy n).
  change (rseq (Rmin x y) n) with (Qmin (rseq x n) (rseq y n)).
  assert (HG : rseq z n - (2#1)*(1#n) <= Qmin (rseq x n) (rseq y n)) by (apply Q.min_glb; lra).
  lra. Qed.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===================================================================== *)
(*  CONTINUUM CALCULUS, FIRST STEPS: convergence of real sequences.           *)
(*  Built on the now-complete ordered field: a real sequence (a_i) CONVERGES    *)
(*  to L (Rconv) iff |a_i - L| <= 1/i as reals (the explicit-modulus form that    *)
(*  R_complete_metric produces). We prove the foundational facts, all axiom-free: *)
(*  the limit of a constant (Rconv_const); a concrete limit, the rationals 1/i      *)
(*  converging to 0 (Rconv_recip); UNIQUENESS OF LIMITS (Rlimit_unique: a sequence   *)
(*  has at most one limit up to Req, proved pointwise with the Qle_limc excess        *)
(*  absorption and the regularity of the two candidate limits); and completeness      *)
(*  restated as convergence (Rcomplete_conv: every real Cauchy sequence converges).    *)
(*  HONEST NOTE: this fixed-1/i modulus is what completeness yields; closure under     *)
(*  + and * (which rescales the modulus) and the epsilon-N reformulation, then          *)
(*  continuity and derivatives, are the natural next steps, not yet mechanized.         *)
(* ===================================================================== *)
(* ===== CONTINUUM CALCULUS: convergence of real sequences ===== *)

Definition Rconv (a : positive -> RR) (L:RR) : Prop :=
  forall i:positive, Rle (Rabs (Rsub (a i) L)) (inj_Q (1#i)).

(* limit of a constant sequence *)
Theorem Rconv_const : forall c:RR, Rconv (fun _ => c) c.
Proof.
  intros c i n.
  change (rseq (Rabs (Rsub c c)) n)
    with (Qabs (rseq c (2*n)%positive + - rseq c (2*n)%positive)).
  change (rseq (inj_Q (1#i)) n) with (1#i).
  assert (E : rseq c (2*n)%positive + - rseq c (2*n)%positive == 0) by ring.
  rewrite (Qabs_wd _ _ E).
  assert (H0 : Qabs 0 == 0) by (apply Qabs_pos; apply Qle_refl). rewrite H0.
  assert (0 <= (1#i)) by (unfold Qle; simpl; lia).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra.
Qed.

(* UNIQUENESS OF LIMITS: a real sequence has at most one limit (up to Req). *)
Theorem Rlimit_unique : forall a L L', Rconv a L -> Rconv a L' -> Req L L'.
Proof.
  intros a L L' HL HL' p q.
  apply (Qle_limc (8#1)).
  { unfold Qle; simpl; lia. }
  intro m.
  pose proof (HL m m) as HLm.
  change (rseq (Rabs (Rsub (a m) L)) m)
    with (Qabs (rseq (a m) (2*m)%positive + - rseq L (2*m)%positive)) in HLm.
  change (rseq (inj_Q (1#m)) m) with (1#m) in HLm.
  apply Qabs_Qle_condition in HLm.
  pose proof (HL' m m) as HL'm.
  change (rseq (Rabs (Rsub (a m) L')) m)
    with (Qabs (rseq (a m) (2*m)%positive + - rseq L' (2*m)%positive)) in HL'm.
  change (rseq (inj_Q (1#m)) m) with (1#m) in HL'm.
  apply Qabs_Qle_condition in HL'm.
  pose proof (rreg L p (2*m)%positive) as RL. apply Qabs_Qle_condition in RL.
  pose proof (rreg L' q (2*m)%positive) as RL'. apply Qabs_Qle_condition in RL'.
  assert (Hmm : (1#(2*m)%positive) <= (1#m)) by (unfold Qle; simpl; nia).
  apply Qabs_Qle_condition. split; lra.
Qed.

(* a concrete convergent sequence: the rationals 1/i, viewed as reals, converge to 0. *)
Theorem Rconv_recip : Rconv (fun i => inj_Q (1#i)) Rzero.
Proof.
  intros i n.
  change (rseq (Rabs (Rsub (inj_Q (1#i)) Rzero)) n)
    with (Qabs (rseq (inj_Q (1#i)) (2*n)%positive + - rseq Rzero (2*n)%positive)).
  change (rseq (inj_Q (1#i)) n) with (1#i).
  change (rseq (inj_Q (1#i)) (2*n)%positive) with (1#i).
  change (rseq Rzero (2*n)%positive) with (0:Q).
  assert (E : (1#i) + - 0 == (1#i)) by ring.
  rewrite (Qabs_wd _ _ E).
  assert (Hp : 0 <= (1#i)) by (unfold Qle; simpl; lia).
  rewrite (Qabs_pos (1#i) Hp).
  assert (0 <= (1#n)) by (unfold Qle; simpl; lia). lra.
Qed.

(* completeness, restated as convergence: every real Cauchy sequence converges. *)
Definition Rcomplete_conv
  (X : positive -> RR)
  (H : forall i j, Rle (Rabs (Rsub (X i) (X j))) (inj_Q ((1#i)+(1#j))))
  : { L : RR | Rconv X L }
  := R_complete_metric X H.

Open Scope nat_scope.

Open Scope Q_scope.

(* ===== REAL METRIC SPACE: Rdist and the metric-space laws ===== *)
Definition Rdist (x y:RR) : RR := Rabs (Rsub x y).

Theorem Rdist_self : forall x, Req (Rdist x x) Rzero.
Proof. intros x n m.
  change (rseq (Rdist x x) n) with (Qabs (rseq x (2*n)%positive + - rseq x (2*n)%positive)).
  change (rseq Rzero m) with (0:Q).
  assert (E1 : rseq x (2*n)%positive + - rseq x (2*n)%positive == 0) by ring.
  rewrite (Qabs_wd _ _ E1).
  assert (H0 : Qabs 0 == 0) by (apply Qabs_pos; apply Qle_refl).
  assert (E2 : Qabs 0 - (0:Q) == 0) by (rewrite H0; ring).
  rewrite (Qabs_wd _ _ E2). rewrite H0.
  assert (0<=(1#n)) by (unfold Qle;simpl;lia). assert (0<=(1#m)) by (unfold Qle;simpl;lia). lra.
Qed.

Theorem Rdist_sym : forall x y, Req (Rdist x y) (Rdist y x).
Proof. intros x y n m.
  change (rseq (Rdist y x) m) with (Qabs (rseq y (2*m)%positive + - rseq x (2*m)%positive)).
  change (rseq (Rdist x y) n) with (Qabs (rseq x (2*n)%positive + - rseq y (2*n)%positive)).
  assert (E : rseq y (2*m)%positive + - rseq x (2*m)%positive
          == -(rseq x (2*m)%positive + - rseq y (2*m)%positive)) by ring.
  rewrite (Qabs_wd _ _ E). rewrite Qabs_opp.
  change (Qabs (rseq x (2*n)%positive + - rseq y (2*n)%positive)) with (rseq (Rabs (Rsub x y)) n).
  change (Qabs (rseq x (2*m)%positive + - rseq y (2*m)%positive)) with (rseq (Rabs (Rsub x y)) m).
  apply (rreg (Rabs (Rsub x y)) n m).
Qed.

Theorem Rdist_nonneg : forall x y, Rle Rzero (Rdist x y).
Proof. intros x y n.
  change (rseq Rzero n) with (0:Q).
  change (rseq (Rdist x y) n) with (Qabs (rseq x (2*n)%positive + - rseq y (2*n)%positive)).
  pose proof (Qabs_nonneg (rseq x (2*n)%positive + - rseq y (2*n)%positive)).
  assert (Htol : (2#1)*(1#n) == (1#n)+(1#n)) by ring. rewrite Htol.
  assert (0<=(1#n)) by (unfold Qle;simpl;lia). lra.
Qed.

(* the metric TRIANGLE INEQUALITY for reals: d(x,z) <= d(x,y) + d(y,z).
   The 2n vs 4n index mismatch (Rsub/Radd resample) leaves a 3/(2n) drift that
   fits inside Rle's 2/n tolerance. *)
Theorem Rdist_triangle : forall x y z, Rle (Rdist x z) (Radd (Rdist x y) (Rdist y z)).
Proof. intros x y z n.
  change (rseq (Rdist x z) n) with (Qabs (rseq x (2*n)%positive + - rseq z (2*n)%positive)).
  change (rseq (Radd (Rdist x y) (Rdist y z)) n)
    with (Qabs (rseq x (4*n)%positive + - rseq y (4*n)%positive)
        + Qabs (rseq y (4*n)%positive + - rseq z (4*n)%positive)).
  pose proof (rreg x (2*n)%positive (4*n)%positive) as Rx. apply Qabs_Qle_condition in Rx.
  pose proof (rreg z (2*n)%positive (4*n)%positive) as Rz. apply Qabs_Qle_condition in Rz.
  pose proof (Qle_Qabs (rseq x (4*n)%positive + - rseq y (4*n)%positive)) as Qxy.
  pose proof (Qle_Qabs (- (rseq x (4*n)%positive + - rseq y (4*n)%positive))) as Qxy'.
  rewrite Qabs_opp in Qxy'.
  pose proof (Qle_Qabs (rseq y (4*n)%positive + - rseq z (4*n)%positive)) as Qyz.
  pose proof (Qle_Qabs (- (rseq y (4*n)%positive + - rseq z (4*n)%positive))) as Qyz'.
  rewrite Qabs_opp in Qyz'.
  assert (Hfrac : (1#(2*n)%positive)+(1#(4*n)%positive) <= (1#n)).
  { repeat rewrite frac_split. assert (0<=(1#n)) by (unfold Qle;simpl;lia). lra. }
  assert (Htol : (2#1)*(1#n) == (1#n)+(1#n)) by ring. rewrite Htol.
  apply Qabs_Qle_condition. split; lra.
Qed.

(* Rabs is 1-LIPSCHITZ: d(|x|,|y|) <= d(x,y).  RHS kept in Qminus form so the
   reverse-triangle hypothesis and the goal share the same opaque Qabs atom. *)
Theorem Rabs_Lipschitz : forall x y, Rle (Rdist (Rabs x) (Rabs y)) (Rdist x y).
Proof. intros x y n.
  change (rseq (Rdist (Rabs x) (Rabs y)) n)
    with (Qabs (Qabs (rseq x (2*n)%positive) + - Qabs (rseq y (2*n)%positive))).
  change (rseq (Rdist x y) n) with (Qabs (rseq x (2*n)%positive - rseq y (2*n)%positive)).
  assert (Hrev : Qabs (Qabs (rseq x (2*n)%positive) + - Qabs (rseq y (2*n)%positive))
              <= Qabs (rseq x (2*n)%positive - rseq y (2*n)%positive)).
  { apply Qabs_Qle_condition. split.
    - pose proof (Qabs_triangle_reverse (rseq y (2*n)%positive) (rseq x (2*n)%positive)) as H.
      rewrite (Qabs_Qminus (rseq y (2*n)%positive) (rseq x (2*n)%positive)) in H. lra.
    - apply Qabs_triangle_reverse. }
  assert (Htol : (2#1)*(1#n) == (1#n)+(1#n)) by ring. rewrite Htol.
  assert (0<=(1#n)) by (unfold Qle;simpl;lia). lra.
Qed.

(* Ropp is an ISOMETRY: d(-x,-y) = d(x,y). *)
Theorem Ropp_isometry : forall x y, Req (Rdist (Ropp x) (Ropp y)) (Rdist x y).
Proof. intros x y n m.
  change (rseq (Rdist (Ropp x) (Ropp y)) n)
    with (Qabs (- rseq x (2*n)%positive + - - rseq y (2*n)%positive)).
  change (rseq (Rdist x y) m) with (Qabs (rseq x (2*m)%positive + - rseq y (2*m)%positive)).
  assert (E : - rseq x (2*n)%positive + - - rseq y (2*n)%positive
          == -(rseq x (2*n)%positive + - rseq y (2*n)%positive)) by ring.
  rewrite (Qabs_wd _ _ E). rewrite Qabs_opp.
  change (Qabs (rseq x (2*n)%positive + - rseq y (2*n)%positive)) with (rseq (Rabs (Rsub x y)) n).
  change (Qabs (rseq x (2*m)%positive + - rseq y (2*m)%positive)) with (rseq (Rabs (Rsub x y)) m).
  apply (rreg (Rabs (Rsub x y)) n m).
Qed.

(* Radd is NON-EXPANSIVE (jointly 1-Lipschitz): d(x+y, x'+y') <= d(x,x') + d(y,y').
   All indices align at 4n, so the triangle is exact (no drift). *)
Theorem Radd_Lipschitz : forall x y x' y',
  Rle (Rdist (Radd x y) (Radd x' y')) (Radd (Rdist x x') (Rdist y y')).
Proof. intros x y x' y' n.
  change (rseq (Rdist (Radd x y) (Radd x' y')) n)
    with (Qabs ((rseq x (4*n)%positive + rseq y (4*n)%positive)
              + - (rseq x' (4*n)%positive + rseq y' (4*n)%positive))).
  change (rseq (Radd (Rdist x x') (Rdist y y')) n)
    with (Qabs (rseq x (4*n)%positive + - rseq x' (4*n)%positive)
        + Qabs (rseq y (4*n)%positive + - rseq y' (4*n)%positive)).
  assert (E : (rseq x (4*n)%positive + rseq y (4*n)%positive)
            + - (rseq x' (4*n)%positive + rseq y' (4*n)%positive)
           == (rseq x (4*n)%positive + - rseq x' (4*n)%positive)
            + (rseq y (4*n)%positive + - rseq y' (4*n)%positive)) by ring.
  rewrite (Qabs_wd _ _ E).
  pose proof (Qabs_triangle (rseq x (4*n)%positive + - rseq x' (4*n)%positive)
                            (rseq y (4*n)%positive + - rseq y' (4*n)%positive)) as Ht.
  assert (Htol : (2#1)*(1#n) == (1#n)+(1#n)) by ring. rewrite Htol.
  assert (0<=(1#n)) by (unfold Qle;simpl;lia). lra.
Qed.

(* ===== POINTWISE CONTINUITY in the real metric (epsilon-delta) ===== *)
Definition Rcontinuous_at (f:RR->RR) (x:RR) : Prop :=
  forall k:positive, exists d:positive,
    forall y:RR, Rle (Rdist x y) (inj_Q (1#d)) -> Rle (Rdist (f x) (f y)) (inj_Q (1#k)).

(* the identity function is continuous everywhere. *)
Theorem Rcontinuous_id : forall x, Rcontinuous_at (fun z => z) x.
Proof. intros x k. exists k. intros y H. exact H. Qed.

(* absolute value is continuous everywhere (delta = epsilon, via 1-Lipschitz). *)
Theorem Rcontinuous_Rabs : forall x, Rcontinuous_at Rabs x.
Proof. intros x k. exists k. intros y H.
  apply (Rle_trans _ (Rdist x y) _).
  - apply Rabs_Lipschitz.
  - exact H.
Qed.

Open Scope nat_scope.

(* ===================================================================== *)
(*  CLASSICAL LAYER (isolated and explicitly flagged).                    *)
(*  Everything ABOVE this line is fully constructive and axiom-free.       *)
(*  Closing the classical frontier (classical consistency of PA) requires  *)
(*  classical logic in the meta-theory -- unavoidably, since classical     *)
(*  soundness of the excluded-middle schema is exactly excluded middle.    *)
(*  We import that single, universally-accepted, consistent principle      *)
(*  (classic : forall P, P \/ ~P) explicitly. Print Assumptions on the     *)
(*  classical theorems shows `classic` as the SOLE axiom; the constructive *)
(*  corpus above is unaffected and stays "Closed under the global context".*)
(* ===================================================================== *)
Require Import Coq.Logic.Classical.

(* classical proof system: the intuitionistic calculus plus excluded middle *)
Inductive ProvC (T:Fm->Prop) : Fm -> Prop :=
| C_ax  : forall f, T f -> ProvC T f
| C_mp  : forall p q, ProvC T (Fimp p q) -> ProvC T p -> ProvC T q
| C_K   : forall p q, ProvC T (Fimp p (Fimp q p))
| C_S   : forall p q r, ProvC T (Fimp (Fimp p (Fimp q r)) (Fimp (Fimp p q) (Fimp p r)))
| C_refl: forall t, ProvC T (Feq t t)
| C_notE: forall p q, ProvC T (Fimp (Fnot p) (Fimp p q))
| C_allE: forall p t, ProvC T (Fall p) -> ProvC T (subst_fm (scons t tvar) p)
| C_exI : forall p t, ProvC T (subst_fm (scons t tvar) p) -> ProvC T (Fex p)
| C_gen : forall p, ProvC T p -> ProvC T (Fall p)
| C_lem : forall p, ProvC T (For p (Fnot p)).

(* classical soundness w.r.t. the D-semantics (LEM case discharged by `classic`) *)
Theorem soundnessC:
  forall (T:Fm->Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    forall f, ProvC T f ->
    forall env, (forall a, T a -> satD env a) -> satD env f.
Proof.
  intros T Hclosed f Hp.
  induction Hp as
    [g Hg | p q Hpq IHpq Hp2 IHp2 | p q | p q r | t | p q
    | p t Hall IHall | p t Hsub IHsub | p Hgen IHgen | p ];
    intros env Henv; simpl in *.
  - apply Henv; exact Hg.
  - exact (IHpq env Henv (IHp2 env Henv)).
  - intros H1 H2; exact H1.
  - intros H1 H2 H3; apply H1; [exact H3 | apply H2; exact H3].
  - reflexivity.
  - intros H1 H2; destruct (H1 H2).
  - apply (proj2 (satD_subst p (scons t tvar) env)).
    apply (proj1 (satD_ext p (consD (evD env t) env)
                            (fun v=>evD env (scons t tvar v))
                  (fun v => match v with 0=>eq_refl | S k=>eq_refl end))).
    exact (IHall env Henv (evD env t)).
  - specialize (IHsub env Henv).
    apply (proj1 (satD_subst p (scons t tvar) env)) in IHsub.
    apply (proj1 (satD_ext p (fun v=>evD env (scons t tvar v))
                            (consD (evD env t) env)
                  (fun v => match v with 0=>eq_refl | S k=>eq_refl end))) in IHsub.
    exists (evD env t); exact IHsub.
  - intro d. apply (IHgen (consD d env)). intros a Ha.
    apply (proj1 (Hclosed a env (consD d env) Ha)). exact (Henv a Ha).
  - apply classic.
Qed.

Theorem consistencyC:
  forall (T:Fm->Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    (exists env, forall a, T a -> satD env a) ->
    ~ ProvC T Fbot.
Proof.
  intros T Hclosed [env Henv] Hpr.
  pose proof (soundnessC T Hclosed Fbot Hpr env Henv) as Hb.
  simpl in Hb. apply Hb; reflexivity.
Qed.

(* CLASSICAL CONSISTENCY OF PA, witnessed by the RD model D.
   Sole axiom: classic (law of excluded middle). *)
Theorem Con_PA_classical : ~ ProvC PA Fbot.
Proof.
  apply (consistencyC PA PA_closed).
  exists (fun _ => zero). intros a Ha. exact (D_models_PA (fun _ => zero) a Ha).
Qed.

Print Assumptions RD3_succ_ne_zero.
Print Assumptions RD4_succ_inj.
Print Assumptions add_assoc.
Print Assumptions add_comm.
Print Assumptions mul_comm.
Print Assumptions mul_assoc.
Print Assumptions mul_add.
Print Assumptions add_mul.
Print Assumptions mul_one.
Print Assumptions le_refl.
Print Assumptions le_trans.
Print Assumptions le_antisym.
Print Assumptions le_total.
Print Assumptions add_cancel_r.
Print Assumptions iso_to_of.
Print Assumptions iso_of_to.
Print Assumptions toNat_add.
Print Assumptions toNat_mul.
Print Assumptions eval_hom.
Print Assumptions lt_irrefl.
Print Assumptions lt_trans.
Print Assumptions lt_trichotomy.
Print Assumptions lt_wf.
Print Assumptions strong_induction.
Print Assumptions eqn_transfer.
Print Assumptions sat_transfer.
Print Assumptions sentence_transfer.
Print Assumptions satD_subst.
Print Assumptions soundness.
Print Assumptions consistency.
Print Assumptions prov_sound_N.
Print Assumptions D_validates_induction.
Print Assumptions D_models_PA.
Print Assumptions Con_PA.
Print Assumptions PA_true_in_N.
Print Assumptions categoricity.
Print Assumptions dist_self.
Print Assumptions dist_eq0.
Print Assumptions dist_pos.
Print Assumptions dist_sym.
Print Assumptions dist_tri.
Print Assumptions Betw_id.
Print Assumptions Betw_sym.
Print Assumptions Betw_refl_l.
Print Assumptions dist2_self.
Print Assumptions dist2_eq0.
Print Assumptions dist2_sym.
Print Assumptions dist2_tri.
Print Assumptions zeq_refl.
Print Assumptions zeq_sym.
Print Assumptions zeq_trans.
Print Assumptions zadd_cong.
Print Assumptions zneg_cong.
Print Assumptions zmul_cong.
Print Assumptions zadd_comm.
Print Assumptions zadd_assoc.
Print Assumptions zadd_0_l.
Print Assumptions zadd_neg.
Print Assumptions zmul_comm.
Print Assumptions zmul_assoc.
Print Assumptions zmul_1_l.
Print Assumptions zmul_distrib_l.
Print Assumptions FTC.
Print Assumptions FTC_inverse.
Print Assumptions Leibniz.
Print Assumptions qadd_neg.
Print Assumptions qmul_assoc.
Print Assumptions qmul_distrib_l.
Print Assumptions qmul_inv.
Print Assumptions Req_refl.
Print Assumptions Req_sym.
Print Assumptions Req_trans.
Print Assumptions Radd_comm.
Print Assumptions Radd_0_l.
Print Assumptions Radd_opp.
Print Assumptions Rle_refl.
Print Assumptions Rle_trans.
Print Assumptions Rle_antisym.
Print Assumptions inj_Q_le.
Print Assumptions Radd_le_mono_r.
Print Assumptions Rlt_irrefl.
Print Assumptions Rbound.
Print Assumptions Rmul.
Print Assumptions Rmul_comm.
Print Assumptions Rmul_1_l.
Print Assumptions prod_reg.
Print Assumptions prod_mix.
Print Assumptions Rmul_wd.
Print Assumptions prod_reg2_k.
Print Assumptions prod_reg3_k.
Print Assumptions Rmul_distrib_l.
Print Assumptions Rmul_assoc.
Print Assumptions R_complete.
Print Assumptions Rabs.
Print Assumptions R_complete_metric.
Print Assumptions Rinv.
Print Assumptions Rmul_inv.
Print Assumptions Rinv_gen.
Print Assumptions Rmul_inv_gen.
Print Assumptions Rlt_le_weak.
Print Assumptions Rlt_trans.
Print Assumptions Rlt_cotrans.
Print Assumptions Rmax.
Print Assumptions Rmin.
Print Assumptions Rle_max_l.
Print Assumptions Rle_max_r.
Print Assumptions Rmax_lub.
Print Assumptions Rmin_le_l.
Print Assumptions Rmin_le_r.
Print Assumptions Rmin_glb.
Print Assumptions Rconv_const.
Print Assumptions Rconv_recip.
Print Assumptions Rlimit_unique.
Print Assumptions Rcomplete_conv.
Print Assumptions Rdist_self.
Print Assumptions Rdist_sym.
Print Assumptions Rdist_nonneg.
Print Assumptions Rdist_triangle.
Print Assumptions Rabs_Lipschitz.
Print Assumptions Ropp_isometry.
Print Assumptions Radd_Lipschitz.
Print Assumptions Rcontinuous_id.
Print Assumptions Rcontinuous_Rabs.
Print Assumptions Con_PA_classical.
