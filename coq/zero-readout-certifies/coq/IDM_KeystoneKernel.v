(* ===================================================================== *)
(*  IDM_KeystoneKernel.v ? the CONVERSE of the keystone: zero retained    *)
(*  information is EXACTLY non-distinction.                               *)
(*                                                                        *)
(*  Companion to IDM_Keystone.v (B(Phi,Phi) = I(Phi)).  That theorem identifies  *)
(*  the Dirichlet form with the retained information.  This one identifies *)
(*  its KERNEL: B(Phi,Phi) = 0 holds precisely when Phi retains no distinction   *)
(*  across any edge, hence is constant on every connected component.       *)
(*                                                                        *)
(*  Coq 8.18+, over Q, no Reals / no classical axioms.                    *)
(* ===================================================================== *)

Require Import List.
Require Import QArith.
Import ListNotations.
Open Scope Q_scope.

Definition edge := (nat * nat * Q)%type.
Definition Phi := nat -> Q.

Definition I_edge (phi : Phi) (e : edge) : Q :=
  let '(i, j, w) := e in  w * ((phi i - phi j) * (phi i - phi j)).

Definition I_form (phi : Phi) (g : list edge) : Q :=
  fold_right (fun e acc => I_edge phi e + acc) 0 g.

(* ---------------------------------------------------------------- *)
(*  Arithmetic groundwork over Q.                                     *)
(* ---------------------------------------------------------------- *)

Lemma Qsq_nonneg : forall x : Q, 0 <= x * x.
Proof.
  intro x. destruct (Qlt_le_dec x 0) as [Hlt | Hge].
  - assert (Hnx : 0 <= - x).
    { apply Qlt_le_weak. apply Qopp_lt_compat in Hlt.
      setoid_replace (- 0) with 0 in Hlt by ring. exact Hlt. }
    setoid_replace (x * x) with ((- x) * (- x)) by ring.
    apply Qmult_le_0_compat; exact Hnx.
  - apply Qmult_le_0_compat; exact Hge.
Qed.

Lemma Qadd_nonneg : forall a b : Q, 0 <= a -> 0 <= b -> 0 <= a + b.
Proof.
  intros a b Ha Hb.
  setoid_replace 0 with (0 + 0) by ring.
  apply Qplus_le_compat; assumption.
Qed.

(* A square vanishes only at zero ? the Q integral-domain step. *)
Lemma Qsq_zero : forall x : Q, x * x == 0 -> x == 0.
Proof.
  intros x H. destruct (Qmult_integral _ _ H) as [Hx | Hx]; exact Hx.
Qed.

(* A sum of two nonnegatives vanishes only if both do. *)
Lemma Qplus_nonneg_eq0 :
  forall a b : Q, 0 <= a -> 0 <= b -> a + b == 0 -> a == 0 /\ b == 0.
Proof.
  intros a b Ha Hb Hsum.
  assert (Hale : a <= a + b).
  { setoid_replace a with (a + 0) at 1 by ring.
    apply Qplus_le_r. exact Hb. }
  assert (Ha0 : a == 0).
  { apply Qle_antisym; [ rewrite <- Hsum; exact Hale | exact Ha ]. }
  split; [ exact Ha0 |].
  rewrite Ha0 in Hsum. rewrite Qplus_0_l in Hsum. exact Hsum.
Qed.

(* ---------------------------------------------------------------- *)
(*  Edge-level: with a strictly positive weight, an edge carries zero *)
(*  retained information exactly when it retains no distinction.      *)
(* ---------------------------------------------------------------- *)

