Require Coq.Arith.PeanoNat.
Require Coq.Bool.Bool.
Require Coq.Classes.Morphisms.
Require Coq.Classes.RelationClasses.
Require Coq.Lists.List.
Require Coq.Logic.Classical.
Require Coq.QArith.QArith.
Require Coq.Setoids.Setoid.
Require Coq.Sorting.Permutation.
Require Coq.ZArith.ZArith.
Require Coq.micromega.Lia.
Require Coq.micromega.Lqa.
Require Field.
Require Lia.
Require List.
Require PeanoNat.
Require Permutation.
Require QArith.
Require Qabs.
Require Qminmax.
Require Qround.
Require Wf_nat.
Require ZArith.

Module URCF08ModelsPA.

Import PeanoNat.
Import Wf_nat.
Import Lia.
Import ZArith.
Import QArith.
Import Field.
Import Qabs.
Import Qminmax.
Import Qround.
Import Coq.micromega.Lqa.
Open Scope nat_scope.

Inductive D : Type :=
  | zero : D
  | succ : D -> D.

Theorem RD3_succ_ne_zero : forall x : D, succ x <> zero.
Proof. intros x H. discriminate H. Qed.

Theorem RD4_succ_inj : forall x y : D, succ x = succ y -> x = y.
Proof. intros x y H. congruence. Qed.

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

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions D_validates_induction.
Print Assumptions D_models_PA.

End URCF08ModelsPA.
