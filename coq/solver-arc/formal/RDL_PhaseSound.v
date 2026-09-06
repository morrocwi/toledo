(* ===================================================================== *)
(*  RDL_PhaseSound.v  --  LL-SEQUENT SOUNDNESS of RDL's linear (MALL)      *)
(*  calculus against the Girard PHASE / QUANTALE model.                    *)
(*                                                                        *)
(*  Bridge:  RDL_Involution.v (one-sided MALL calculus + involutive dual)  *)
(*           <->  RDL_Phase.v (orthogonality closure, fact lattice).       *)
(*  Self-contained: re-declares the phase algebra and the MALL syntax so   *)
(*  that  coqc RDL_PhaseSound.v  checks standalone.                        *)
(*                                                                        *)
(*  THEOREM (Girard phase soundness, multiplicative-additive LL):          *)
(*    every provable one-sided sequent  |- A_1,...,A_n  is VALID in every   *)
(*    phase space: the product of the orthogonals of the formulas lands    *)
(*    in the pole.  Equivalently  e in (par_i [[A_i]]).                     *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free (no funext / prop-ext / classical   *)
(*  / choice):                                                             *)
(*    sem_dual    [[dual A]] ~ [[A]]^perp   (syntactic De Morgan =          *)
(*                semantic orthogonal: additive + multiplicative cases)     *)
(*    sem_fact    every [[A]] is a fact                                    *)
(*    peel        Valid (A::G) <-> Inc (Den G) [[A]]   (the adjunction)     *)
(*    soundness   Prov G -> Valid G        (induction over ALL rules)       *)
(*    consistent  ~ Prov []                (absurdity not provable;         *)
(*                proved SEMANTICALLY via a one-point phase collapse)       *)
(* ===================================================================== *)

Require Import Coq.Lists.List. Import ListNotations.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Arith.PeanoNat.
Require Import Lia.

(* ===================================================================== *)
(*  PART A -- the MALL syntax and the involutive negation (M-independent)  *)
(* ===================================================================== *)

Inductive Frm :=
| at_   : nat -> Frm
| dat_  : nat -> Frm
| tens  : Frm -> Frm -> Frm
| par   : Frm -> Frm -> Frm
| one   : Frm
| bot   : Frm
| awith : Frm -> Frm -> Frm
| oplus : Frm -> Frm -> Frm
| top   : Frm
| zero  : Frm.

Fixpoint dual (A:Frm) : Frm :=
  match A with
  | at_ n      => dat_ n
  | dat_ n     => at_ n
  | tens A B   => par   (dual A) (dual B)
  | par A B    => tens  (dual A) (dual B)
  | one        => bot
  | bot        => one
  | awith A B  => oplus (dual A) (dual B)
  | oplus A B  => awith (dual A) (dual B)
  | top        => zero
  | zero       => top
  end.

Theorem dual_involutive : forall A, dual (dual A) = A.
Proof.
  induction A; simpl; try reflexivity; rewrite IHA1, IHA2; reflexivity.
Qed.

Inductive Prov : list Frm -> Prop :=
| p_ax     : forall n,       Prov [at_ n; dat_ n]
| p_exch   : forall G D,     Permutation G D -> Prov G -> Prov D
| p_cut    : forall G D A,   Prov (A::G) -> Prov (dual A::D) -> Prov (G++D)
| p_tens   : forall G D A B, Prov (A::G) -> Prov (B::D) -> Prov (tens A B::(G++D))
| p_par    : forall G A B,   Prov (A::B::G) -> Prov (par A B::G)
| p_one    :                 Prov [one]
| p_bot    : forall G,       Prov G -> Prov (bot::G)
| p_with   : forall G A B,   Prov (A::G) -> Prov (B::G) -> Prov (awith A B::G)
| p_oplus1 : forall G A B,   Prov (A::G) -> Prov (oplus A B::G)
| p_oplus2 : forall G A B,   Prov (B::G) -> Prov (oplus A B::G)
| p_top    : forall G,       Prov (top::G).

(* ===================================================================== *)
(*  PART B -- the phase model and the soundness theorem                    *)
(* ===================================================================== *)

Section PhaseSound.
Variable M : Type.
Variable op : M -> M -> M.
Variable e : M.
Hypothesis op_comm  : forall a b, op a b = op b a.
Hypothesis op_assoc : forall a b c, op a (op b c) = op (op a b) c.
Hypothesis op_unit  : forall a, op e a = a.
Variable pole : M -> Prop.

Definition Ens := M -> Prop.
Definition Inc   (X Y:Ens) : Prop := forall m, X m -> Y m.
Definition Equiv (X Y:Ens) : Prop := Inc X Y /\ Inc Y X.

Lemma inc_refl  : forall X, Inc X X.                           Proof. intros X m H; exact H. Qed.
Lemma inc_trans : forall X Y Z, Inc X Y -> Inc Y Z -> Inc X Z. Proof. intros X Y Z H1 H2 m H; apply H2, H1, H. Qed.

Lemma equiv_refl  : forall X, Equiv X X.                       Proof. intros X; split; apply inc_refl. Qed.
Lemma equiv_sym   : forall X Y, Equiv X Y -> Equiv Y X.        Proof. intros X Y [H1 H2]; split; assumption. Qed.
Lemma equiv_trans : forall X Y Z, Equiv X Y -> Equiv Y Z -> Equiv X Z.
Proof. intros X Y Z [H1 H2] [H3 H4]; split; eapply inc_trans; eassumption. Qed.

Definition orth (X:Ens) : Ens := fun m => forall x, X x -> pole (op m x).

Lemma orth_antitone : forall X Y, Inc X Y -> Inc (orth Y) (orth X).
Proof. intros X Y H m Hm x Hx. apply Hm. apply H. exact Hx. Qed.

Lemma inc_orth_orth : forall X, Inc X (orth (orth X)).
Proof. intros X m HX y Hy. rewrite (op_comm m y). apply Hy. exact HX. Qed.

Lemma orth3 : forall X, Equiv (orth (orth (orth X))) (orth X).
Proof.
  intros X. split.
  - apply orth_antitone. apply inc_orth_orth.
  - apply (inc_orth_orth (orth X)).
Qed.

Lemma equiv_orth : forall A B, Equiv A B -> Equiv (orth A) (orth B).
Proof. intros A B [H1 H2]. split; apply orth_antitone; assumption. Qed.

Lemma clo_mono : forall A B, Inc A B -> Inc (orth (orth A)) (orth (orth B)).
Proof. intros A B H. apply orth_antitone. apply orth_antitone. exact H. Qed.

Lemma equiv_clo : forall A B, Equiv A B -> Equiv (orth (orth A)) (orth (orth B)).
Proof. intros A B H. apply equiv_orth. apply equiv_orth. exact H. Qed.

Definition Fact (X:Ens) : Prop := Inc (orth (orth X)) X.

Lemma orth_fact     : forall X, Fact (orth X).        Proof. intros X. unfold Fact. apply (orth3 X). Qed.
Lemma fact_orthorth : forall Z, Fact (orth (orth Z)). Proof. intros Z. apply (orth_fact (orth Z)). Qed.
Lemma fact_equiv    : forall X, Fact X -> Equiv (orth (orth X)) X.
Proof. intros X HF. split; [ exact HF | apply inc_orth_orth ]. Qed.

Definition pmul (X Y:Ens) : Ens := fun m => exists a b, X a /\ Y b /\ m = op a b.
Definition unitSet : Ens := fun m => m = e.

Lemma pmul_comm : forall X Y, Equiv (pmul X Y) (pmul Y X).
Proof.
  intros X Y. split; intros m [a [b [Ha [Hb Hm]]]];
    exists b, a; repeat split; try assumption; rewrite Hm; apply op_comm.
Qed.

Lemma pmul_mono : forall X X' Y Y', Inc X X' -> Inc Y Y' -> Inc (pmul X Y) (pmul X' Y').
Proof.
  intros X X' Y Y' HX HY m [a [b [Ha [Hb Hm]]]].
  exists a, b. repeat split; [ exact (HX a Ha) | exact (HY b Hb) | exact Hm ].
Qed.

Lemma pmul_equiv : forall X X' Y Y', Equiv X X' -> Equiv Y Y' -> Equiv (pmul X Y) (pmul X' Y').
Proof. intros X X' Y Y' [HX1 HX2] [HY1 HY2]. split; apply pmul_mono; assumption. Qed.

Lemma pmul_assoc : forall X Y Z, Equiv (pmul X (pmul Y Z)) (pmul (pmul X Y) Z).
Proof.
  intros X Y Z. split.
  - intros m [a [w [Ha [[b [c [Hb [Hc Hw]]]] Hm]]]].
    subst w. subst m. exists (op a b), c.
    repeat split; [ exists a, b; split; [exact Ha|split; [exact Hb|reflexivity]]
                  | exact Hc | exact (op_assoc a b c) ].
  - intros m [u [c [[a [b [Ha [Hb Hu]]]] [Hc Hm]]]].
    subst u. subst m. exists a, (op b c).
    repeat split; [ exact Ha
                  | exists b, c; split; [exact Hb|split; [exact Hc|reflexivity]]
                  | symmetry; apply op_assoc ].
Qed.

Lemma pmul_unit_l : forall X, Equiv (pmul unitSet X) X.
Proof.
  intros X. split.
  - intros m [a [b [Ha [Hb Hm]]]]. unfold unitSet in Ha. subst a.
    rewrite Hm. rewrite (op_unit b). exact Hb.
  - intros m Hm. exists e, m. split;
      [ reflexivity | split; [ exact Hm | rewrite (op_unit m); reflexivity ] ].
Qed.

Lemma pmul_unit_r : forall X, Equiv (pmul X unitSet) X.
Proof. intros X. apply (equiv_trans _ (pmul unitSet X) _); [ apply pmul_comm | apply pmul_unit_l ]. Qed.

Lemma pmul_swap : forall X Y Z, Equiv (pmul X (pmul Y Z)) (pmul Y (pmul X Z)).
Proof.
  intros X Y Z.
  apply (equiv_trans _ (pmul (pmul X Y) Z) _); [ apply pmul_assoc | ].
  apply (equiv_trans _ (pmul (pmul Y X) Z) _).
  - apply pmul_equiv; [ apply pmul_comm | apply equiv_refl ].
  - apply equiv_sym. apply pmul_assoc.
Qed.

(* THE ADJUNCTION: product into the pole = inclusion into the orthogonal. *)
Lemma pmul_orth_adj : forall P Q, Inc (pmul P Q) pole <-> Inc Q (orth P).
Proof.
  intros P Q. split.
  - intros H q Hq x Hx. rewrite (op_comm q x). apply H.
    exists x, q. split; [ exact Hx | split; [ exact Hq | reflexivity ] ].
  - intros H m [a [b [Ha [Hb Hm]]]]. rewrite Hm. rewrite (op_comm a b).
    exact (H b Hb a Ha).
Qed.

Lemma orth_union_split : forall X Y,
  Equiv (orth (fun m => X m \/ Y m)) (fun m => orth X m /\ orth Y m).
Proof.
  intros X Y. split.
  - intros g Hg. split; intros x Hx; apply Hg; [ left | right ]; exact Hx.
  - intros g [HgX HgY] x [Hx | Hy]; [ exact (HgX x Hx) | exact (HgY x Hy) ].
Qed.

Lemma union_equiv : forall X X' Y Y',
  Equiv X X' -> Equiv Y Y' ->
  Equiv (fun m => X m \/ Y m) (fun m => X' m \/ Y' m).
Proof.
  intros X X' Y Y' [HX1 HX2] [HY1 HY2]. split; intros m [h | h];
    [ left; exact (HX1 m h) | right; exact (HY1 m h)
    | left; exact (HX2 m h) | right; exact (HY2 m h) ].
Qed.

Definition tensF (X Y:Ens) : Ens := orth (orth (pmul X Y)).
Definition parF  (X Y:Ens) : Ens := orth (pmul (orth X) (orth Y)).
Definition oneF  : Ens := orth (orth unitSet).
Definition botF  : Ens := orth unitSet.
Definition withF (X Y:Ens) : Ens := fun m => X m /\ Y m.
Definition plusF (X Y:Ens) : Ens := orth (orth (fun m => X m \/ Y m)).
Definition topF  : Ens := fun _ => True.
Definition zeroF : Ens := orth topF.

Lemma with_fact : forall X Y, Fact X -> Fact Y -> Fact (withF X Y).
Proof.
  intros X Y HX HY m Hm. split.
  - apply HX. apply (clo_mono (withF X Y) X); [ intros z [Hz _]; exact Hz | exact Hm ].
  - apply HY. apply (clo_mono (withF X Y) Y); [ intros z [_ Hz]; exact Hz | exact Hm ].
Qed.

Lemma withF_equiv : forall X X' Y Y',
  Equiv X X' -> Equiv Y Y' -> Equiv (withF X Y) (withF X' Y').
Proof.
  intros X X' Y Y' [HX1 HX2] [HY1 HY2]. split; intros m [hx hy]; split;
    [ exact (HX1 m hx) | exact (HY1 m hy) | exact (HX2 m hx) | exact (HY2 m hy) ].
Qed.

Variable v : nat -> Ens.
Hypothesis Vfact : forall n, Fact (v n).

Fixpoint sem (A:Frm) : Ens :=
  match A with
  | at_ n      => v n
  | dat_ n     => orth (v n)
  | tens A B   => tensF (sem A) (sem B)
  | par A B    => parF  (sem A) (sem B)
  | one        => oneF
  | bot        => botF
  | awith A B  => withF (sem A) (sem B)
  | oplus A B  => plusF (sem A) (sem B)
  | top        => topF
  | zero       => zeroF
  end.

Fixpoint Den (G:list Frm) : Ens :=
  match G with
  | nil    => unitSet
  | A :: G => pmul (orth (sem A)) (Den G)
  end.
Definition Valid (G:list Frm) : Prop := Inc (Den G) pole.

Lemma Den_app : forall G D, Equiv (Den (G ++ D)) (pmul (Den G) (Den D)).
Proof.
  intros G D. induction G as [|a G' IHG].
  - apply equiv_sym. apply (pmul_unit_l (Den D)).
  - apply (equiv_trans (Den ((a::G') ++ D))
                       (pmul (orth (sem a)) (pmul (Den G') (Den D)))
                       (pmul (Den (a::G')) (Den D))).
    + apply pmul_equiv; [ apply equiv_refl | exact IHG ].
    + apply pmul_assoc.
Qed.

Lemma Den_perm : forall G D, Permutation G D -> Equiv (Den G) (Den D).
Proof.
  intros G D HP.
  induction HP as [ | x l l' HP IHHP | x y l | l l' l'' HP1 IHHP1 HP2 IHHP2 ].
  - apply equiv_refl.
  - apply pmul_equiv; [ apply equiv_refl | exact IHHP ].
  - apply pmul_swap.
  - apply (equiv_trans _ _ _ IHHP1 IHHP2).
Qed.

Lemma sem_fact : forall A, Fact (sem A).
Proof.
  induction A.
  - apply Vfact.
  - apply orth_fact.
  - apply fact_orthorth.
  - apply orth_fact.
  - apply fact_orthorth.
  - apply orth_fact.
  - apply with_fact; assumption.
  - apply fact_orthorth.
  - intros m _; exact I.
  - apply orth_fact.
Qed.

Lemma sem_dual : forall A, Equiv (sem (dual A)) (orth (sem A)).
Proof.
  induction A as
   [ n | n | A1 IH1 A2 IH2 | A1 IH1 A2 IH2 | | | A1 IH1 A2 IH2 | A1 IH1 A2 IH2 | | ].
  - apply equiv_refl.
  - apply equiv_sym. apply fact_equiv. apply Vfact.
  - apply (equiv_trans _ (orth (pmul (sem A1) (sem A2))) _).
    + apply equiv_orth. apply pmul_equiv.
      * apply (equiv_trans _ (orth (orth (sem A1))) _);
          [ apply equiv_orth; exact IH1 | apply fact_equiv; apply sem_fact ].
      * apply (equiv_trans _ (orth (orth (sem A2))) _);
          [ apply equiv_orth; exact IH2 | apply fact_equiv; apply sem_fact ].
    + apply equiv_sym. apply orth3.
  - apply equiv_clo. apply pmul_equiv; [ exact IH1 | exact IH2 ].
  - apply equiv_sym. apply orth3.
  - apply equiv_refl.
  - apply (equiv_trans _ (orth (orth (fun m => orth (sem A1) m \/ orth (sem A2) m))) _).
    + apply equiv_clo. apply union_equiv; [ exact IH1 | exact IH2 ].
    + apply equiv_orth.
      apply (equiv_trans _ (withF (orth (orth (sem A1))) (orth (orth (sem A2)))) _).
      * apply orth_union_split.
      * apply withF_equiv; apply fact_equiv; apply sem_fact.
  - apply (equiv_trans _ (withF (orth (sem A1)) (orth (sem A2))) _).
    + apply withF_equiv; [ exact IH1 | exact IH2 ].
    + apply (equiv_trans _ (orth (fun m => sem A1 m \/ sem A2 m)) _).
      * apply equiv_sym. apply orth_union_split.
      * apply equiv_sym. apply orth3.
  - apply equiv_refl.
  - split; [ apply inc_orth_orth | intros m _; exact I ].
Qed.

Lemma peel : forall A G, Valid (A::G) <-> Inc (Den G) (sem A).
Proof.
  intros A G. split.
  - intro H. unfold Valid in H.
    apply (proj1 (pmul_orth_adj (orth (sem A)) (Den G))) in H.
    intros m Hm. apply (sem_fact A). apply H. exact Hm.
  - intro H. unfold Valid.
    apply (proj2 (pmul_orth_adj (orth (sem A)) (Den G))).
    intros m Hm. apply (inc_orth_orth (sem A)). apply H. exact Hm.
Qed.

(* ===================================================================== *)
(*  THE SOUNDNESS THEOREM                                                  *)
(* ===================================================================== *)
Theorem soundness : forall G, Prov G -> Valid G.
Proof.
  intros G0 H.
  induction H as
   [ n
   | G D perm pr IHpr
   | G D A pr1 IH1 pr2 IH2
   | G D A B pr1 IH1 pr2 IH2
   | G A B pr IH
   |
   | G pr IH
   | G A B pr1 IH1 pr2 IH2
   | G A B pr IH
   | G A B pr IH
   | G ].
  - apply (proj2 (peel (at_ n) [dat_ n])).
    intros m Hm. apply (Vfact n).
    exact (proj1 (pmul_unit_r (orth (orth (v n)))) m Hm).
  - intros m Hm. apply IHpr. exact (proj2 (Den_perm _ _ perm) m Hm).
  - intros m Hm.
    apply (proj1 (Den_app G D)) in Hm.
    destruct Hm as [a [b [HGa [HDb Hm]]]].
    pose proof (proj1 (peel A G) IH1) as HA.
    pose proof (proj1 (peel (dual A) D) IH2) as HB.
    pose proof (proj1 (sem_dual A) b (HB b HDb)) as Hortb.
    rewrite Hm. rewrite (op_comm a b).
    exact (Hortb a (HA a HGa)).
  - apply (proj2 (peel (tens A B) (G ++ D))).
    intros m Hm.
    apply (inc_orth_orth (pmul (sem A) (sem B)) m).
    apply (proj1 (Den_app G D)) in Hm.
    destruct Hm as [a [b [HGa [HDb Hm]]]].
    exists a, b. split;
      [ exact (proj1 (peel A G) IH1 a HGa)
      | split; [ exact (proj1 (peel B D) IH2 b HDb) | exact Hm ] ].
  - apply (proj2 (peel (par A B) G)).
    apply (proj1 (pmul_orth_adj (pmul (orth (sem A)) (orth (sem B))) (Den G))).
    intros m Hm. unfold Valid, Inc in IH.
    exact (IH m (proj2 (pmul_assoc (orth (sem A)) (orth (sem B)) (Den G)) m Hm)).
  - apply (proj2 (peel one [])).
    exact (inc_orth_orth unitSet).
  - apply (proj2 (peel bot G)).
    intros g Hg x Hx. unfold unitSet in Hx. rewrite Hx.
    rewrite (op_comm g e). rewrite (op_unit g).
    exact (IH g Hg).
  - apply (proj2 (peel (awith A B) G)).
    intros g Hg. split;
      [ exact (proj1 (peel A G) IH1 g Hg) | exact (proj1 (peel B G) IH2 g Hg) ].
  - apply (proj2 (peel (oplus A B) G)).
    intros g Hg. apply (inc_orth_orth (fun m => sem A m \/ sem B m) g).
    left. exact (proj1 (peel A G) IH g Hg).
  - apply (proj2 (peel (oplus A B) G)).
    intros g Hg. apply (inc_orth_orth (fun m => sem A m \/ sem B m) g).
    right. exact (proj1 (peel B G) IH g Hg).
  - apply (proj2 (peel top G)).
    intros g _. exact I.
Qed.

(* ---- reduction lemmas used by the separation (PART D) -------------- *)
(* a two-formula sequent is valid iff the orthogonal of one side is       *)
(* contained in the other -- the clean shape for refuting underivability. *)
Lemma valid_pair : forall C D, Valid [C; D] <-> Inc (orth (sem D)) (sem C).
Proof.
  intros C D. split.
  - intro H. apply (proj1 (peel C [D])) in H.
    intros m Hm. apply H. exact (proj2 (pmul_unit_r (orth (sem D))) m Hm).
  - intro H. apply (proj2 (peel C [D])).
    intros m Hm. apply H. exact (proj1 (pmul_unit_r (orth (sem D))) m Hm).
Qed.

(* validity of  |- A^perp, A (x) A  forces  [[A]]^perp (x) [[A]]^perp ... *)
(* concretely it forces  orth (pmul (v0) (v0))  <=  orth (v0) , which a    *)
(* non-idempotent monoid can break (contraction is unsound).              *)
Lemma valid_AA :
  Valid [dat_ 0; tens (at_ 0) (at_ 0)] ->
  Inc (orth (pmul (v 0) (v 0))) (orth (v 0)).
Proof.
  intro Hv. apply (proj1 (valid_pair (dat_ 0) (tens (at_ 0) (at_ 0)))) in Hv.
  intros m Hm. apply Hv. exact (proj2 (orth3 (pmul (v 0) (v 0))) m Hm).
Qed.

(* the separation, internalized: ANY witness that  orth (pmul v0 v0)  is   *)
(* not contained in  orth v0  refutes derivability of  |- A^perp, A (x) A.  *)
(* Goes through soundness, so when the section closes this lemma is         *)
(* abstracted over all three monoid laws (in the comm/assoc/unit order).    *)
Lemma contraction_needs_idem :
  (exists w, orth (pmul (v 0) (v 0)) w /\ ~ orth (v 0) w) ->
  ~ Prov [dat_ 0; tens (at_ 0) (at_ 0)].
Proof.
  intros [w [Hw Hnw]] H.
  pose proof (valid_AA (soundness _ H)) as Hinc.
  exact (Hnw (Hinc w Hw)).
Qed.

End PhaseSound.

(* ===================================================================== *)
(*  PART C -- CONSISTENCY as a corollary of soundness.                     *)
(*  One-point phase collapse (M = unit, pole = empty): Valid [] reduces    *)
(*  to (pole e), false there, so soundness forbids any derivation of the   *)
(*  empty sequent.  The linear calculus is CONSISTENT.                     *)
(* ===================================================================== *)

Definition uop (a b : unit) : unit := tt.
Definition ue : unit := tt.
Definition upole (_ : unit) : Prop := False.
Definition uv (_ : nat) (_ : unit) : Prop := False.

Lemma u_comm  : forall a b, uop a b = uop b a.                   Proof. reflexivity. Qed.
Lemma u_assoc : forall a b c, uop a (uop b c) = uop (uop a b) c. Proof. reflexivity. Qed.
Lemma u_unit  : forall a, uop ue a = a.                          Proof. intro a; destruct a; reflexivity. Qed.

Lemma u_Vfact : forall n, Fact unit uop upole (uv n).
Proof.
  intros n m H. unfold orth in H. apply (H tt). intros y Hy. destruct Hy.
Qed.

Theorem consistent : ~ Prov [].
Proof.
  intro H.
  pose proof (soundness unit uop ue u_comm u_assoc u_unit upole uv u_Vfact [] H) as S.
  exact (S ue eq_refl).
Qed.

(* ===================================================================== *)
(*  PART D -- the MULTIPLICATIVE / ADDITIVE SEPARATION (contraction).      *)
(*  Token monoid  (nat, +, 0)  with pole = { n | n >= 2 }, every atom      *)
(*  read as  geq1 = { m | m >= 1 }.  Then  geq1^perp = geq1  (so it is a    *)
(*  FACT) but  geq1 (x) geq1 = { m | m >= 2 }, so  geq1 NOT<= geq1 (x) geq1. *)
(*  Hence  A |- A (x) A  is NOT derivable: CONTRACTION is unsound, the      *)
(*  multiplicative (x) does not collapse to the additive (& is idempotent,  *)
(*  so this is exactly the separation  A & A  |/-  A (x) A).               *)
(*  Proved SEMANTICALLY via soundness -- a phase-model witness alongside    *)
(*  the grading witness in RDL_Linear.v.                                   *)
(* ===================================================================== *)

Definition geq1 (m : nat) : Prop := 1 <= m.
Definition geq2 (m : nat) : Prop := 2 <= m.

Lemma n_comm  : forall a b, Nat.add a b = Nat.add b a.                       Proof. exact Nat.add_comm. Qed.
Lemma n_assoc : forall a b c, Nat.add a (Nat.add b c) = Nat.add (Nat.add a b) c. Proof. exact Nat.add_assoc. Qed.
Lemma n_unit  : forall a, Nat.add 0 a = a.                                   Proof. reflexivity. Qed.

(* geq1 is a fact:  its double orthogonal is itself (in fact geq1^perp = geq1). *)
Lemma geq1_fact : Fact nat Nat.add geq2 geq1.
Proof.
  intros m H.
  assert (Ho1 : orth nat Nat.add geq2 geq1 1).
  { unfold orth, geq2, geq1. intros y Hy. lia. }
  pose proof (H 1 Ho1) as Hm. unfold geq2 in Hm. unfold geq1. lia.
Qed.

Theorem no_contraction : ~ Prov [dat_ 0; tens (at_ 0) (at_ 0)].
Proof.
  apply (contraction_needs_idem nat Nat.add 0 n_comm n_assoc n_unit
                                geq2 (fun _ => geq1) (fun _ => geq1_fact)).
  exists 0. split.
  - (* 0 in orth (pmul geq1 geq1):  x = a+b with a,b >= 1  =>  0+x >= 2 *)
    unfold orth, pmul, geq2, geq1. intros x [a [b [Ha [Hb Hx]]]]. lia.
  - (* 0 not in orth geq1:  it would force  2 <= 0+1 *)
    unfold orth, geq2, geq1. intros Hbad. specialize (Hbad 1 (le_n 1)). lia.
Qed.

(* ===================================================================== *)
(*  AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0).                           *)
(*  All five theorems: Closed under the global context.                    *)
(*  Involution law + phase soundness of the full MALL calculus             *)
(*  (ax/exch/cut, (x)/par, 1/bot, &/(+), top) + the consistency corollary.*)
(*  No funext, no prop-ext, no classical, no choice.                       *)
(* ===================================================================== *)
Print Assumptions dual_involutive.
Print Assumptions sem_dual.
Print Assumptions soundness.
Print Assumptions consistent.
Print Assumptions no_contraction.