Lemma I_edge_nonneg :
  forall phi e, (let '(_,_,w) := e in 0 <= w) -> 0 <= I_edge phi e.
Proof.
  intros phi [[i j] w] Hw. unfold I_edge.
  apply Qmult_le_0_compat; [exact Hw | apply Qsq_nonneg].
Qed.

Lemma I_edge_zero_iff :
  forall phi i j w,
    0 < w ->
    (I_edge phi (i, j, w) == 0 <-> phi i == phi j).
Proof.
  intros phi i j w Hw. unfold I_edge. split.
  - intro H.
    destruct (Qmult_integral _ _ H) as [Hw0 | Hd].
    + exfalso. rewrite Hw0 in Hw. apply (Qlt_irrefl 0). exact Hw.
    + apply Qsq_zero in Hd.
      apply Qplus_inj_r with (z := - phi j).
      setoid_replace (phi i + - phi j) with (phi i - phi j) by ring.
      setoid_replace (phi j + - phi j) with 0 by ring.
      exact Hd.
  - intro H.
    setoid_replace (phi i - phi j) with 0 by (rewrite H; ring).
    ring.
Qed.

(* ---------------------------------------------------------------- *)
(*  Graph-level: the total vanishes exactly when every edge does.     *)
(* ---------------------------------------------------------------- *)

Lemma I_form_zero_forall :
  forall phi g,
    (forall e, In e g -> let '(_,_,w) := e in 0 <= w) ->
    I_form phi g == 0 ->
    forall e, In e g -> I_edge phi e == 0.
Proof.
  intros phi g. induction g as [| e0 es IH]; intros Hw Hsum e Hin.
  - inversion Hin.
  - simpl in Hsum.
    assert (H0 : 0 <= I_edge phi e0).
    { apply I_edge_nonneg. apply Hw. left; reflexivity. }
    assert (Hrest : 0 <= I_form phi es).
    { clear Hsum Hin IH. induction es as [| e1 es1 IH1]; simpl.
      - apply Qle_refl.
      - apply Qadd_nonneg.
        + apply I_edge_nonneg. apply Hw. right; left; reflexivity.
        + apply IH1. intros e' Hin'. apply Hw.
          destruct Hin' as [Heq | Hin''].
          * left; exact Heq.
          * right; right; exact Hin''. }
    destruct (Qplus_nonneg_eq0 _ _ H0 Hrest Hsum) as [He0 Hes].
    destruct Hin as [Heq | Hin'].
    + rewrite <- Heq. exact He0.
    + apply IH; [| exact Hes | exact Hin'].
      intros e' Hin''. apply Hw. right; exact Hin''.
Qed.

(* ---------------------------------------------------------------- *)
(*  THEOREM (kernel of the keystone, edge form).                      *)
(*  With strictly positive weights, zero retained information is       *)
(*  EXACTLY the absence of a retained distinction on every edge.       *)
(* ---------------------------------------------------------------- *)

Theorem keystone_zero_iff_edge :
  forall (phi : Phi) (g : list edge),
    (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
    (I_form phi g == 0 <-> forall i j w, In (i,j,w) g -> phi i == phi j).
Proof.
  intros phi g Hpos. split.
  - intros Hzero i j w Hin.
    assert (Hw : 0 < w) by (apply (Hpos (i,j,w)); exact Hin).
    apply (I_edge_zero_iff phi i j w Hw).
    apply (I_form_zero_forall phi g).
    + intros e He. specialize (Hpos e He).
      destruct e as [[a b] c]. apply Qlt_le_weak. exact Hpos.
    + exact Hzero.
    + exact Hin.
  - intros Hall. induction g as [| e0 es IH]; simpl.
    + reflexivity.
    + destruct e0 as [[i0 j0] w0].
      assert (Hw0 : 0 < w0) by (apply (Hpos (i0,j0,w0)); left; reflexivity).
      assert (He0 : I_edge phi (i0,j0,w0) == 0).
      { apply (I_edge_zero_iff phi i0 j0 w0 Hw0).
        apply (Hall i0 j0 w0). left; reflexivity. }
      rewrite He0. rewrite Qplus_0_l.
      apply IH.
      * intros e He. apply Hpos. right; exact He.
      * intros i j w Hin. apply (Hall i j w). right; exact Hin.
Qed.

(* ---------------------------------------------------------------- *)
(*  Connectivity: distinction propagates along paths, so the kernel   *)
(*  is exactly the set of fields constant on connected components.    *)
(* ---------------------------------------------------------------- *)

Definition adj (g : list edge) (i j : nat) : Prop :=
  (exists w, In (i,j,w) g) \/ (exists w, In (j,i,w) g).

Inductive reach (g : list edge) : nat -> nat -> Prop :=
| reach_refl : forall i, reach g i i
| reach_step : forall i j k, adj g i j -> reach g j k -> reach g i k.

Lemma edge_gives_reach :
  forall g i j w, In (i,j,w) g -> reach g i j.
Proof.
  intros g i j w Hin.
  apply (reach_step g i j j).
  - left. exists w. exact Hin.
  - apply reach_refl.
Qed.

Theorem keystone_zero_iff_component :
  forall (phi : Phi) (g : list edge),
    (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
    (I_form phi g == 0 <-> forall i j, reach g i j -> phi i == phi j).
Proof.
  intros phi g Hpos. split.
  - intros Hzero i j Hr.
    assert (Hedge : forall a b w, In (a,b,w) g -> phi a == phi b).
    { apply (keystone_zero_iff_edge phi g Hpos). exact Hzero. }
    induction Hr as [i | i j k Hadj Hr IH].
    + reflexivity.
    + assert (Hij : phi i == phi j).
      { destruct Hadj as [[w Hin] | [w Hin]].
        - apply (Hedge i j w). exact Hin.
        - symmetry. apply (Hedge j i w). exact Hin. }
      rewrite Hij. exact IH.
  - intros Hreach.
    apply (keystone_zero_iff_edge phi g Hpos).
    intros i j w Hin.
    apply Hreach. apply (edge_gives_reach g i j w). exact Hin.
Qed.

(* ---------------------------------------------------------------- *)
(*  Reading.  delta_R is the primitive: a retained difference exists.  *)
(*  keystone_B_eq_I identifies the Dirichlet form with the retained    *)
(*  information; the theorems above identify its zero locus with the    *)
(*  failure of delta_R.  Zero is therefore not one value among others   *)
(*  in the range of the readout: it is the fibre over non-distinction.  *)
(* ---------------------------------------------------------------- *)

(* ===================================================================== *)
(*  PART II - the kernel is a subspace, and indistinguishability is an     *)
(*  equivalence.  This is what licenses calling 0 an equivalence class     *)
(*  rather than merely a fibre.                                           *)
(* ===================================================================== *)

Definition Fzero  : Phi := fun _ => 0.
Definition Fadd   (a b : Phi) : Phi := fun n => a n + b n.
Definition Fscale (c : Q) (a : Phi) : Phi := fun n => c * a n.
Definition Fsub   (a b : Phi) : Phi := fun n => a n - b n.

(* I_form only depends on the field up to pointwise equality. *)
Lemma I_form_ext :
  forall (a b : Phi) (g : list edge),
    (forall n, a n == b n) -> I_form a g == I_form b g.
Proof.
  intros a b g H. induction g as [| e es IH]; simpl.
  - reflexivity.
  - destruct e as [[i j] w]. unfold I_edge.
    rewrite (H i), (H j), IH. reflexivity.
Qed.

(* --- the kernel contains the zero field ------------------------------- *)
Theorem kernel_zero :
  forall g, (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
            I_form Fzero g == 0.
Proof.
  intros g Hpos. apply (keystone_zero_iff_edge Fzero g Hpos).
  intros i j w Hin. unfold Fzero. reflexivity.
Qed.

(* --- the kernel is closed under addition ------------------------------ *)
Theorem kernel_add :
  forall (a b : Phi) (g : list edge),
    (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
    I_form a g == 0 -> I_form b g == 0 -> I_form (Fadd a b) g == 0.
Proof.
  intros a b g Hpos Ha Hb.
  assert (Ea : forall i j w, In (i,j,w) g -> a i == a j)
    by (apply (keystone_zero_iff_edge a g Hpos); exact Ha).
  assert (Eb : forall i j w, In (i,j,w) g -> b i == b j)
    by (apply (keystone_zero_iff_edge b g Hpos); exact Hb).
  apply (keystone_zero_iff_edge (Fadd a b) g Hpos).
  intros i j w Hin. unfold Fadd.
  rewrite (Ea i j w Hin), (Eb i j w Hin). reflexivity.
Qed.

(* --- the kernel is closed under scalar multiplication ----------------- *)
Theorem kernel_scale :
  forall (c : Q) (a : Phi) (g : list edge),
    (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
    I_form a g == 0 -> I_form (Fscale c a) g == 0.
Proof.
  intros c a g Hpos Ha.
  assert (Ea : forall i j w, In (i,j,w) g -> a i == a j)
    by (apply (keystone_zero_iff_edge a g Hpos); exact Ha).
  apply (keystone_zero_iff_edge (Fscale c a) g Hpos).
  intros i j w Hin. unfold Fscale.
  rewrite (Ea i j w Hin). reflexivity.
Qed.

(* --- indistinguishability under the readout --------------------------- *)
Definition indist (g : list edge) (a b : Phi) : Prop := I_form (Fsub a b) g == 0.

Theorem indist_refl :
  forall g a, (forall e, In e g -> let '(_,_,w) := e in 0 < w) -> indist g a a.
Proof.
  intros g a Hpos. unfold indist.
  apply (keystone_zero_iff_edge (Fsub a a) g Hpos).
  intros i j w Hin. unfold Fsub. ring.
Qed.

Theorem indist_sym :
  forall g a b, (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
                indist g a b -> indist g b a.
Proof.
  intros g a b Hpos H. unfold indist in *.
  assert (E : forall i j w, In (i,j,w) g -> (Fsub a b) i == (Fsub a b) j)
    by (apply (keystone_zero_iff_edge (Fsub a b) g Hpos); exact H).
  apply (keystone_zero_iff_edge (Fsub b a) g Hpos).
  intros i j w Hin. specialize (E i j w Hin). unfold Fsub in *.
  apply Qopp_comp in E.
  setoid_replace (b i - a i) with (- (a i - b i)) by ring.
  setoid_replace (b j - a j) with (- (a j - b j)) by ring.
  exact E.
Qed.

Theorem indist_trans :
  forall g a b c, (forall e, In e g -> let '(_,_,w) := e in 0 < w) ->
                  indist g a b -> indist g b c -> indist g a c.
Proof.
  intros g a b c Hpos Hab Hbc. unfold indist in *.
  assert (Eab : forall i j w, In (i,j,w) g -> (Fsub a b) i == (Fsub a b) j)
    by (apply (keystone_zero_iff_edge (Fsub a b) g Hpos); exact Hab).
  assert (Ebc : forall i j w, In (i,j,w) g -> (Fsub b c) i == (Fsub b c) j)
    by (apply (keystone_zero_iff_edge (Fsub b c) g Hpos); exact Hbc).
  apply (keystone_zero_iff_edge (Fsub a c) g Hpos).
  intros i j w Hin.
  specialize (Eab i j w Hin). specialize (Ebc i j w Hin).
  unfold Fsub in *.
  setoid_replace (a i - c i) with ((a i - b i) + (b i - c i)) by ring.
  setoid_replace (a j - c j) with ((a j - b j) + (b j - c j)) by ring.
  rewrite Eab, Ebc. reflexivity.
Qed.
