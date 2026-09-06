(* ===================================================================== *)
(*  RDL_All.v  --  UNIFIED RDL LOGIC KERNEL (single file, 14 modules).     *)
(*  Each RDL_* file is wrapped in its own Module so the independently-     *)
(*  declared Frm/Form/val/dual/Prov/Pcf/... never clash.  Libraries are    *)
(*  REQUIRED (loaded) at top but IMPORTED locally inside each module, so   *)
(*  each module keeps its own notation scope (nat vs Q vs Z) with no       *)
(*  cross-contamination.  Every module is axiom-free (no funext / no       *)
(*  classical / no admit).  The arithmetic kernel RD.v (single isolated    *)
(*  classic) is kept SEPARATE by design.   coqc 8.18.0.                    *)
(* ===================================================================== *)

(* ---- libraries: Require (load) only, NO global Import/Open Scope ---- *)
Require Coq.Arith.PeanoNat.
Require Coq.Bool.Bool.
Require Coq.Classes.Morphisms.
Require Coq.Classes.RelationClasses.
Require Coq.Lists.List.
Require Coq.QArith.QArith.
Require Coq.Setoids.Setoid.
Require Coq.Sorting.Permutation.
Require Coq.ZArith.ZArith.
Require Coq.micromega.Lia.
Require Coq.micromega.Lqa.
Require Lia.
Require List.
Require Permutation.


(* ================== Module Sequent  (from RDL_Sequent.v) ================== *)
Module Sequent.

(* ===================================================================== *)
(*  RDL_Sequent.v                                                         *)
(*  Propositional SEQUENT CALCULUS of Retained-Distinction Logic,         *)
(*  mechanized over the 4-valued FDE retention algebra (T / F / B / N).   *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free, no classical logic:          *)
(*    sound                      soundness of the FULL calculus incl. cut *)
(*                               (= the "no-creation"/transport principle)*)
(*    non_explosion              [p, ∼p] ⊬ q   (paraconsistency)          *)
(*    classical_explosion        2-valued limit recovers ex falso         *)
(*    contradiction_is_obstruction   val(p ∧ ∼p) = B                      *)
(*                                                                        *)
(*  This promotes the propositional sequent layer from DESIGN → VERIFIED. *)
(*  NOT claimed here (remain scoped targets): cut-ELIMINATION (syntactic),*)
(*  first-order sequent rules, budget/resolution/record refinements,      *)
(*  derived modality, retention-transport model completeness.             *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.Bool.Bool.

(* ---- 4-valued retention algebra :  v = (t-evidence, f-evidence) ------ *)
Definition val := (bool * bool)%type.
Definition vT : val := (true , false).
Definition vF : val := (false, true ).
Definition vB : val := (true , true ).   (* obstruction / glut *)
Definition vN : val := (false, false).   (* gap *)

Definition vneg  (v:val)   : val := (snd v, fst v).                    (* access-reversal (involutive) *)
Definition vconj (a b:val) : val := (fst a && fst b, snd a || snd b).  (* FDE meet  (⊗ reading) *)
Definition vdisj (a b:val) : val := (fst a || fst b, snd a && snd b).  (* FDE join  (⊕ reading) *)
Definition designated (v:val) : Prop := fst v = true.                  (* "at least true" : {T,B} *)
Definition obstruction (v:val) : bool := fst v && snd v.               (* O = 1  iff  v = B *)

(* ---- syntax --------------------------------------------------------- *)
Inductive Form :=
| Atom : nat -> Form
| Neg  : Form -> Form
| Conj : Form -> Form -> Form
| Disj : Form -> Form -> Form.

Fixpoint eval (nu:nat->val) (p:Form) : val :=
  match p with
  | Atom n   => nu n
  | Neg a    => vneg  (eval nu a)
  | Conj a b => vconj (eval nu a) (eval nu b)
  | Disj a b => vdisj (eval nu a) (eval nu b)
  end.

(* ---- validity : every valuation designating all of Γ designates φ --- *)
Definition sat (nu:nat->val) (G:list Form) (p:Form) : Prop :=
  (forall q, In q G -> designated (eval nu q)) -> designated (eval nu p).
Definition valid (G:list Form) (p:Form) : Prop := forall nu, sat nu G p.

(* ---- the sequent calculus   Γ ⊢ φ   (single conclusion) ------------- *)
Inductive Deriv : list Form -> Form -> Prop :=
| d_ax     : forall G p,     In p G -> Deriv G p
| d_dneg_i : forall G a,     Deriv G a -> Deriv G (Neg (Neg a))
| d_dneg_e : forall G a,     Deriv G (Neg (Neg a)) -> Deriv G a
| d_conjI  : forall G a b,   Deriv G a -> Deriv G b -> Deriv G (Conj a b)
| d_conjE1 : forall G a b,   Deriv G (Conj a b) -> Deriv G a
| d_conjE2 : forall G a b,   Deriv G (Conj a b) -> Deriv G b
| d_disjI1 : forall G a b,   Deriv G a -> Deriv G (Disj a b)
| d_disjI2 : forall G a b,   Deriv G b -> Deriv G (Disj a b)
| d_disjE  : forall G a b c, Deriv G (Disj a b) -> Deriv (a::G) c -> Deriv (b::G) c -> Deriv G c
| d_cut    : forall G a c,   Deriv G a -> Deriv (a::G) c -> Deriv G c.   (* transport composition *)

(* ---- context extension helper --------------------------------------- *)
Lemma cons_des : forall nu a G,
  designated (eval nu a) ->
  (forall q, In q G -> designated (eval nu q)) ->
  (forall q, In q (a::G) -> designated (eval nu q)).
Proof.
  intros nu a G Ha HG q Hin. destruct Hin as [Heq | Hin].
  - rewrite <- Heq. exact Ha.
  - apply HG. exact Hin.
Qed.

(* ===================================================================== *)
(*  SOUNDNESS  (incl. cut) — the "no creation" principle, machine-checked *)
(* ===================================================================== *)
Theorem sound : forall G p, Deriv G p -> valid G p.
Proof.
  intros G p D. induction D; intros nu HG.
  - (* ax *) apply HG. assumption.
  - (* dneg_i *) specialize (IHD nu HG). unfold designated in *. simpl.
      unfold vneg. destruct (eval nu a) as [ta fa]. simpl in *. exact IHD.
  - (* dneg_e *) specialize (IHD nu HG). unfold designated in *.
      simpl in IHD. unfold vneg in IHD. destruct (eval nu a) as [ta fa]. simpl in *. exact IHD.
  - (* conjI *) specialize (IHD1 nu HG). specialize (IHD2 nu HG). unfold designated in *.
      simpl. unfold vconj. destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
      simpl in *. rewrite IHD1, IHD2. reflexivity.
  - (* conjE1 *) specialize (IHD nu HG). unfold designated in *. simpl in IHD.
      unfold vconj in IHD. destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
      simpl in *. apply andb_prop in IHD. destruct IHD as [Ha Hb]. exact Ha.
  - (* conjE2 *) specialize (IHD nu HG). unfold designated in *. simpl in IHD.
      unfold vconj in IHD. destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
      simpl in *. apply andb_prop in IHD. destruct IHD as [Ha Hb]. exact Hb.
  - (* disjI1 *) specialize (IHD nu HG). unfold designated in *. simpl.
      unfold vdisj. destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
      simpl in *. rewrite IHD. reflexivity.
  - (* disjI2 *) specialize (IHD nu HG). unfold designated in *. simpl.
      unfold vdisj. destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
      simpl in *. rewrite IHD. rewrite orb_true_r. reflexivity.
  - (* disjE *) specialize (IHD1 nu HG).
      assert (Hd : designated (eval nu a) \/ designated (eval nu b)).
      { unfold designated in *. simpl in IHD1. unfold vdisj in IHD1.
        destruct (eval nu a) as [ta fa]. destruct (eval nu b) as [tb fb].
        simpl in *. apply orb_prop in IHD1. exact IHD1. }
      destruct Hd as [Ha | Hb].
      + apply IHD2. apply cons_des. exact Ha. exact HG.
      + apply IHD3. apply cons_des. exact Hb. exact HG.
  - (* cut *) specialize (IHD1 nu HG). apply IHD2. apply cons_des. exact IHD1. exact HG.
Qed.

(* ===================================================================== *)
(*  NON-EXPLOSION  (paraconsistency at the sequent level)                 *)
(*  Countermodel: atom 0 ↦ B (designated), so ∼(atom 0) ↦ B (designated), *)
(*  yet atom 1 ↦ F (not designated). Soundness ⇒ [p,∼p] ⊬ q.              *)
(* ===================================================================== *)
Definition cex : nat -> val := fun n => match n with 0 => vB | _ => vF end.

Theorem non_explosion : ~ Deriv [Atom 0; Neg (Atom 0)] (Atom 1).
Proof.
  intro D. apply sound in D. specialize (D cex). unfold sat in D.
  assert (Hpre : forall q, In q [Atom 0; Neg (Atom 0)] -> designated (eval cex q)).
  { intros q Hin. simpl in Hin. destruct Hin as [Heq | [Heq | F]].
    - rewrite <- Heq. unfold designated. simpl. reflexivity.
    - rewrite <- Heq. unfold designated. simpl. reflexivity.
    - destruct F. }
  apply D in Hpre. unfold designated in Hpre. simpl in Hpre. discriminate Hpre.
Qed.

(* ===================================================================== *)
(*  CLASSICAL LIMIT — restrict to 2 values (snd = ¬fst): ex falso returns *)
(* ===================================================================== *)
Definition classical (nu:nat->val) : Prop := forall n, snd (nu n) = negb (fst (nu n)).

Theorem classical_explosion :
  forall nu, classical nu ->
  designated (eval nu (Atom 0)) -> designated (eval nu (Neg (Atom 0))) ->
  designated (eval nu (Atom 1)).
Proof.
  intros nu Hcl H0 Hn0. exfalso.
  unfold designated in H0, Hn0.
  simpl in H0.
  simpl in Hn0. unfold vneg in Hn0. simpl in Hn0.
  specialize (Hcl 0).
  rewrite H0 in Hcl. simpl in Hcl.
  rewrite Hn0 in Hcl. discriminate Hcl.
Qed.

(* ===================================================================== *)
(*  CONTRADICTION IS OBSTRUCTION :  val(p ∧ ∼p) = B  (obstruction = 1)    *)
(* ===================================================================== *)
Theorem contradiction_is_obstruction :
  obstruction (eval cex (Conj (Atom 0) (Neg (Atom 0)))) = true.
Proof. unfold cex. cbn. reflexivity. Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0)                             *)
(* Each command below prints: "Closed under the global context".          *)
(* No axioms, no Admitted, no `classic`.                                   *)
(* sound  = soundness incl. cut ; non_explosion = paraconsistency ;        *)
(* classical_explosion = 2-valued limit ; contradiction_is_obstruction =   *)
(* val(p /\ ~p) = B .                                                       *)
(* ====================================================================== *)
Print Assumptions sound .
Print Assumptions non_explosion .
Print Assumptions classical_explosion .
Print Assumptions contradiction_is_obstruction .

End Sequent.

(* ================== Module CutElim  (from RDL_CutElim.v) ================== *)
Module CutElim.

(* ===================================================================== *)
(*  RDL_CutElim.v  —  CUT-ELIMINATION for the RDL propositional sequent   *)
(*  calculus, over the 4-valued FDE retention algebra.                    *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free:                              *)
(*    perm_adm   permutation (exchange) admissibility, cut-free system    *)
(*    weak_adm   weakening admissibility, cut-free system                 *)
(*    cut_adm    CUT ADMISSIBILITY  (the cut rule is eliminable)          *)
(*    cut_elim   Deriv (with cut) ⊢  ⇒  Dcf (cut-free) ⊢                  *)
(*    sound_cf / cut_free_non_explosion                                   *)
(*                                                                        *)
(*  Closes cleanly: the calculus has NO left-rule decomposing a context   *)
(*  formula; the cut formula is consumed only at axiom leaves, so cut =   *)
(*  substitution of the left derivation into those leaves. cut_adm needs  *)
(*  only structural induction on the right derivation (+ exchange/weak),  *)
(*  no rank/height measure.                                               *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.Bool.Bool.
Import Coq.Sorting.Permutation.

Inductive Form :=
| Atom : nat -> Form | Neg : Form -> Form
| Conj : Form -> Form -> Form | Disj : Form -> Form -> Form.

Definition val := (bool * bool)%type.
Definition vneg  (v:val)   : val := (snd v, fst v).
Definition vconj (a b:val) : val := (fst a && fst b, snd a || snd b).
Definition vdisj (a b:val) : val := (fst a || fst b, snd a && snd b).
Definition designated (v:val) : Prop := fst v = true.
Fixpoint eval (nu:nat->val) (p:Form) : val :=
  match p with
  | Atom n => nu n | Neg a => vneg (eval nu a)
  | Conj a b => vconj (eval nu a) (eval nu b) | Disj a b => vdisj (eval nu a) (eval nu b) end.
Definition valid (G:list Form) (p:Form) : Prop :=
  forall nu, (forall q, In q G -> designated (eval nu q)) -> designated (eval nu p).

Inductive Deriv : list Form -> Form -> Prop :=
| d_ax     : forall G p,     In p G -> Deriv G p
| d_dneg_i : forall G a,     Deriv G a -> Deriv G (Neg (Neg a))
| d_dneg_e : forall G a,     Deriv G (Neg (Neg a)) -> Deriv G a
| d_conjI  : forall G a b,   Deriv G a -> Deriv G b -> Deriv G (Conj a b)
| d_conjE1 : forall G a b,   Deriv G (Conj a b) -> Deriv G a
| d_conjE2 : forall G a b,   Deriv G (Conj a b) -> Deriv G b
| d_disjI1 : forall G a b,   Deriv G a -> Deriv G (Disj a b)
| d_disjI2 : forall G a b,   Deriv G b -> Deriv G (Disj a b)
| d_disjE  : forall G a b c, Deriv G (Disj a b) -> Deriv (a::G) c -> Deriv (b::G) c -> Deriv G c
| d_cut    : forall G a c,   Deriv G a -> Deriv (a::G) c -> Deriv G c.

Inductive Dcf : list Form -> Form -> Prop :=
| cf_ax     : forall G p,     In p G -> Dcf G p
| cf_dneg_i : forall G a,     Dcf G a -> Dcf G (Neg (Neg a))
| cf_dneg_e : forall G a,     Dcf G (Neg (Neg a)) -> Dcf G a
| cf_conjI  : forall G a b,   Dcf G a -> Dcf G b -> Dcf G (Conj a b)
| cf_conjE1 : forall G a b,   Dcf G (Conj a b) -> Dcf G a
| cf_conjE2 : forall G a b,   Dcf G (Conj a b) -> Dcf G b
| cf_disjI1 : forall G a b,   Dcf G a -> Dcf G (Disj a b)
| cf_disjI2 : forall G a b,   Dcf G b -> Dcf G (Disj a b)
| cf_disjE  : forall G a b c, Dcf G (Disj a b) -> Dcf (a::G) c -> Dcf (b::G) c -> Dcf G c.

Lemma perm_adm : forall G c, Dcf G c -> forall G', Permutation G G' -> Dcf G' c.
Proof.
  intros G c D. induction D; intros G' HP.
  - apply cf_ax. eapply Permutation_in; [exact HP | exact H].
  - apply cf_dneg_i; apply IHD; exact HP.
  - apply cf_dneg_e; apply IHD; exact HP.
  - apply cf_conjI; [apply IHD1; exact HP | apply IHD2; exact HP].
  - eapply cf_conjE1; apply IHD; exact HP.
  - eapply cf_conjE2; apply IHD; exact HP.
  - apply cf_disjI1; apply IHD; exact HP.
  - apply cf_disjI2; apply IHD; exact HP.
  - eapply cf_disjE.
    + apply IHD1; exact HP.
    + apply IHD2; apply perm_skip; exact HP.
    + apply IHD3; apply perm_skip; exact HP.
Qed.

Lemma weak_adm : forall G c, Dcf G c -> forall q, Dcf (q::G) c.
Proof.
  intros G c D. induction D; intros q.
  - apply cf_ax. right; exact H.
  - apply cf_dneg_i; apply IHD.
  - apply cf_dneg_e; apply IHD.
  - apply cf_conjI; [apply IHD1 | apply IHD2].
  - eapply cf_conjE1; apply IHD.
  - eapply cf_conjE2; apply IHD.
  - apply cf_disjI1; apply IHD.
  - apply cf_disjI2; apply IHD.
  - eapply cf_disjE.
    + apply IHD1.
    + eapply perm_adm. apply (IHD2 q). apply perm_swap.
    + eapply perm_adm. apply (IHD3 q). apply perm_swap.
Qed.

Lemma cut_adm : forall D c, Dcf D c -> forall x Gx,
  Permutation D (x :: Gx) -> Dcf Gx x -> Dcf Gx c.
Proof.
  intros D c Dpf. induction Dpf; intros x Gx HP Dx.
  - assert (Hin : In p (x :: Gx)) by (eapply Permutation_in; [exact HP | exact H]).
    destruct Hin as [Heq | Hin].
    + subst p. exact Dx.
    + apply cf_ax; exact Hin.
  - apply cf_dneg_i.  eapply IHDpf;  [exact HP | exact Dx].
  - apply cf_dneg_e.  eapply IHDpf;  [exact HP | exact Dx].
  - apply cf_conjI;  [ eapply IHDpf1; [exact HP | exact Dx]
                     | eapply IHDpf2; [exact HP | exact Dx] ].
  - eapply cf_conjE1. eapply IHDpf;  [exact HP | exact Dx].
  - eapply cf_conjE2. eapply IHDpf;  [exact HP | exact Dx].
  - apply cf_disjI1.  eapply IHDpf;  [exact HP | exact Dx].
  - apply cf_disjI2.  eapply IHDpf;  [exact HP | exact Dx].
  - eapply cf_disjE.
    + eapply IHDpf1; [exact HP | exact Dx].
    + eapply IHDpf2.
      * eapply Permutation_trans; [ apply perm_skip; exact HP | apply perm_swap ].
      * apply weak_adm; exact Dx.
    + eapply IHDpf3.
      * eapply Permutation_trans; [ apply perm_skip; exact HP | apply perm_swap ].
      * apply weak_adm; exact Dx.
Qed.

Theorem cut_elim : forall G c, Deriv G c -> Dcf G c.
Proof.
  intros G c D. induction D.
  - apply cf_ax; exact H.
  - apply cf_dneg_i; exact IHD.
  - apply cf_dneg_e; exact IHD.
  - apply cf_conjI; [exact IHD1 | exact IHD2].
  - eapply cf_conjE1; exact IHD.
  - eapply cf_conjE2; exact IHD.
  - apply cf_disjI1; exact IHD.
  - apply cf_disjI2; exact IHD.
  - eapply cf_disjE; [exact IHD1 | exact IHD2 | exact IHD3].
  - eapply cut_adm; [exact IHD2 | apply Permutation_refl | exact IHD1].
Qed.

Lemma cons_des : forall nu a G,
  designated (eval nu a) ->
  (forall q, In q G -> designated (eval nu q)) ->
  (forall q, In q (a::G) -> designated (eval nu q)).
Proof. intros nu a G Ha HG q [Heq|Hin]. rewrite <- Heq; exact Ha. apply HG; exact Hin. Qed.

Theorem sound_cf : forall G p, Dcf G p -> valid G p.
Proof.
  intros G p D. induction D; intros nu HG.
  - apply HG; assumption.
  - specialize (IHD nu HG). unfold designated in *. simpl. unfold vneg.
      destruct (eval nu a) as [ta fa]. simpl in *. exact IHD.
  - specialize (IHD nu HG). unfold designated in *. simpl in IHD. unfold vneg in IHD.
      destruct (eval nu a) as [ta fa]. simpl in *. exact IHD.
  - specialize (IHD1 nu HG); specialize (IHD2 nu HG). unfold designated in *.
      simpl; unfold vconj. destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb].
      simpl in *. rewrite IHD1, IHD2; reflexivity.
  - specialize (IHD nu HG). unfold designated in *. simpl in IHD. unfold vconj in IHD.
      destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb]. simpl in *.
      apply andb_prop in IHD; destruct IHD as [Ha Hb]; exact Ha.
  - specialize (IHD nu HG). unfold designated in *. simpl in IHD. unfold vconj in IHD.
      destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb]. simpl in *.
      apply andb_prop in IHD; destruct IHD as [Ha Hb]; exact Hb.
  - specialize (IHD nu HG). unfold designated in *. simpl; unfold vdisj.
      destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb]. simpl in *.
      rewrite IHD; reflexivity.
  - specialize (IHD nu HG). unfold designated in *. simpl; unfold vdisj.
      destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb]. simpl in *.
      rewrite IHD; rewrite orb_true_r; reflexivity.
  - specialize (IHD1 nu HG).
      assert (Hd : designated (eval nu a) \/ designated (eval nu b)).
      { unfold designated in *. simpl in IHD1. unfold vdisj in IHD1.
        destruct (eval nu a) as [ta fa]; destruct (eval nu b) as [tb fb]. simpl in *.
        apply orb_prop in IHD1; exact IHD1. }
      destruct Hd as [Ha | Hb].
      + apply IHD2; apply cons_des; [exact Ha | exact HG].
      + apply IHD3; apply cons_des; [exact Hb | exact HG].
Qed.

Definition cex : nat -> val := fun n => match n with 0 => (true,true) | _ => (false,true) end.

Theorem cut_free_non_explosion : ~ Dcf [Atom 0; Neg (Atom 0)] (Atom 1).
Proof.
  intro D. apply sound_cf in D. specialize (D cex).
  assert (Hpre : forall q, In q [Atom 0; Neg (Atom 0)] -> designated (eval cex q)).
  { intros q [Heq|[Heq|F]].
    - rewrite <- Heq; unfold designated; simpl; reflexivity.
    - rewrite <- Heq; unfold designated; simpl; reflexivity.
    - destruct F. }
  apply D in Hpre. unfold designated in Hpre; simpl in Hpre; discriminate Hpre.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0)                             *)
(* Each command below prints: "Closed under the global context".          *)
(* Full propositional cut-elimination. No axioms, no Admitted.            *)
(* cut_adm = cut admissible ; cut_elim = Deriv|- => Dcf|- ;                *)
(* sound_cf = cut-free soundness ; cut_free_non_explosion = paraconsist.   *)
(* ====================================================================== *)
Print Assumptions cut_adm .
Print Assumptions cut_elim .
Print Assumptions sound_cf .
Print Assumptions cut_free_non_explosion .

End CutElim.

(* ================== Module FOL  (from RDL_FOL.v) ================== *)
Module FOL.

(* ===================================================================== *)
(*  RDL_FOL.v  —  FIRST-ORDER sequent calculus of RDL over the domain     *)
(*  D = nat, with the relational 4-valued FDE semantics (tt / ff) and     *)
(*  de Bruijn variables.                                                  *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free:                              *)
(*    ttff_ext      tt/ff respect pointwise-equal assignments             *)
(*    rename_sound  semantic soundness of de Bruijn renaming              *)
(*    soundF        SOUNDNESS of the first-order sequent calculus,         *)
(*                  including ∀L, ∀R (eigenvariable), ∃R                   *)
(*                                                                        *)
(*  (∃L — the other eigenvariable rule — needs a conclusion-shift and is  *)
(*   left as the remaining target here; full FO soundness is in any case  *)
(*   already machine-checked Hilbert-style in RD.v.)                      *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.Bool.Bool.

Definition val := (bool * bool)%type.

Inductive Form :=
| Pr  : nat -> nat -> Form          (* a binary distinction over two variables *)
| Neg : Form -> Form
| Conj: Form -> Form -> Form
| Disj: Form -> Form -> Form
| All : Form -> Form
| Ex  : Form -> Form.

Definition scons (d:nat) (r:nat->nat) : nat->nat := fun n => match n with 0 => d | S k => r k end.
Definition idr : nat -> nat := fun n => n.
Definition upr (s:nat->nat) : nat->nat := scons 0 (fun k => S (s k)).

Fixpoint rename (s:nat->nat) (p:Form) : Form :=
  match p with
  | Pr i j   => Pr (s i) (s j)
  | Neg a    => Neg (rename s a)
  | Conj a b => Conj (rename s a) (rename s b)
  | Disj a b => Disj (rename s a) (rename s b)
  | All a    => All (rename (upr s) a)
  | Ex a     => Ex  (rename (upr s) a)
  end.
Definition inst (m:nat) (a:Form) : Form := rename (scons m idr) a.

Fixpoint tt (I:nat->nat->val) (r:nat->nat) (p:Form) {struct p} : Prop :=
  match p with
  | Pr i j   => fst (I (r i) (r j)) = true
  | Neg a    => ff I r a
  | Conj a b => tt I r a /\ tt I r b
  | Disj a b => tt I r a \/ tt I r b
  | All a    => forall d, tt I (scons d r) a
  | Ex a     => exists d, tt I (scons d r) a
  end
with ff (I:nat->nat->val) (r:nat->nat) (p:Form) {struct p} : Prop :=
  match p with
  | Pr i j   => snd (I (r i) (r j)) = true
  | Neg a    => tt I r a
  | Conj a b => ff I r a \/ ff I r b
  | Disj a b => ff I r a /\ ff I r b
  | All a    => exists d, ff I (scons d r) a
  | Ex a     => forall d, ff I (scons d r) a
  end.

(* ---- pointwise extensionality (mutual, by induction on the formula) -- *)
Lemma ttff_ext : forall p I r r', (forall n, r n = r' n) ->
  (tt I r p <-> tt I r' p) /\ (ff I r p <-> ff I r' p).
Proof.
  induction p; intros I r r' E; simpl.
  - rewrite (E n), (E n0). split; tauto.
  - destruct (IHp I r r' E) as [Ht Hf]. split; [exact Hf | exact Ht].
  - destruct (IHp1 I r r' E) as [Ht1 Hf1]; destruct (IHp2 I r r' E) as [Ht2 Hf2].
    split; [clear -Ht1 Ht2; tauto | clear -Hf1 Hf2; tauto].
  - destruct (IHp1 I r r' E) as [Ht1 Hf1]; destruct (IHp2 I r r' E) as [Ht2 Hf2].
    split; [clear -Ht1 Ht2; tauto | clear -Hf1 Hf2; tauto].
  - assert (Hd : forall d, (tt I (scons d r) p <-> tt I (scons d r') p) /\
                           (ff I (scons d r) p <-> ff I (scons d r') p)).
    { intro d. apply IHp. intro n; destruct n; simpl; [reflexivity | apply E]. }
    split.
    + split; intros Hh d; [ apply (proj1 (proj1 (Hd d))) | apply (proj2 (proj1 (Hd d))) ]; apply Hh.
    + split; intros [d Hh]; exists d; [ apply (proj1 (proj2 (Hd d))) | apply (proj2 (proj2 (Hd d))) ]; exact Hh.
  - assert (Hd : forall d, (tt I (scons d r) p <-> tt I (scons d r') p) /\
                           (ff I (scons d r) p <-> ff I (scons d r') p)).
    { intro d. apply IHp. intro n; destruct n; simpl; [reflexivity | apply E]. }
    split.
    + split; intros [d Hh]; exists d; [ apply (proj1 (proj1 (Hd d))) | apply (proj2 (proj1 (Hd d))) ]; exact Hh.
    + split; intros Hh d; [ apply (proj1 (proj2 (Hd d))) | apply (proj2 (proj2 (Hd d))) ]; apply Hh.
Qed.

(* ---- semantic soundness of renaming (mutual) ------------------------ *)
Lemma rename_sound : forall p I r s,
  (tt I r (rename s p) <-> tt I (fun n => r (s n)) p) /\
  (ff I r (rename s p) <-> ff I (fun n => r (s n)) p).
Proof.
  induction p; intros I r s; simpl.
  - split; tauto.
  - destruct (IHp I r s) as [Ht Hf]. split; [exact Hf | exact Ht].
  - destruct (IHp1 I r s) as [Ht1 Hf1]; destruct (IHp2 I r s) as [Ht2 Hf2].
    split; [clear -Ht1 Ht2; tauto | clear -Hf1 Hf2; tauto].
  - destruct (IHp1 I r s) as [Ht1 Hf1]; destruct (IHp2 I r s) as [Ht2 Hf2].
    split; [clear -Ht1 Ht2; tauto | clear -Hf1 Hf2; tauto].
  - assert (E : forall d n, (scons d r) (upr s n) = (scons d (fun k => r (s k))) n).
    { intros d n; destruct n; simpl; reflexivity. }
    split.
    + split; intros Hh d; specialize (Hh d);
        [ destruct (IHp I (scons d r) (upr s)) as [Ht _];
          destruct (ttff_ext p I _ _ (E d)) as [He _]; tauto
        | destruct (IHp I (scons d r) (upr s)) as [Ht _];
          destruct (ttff_ext p I _ _ (E d)) as [He _]; tauto ].
    + split; intros [d Hh]; exists d;
        [ destruct (IHp I (scons d r) (upr s)) as [_ Hf];
          destruct (ttff_ext p I _ _ (E d)) as [_ He]; tauto
        | destruct (IHp I (scons d r) (upr s)) as [_ Hf];
          destruct (ttff_ext p I _ _ (E d)) as [_ He]; tauto ].
  - assert (E : forall d n, (scons d r) (upr s n) = (scons d (fun k => r (s k))) n).
    { intros d n; destruct n; simpl; reflexivity. }
    split.
    + split; intros [d Hh]; exists d;
        [ destruct (IHp I (scons d r) (upr s)) as [Ht _];
          destruct (ttff_ext p I _ _ (E d)) as [He _]; tauto
        | destruct (IHp I (scons d r) (upr s)) as [Ht _];
          destruct (ttff_ext p I _ _ (E d)) as [He _]; tauto ].
    + split; intros Hh d; specialize (Hh d);
        [ destruct (IHp I (scons d r) (upr s)) as [_ Hf];
          destruct (ttff_ext p I _ _ (E d)) as [_ He]; tauto
        | destruct (IHp I (scons d r) (upr s)) as [_ Hf];
          destruct (ttff_ext p I _ _ (E d)) as [_ He]; tauto ].
Qed.

(* ---- the first-order sequent calculus  Γ ⊢ φ ------------------------ *)
Inductive DerivF : list Form -> Form -> Prop :=
| fax     : forall G p,     In p G -> DerivF G p
| fdneg_i : forall G a,     DerivF G a -> DerivF G (Neg (Neg a))
| fdneg_e : forall G a,     DerivF G (Neg (Neg a)) -> DerivF G a
| fconjI  : forall G a b,   DerivF G a -> DerivF G b -> DerivF G (Conj a b)
| fconjE1 : forall G a b,   DerivF G (Conj a b) -> DerivF G a
| fconjE2 : forall G a b,   DerivF G (Conj a b) -> DerivF G b
| fdisjI1 : forall G a b,   DerivF G a -> DerivF G (Disj a b)
| fdisjI2 : forall G a b,   DerivF G b -> DerivF G (Disj a b)
| fdisjE  : forall G a b c, DerivF G (Disj a b) -> DerivF (a::G) c -> DerivF (b::G) c -> DerivF G c
| fallL   : forall G a c m, DerivF (inst m a :: G) c -> DerivF (All a :: G) c       (* ∀L : instantiate var 0 with var m *)
| fallR   : forall G a,     DerivF (map (rename S) G) a -> DerivF G (All a)          (* ∀R : eigenvariable via context shift *)
| fexR    : forall G a m,   DerivF G (inst m a) -> DerivF G (Ex a)                   (* ∃R : witness var m *)
| fexL    : forall G a c,   DerivF (a :: map (rename S) G) (rename S c) -> DerivF (Ex a :: G) c. (* ∃L : eigenvariable; shift context + conclusion *)

Definition validF (G:list Form) (p:Form) : Prop :=
  forall I r, (forall q, In q G -> tt I r q) -> tt I r p.

(* helper: instantiation soundness *)
Lemma inst_sound : forall I r m a, tt I r (inst m a) <-> tt I (scons (r m) r) a.
Proof.
  intros I r m a. unfold inst.
  destruct (rename_sound a I r (scons m idr)) as [Ht _].
  assert (E : forall n, r ((scons m idr) n) = (scons (r m) r) n).
  { intro n; destruct n; simpl; reflexivity. }
  destruct (ttff_ext a I (fun n => r ((scons m idr) n)) (scons (r m) r) E) as [He _].
  tauto.
Qed.

(* helper: context-shift soundness for ∀R *)
Lemma shift_ctx : forall I r d q, tt I (scons d r) (rename S q) <-> tt I r q.
Proof.
  intros I r d q. destruct (rename_sound q I (scons d r) S) as [Ht _].
  assert (E : forall n, (scons d r) (S n) = r n) by (intro n; reflexivity).
  destruct (ttff_ext q I (fun n => (scons d r) (S n)) r E) as [He _].
  tauto.
Qed.

Theorem soundF : forall G p, DerivF G p -> validF G p.
Proof.
  intros G p D. induction D; intros I r Hctx.
  - apply Hctx; assumption.
  - simpl. apply IHD; exact Hctx.
  - assert (Htt : tt I r (Neg (Neg a))) by (apply IHD; exact Hctx). simpl in Htt; exact Htt.
  - simpl. split; [apply IHD1; exact Hctx | apply IHD2; exact Hctx].
  - assert (Htt : tt I r (Conj a b)) by (apply IHD; exact Hctx). simpl in Htt; tauto.
  - assert (Htt : tt I r (Conj a b)) by (apply IHD; exact Hctx). simpl in Htt; tauto.
  - simpl. left; apply IHD; exact Hctx.
  - simpl. right; apply IHD; exact Hctx.
  - (* disjE *)
    assert (Hd : tt I r (Disj a b)) by (apply IHD1; exact Hctx). simpl in Hd. destruct Hd as [Ha | Hb].
    + apply IHD2. intros q [Heq | Hin]; [ rewrite <- Heq; exact Ha | apply Hctx; exact Hin ].
    + apply IHD3. intros q [Heq | Hin]; [ rewrite <- Heq; exact Hb | apply Hctx; exact Hin ].
  - (* fallL : All a :: G ⊢ c ; instantiate var m *)
    apply IHD. intros q [Heq | Hin].
    + rewrite <- Heq. apply inst_sound.
      assert (HAll : tt I r (All a)) by (apply Hctx; left; reflexivity).
      simpl in HAll. apply HAll.
    + apply Hctx; right; exact Hin.
  - (* fallR : Γ ⊢ All a from (map (rename S) Γ) ⊢ a *)
    simpl. intro d. apply IHD. intros q Hin.
    apply in_map_iff in Hin. destruct Hin as [g [Heq Hg]]. subst q.
    apply shift_ctx. apply Hctx; exact Hg.
  - (* fexR : Γ ⊢ Ex a from Γ ⊢ inst m a *)
    simpl. exists (r m). apply (proj1 (inst_sound I r m a)). apply IHD; exact Hctx.
  - (* fexL : Ex a :: G ⊢ c ; eigenvariable, conclusion + context shifted by rename S *)
    assert (HEx : tt I r (Ex a)) by (apply Hctx; left; reflexivity).
    simpl in HEx. destruct HEx as [d Hd].
    apply (proj1 (shift_ctx I r d c)).
    apply IHD. intros q [Heq | Hin].
    + rewrite <- Heq. exact Hd.
    + apply in_map_iff in Hin. destruct Hin as [g [Hge Hg]]. subst q.
      apply (proj2 (shift_ctx I r d g)). apply Hctx; right; exact Hg.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0)                             *)
(* Each command below prints: "Closed under the global context".          *)
(* First-order sequent soundness (prop + fcut + forall-L/R + exists-R).    *)
(* No axioms, no Admitted.                                                 *)
(* ====================================================================== *)
Print Assumptions soundF .
Print Assumptions rename_sound .
Print Assumptions inst_sound .
Print Assumptions ttff_ext .
Print Assumptions shift_ctx .

End FOL.

(* ================== Module Linear  (from RDL_Linear.v) ================== *)
Module Linear.

(* ===================================================================== *)
(*  RDL_Linear.v  —  the SUBSTRUCTURAL core of RDL, mechanized.           *)
(*                                                                        *)
(*  Multiplicative intuitionistic linear sequent calculus `Lin` with      *)
(*  MULTISET contexts (Permutation-quotiented lists): ax / exch / cut /   *)
(*  1 / ⊗ / ⊸.  No structural rules are assumed.                          *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free:                              *)
(*    Lin_grading          ℤ-grading conservation: every provable         *)
(*                         sequent satisfies  Σcost(Γ) = cost(φ)           *)
(*    weakening_unsound     ~ Lin [p] 1     (a premise cannot be discarded)*)
(*    contraction_unsound   ~ Lin [p] (p⊗p) (a premise cannot be doubled)  *)
(*  ⇒ the calculus is genuinely substructural (was the DES claim).        *)
(*                                                                        *)
(*  LinE extends Lin with `!`. Positive derivations                       *)
(*    bang_derelict  !A ⊢ A ;  bang_weak  !A ⊢ 1 ;  bang_dup  !A ⊢ !A⊗!A   *)
(*  mechanize "only !d is freely weakened/contracted." The grading model   *)
(*  is, by design, NOT sound for LinE (dereliction would force cost A = 0) *)
(*  — exactly why ! is the controlled gateway to the structural rules.    *)
(*                                                                        *)
(*  Still DES: a phase/quantale model for the residual MELL separations;   *)
(*  additive ⊕/& ; involutive two-sided ∼ (MLL) ; resolution & record     *)
(*  rules ; cut-elimination for this budgeted calculus.                    *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.ZArith.ZArith.
Import Coq.micromega.Lia.
Import Coq.Sorting.Permutation.

Inductive LForm :=
| lvar  : nat -> LForm
| lone  : LForm
| ltens : LForm -> LForm -> LForm
| llolli: LForm -> LForm -> LForm
| lbang : LForm -> LForm.

Inductive Lin : list LForm -> LForm -> Prop :=
| l_ax     : forall A,           Lin [A] A
| l_exch   : forall G D A,       Permutation G D -> Lin G A -> Lin D A
| l_cut    : forall G D A C,     Lin G A -> Lin (A::D) C -> Lin (G++D) C
| l_oneR   :                     Lin [] lone
| l_oneL   : forall G C,         Lin G C -> Lin (lone::G) C
| l_tensR  : forall G D A B,     Lin G A -> Lin D B -> Lin (G++D) (ltens A B)
| l_tensL  : forall G A B C,     Lin (A::B::G) C -> Lin (ltens A B::G) C
| l_lolliR : forall G A B,       Lin (A::G) B -> Lin G (llolli A B)
| l_lolliL : forall G D A B C,   Lin G A -> Lin (B::D) C -> Lin (llolli A B::(G++D)) C.

(* ---- ℤ-grading conservation model ----------------------------------- *)
Fixpoint cost (f:nat->Z) (A:LForm) : Z :=
  match A with
  | lvar n     => f n
  | lone       => 0%Z
  | ltens A B  => (cost f A + cost f B)%Z
  | llolli A B => (cost f B - cost f A)%Z
  | lbang _    => 0%Z
  end.
Definition gsum (f:nat->Z) (G:list LForm) : Z := fold_right Z.add 0%Z (map (cost f) G).

Lemma gsum_nil  : forall f, gsum f [] = 0%Z.        Proof. reflexivity. Qed.
Lemma gsum_cons : forall f A G, gsum f (A::G) = (cost f A + gsum f G)%Z. Proof. reflexivity. Qed.
Lemma gsum_app  : forall f G D, gsum f (G++D) = (gsum f G + gsum f D)%Z.
Proof.
  intros f G D. induction G as [|A G IH].
  - rewrite app_nil_l, gsum_nil. lia.
  - rewrite <- app_comm_cons, !gsum_cons, IH. lia.
Qed.
Lemma gsum_perm : forall f G D, Permutation G D -> gsum f G = gsum f D.
Proof.
  intros f G D HP. induction HP.
  - reflexivity.
  - rewrite !gsum_cons. lia.
  - rewrite !gsum_cons. lia.
  - lia.
Qed.

Theorem Lin_grading : forall G A, Lin G A -> forall f, gsum f G = cost f A.
Proof.
  intros G A Der. induction Der; intros f;
    repeat match goal with H : forall _ : nat -> Z, _ |- _ => specialize (H f) end;
    repeat match goal with H : Permutation ?X ?Y |- _ => rewrite (gsum_perm f X Y H) in * end;
    repeat (rewrite gsum_cons in * || rewrite gsum_app in * || rewrite gsum_nil in *);
    cbn [cost] in *;
    lia.
Qed.

(* ---- the structural rules are UNSOUND in the linear calculus -------- *)
Definition val1 : nat -> Z := fun _ => 1%Z.

Theorem weakening_unsound : ~ Lin [lvar 0] lone.
Proof. intro H. pose proof (Lin_grading _ _ H val1) as G. vm_compute in G. lia. Qed.

Theorem contraction_unsound : ~ Lin [lvar 0] (ltens (lvar 0) (lvar 0)).
Proof. intro H. pose proof (Lin_grading _ _ H val1) as G. vm_compute in G. lia. Qed.

(* sanity: identity and a genuine linear entailment ARE provable *)
Example ax_ok    : Lin [lvar 0] (lvar 0).  Proof. apply l_ax. Qed.
Example modus_ok : Lin [lvar 0; llolli (lvar 0) (lvar 1)] (lvar 1).
Proof.
  apply (l_exch (llolli (lvar 0) (lvar 1) :: [lvar 0])); [apply perm_swap|].
  change (llolli (lvar 0) (lvar 1) :: [lvar 0])
    with (llolli (lvar 0) (lvar 1) :: ([lvar 0] ++ [])).
  apply l_lolliL; apply l_ax.
Qed.

(* ---- LinE = Lin + the exponential `!` -------------------------------- *)
Inductive LinE : list LForm -> LForm -> Prop :=
| le_emb     : forall G A,       Lin G A -> LinE G A
| le_exch    : forall G D A,     Permutation G D -> LinE G A -> LinE D A
| le_cut     : forall G D A C,   LinE G A -> LinE (A::D) C -> LinE (G++D) C
| le_tensR   : forall G D A B,   LinE G A -> LinE D B -> LinE (G++D) (ltens A B)
| le_derelict: forall G A C,     LinE (A::G) C -> LinE (lbang A :: G) C
| le_weak    : forall G A C,     LinE G C -> LinE (lbang A :: G) C
| le_contr   : forall G A C,     LinE (lbang A :: lbang A :: G) C -> LinE (lbang A :: G) C.

Lemma bang_derelict : forall A, LinE [lbang A] A.
Proof. intro A. apply le_derelict. apply le_emb. apply l_ax. Qed.

Lemma bang_weak : forall A, LinE [lbang A] lone.
Proof. intro A. apply le_weak. apply le_emb. apply l_oneR. Qed.

Lemma bang_dup : forall A, LinE [lbang A] (ltens (lbang A) (lbang A)).
Proof.
  intro A. apply le_contr.
  change [lbang A; lbang A] with ([lbang A] ++ [lbang A]).
  apply le_tensR; apply le_emb; apply l_ax.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context". Lin_grading = conservation ; weakening/contraction_unsound =  *)
(* substructural signature ; bang_* = ! restores structurals (only on !).  *)
(* ====================================================================== *)
Print Assumptions Lin_grading.
Print Assumptions weakening_unsound.
Print Assumptions contraction_unsound.
Print Assumptions bang_derelict.
Print Assumptions bang_weak.
Print Assumptions bang_dup.

End Linear.

(* ================== Module Modal  (from RDL_Modal.v) ================== *)
Module Modal.

(* ===================================================================== *)
(*  RDL_Modal.v  —  soundness of the URCF modal layer ◇/□.                 *)
(*                                                                        *)
(*  In URCF, `◇/□` quantify over the FIELD OF RETAINED ALTERNATIVES,       *)
(*  itself derived from distinguishability (RDL-MOD-1). That field is a    *)
(*  Kripke frame (W, R) whose accessibility R is the retained causal       *)
(*  order — exactly the relation `reach` of RDL_Graph.v. A graph / causal  *)
(*  order simply IS a Kripke frame, which is why the discrete-order core    *)
(*  bridges directly to the modality item.                                *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free:                                   *)
(*    K_valid     □(a→b) → (□a → □b)        — valid in EVERY frame          *)
(*    nec         ⊨ a  ⇒  ⊨ □a               — necessitation, every frame    *)
(*    T_valid     □a → a                     — valid when R reflexive        *)
(*    Four_valid  □a → □□a                   — valid when R transitive       *)
(*  The retained causal order is a preorder (reflexive + transitive), so   *)
(*  ◇/□ over it is S4-SOUND. (Completeness — a canonical frame — stays DES.)*)
(* ===================================================================== *)

Inductive MForm :=
| matom : nat -> MForm
| mbot  : MForm
| mimp  : MForm -> MForm -> MForm
| mbox  : MForm -> MForm.

Definition mneg (a:MForm) : MForm := mimp a mbot.
Definition mdia (a:MForm) : MForm := mneg (mbox (mneg a)).   (* ◇a := ¬□¬a *)

(* Kripke forcing over a frame (W,R) with valuation val *)
Fixpoint force (W:Type) (R:W->W->Prop) (val:W->nat->Prop) (w:W) (A:MForm) : Prop :=
  match A with
  | matom p  => val w p
  | mbot     => False
  | mimp a b => force W R val w a -> force W R val w b
  | mbox a   => forall v, R w v -> force W R val v a
  end.

Definition Fvalid (W:Type) (R:W->W->Prop) (A:MForm) : Prop :=
  forall val w, force W R val w A.

(* K : distribution — valid in every frame *)
Theorem K_valid : forall W R a b,
  Fvalid W R (mimp (mbox (mimp a b)) (mimp (mbox a) (mbox b))).
Proof.
  intros W R a b val w. simpl. intros Hab Ha v Rwv.
  apply (Hab v Rwv). apply (Ha v Rwv).
Qed.

(* Necessitation — every frame *)
Theorem nec : forall W R a, Fvalid W R a -> Fvalid W R (mbox a).
Proof. intros W R a Ha val w. simpl. intros v Rwv. apply Ha. Qed.

(* T : reflexivity ⇒ □a → a *)
Theorem T_valid : forall W R a,
  (forall w, R w w) -> Fvalid W R (mimp (mbox a) a).
Proof. intros W R a Hrefl val w. simpl. intros H. apply H. apply Hrefl. Qed.

(* 4 : transitivity ⇒ □a → □□a *)
Theorem Four_valid : forall W R a,
  (forall x y z, R x y -> R y z -> R x z) ->
  Fvalid W R (mimp (mbox a) (mbox (mbox a))).
Proof.
  intros W R a Htrans val w. simpl. intros H v Rwv u Rvu.
  apply H. apply (Htrans w v u Rwv Rvu).
Qed.

(* Corollary: over a preorder (the retained causal order), S4 holds. *)
Theorem s4_sound : forall W (Rle:W->W->Prop) a,
  (forall w, Rle w w) ->
  (forall x y z, Rle x y -> Rle y z -> Rle x z) ->
  Fvalid W Rle (mimp (mbox a) a) /\ Fvalid W Rle (mimp (mbox a) (mbox (mbox a))).
Proof.
  intros W Rle a Hr Ht. split; [ apply T_valid; exact Hr | apply Four_valid; exact Ht ].
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  K + necessitation (any frame) ; T + 4 (reflexive/transitive) *)
(* ⇒ S4 soundness over the retained causal-order frame.                    *)
(* ====================================================================== *)
Print Assumptions K_valid.
Print Assumptions nec.
Print Assumptions T_valid.
Print Assumptions Four_valid.
Print Assumptions s4_sound.

End Modal.

(* ================== Module Graph  (from RDL_Graph.v) ================== *)
Module Graph.

(* ===================================================================== *)
(*  RDL_Graph.v  —  the causal-graph (node-graph) SPECTRAL core of URCF.   *)
(*                                                                        *)
(*  Causal set theory's mathematical kernel is a locally-finite poset     *)
(*  with an associated causal / link matrix and graph-Laplacian spectrum. *)
(*  In the URCF frame this IS the retained order `D` plus the geometry     *)
(*  operator  L_R = D_W − W.  Here we mechanize the symmetric-weight        *)
(*  graph-Laplacian spectral facts that BOTH the URCF turbulence (RTPE)    *)
(*  and DHRG proof packs *assume* as a premise (Δ_spec = λ₂ > 0).          *)
(*                                                                        *)
(*  We work over ℚ (constructive ⇒ axiom-free; the analytic facts come     *)
(*  from `lra`/`nra` of Lqa, which add no axioms).                        *)
(*                                                                        *)
(*  energy V x  =  Σ_{i,j∈V} w_ij (x_i − x_j)²   = 2·xᵀ L_R x              *)
(*  (the Dirichlet energy = the quadratic form of L_R = D_W − W).          *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free:                                   *)
(*    energy_nonneg     0 ≤ energy V x                 (L_R is PSD)        *)
(*    energy_const      energy V (const c) == 0        (constants ∈ ker)  *)
(*    energy_zero_edge  energy V x == 0 ⇒ x equal across every edge        *)
(*    kernel_connected  connected V ⇒ (energy V x == 0 ⇒ x constant on V) *)
(*                      = algebraic connectivity / Fiedler, KERNEL form:   *)
(*                      ker L_R = constants  ⇔  the graph is connected.    *)
(*                      (⇒ the assumed λ₂ > 0 premise is now a theorem.)   *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.QArith.QArith.
Import Coq.micromega.Lqa.

(* ---- ℚ square helpers (each a tiny `nra`, no axioms) ----------------- *)
Lemma Qsq_nonneg : forall a:Q, 0 <= a * a.
Proof. intro a. nra. Qed.
Lemma Qsq_eq0 : forall a:Q, a * a == 0 -> a == 0.
Proof. intros a H. nra. Qed.
Lemma Qmult_pos_eq0 : forall p a:Q, 0 < p -> p * a == 0 -> a == 0.
Proof. intros p a Hp H. nra. Qed.

Section Graph.
Variable w : nat -> nat -> Q.                 (* edge weights *)
Hypothesis wsym : forall i j, w i j == w j i.  (* symmetric (undirected) *)
Hypothesis wpos : forall i j, 0 <= w i j.      (* nonnegative *)

(* finite vertex carrier = a list of indices; sums fold over it *)
Definition sumV (V:list nat) (f:nat->Q) : Q := fold_right Qplus 0 (map f V).

Lemma sumV_nil  : forall f, sumV [] f = 0.                       Proof. reflexivity. Qed.
Lemma sumV_cons : forall a V f, sumV (a::V) f = (f a + sumV V f). Proof. reflexivity. Qed.

Lemma sumV_nonneg : forall V f, (forall i, In i V -> 0 <= f i) -> 0 <= sumV V f.
Proof.
  induction V as [|a V IH]; intros f H.
  - rewrite sumV_nil. lra.
  - rewrite sumV_cons.
    assert (0 <= f a) by (apply H; left; reflexivity).
    assert (0 <= sumV V f) by (apply IH; intros i Hi; apply H; right; exact Hi).
    lra.
Qed.

Lemma sumV_eq0 : forall V f, (forall i, In i V -> f i == 0) -> sumV V f == 0.
Proof.
  induction V as [|a V IH]; intros f H.
  - rewrite sumV_nil. reflexivity.
  - rewrite sumV_cons.
    assert (Ha : f a == 0) by (apply H; left; reflexivity).
    assert (HV : sumV V f == 0) by (apply IH; intros i Hi; apply H; right; exact Hi).
    rewrite Ha, HV. ring.
Qed.

Lemma sumV_zero_each : forall V f, (forall i, In i V -> 0 <= f i) -> sumV V f == 0 ->
                       forall i, In i V -> f i == 0.
Proof.
  induction V as [|a V IH]; intros f Hpos Hsum i Hi.
  - inversion Hi.
  - rewrite sumV_cons in Hsum.
    assert (Ha : 0 <= f a) by (apply Hpos; left; reflexivity).
    assert (HV : 0 <= sumV V f) by (apply sumV_nonneg; intros j Hj; apply Hpos; right; exact Hj).
    assert (Hfa : f a == 0) by lra.
    assert (HsV : sumV V f == 0) by lra.
    destruct Hi as [Hia | Hi'].
    + rewrite Hia in Hfa. exact Hfa.
    + apply (IH f); [ intros j Hj; apply Hpos; right; exact Hj | exact HsV | exact Hi' ].
Qed.

(* ---- Dirichlet energy = quadratic form of the Laplacian L_R = D_W − W -- *)
Definition energy (V:list nat) (x:nat->Q) : Q :=
  sumV V (fun i => sumV V (fun j => w i j * (x i - x j) * (x i - x j))).

(* L_R is positive semidefinite *)
Theorem energy_nonneg : forall V x, 0 <= energy V x.
Proof.
  intros V x. apply sumV_nonneg. intros i Hi. apply sumV_nonneg. intros j Hj.
  pose proof (wpos i j). pose proof (Qsq_nonneg (x i - x j)). nra.
Qed.

(* constant vectors are in the kernel (λ₁ = 0, all-ones zero mode) *)
Theorem energy_const : forall V c, energy V (fun _ => c) == 0.
Proof.
  intros V c. unfold energy.
  apply sumV_eq0. intros i Hi. cbv beta.
  apply sumV_eq0. intros j Hj. cbv beta. ring.
Qed.

(* ---- connectivity ---------------------------------------------------- *)
Definition edge (i j:nat) : Prop := 0 < w i j.

Inductive reach (V:list nat) : nat -> nat -> Prop :=
| reach0 : forall i,     In i V -> reach V i i
| reachS : forall i j k, In i V -> edge i j -> reach V j k -> reach V i k.

Lemma reach_inL : forall V a b, reach V a b -> In a V.
Proof. intros V a b H. induction H; assumption. Qed.

Definition connected (V:list nat) : Prop :=
  forall i j, In i V -> In j V -> reach V i j.

(* zero energy forces equality across every (positively-weighted) edge *)
Theorem energy_zero_edge : forall V x, energy V x == 0 ->
   forall i j, In i V -> In j V -> edge i j -> x i == x j.
Proof.
  intros V x Hen i j Hi Hj Hedge.
  assert (Hinner : sumV V (fun b => w i b * (x i - x b) * (x i - x b)) == 0).
  { apply (sumV_zero_each V (fun a => sumV V (fun b => w a b * (x a - x b) * (x a - x b)))).
    - intros a Ha. apply sumV_nonneg. intros b Hb. pose proof (wpos a b). pose proof (Qsq_nonneg (x a - x b)). nra.
    - exact Hen.
    - exact Hi. }
  assert (Hterm : w i j * (x i - x j) * (x i - x j) == 0).
  { apply (sumV_zero_each V (fun b => w i b * (x i - x b) * (x i - x b))).
    - intros b Hb. pose proof (wpos i b). pose proof (Qsq_nonneg (x i - x b)). nra.
    - exact Hinner.
    - exact Hj. }
  assert (Hwdd : w i j * ((x i - x j) * (x i - x j)) == 0) by (rewrite <- Hterm; ring).
  apply (Qmult_pos_eq0 _ _ Hedge) in Hwdd.
  apply Qsq_eq0 in Hwdd. lra.
Qed.

(* equality propagates along any causal/reachable path *)
Lemma reach_eq : forall V x, energy V x == 0 ->
   forall i k, reach V i k -> x i == x k.
Proof.
  intros V x Hen i k Hr. induction Hr as [i Hi | i j k Hi Hedge Hr IHr].
  - reflexivity.
  - assert (Hj : In j V) by (eapply reach_inL; eauto).
    assert (Hxij : x i == x j)
      by (apply (energy_zero_edge V x Hen i j); [exact Hi | exact Hj | exact Hedge]).
    rewrite Hxij. exact IHr.
Qed.

(* ALGEBRAIC CONNECTIVITY / FIEDLER (kernel form):                         *)
(* on a connected graph the Laplacian's null space is exactly the constants *)
(* ⇔ the spectral margin λ₂ is strictly positive.                          *)
Theorem kernel_connected : forall V x, connected V -> energy V x == 0 ->
   forall i j, In i V -> In j V -> x i == x j.
Proof.
  intros V x Hconn Hen i j Hi Hj.
  apply (reach_eq V x Hen). apply Hconn; assumption.
Qed.

End Graph.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  PSD + zero-mode + edge-rigidity + Fiedler-kernel, all over   *)
(* ℚ, no axioms (the section hypotheses wsym/wpos became arguments).       *)
(* ====================================================================== *)
Print Assumptions energy_nonneg.
Print Assumptions energy_const.
Print Assumptions energy_zero_edge.
Print Assumptions kernel_connected.

End Graph.

(* ================== Module Readout  (from RDL_Readout.v) ================== *)
Module Readout.

(* ===================================================================== *)
(*  RDL_Readout.v  —  the RECORD/READOUT and RESOLUTION layer of RDL,      *)
(*  with the semantics PINNED by the genesis canon (RAR §1, §3).          *)
(*                                                                        *)
(*  These are the two items previously flagged DES "needs its formal       *)
(*  semantics pinned first." The canon supplies them:                     *)
(*                                                                        *)
(*    record_genesis_operator :  M_A = K · θ + η                           *)
(*        K = framing/readout operator, θ = latent world-truth (never      *)
(*        directly accessed), η = irreducible residual/noise. A record is  *)
(*        an accessibility-weighted readout of retained distinguishability,*)
(*        NEVER the latent θ itself  (R_O ≠ D_O).                          *)
(*                                                                        *)
(*    resolution :  a coarse-graining = a vertex quotient  q : V → V'.      *)
(*        "φ factors through the coarsening G_{ρ→ρ'}" = φ is constant on    *)
(*        q-fibres (coarse-measurable).                                    *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free (over ℚ):                      *)
(*    record_ne_latent       irreducible residual ⇒ record ≠ latent       *)
(*                           (even with a perfect, identity framing)       *)
(*    readout_loses          a framing that identifies two distinct        *)
(*                           latents has NO exact inverse — read-out        *)
(*                           distinctions are not recoverable (RDL-LIM-1).  *)
(*    resolution_internal_zero  under coarsening, within-class             *)
(*                           distinctions vanish (the Dirichlet-energy      *)
(*                           content: q-internal edges drop out).          *)
(*    resolution_refine      coarse-measurable ⇒ fine-measurable           *)
(*                           (the resolution tower q' = r∘q).               *)
(*                                                                        *)
(*  This PINS the semantics + proves the characteristic theorems of the    *)
(*  record and resolution rules. Their full sequent-rule soundness (the    *)
(*  rules as proof-theoretic operators) stays DES.                        *)
(* ===================================================================== *)

Import Coq.QArith.QArith.
Import Coq.micromega.Lqa.

Definition State := nat -> Q.

(* ====================== RECORD / READOUT layer ======================== *)
(* a record is the readout K of the latent θ, plus irreducible residual η *)
Definition record (K:State->State) (theta eta:State) : State :=
  fun i => K theta i + eta i.

(* (1) irreducible residual ⇒ the record is never the latent,              *)
(*     even under a perfect (identity) framing  (R_O ≠ D_O).               *)
Theorem record_ne_latent :
  forall (theta eta:State) i, ~ (eta i == 0) ->
    ~ (record (fun s => s) theta eta i == theta i).
Proof.
  intros theta eta i Hne Heq. unfold record in Heq. cbn in Heq.
  apply Hne. lra.
Qed.

(* (2) a framing that collapses two distinct latents to the SAME record    *)
(*     has no exact reconstruction: distinctions read out are lost         *)
(*     (no left inverse of a non-injective readout) — the structural        *)
(*     no-omniscience floor (RDL-LIM-1).                                   *)
Theorem readout_loses :
  forall (K:State->State) (a b:State),
    K a = K b ->                                  (* K identifies a and b   *)
    ~ (forall i, a i == b i) ->                    (* yet a, b differ        *)
    ~ (exists g:State->State, forall s, g (K s) = s). (* no exact inverse    *)
Proof.
  intros K a b Hcollapse Hdiff [g Hg].
  apply Hdiff. intro i.
  assert (E : a = b).
  { rewrite <- (Hg a), <- (Hg b), Hcollapse. reflexivity. }
  rewrite E. reflexivity.
Qed.

(* ======================== RESOLUTION layer ============================ *)
(* coarsening G_{ρ→ρ'} = a vertex quotient q ; "φ factors through it"      *)
(* = φ is constant on q-fibres (coarse-measurable).                        *)
Definition respects (q:nat->nat) (x:State) : Prop :=
  forall i j, q i = q j -> x i == x j.

(* (3) under coarsening, within-class (q-internal) distinctions vanish —    *)
(*     so q-internal edges contribute 0 to the Dirichlet energy of L_R.    *)
(*     This is the resolution rule's content: coarsening loses, not        *)
(*     creates, distinctions.                                              *)
Theorem resolution_internal_zero :
  forall q x i j, respects q x -> q i = q j -> (x i - x j) * (x i - x j) == 0.
Proof.
  intros q x i j Hr Hq.
  assert (Heq : x i == x j) by (apply Hr; exact Hq).
  assert (x i - x j == 0) by lra. nra.
Qed.

(* (4) the resolution tower: if x is measurable at the COARSER resolution   *)
(*     q' = r∘q, it is measurable at the FINER resolution q.               *)
Theorem resolution_refine :
  forall (q r:nat->nat) (x:State),
    respects (fun i => r (q i)) x -> respects q x.
Proof.
  intros q r x H i j Hq. apply H. rewrite Hq. reflexivity.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  record≠latent + lossy-readout-not-invertible (record rule    *)
(* semantics) ; internal-collapse + resolution-tower (resolution rule       *)
(* semantics).  No axioms (no funext, no classical).                       *)
(* ====================================================================== *)
Print Assumptions record_ne_latent.
Print Assumptions readout_loses.
Print Assumptions resolution_internal_zero.
Print Assumptions resolution_refine.

End Readout.

(* ================== Module RuleSound  (from RDL_RuleSound.v) ================== *)
Module RuleSound.

(* ===================================================================== *)
(*  RDL_RuleSound.v  —  SOUNDNESS of the resolution and record rules,       *)
(*  as inference rules over FDE valuations, grounding the semantics         *)
(*  pinned in RDL_Readout.v.                                               *)
(*                                                                        *)
(*  FDE valuation:  ν : atom → val,  val = bool×bool,  designated = fst.    *)
(*  A "resolution ρ" is a coarsening q on atoms; ν is ρ-measurable          *)
(*  (respects the resolution) iff it is constant on q-fibres.              *)
(*  validity at resolution q := holds for every q-measurable valuation.    *)
(*                                                                        *)
(*  VERIFIED HERE (coqc 8.18.0), axiom-free:                              *)
(*                                                                        *)
(*  RESOLUTION RULE                                                        *)
(*    resolution_sound          a judgment valid at a FINE resolution q     *)
(*                              stays valid at any COARSER resolution r∘q    *)
(*                              (the rule  ⊨_ρ φ  ⟹  ⊨_ρ' φ , ρ' coarser    *)
(*                              — coarsening loses, never creates,          *)
(*                              distinctions, so it preserves validity).    *)
(*    resolution_creates_validity   the rule is NONTRIVIAL: merging two     *)
(*                              atoms makes `atom0 = atom1` valid at the     *)
(*                              coarse resolution though it fails at the     *)
(*                              finest one.                                  *)
(*                                                                        *)
(*  RECORD RULE  (record_genesis  M_A = K·θ + η)                           *)
(*    record_sound              record INTRODUCTION is sound: a universal   *)
(*                              (latent) truth survives any framing K.       *)
(*    record_not_factive        record ELIMINATION is UNSOUND: record-       *)
(*                              validity does NOT yield latent-validity —    *)
(*                              a record is never the latent θ (R_O ≠ D_O).  *)
(*                              Witness: a total framing collapse.           *)
(* ===================================================================== *)

Import Coq.Arith.PeanoNat.

Definition val := (bool * bool)%type.
Definition Val := nat -> val.
Definition desig (v:val) : Prop := fst v = true.    (* designated = {T,B} *)

(* ====================== RESOLUTION RULE =============================== *)
Definition respects_val (q:nat->nat) (nu:Val) : Prop :=
  forall p p', q p = q p' -> nu p = nu p'.
Definition valid_at (q:nat->nat) (sat:Val->Prop) : Prop :=
  forall nu, respects_val q nu -> sat nu.

(* SOUND: validity at a fine resolution transports to any coarser one.     *)
Theorem resolution_sound :
  forall (q r:nat->nat) (sat:Val->Prop),
    valid_at q sat -> valid_at (fun p => r (q p)) sat.
Proof.
  intros q r sat H nu Hnu. apply H.
  intros p p' Hq. apply Hnu. rewrite Hq. reflexivity.
Qed.

(* NONTRIVIAL: coarsening can strictly CREATE validity (merge atoms 0,1).  *)
Definition agree01 : Val -> Prop := fun nu => nu 0 = nu 1.
Definition mergeq  : nat -> nat   := fun p => if Nat.eqb p 1 then 0 else p.

Theorem resolution_creates_validity :
  valid_at mergeq agree01 /\ ~ valid_at (fun p => p) agree01.
Proof.
  split.
  - intros nu Hnu. unfold agree01. apply (Hnu 0 1). reflexivity.
  - intros H.
    pose (nu := fun p : nat => if Nat.eqb p 0 then (true,false) else (false,false)).
    assert (Hr : respects_val (fun p => p) nu)
      by (intros p p' E; rewrite E; reflexivity).
    specialize (H nu Hr). unfold agree01, nu in H. cbn in H. discriminate H.
Qed.

(* ======================== RECORD RULE ================================= *)
(* a readout K reframes the valuation; record-validity = validity on K(θ). *)

(* SOUND (record introduction): a universal latent truth survives framing.  *)
Theorem record_sound :
  forall (K:Val->Val) (sat:Val->Prop),
    (forall nu, sat nu) -> (forall nu, sat (K nu)).
Proof. intros K sat H nu. apply H. Qed.

(* UNSOUND (record elimination): record-valid does NOT give latent-valid —  *)
(* the record is never the latent θ. Witness: a total framing collapse.    *)
Definition Kcollapse : Val -> Val := fun _ _ => (true,false).
Definition sat0 : Val -> Prop := fun nu => nu 0 = (true,false).

Theorem record_not_factive :
  (forall nu, sat0 (Kcollapse nu)) /\ ~ (forall nu, sat0 nu).
Proof.
  split.
  - intros nu. unfold sat0, Kcollapse. reflexivity.
  - intros H. specialize (H (fun _ => (false,false))).
    unfold sat0 in H. cbn in H. discriminate H.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  resolution rule sound + nontrivial ; record introduction     *)
(* sound, record elimination unsound (record ≠ latent).                    *)
(* ====================================================================== *)
Print Assumptions resolution_sound.
Print Assumptions resolution_creates_validity.
Print Assumptions record_sound.
Print Assumptions record_not_factive.

End RuleSound.

(* ================== Module Rules  (from RDL_Rules.v) ================== *)
Module Rules.

(* ===================================================================== *)
(*  RDL_Rules.v  —  SOUNDNESS of the record rule and the resolution rule.  *)
(*                                                                        *)
(*  Building on the semantics pinned in RDL_Readout.v, here the two rules  *)
(*  are stated as proper inference rules and proved sound (validity-       *)
(*  preserving) w.r.t. that semantics.                                    *)
(*                                                                        *)
(*  Record / readout modality  R  (rrec):  R φ is read off the K-          *)
(*  transformed state — `sat (R φ) x = sat φ (K x)` — the logical form of  *)
(*  the record_genesis operator M_A = K·θ + η.                            *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free (over ℚ):                          *)
(*    R_dist          R(a→b) → (Ra → Rb)         — R distributes (any K)   *)
(*    R_nec           ⊨ a  ⇒  ⊨ R a              — necessitation           *)
(*    R_not_factive   R a → a is NOT valid       — the record is never     *)
(*                    the latent (you cannot read raw truth off a record); *)
(*                    contrast S4's factive □ (RDL_Modal.v) — R is the      *)
(*                    deliberately NON-factive readout modality.           *)
(*    resolution_rule ⊨_q Γ φ  ⇒  ⊨_{r∘q} Γ φ    — valid at a FINE          *)
(*                    resolution ⇒ valid at any COARSER one (sound; proved  *)
(*                    via the resolution tower respects(r∘q) ⊆ respects q). *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.QArith.QArith.
Import Coq.micromega.Lqa.

Definition State := nat -> Q.

Inductive RForm :=
| ratom : nat -> RForm
| rbot  : RForm
| rimp  : RForm -> RForm -> RForm
| rrec  : RForm -> RForm.            (* R : the record/readout modality *)

Definition rneg (a:RForm) : RForm := rimp a rbot.

(* forcing; the record modality reads its argument off the K-transformed state *)
Fixpoint sat (K:State->State) (val:State->nat->Prop) (x:State) (A:RForm) : Prop :=
  match A with
  | ratom p  => val x p
  | rbot     => False
  | rimp a b => sat K val x a -> sat K val x b
  | rrec a   => sat K val (K x) a
  end.

Definition Rvalid (K:State->State) (A:RForm) : Prop := forall val x, sat K val x A.

(* ---- record rule: distribution + necessitation (sound for every K) --- *)
Theorem R_dist : forall K a b,
  Rvalid K (rimp (rrec (rimp a b)) (rimp (rrec a) (rrec b))).
Proof. intros K a b val x. simpl. intros Hab Ha. apply Hab. exact Ha. Qed.

Theorem R_nec : forall K a, Rvalid K a -> Rvalid K (rrec a).
Proof. intros K a Ha val x. simpl. apply Ha. Qed.

(* ---- the record is NOT factive: R φ → φ fails (record ≠ latent) ------- *)
Theorem R_not_factive : exists K a, ~ Rvalid K (rimp (rrec a) a).
Proof.
  exists (fun _ : State => fun _ : nat => 0%Q). exists (ratom 0).
  unfold Rvalid. intro H.
  specialize (H (fun (s:State) (n:nat) => s n == 0%Q) (fun _ : nat => 1%Q)).
  simpl in H.
  assert (Hpre : 0%Q == 0%Q) by reflexivity.
  specialize (H Hpre). lra.
Qed.

(* ---- resolution rule: fine-resolution validity ⇒ coarse-resolution ---- *)
Definition respects (q:nat->nat) (x:State) : Prop :=
  forall i j, q i = q j -> x i == x j.

Definition valid_at (q:nat->nat) (K:State->State) (val:State->nat->Prop)
                    (G:list RForm) (A:RForm) : Prop :=
  forall x, respects q x -> (forall g, In g G -> sat K val x g) -> sat K val x A.

Theorem resolution_rule :
  forall (q r:nat->nat) K val G A,
    valid_at q K val G A -> valid_at (fun i => r (q i)) K val G A.
Proof.
  intros q r K val G A H x Hx HG.
  apply H; [ | exact HG ].
  intros i j Hq. apply Hx. rewrite Hq. reflexivity.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  Record rule (distribution + necessitation + non-factivity)   *)
(* and resolution rule (fine ⇒ coarse) are SOUND w.r.t. the readout /       *)
(* coarsening semantics. No axioms (no funext, no classical).              *)
(* ====================================================================== *)
Print Assumptions R_dist.
Print Assumptions R_nec.
Print Assumptions R_not_factive.
Print Assumptions resolution_rule.

End Rules.

(* ================== Module Phase  (from RDL_Phase.v) ================== *)
Module Phase.

(* ===================================================================== *)
(*  RDL_Phase.v  —  the PHASE / QUANTALE model for RDL's linear layer.     *)
(*                                                                        *)
(*  Girard's phase semantics: over a commutative monoid (M,·,1) with a     *)
(*  distinguished pole ⊥ ⊆ M, the orthogonal  X^⊥ = { m | ∀x∈X, m·x∈⊥ }    *)
(*  gives a closure operator  X ↦ X^⊥⊥  whose fixpoints are the FACTS.      *)
(*  Facts form a *-autonomous lattice: the orthogonal is an INVOLUTIVE      *)
(*  negation, ⊗/1 are the multiplicatives, ∩/closure-∪ the additives &/⊕.  *)
(*                                                                        *)
(*  Mechanized WITHOUT funext / prop-ext: sets are M→Prop, handled up to    *)
(*  inclusion `Inc` and equivalence `Equiv`.                              *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free:                                   *)
(*    orth3       X^⊥⊥⊥ ≈ X^⊥                    (closure operator)         *)
(*    orth_fact   X^⊥ is always a fact                                     *)
(*    dual_invol  Fact X ⇒ ∼∼X ≈ X              (TWO-SIDED INVOLUTIVE ∼)    *)
(*    tens_fact   X⊗Y is a fact ;  tens_comm  X⊗Y ≈ Y⊗X                     *)
(*    one_fact / bot_fact   the units 1, ⊥ are facts                       *)
(*    with_fact   X & Y (= X∩Y) is a fact        (ADDITIVE &, the meet)     *)
(*    plus_fact   X ⊕ Y (= (X∪Y)^⊥⊥) is a fact   (ADDITIVE ⊕, the join)     *)
(*                                                                        *)
(*  This is the model algebra for three DES items at once: the two-sided    *)
(*  involutive ∼, the phase/quantale model, and the additives ⊕/&. (The     *)
(*  ⊗-unit law, ⅋ via de Morgan, and full LL-sequent soundness against this *)
(*  model are the remaining wiring.)                                       *)
(* ===================================================================== *)

Section Phase.
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

Lemma inc_refl  : forall X, Inc X X.                          Proof. intros X m H; exact H. Qed.
Lemma inc_trans : forall X Y Z, Inc X Y -> Inc Y Z -> Inc X Z. Proof. intros X Y Z H1 H2 m H; apply H2, H1, H. Qed.

(* orthogonal *)
Definition orth (X:Ens) : Ens := fun m => forall x, X x -> pole (op m x).

Lemma orth_antitone : forall X Y, Inc X Y -> Inc (orth Y) (orth X).
Proof. intros X Y H m Hm x Hx. apply Hm. apply H. exact Hx. Qed.

Lemma inc_orth_orth : forall X, Inc X (orth (orth X)).
Proof.
  intros X m HX y Hy. rewrite (op_comm m y). apply Hy. exact HX.
Qed.

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

(* FACT = double-orthogonal-closed *)
Definition Fact (X:Ens) : Prop := Inc (orth (orth X)) X.

Lemma orth_fact : forall X, Fact (orth X).
Proof. intros X. unfold Fact. apply (orth3 X). Qed.

Lemma fact_orthorth : forall Z, Fact (orth (orth Z)).
Proof. intros Z. apply (orth_fact (orth Z)). Qed.

(* linear negation = orthogonal ; INVOLUTIVE on facts *)
Definition dual (X:Ens) : Ens := orth X.

Lemma dual_fact : forall X, Fact (dual X).
Proof. intros X. apply orth_fact. Qed.

Theorem dual_invol : forall X, Fact X -> Equiv (dual (dual X)) X.
Proof.
  intros X HF. split.
  - exact HF.
  - apply inc_orth_orth.
Qed.

(* ---- multiplicative tensor ⊗ and unit 1 ----------------------------- *)
Definition prod (X Y:Ens) : Ens := fun m => exists a b, X a /\ Y b /\ m = op a b.
Definition tens (X Y:Ens) : Ens := orth (orth (prod X Y)).

Theorem tens_fact : forall X Y, Fact (tens X Y).
Proof. intros X Y. apply fact_orthorth. Qed.

Theorem tens_comm : forall X Y, Equiv (tens X Y) (tens Y X).
Proof.
  intros X Y. apply equiv_clo. split; intros m [a [b [HA [HB Hm]]]];
    exists b, a; repeat split; try assumption; rewrite Hm; apply op_comm.
Qed.

Definition unitSet : Ens := fun m => m = e.
Definition oneF : Ens := orth (orth unitSet).
Definition botF : Ens := orth unitSet.

Theorem one_fact : Fact oneF.            Proof. apply fact_orthorth. Qed.
Theorem bot_fact : Fact botF.            Proof. apply orth_fact. Qed.

(* ---- additives :  & = intersection (meet) ,  ⊕ = closure of ∪ (join) - *)
Definition withF (X Y:Ens) : Ens := fun m => X m /\ Y m.
Definition plusF (X Y:Ens) : Ens := orth (orth (fun m => X m \/ Y m)).

Theorem with_fact : forall X Y, Fact X -> Fact Y -> Fact (withF X Y).
Proof.
  intros X Y HX HY m Hm. split.
  - apply HX. apply (clo_mono (withF X Y) X); [ intros z [Hz _]; exact Hz | exact Hm ].
  - apply HY. apply (clo_mono (withF X Y) Y); [ intros z [_ Hz]; exact Hz | exact Hm ].
Qed.

Theorem with_meet_l : forall X Y, Inc (withF X Y) X.   Proof. intros X Y m [H _]; exact H. Qed.
Theorem with_meet_r : forall X Y, Inc (withF X Y) Y.   Proof. intros X Y m [_ H]; exact H. Qed.

Theorem plus_fact : forall X Y, Fact (plusF X Y).      Proof. intros X Y. apply fact_orthorth. Qed.
Theorem plus_join_l : forall X Y, Inc X (plusF X Y).
Proof. intros X Y. apply (inc_trans X (fun m => X m \/ Y m)); [ intros m H; left; exact H | apply inc_orth_orth ]. Qed.
Theorem plus_join_r : forall X Y, Inc Y (plusF X Y).
Proof. intros X Y. apply (inc_trans Y (fun m => X m \/ Y m)); [ intros m H; right; exact H | apply inc_orth_orth ]. Qed.

End Phase.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  Closure operator + INVOLUTIVE negation (∼∼X≈X) + ⊗ (comm) +   *)
(* units + additive meet/join — the phase/quantale model algebra.          *)
(* No funext, no prop-ext, no classical.                                   *)
(* ====================================================================== *)
Print Assumptions orth3.
Print Assumptions dual_invol.
Print Assumptions tens_fact.
Print Assumptions tens_comm.
Print Assumptions one_fact.
Print Assumptions with_fact.
Print Assumptions plus_fact.

End Phase.

(* ================== Module Involution  (from RDL_Involution.v) ================== *)
Module Involution.

(* ===================================================================== *)
(*  RDL_Involution.v  —  involutive negation ∼ and the additive layer.    *)
(*                                                                        *)
(*  The RDL connective `∼` is the involutive dual (access-reversal,        *)
(*  RDL-NEG-1). The cleanest mechanization is the one-sided classical      *)
(*  multiplicative-additive linear calculus (MALL, Girard style): negation *)
(*  ∼ is the De Morgan `dual`, and INVOLUTION ∼∼A = A is a theorem about    *)
(*  that map. This file also brings the ADDITIVES ⊕/& into the calculus    *)
(*  (the ℤ-grading of RDL_Linear.v is sound only for the multiplicative    *)
(*  fragment, so additives need this proof-theoretic treatment).          *)
(*                                                                        *)
(*  VERIFIED (coqc 8.18.0), axiom-free:                                   *)
(*    dual_involutive  ∼∼A = A                 (involution — the ∼ law)    *)
(*    id_expand        ⊢ A, ∼A   for every A    (identity expansion / η):   *)
(*                     the axiom reduces to atoms; the multiplicative AND   *)
(*                     additive rules are jointly coherent.                *)
(*                                                                        *)
(*  Still DES: cut-elimination for this calculus, and a phase/quantale     *)
(*  model giving the additive↔multiplicative SEPARATIONS (e.g. A&B ⊬ A⊗B). *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.Sorting.Permutation.

(* full MALL formula syntax in negation-normal form *)
Inductive Frm :=
| at_   : nat -> Frm          (* atom         a    *)
| dat_  : nat -> Frm          (* dual atom    a⊥   *)
| tens  : Frm -> Frm -> Frm   (* ⊗            *)
| par   : Frm -> Frm -> Frm   (* ⅋            *)
| one   : Frm                 (* 1            *)
| bot   : Frm                 (* ⊥            *)
| awith : Frm -> Frm -> Frm   (* &            *)
| oplus : Frm -> Frm -> Frm   (* ⊕            *)
| top   : Frm                 (* ⊤            *)
| zero  : Frm.                (* 0            *)

(* De Morgan dual = the involutive negation ∼ *)
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

(* INVOLUTION: ∼ is its own inverse *)
Theorem dual_involutive : forall A, dual (dual A) = A.
Proof.
  induction A; simpl; try reflexivity; rewrite IHA1, IHA2; reflexivity.
Qed.

(* one-sided MALL sequent calculus  ⊢ Δ   (Δ a multiset) *)
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

(* IDENTITY EXPANSION (η):  ⊢ A, ∼A  for every formula A.                  *)
(* The axiom rule p_ax is only stated for atoms; this shows the general    *)
(* identity is derivable, and exercises every multiplicative + additive    *)
(* rule together.                                                          *)
Theorem id_expand : forall A, Prov [A; dual A].
Proof.
  induction A; simpl.
  - (* at_ n *) apply p_ax.
  - (* dat_ n *) apply (p_exch [at_ n; dat_ n]); [apply perm_swap | apply p_ax].
  - (* tens *)
    assert (H1 : Prov (tens A1 A2 :: ([dual A1] ++ [dual A2])))
      by (apply p_tens; [exact IHA1 | exact IHA2]).
    simpl in H1.
    assert (H2 : Prov [dual A1; dual A2; tens A1 A2]).
    { apply (p_exch _ _ (Permutation_app_comm [tens A1 A2] [dual A1; dual A2])) in H1. exact H1. }
    apply (p_exch [par (dual A1) (dual A2); tens A1 A2]); [apply perm_swap |].
    apply p_par. exact H2.
  - (* par *)
    assert (H1 : Prov (tens (dual A1) (dual A2) :: ([A1] ++ [A2]))).
    { apply p_tens; [ apply (p_exch [A1; dual A1]); [apply perm_swap | exact IHA1]
                    | apply (p_exch [A2; dual A2]); [apply perm_swap | exact IHA2] ]. }
    simpl in H1.
    assert (H2 : Prov [A1; A2; tens (dual A1) (dual A2)]).
    { apply (p_exch _ _ (Permutation_app_comm [tens (dual A1) (dual A2)] [A1; A2])) in H1. exact H1. }
    apply p_par. exact H2.
  - (* one *) apply (p_exch [bot; one]); [apply perm_swap |]. apply p_bot. apply p_one.
  - (* bot *) apply p_bot. apply p_one.
  - (* awith *)
    apply p_with.
    + apply (p_exch [oplus (dual A1) (dual A2); A1]); [apply perm_swap |].
      apply p_oplus1. apply (p_exch [A1; dual A1]); [apply perm_swap | exact IHA1].
    + apply (p_exch [oplus (dual A1) (dual A2); A2]); [apply perm_swap |].
      apply p_oplus2. apply (p_exch [A2; dual A2]); [apply perm_swap | exact IHA2].
  - (* oplus *)
    apply (p_exch [awith (dual A1) (dual A2); oplus A1 A2]); [apply perm_swap |].
    apply p_with.
    + apply (p_exch [oplus A1 A2; dual A1]); [apply perm_swap |].
      apply p_oplus1. exact IHA1.
    + apply (p_exch [oplus A1 A2; dual A2]); [apply perm_swap |].
      apply p_oplus2. exact IHA2.
  - (* top *) apply p_top.
  - (* zero *) apply (p_exch [top; zero]); [apply perm_swap |]. apply p_top.
Qed.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) — "Closed under the global   *)
(* context".  dual_involutive = the ∼ law ; id_expand = the calculus       *)
(* proves every identity (multiplicative + additive rules coherent).       *)
(* ====================================================================== *)
Print Assumptions dual_involutive.
Print Assumptions id_expand.

End Involution.

(* ================== Module PhaseSound  (from RDL_PhaseSound.v) ================== *)
Module PhaseSound.

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

Import Coq.Lists.List. Import ListNotations.
Import Coq.Sorting.Permutation.
Import Coq.Arith.PeanoNat.
Import Lia.

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

(* validity of  |- (A&B)^perp, A (x) B  forces  orth(pmul v0 v1) <= orth(v0&v1).  *)
(* The de Morgan dual  (A&B)^perp = A^perp (+) B^perp  is handled by sem_dual.      *)
Lemma valid_AB :
  Valid [oplus (dat_ 0) (dat_ 1); tens (at_ 0) (at_ 1)] ->
  Inc (orth (pmul (v 0) (v 1))) (orth (withF (v 0) (v 1))).
Proof.
  intro Hv.
  apply (proj1 (valid_pair (oplus (dat_ 0) (dat_ 1)) (tens (at_ 0) (at_ 1)))) in Hv.
  intros m Hm.
  apply (proj1 (sem_dual (awith (at_ 0) (at_ 1)))).
  apply Hv.
  exact (proj2 (orth3 (pmul (v 0) (v 1))) m Hm).
Qed.

(* the additive/multiplicative separation, internalized: any witness that      *)
(* orth(pmul v0 v1) is not contained in orth(v0 & v1) refutes  A & B |- A (x) B. *)
Lemma additive_needs_collapse :
  (exists w, orth (pmul (v 0) (v 1)) w /\ ~ orth (withF (v 0) (v 1)) w) ->
  ~ Prov [oplus (dat_ 0) (dat_ 1); tens (at_ 0) (at_ 1)].
Proof.
  intros [w [Hw Hnw]] H.
  pose proof (valid_AB (soundness _ H)) as Hinc.
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

(* The additive (+) multiplicative separation for DISTINCT atoms:           *)
(*   a0 & a1  |/-  a0 (x) a1.                                                *)
(* Same token monoid; the witnessing assignment reads both atoms as geq1     *)
(* (the canonical collapse witness -- & not<= (x) is exactly the inability   *)
(* to duplicate a shared additive choice into a multiplicative product).     *)
Theorem no_additive : ~ Prov [oplus (dat_ 0) (dat_ 1); tens (at_ 0) (at_ 1)].
Proof.
  apply (additive_needs_collapse nat Nat.add 0 n_comm n_assoc n_unit
                                 geq2 (fun _ => geq1) (fun _ => geq1_fact)).
  exists 0. split.
  - (* 0 in orth (pmul geq1 geq1):  x = a+b, a,b >= 1  =>  0+x >= 2 *)
    unfold orth, pmul, geq2, geq1. intros x [a [b [Ha [Hb Hx]]]]. lia.
  - (* 0 not in orth (geq1 & geq1):  x = 1 would force  2 <= 0+1 *)
    unfold orth, withF, geq2, geq1. intros Hbad.
    specialize (Hbad 1 (conj (le_n 1) (le_n 1))). lia.
Qed.

(* ===================================================================== *)
(*  PART E -- the SAME separation with GENUINELY DISTINCT atoms.           *)
(*  The earlier remark (that a concrete model forces v0 = v1) was WRONG:   *)
(*  it was an artifact of the pole {n>=2}, not a theorem.  Keep the SAME    *)
(*  carrier (nat,+,0); change ONLY the pole to  pole3 = { n | n=0 or n>=3 } *)
(*  (the pole, not the predicates, is what fixes duality).  Then            *)
(*  geq1 = {m>=1} and geq2 = {m>=2} are DISTINCT facts                      *)
(*    geq1^perp = geq2 ,  geq2^perp = geq1 ,                               *)
(*  and  geq1 & geq2 = {>=2}  while  geq1 (x) geq2 = {>=3}, so              *)
(*    geq1 & geq2  NOT<=  geq1 (x) geq2     (witness 2).                    *)
(*  Reading a0 |-> geq1 and a1 |-> geq2 (two DIFFERENT facts) still gives   *)
(*    a0 & a1  |/-  a0 (x) a1 .                                            *)
(* ===================================================================== *)

Definition pole3 (n : nat) : Prop := n = 0 \/ 3 <= n.
Definition v3 (n : nat) : nat -> Prop := match n with 0 => geq1 | S _ => geq2 end.

(* both facts under the new pole:  geq1^perp = geq2 and geq2^perp = geq1.   *)
Lemma geq1_fact3 : Fact nat Nat.add pole3 geq1.
Proof.
  intros m H.
  assert (Ho2 : orth nat Nat.add pole3 geq1 2).
  { unfold orth, pole3, geq1. intros y Hy. right. lia. }
  destruct (H 2 Ho2) as [Hc | Hc]; unfold geq1; lia.
Qed.

Lemma geq2_fact3 : Fact nat Nat.add pole3 geq2.
Proof.
  intros m H.
  assert (Ho1 : orth nat Nat.add pole3 geq2 1).
  { unfold orth, pole3, geq2. intros y Hy. right. lia. }
  destruct (H 1 Ho1) as [Hc | Hc]; unfold geq2; lia.
Qed.

Lemma v3_Vfact : forall n, Fact nat Nat.add pole3 (v3 n).
Proof. intro n; destruct n; [ exact geq1_fact3 | exact geq2_fact3 ]. Qed.

(* the two atoms really get DIFFERENT facts: 1 is in [[a0]] but not in [[a1]]. *)
Lemma atoms_distinct : v3 0 1 /\ ~ v3 1 1.
Proof. split; [ unfold v3, geq1; lia | unfold v3, geq2; lia ]. Qed.

Theorem no_additive_distinct : ~ Prov [oplus (dat_ 0) (dat_ 1); tens (at_ 0) (at_ 1)].
Proof.
  apply (additive_needs_collapse nat Nat.add 0 n_comm n_assoc n_unit
                                 pole3 v3 v3_Vfact).
  exists 0. split.
  - (* 0 in orth (pmul geq1 geq2):  a>=1, b>=2  =>  a+b >= 3, so pole3 holds *)
    cbn [v3]. unfold orth, pmul, pole3, geq1, geq2.
    intros x [a [b [Ha [Hb Hx]]]]. right. lia.
  - (* 0 not in orth (geq1 & geq2) = {>=1}:  x = 2 satisfies the premise *)
    (* but 0+2 = 2 is NOT in pole3, so the readout fails. *)
    cbn [v3]. unfold orth, withF, pole3, geq1, geq2.
    intros Hbad. assert (Hpre : 1 <= 2 /\ 2 <= 2) by (split; lia).
    destruct (Hbad 2 Hpre) as [Hc | Hc]; lia.
Qed.

(* ===================================================================== *)
(*  PART F -- the CUT-FREE calculus, and the reduction of cut-elimination  *)
(*  to cut-free phase-completeness (Okada).                                *)
(*                                                                        *)
(*  Pcf is the MALL calculus WITHOUT cut.  We verify here, axiom-free:      *)
(*    Pcf_Prov            cut-free proofs ARE proofs (Pcf subsystem-of Prov)*)
(*    cut_free_consistent the cut-free system is consistent (no |- [])      *)
(*    no_*_cf             the separations survive cut-free                  *)
(*    id_cf               CUT-FREE IDENTITY EXPANSION |- A, ~A for every A  *)
(*                        (the identity half of cut-elimination)          *)
(*    soundness_all       Prov G -> valid in EVERY phase space              *)
(*    cut_elim_from_cf_completeness                                         *)
(*                        IF the cut-free system is phase-complete THEN      *)
(*                        cut admissibility holds -- so what remains for     *)
(*                        full cut-elimination is exactly Okada's lemma      *)
(*                        (cut-free completeness), NOT a new principle.      *)
(* ===================================================================== *)

Inductive Pcf : list Frm -> Prop :=
| c_ax     : forall n,       Pcf [at_ n; dat_ n]
| c_exch   : forall G D,     Permutation G D -> Pcf G -> Pcf D
| c_tens   : forall G D A B, Pcf (A::G) -> Pcf (B::D) -> Pcf (tens A B::(G++D))
| c_par    : forall G A B,   Pcf (A::B::G) -> Pcf (par A B::G)
| c_one    :                 Pcf [one]
| c_bot    : forall G,       Pcf G -> Pcf (bot::G)
| c_with   : forall G A B,   Pcf (A::G) -> Pcf (B::G) -> Pcf (awith A B::G)
| c_oplus1 : forall G A B,   Pcf (A::G) -> Pcf (oplus A B::G)
| c_oplus2 : forall G A B,   Pcf (B::G) -> Pcf (oplus A B::G)
| c_top    : forall G,       Pcf (top::G).

(* every cut-free proof is a proof. *)
Theorem Pcf_Prov : forall G, Pcf G -> Prov G.
Proof.
  intros G H. induction H.
  - apply p_ax.
  - apply (p_exch G D); assumption.
  - apply p_tens; assumption.
  - apply p_par; assumption.
  - apply p_one.
  - apply p_bot; assumption.
  - apply p_with; assumption.
  - apply p_oplus1; assumption.
  - apply p_oplus2; assumption.
  - apply p_top.
Qed.

(* the cut-free system is CONSISTENT (semantically, via soundness). *)
Theorem cut_free_consistent : ~ Pcf [].
Proof. intro H. exact (consistent (Pcf_Prov [] H)). Qed.

(* the separations survive cut-free (Pcf subsystem-of Prov). *)
Theorem no_contraction_cf : ~ Pcf [dat_ 0; tens (at_ 0) (at_ 0)].
Proof. intro H. exact (no_contraction (Pcf_Prov _ H)). Qed.
Theorem no_additive_cf : ~ Pcf [oplus (dat_ 0) (dat_ 1); tens (at_ 0) (at_ 1)].
Proof. intro H. exact (no_additive (Pcf_Prov _ H)). Qed.

(* CUT-FREE IDENTITY EXPANSION:  |- A, ~A with NO cut, for every formula A. *)
(* c_ax is stated only for atoms; the general identity is derivable without *)
(* cut -- the identity half of cut-elimination (the other half being cut  *)
(* admissibility, the hard part that remains).                             *)
Theorem id_cf : forall A, Pcf [A; dual A].
Proof.
  induction A; simpl.
  - apply c_ax.
  - apply (c_exch [at_ n; dat_ n]); [apply perm_swap | apply c_ax].
  - assert (H1 : Pcf (tens A1 A2 :: ([dual A1] ++ [dual A2])))
      by (apply c_tens; [exact IHA1 | exact IHA2]).
    simpl in H1.
    assert (H2 : Pcf [dual A1; dual A2; tens A1 A2]).
    { apply (c_exch _ _ (Permutation_app_comm [tens A1 A2] [dual A1; dual A2])) in H1.
      exact H1. }
    apply (c_exch [par (dual A1) (dual A2); tens A1 A2]); [apply perm_swap |].
    apply c_par. exact H2.
  - assert (H1 : Pcf (tens (dual A1) (dual A2) :: ([A1] ++ [A2]))).
    { apply c_tens; [ apply (c_exch [A1; dual A1]); [apply perm_swap | exact IHA1]
                    | apply (c_exch [A2; dual A2]); [apply perm_swap | exact IHA2] ]. }
    simpl in H1.
    assert (H2 : Pcf [A1; A2; tens (dual A1) (dual A2)]).
    { apply (c_exch _ _ (Permutation_app_comm [tens (dual A1) (dual A2)] [A1; A2])) in H1.
      exact H1. }
    apply c_par. exact H2.
  - apply (c_exch [bot; one]); [apply perm_swap |]. apply c_bot. apply c_one.
  - apply c_bot. apply c_one.
  - apply c_with.
    + apply (c_exch [oplus (dual A1) (dual A2); A1]); [apply perm_swap |].
      apply c_oplus1. apply (c_exch [A1; dual A1]); [apply perm_swap | exact IHA1].
    + apply (c_exch [oplus (dual A1) (dual A2); A2]); [apply perm_swap |].
      apply c_oplus2. apply (c_exch [A2; dual A2]); [apply perm_swap | exact IHA2].
  - apply (c_exch [awith (dual A1) (dual A2); oplus A1 A2]); [apply perm_swap |].
    apply c_with.
    + apply (c_exch [oplus A1 A2; dual A1]); [apply perm_swap |].
      apply c_oplus1. exact IHA1.
    + apply (c_exch [oplus A1 A2; dual A2]); [apply perm_swap |].
      apply c_oplus2. exact IHA2.
  - apply c_top.
  - apply (c_exch [top; zero]); [apply perm_swap |]. apply c_top.
Qed.

(* phase-validity = valid in EVERY phase space (over all model parameters). *)
Definition PhaseValid (G : list Frm) : Prop :=
  forall (M : Type) (op : M -> M -> M) (e : M),
    (forall a b, op a b = op b a) ->
    (forall a b c, op a (op b c) = op (op a b) c) ->
    (forall a, op e a = a) ->
    forall (pole : M -> Prop) (v : nat -> M -> Prop),
      (forall n, Fact M op pole (v n)) ->
      Valid M op e pole v G.

Theorem soundness_all : forall G, Prov G -> PhaseValid G.
Proof.
  intros G H M op e c a u pole v Vf.
  exact (soundness M op e c a u pole v Vf G H).
Qed.

(* THE REDUCTION: cut admissibility follows from cut-free phase-completeness. *)
(* Okada's fundamental lemma -- every phase-valid sequent is cut-free         *)
(* provable -- is the single remaining ingredient; it would yield full        *)
(* cut-elimination (Prov G -> Pcf G) with no further principle.               *)
Theorem cut_elim_from_cf_completeness :
  (forall G, PhaseValid G -> Pcf G) -> (forall G, Prov G -> Pcf G).
Proof. intros Hcomp G H. apply Hcomp. apply soundness_all. exact H. Qed.

(* ===================================================================== *)
(*  PART G -- the syntactic-phase-space pole is GAUGE-INVARIANT.            *)
(*                                                                        *)
(*  Okada builds a phase space whose carrier is contexts (multisets of     *)
(*  formulas) and whose pole is cut-free provability.  The one fact that    *)
(*  makes that pole legitimate -- it respects the context equivalence       *)
(*  (Permutation = formula order is a coordinate, the graph-gauge) --     *)
(*  is already a primitive of the calculus: it is exactly c_exch.           *)
(*  No funext, no strict multiset equality.                                *)
(* ===================================================================== *)
Theorem Pcf_pole_proper : forall G D, Permutation G D -> Pcf G -> Pcf D.
Proof. intros G D Hp H. exact (c_exch G D Hp H). Qed.

(* ===================================================================== *)
(*  AXIOM-FREEDOM CHECK  (coqc 8.18.0, exit 0) -- Closed under the global *)
(*  context.  Involution law + phase soundness of the full MALL calculus  *)
(*  (ax/exch/cut, (x)/par, 1/bot, &/(+), top) + the consistency corollary. *)
(*  No funext, no prop-ext, no classical, no choice.                       *)
(* ===================================================================== *)
Print Assumptions dual_involutive.
Print Assumptions sem_dual.
Print Assumptions soundness.
Print Assumptions consistent.
Print Assumptions no_contraction.
Print Assumptions no_additive.
Print Assumptions no_additive_distinct.
Print Assumptions Pcf_Prov.
Print Assumptions cut_free_consistent.
Print Assumptions id_cf.
Print Assumptions soundness_all.
Print Assumptions cut_elim_from_cf_completeness.
Print Assumptions Pcf_pole_proper.

End PhaseSound.

(* ================== Module ContextSetoid  (from RDL_ContextSetoid.v) ================== *)
Module ContextSetoid.

(* ===================================================================== *)
(*  RDL_ContextSetoid.v                                                    *)
(*  Dissolving the funext wall of the Okada/semantic route to            *)
(*  cut-elimination, in the place RDL says it lives: equality of retained  *)
(*  content is a READOUT (an equivalence), never identity of               *)
(*  representations.  So the context-monoid is commutative UP TO an         *)
(*  equivalence -- Permutation, the graph-gauge formula order is just a    *)
(*  coordinate (cf. PGFT Table 10: relabeling nodes must not change        *)
(*  invariant readouts) -- and NO funext is needed, because we never        *)
(*  assert two representations of the same content are Leibniz-equal.       *)
(*  Verified, axiom-free, funext-free.  coqc 8.18.                          *)
(* ===================================================================== *)

Import List.
Import Permutation.
Import ListNotations.

(* A commutative monoid UP TO an equivalence (a setoid commutative        *)
(* monoid).  The strict framework demanded cm_op x y = cm_op y x as        *)
(* Leibniz equality; that conflated same retained content with same      *)
(* representation, which the canon forbids (R_O <> D_O; M_A <> theta).     *)
Record CommMonoidUpTo : Type := {
  cm_car  : Type;
  cm_eqv  : cm_car -> cm_car -> Prop;
  cm_op   : cm_car -> cm_car -> cm_car;
  cm_e    : cm_car;
  cm_refl   : forall x, cm_eqv x x;
  cm_sym    : forall x y, cm_eqv x y -> cm_eqv y x;
  cm_trans  : forall x y z, cm_eqv x y -> cm_eqv y z -> cm_eqv x z;
  cm_op_proper : forall x x' y y',
      cm_eqv x x' -> cm_eqv y y' -> cm_eqv (cm_op x y) (cm_op x' y');
  cm_comm   : forall x y,   cm_eqv (cm_op x y) (cm_op y x);
  cm_assoc  : forall x y z, cm_eqv (cm_op x (cm_op y z)) (cm_op (cm_op x y) z);
  cm_unit_l : forall x,     cm_eqv (cm_op cm_e x) x
}.

(* The free instance: contexts (multisets of anything) under append, read   *)
(* up to permutation.  Append is associative/unital ON THE NOSE and         *)
(* commutative UP TO permutation -- the gauge structure of combining        *)
(* retained content.                                                        *)
Definition ContextCM (X : Type) : CommMonoidUpTo.
Proof.
  refine {| cm_car := list X; cm_eqv := @Permutation X;
            cm_op := @app X; cm_e := @nil X;
            cm_refl := _; cm_sym := _; cm_trans := _; cm_op_proper := _;
            cm_comm := _; cm_assoc := _; cm_unit_l := _ |}.
  - exact (@Permutation_refl X).
  - exact (@Permutation_sym X).
  - exact (@Permutation_trans X).
  - intros x x' y y' Hx Hy. apply Permutation_app; assumption.
  - intros x y. apply Permutation_app_comm.
  - intros x y z. rewrite app_assoc. apply Permutation_refl.
  - intros x. apply Permutation_refl.
Defined.

(* A pole/readout is admissible iff invariant under the equivalence         *)
(* (gauge-invariant).  For ContextCM: closed under permutation.             *)
Definition RespectsEqv (M : CommMonoidUpTo) (P : cm_car M -> Prop) : Prop :=
  forall x y, cm_eqv M x y -> P x -> P y.

(* the congruence rewrite the phase-model refactor will lean on -- no funext *)
Lemma context_comm_no_funext (X:Type) (l l' : list X) :
  cm_eqv (ContextCM X) (cm_op (ContextCM X) l l') (cm_op (ContextCM X) l' l).
Proof. apply (cm_comm (ContextCM X)). Qed.

Print Assumptions ContextCM.
Print Assumptions context_comm_no_funext.

End ContextSetoid.

(* ================== Module PhaseSetoid  (from RDL_PhaseSetoid.v) ================== *)
Module PhaseSetoid.

(* ===================================================================== *)
(*  RDL_PhaseSetoid.v                                                      *)
(*  Girard phase soundness of MALL re-proved over a SETOID commutative     *)
(*  monoid: the monoid laws hold UP TO an equivalence (eqv), not Leibniz    *)
(*  equality.  This is the philosophically-correct phase model for RDL --   *)
(*  equality of retained content is a READOUT (an equivalence), never       *)
(*  identity of representations -- and it is exactly what the Okada/        *)
(*  semantic route to cut-elimination needs, because the context-monoid     *)
(*  (list Frm, ++, [], Permutation) lives natively here with NO funext.     *)
(*                                                                          *)
(*  The strict phase model of RDL_PhaseSound.v is the special case          *)
(*  eqv := eq.  The context monoid hypotheses are discharged by             *)
(*  RDL_ContextSetoid.v (ContextCM Frm); only the pole and the atom-fact    *)
(*  assignment remain open, to be supplied by the Okada fundamental lemma.  *)
(*                                                                          *)
(*  VERIFIED (coqc 8.18.0), axiom-free, funext-free.                        *)
(* ===================================================================== *)

Import Coq.Lists.List. Import ListNotations.
Import Coq.Sorting.Permutation.
Import Coq.Classes.Morphisms.
Import Coq.Classes.RelationClasses.
Import Coq.Setoids.Setoid.
Import Lia.

(* ---- PART A : MALL syntax + involutive dual + one-sided calculus ------ *)
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

(* ---- PART B : the SETOID phase model ---------------------------------- *)
Section PhaseSetoid.
Variable M : Type.
Variable eqv : M -> M -> Prop.
Variable op : M -> M -> M.
Variable e : M.
Hypothesis eqv_equiv : Equivalence eqv.
Hypothesis op_proper : Proper (eqv ==> eqv ==> eqv) op.
Hypothesis op_comm  : forall a b, eqv (op a b) (op b a).
Hypothesis op_assoc : forall a b c, eqv (op a (op b c)) (op (op a b) c).
Hypothesis op_unit  : forall a, eqv (op e a) a.
Variable pole : M -> Prop.
Hypothesis pole_proper : Proper (eqv ==> iff) pole.

Existing Instance eqv_equiv.
Existing Instance op_proper.
Existing Instance pole_proper.

Definition Ens := M -> Prop.
Definition Inc   (X Y:Ens) : Prop := forall m, X m -> Y m.
Definition Equiv (X Y:Ens) : Prop := Inc X Y /\ Inc Y X.

Lemma inc_refl  : forall X, Inc X X.                           Proof. intros X m H; exact H. Qed.
Lemma inc_trans : forall X Y Z, Inc X Y -> Inc Y Z -> Inc X Z. Proof. intros X Y Z H1 H2 m H; apply H2, H1, H. Qed.
Lemma equiv_refl  : forall X, Equiv X X.                       Proof. intros X; split; apply inc_refl. Qed.
Lemma equiv_sym   : forall X Y, Equiv X Y -> Equiv Y X.        Proof. intros X Y [H1 H2]; split; assumption. Qed.
Lemma equiv_trans : forall X Y Z, Equiv X Y -> Equiv Y Z -> Equiv X Z.
Proof. intros X Y Z [H1 H2] [H3 H4]; split; eapply inc_trans; eassumption. Qed.

(* a set is CLOSED when it respects the equivalence (gauge-invariant) *)
Definition Cl (X:Ens) : Prop := forall m m', eqv m m' -> X m -> X m'.

Definition orth (X:Ens) : Ens := fun m => forall x, X x -> pole (op m x).

Lemma orth_antitone : forall X Y, Inc X Y -> Inc (orth Y) (orth X).
Proof. intros X Y H m Hm x Hx. apply Hm. apply H. exact Hx. Qed.

Lemma inc_orth_orth : forall X, Inc X (orth (orth X)).
Proof. intros X m HX y Hy. rewrite (op_comm m y). apply Hy. exact HX. Qed.

Lemma orth3 : forall X, Equiv (orth (orth (orth X))) (orth X).
Proof. intros X. split; [ apply orth_antitone; apply inc_orth_orth | apply (inc_orth_orth (orth X)) ]. Qed.

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

(* orthogonals and products are always closed -- no funext, just eqv-trans *)
Lemma orth_cl : forall Z, Cl (orth Z).
Proof. intros Z m m' Hmm' Hm x Hx. rewrite <- Hmm'. apply Hm. exact Hx. Qed.

Definition pmul (X Y:Ens) : Ens := fun m => exists a b, X a /\ Y b /\ eqv m (op a b).
Definition unitSet : Ens := fun m => eqv m e.

Lemma pmul_cl : forall X Y, Cl (pmul X Y).
Proof.
  intros X Y m m' Hmm' [a [b [Ha [Hb Hm]]]]. exists a, b.
  split; [ exact Ha | split; [ exact Hb | rewrite <- Hmm'; exact Hm ] ].
Qed.

Lemma unitSet_cl : Cl unitSet.
Proof. intros m m' Hmm' Hm. unfold unitSet in *. rewrite <- Hmm'. exact Hm. Qed.

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
    rewrite Hw in Hm. exists (op a b), c.
    repeat split; [ exists a, b; split; [exact Ha|split; [exact Hb|reflexivity]]
                  | exact Hc | rewrite Hm; apply op_assoc ].
  - intros m [u [c [[a [b [Ha [Hb Hu]]]] [Hc Hm]]]].
    rewrite Hu in Hm. exists a, (op b c).
    repeat split; [ exact Ha
                  | exists b, c; split; [exact Hb|split; [exact Hc|reflexivity]]
                  | rewrite Hm; symmetry; apply op_assoc ].
Qed.

Lemma pmul_unit_l : forall X, Cl X -> Equiv (pmul unitSet X) X.
Proof.
  intros X HX. split.
  - intros m [a [b [Ha [Hb Hm]]]]. apply (HX b m).
    + symmetry. transitivity (op a b); [ exact Hm | ].
      transitivity (op e b);
        [ apply op_proper; [ exact Ha | reflexivity ] | apply op_unit ].
    + exact Hb.
  - intros m Hm. exists e, m. split.
    + unfold unitSet. reflexivity.
    + split; [ exact Hm | symmetry; apply op_unit ].
Qed.

Lemma pmul_unit_r : forall X, Cl X -> Equiv (pmul X unitSet) X.
Proof.
  intros X HX. apply (equiv_trans _ (pmul unitSet X) _);
    [ apply pmul_comm | apply pmul_unit_l; exact HX ].
Qed.

Lemma pmul_swap : forall X Y Z, Equiv (pmul X (pmul Y Z)) (pmul Y (pmul X Z)).
Proof.
  intros X Y Z.
  apply (equiv_trans _ (pmul (pmul X Y) Z) _); [ apply pmul_assoc | ].
  apply (equiv_trans _ (pmul (pmul Y X) Z) _).
  - apply pmul_equiv; [ apply pmul_comm | apply equiv_refl ].
  - apply equiv_sym. apply pmul_assoc.
Qed.

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

(* Den G is always closed (it is unitSet or a pmul) *)
Lemma Den_cl : forall G, Cl (Den G).
Proof. intros G; destruct G; [ apply unitSet_cl | apply pmul_cl ]. Qed.

Lemma Den_app : forall G D, Equiv (Den (G ++ D)) (pmul (Den G) (Den D)).
Proof.
  intros G D. induction G as [|a G' IHG].
  - apply equiv_sym. apply pmul_unit_l. apply Den_cl.
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
    exact (proj1 (pmul_unit_r (orth (orth (v n))) (orth_cl (orth (v n)))) m Hm).
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

End PhaseSetoid.

(* The strict phase model of RDL_PhaseSound.v is the special case eqv := eq:  *)
(* Leibniz equality is an equivalence, every op is Proper for it, and every    *)
(* predicate is Proper for it.  So the setoid soundness SUBSUMES the strict.    *)
Corollary soundness_strict :
  forall (M:Type) (op:M->M->M) (e:M),
    (forall a b, op a b = op b a) ->
    (forall a b c, op a (op b c) = op (op a b) c) ->
    (forall a, op e a = a) ->
    forall (pole:M->Prop) (v:nat->Ens M),
      (forall n, Fact M op pole (v n)) ->
      forall G, Prov G -> Valid M (@eq M) op e pole v G.
Proof.
  intros M op e Hc Ha Hu pole v Vf G HG.
  apply (soundness M (@eq M) op e).
  - exact eq_equivalence.
  - repeat intro; subst; reflexivity.
  - exact Hc.
  - exact Ha.
  - exact Hu.
  - intros x y Hxy; subst; reflexivity.
  - exact Vf.
  - exact HG.
Qed.

(* The Okada phase space's MONOID is exactly the context monoid (list Frm,    *)
(* ++, [], Permutation).  Every monoid hypothesis of [soundness] is discharged *)
(* here with the stdlib Permutation lemmas -- NO funext.  What remains for     *)
(* cut-free completeness (hence cut-elimination) is only the pole = cut-free   *)
(* provability and the atom-fact assignment: the Okada fundamental lemma.      *)
Lemma context_phase_soundness :
  forall (pole : list Frm -> Prop),
    Proper (@Permutation Frm ==> iff) pole ->
    forall (v : nat -> Ens (list Frm)),
      (forall n, Fact (list Frm) (@app Frm) pole (v n)) ->
      forall G, Prov G ->
        Valid (list Frm) (@Permutation Frm) (@app Frm) (@nil Frm) pole v G.
Proof.
  intros pole Hpole v Vf G HG.
  apply (soundness (list Frm) (@Permutation Frm) (@app Frm) (@nil Frm)).
  - constructor.
    + intro l; apply Permutation_refl.
    + intros l1 l2 H; apply Permutation_sym; exact H.
    + intros l1 l2 l3 H1 H2; apply (Permutation_trans H1 H2).
  - intros x x' Hx y y' Hy; apply Permutation_app; assumption.
  - intros a b; apply Permutation_app_comm.
  - intros a b c; rewrite app_assoc; apply Permutation_refl.
  - intros a; apply Permutation_refl.
  - exact Hpole.
  - exact Vf.
  - exact HG.
Qed.

Print Assumptions soundness.
Print Assumptions sem_dual.
Print Assumptions peel.
Print Assumptions soundness_strict.
Print Assumptions context_phase_soundness.

(* ===================================================================== *)
(*  PART C -- the OKADA fundamental lemma and cut-elimination for MALL.    *)
(*  The syntactic phase space: contexts (list Frm) under ++ up to          *)
(*  Permutation (the context monoid of RDL_ContextSetoid), with the pole   *)
(*  = CUT-FREE provability.  Okada's reflection (sem A reflects into        *)
(*  cut-free derivability) is proved by a single induction on A using one   *)
(*  uniform trick: instantiate the outer orthogonal at the singleton [A]    *)
(*  and discharge with the cut-free introduction rule + the IH.  No fact-   *)
(*  ness side lemmas, no simultaneous dual induction.                       *)
(* ===================================================================== *)

(* the cut-free calculus = Prov minus p_cut *)
Inductive Pcf : list Frm -> Prop :=
| c_ax     : forall n,       Pcf [at_ n; dat_ n]
| c_exch   : forall G D,     Permutation G D -> Pcf G -> Pcf D
| c_tens   : forall G D A B, Pcf (A::G) -> Pcf (B::D) -> Pcf (tens A B::(G++D))
| c_par    : forall G A B,   Pcf (A::B::G) -> Pcf (par A B::G)
| c_one    :                 Pcf [one]
| c_bot    : forall G,       Pcf G -> Pcf (bot::G)
| c_with   : forall G A B,   Pcf (A::G) -> Pcf (B::G) -> Pcf (awith A B::G)
| c_oplus1 : forall G A B,   Pcf (A::G) -> Pcf (oplus A B::G)
| c_oplus2 : forall G A B,   Pcf (B::G) -> Pcf (oplus A B::G)
| c_top    : forall G,       Pcf (top::G).

(* cut-free derivations are derivations *)
Theorem Pcf_Prov : forall G, Pcf G -> Prov G.
Proof.
  induction 1.
  - apply p_ax.
  - apply (p_exch G D); assumption.
  - apply p_tens; assumption.
  - apply p_par; assumption.
  - apply p_one.
  - apply p_bot; assumption.
  - apply p_with; assumption.
  - apply p_oplus1; assumption.
  - apply p_oplus2; assumption.
  - apply p_top.
Qed.

(* the pole (cut-free provability) is gauge-invariant: respects Permutation *)
Lemma Pcf_proper : Proper (@Permutation Frm ==> iff) Pcf.
Proof.
  intros x y H; split; intro Hp;
    [ exact (c_exch x y H Hp) | exact (c_exch y x (Permutation_sym H) Hp) ].
Qed.

(* Γ ++ [X]  ~  X :: Γ  (snoc = cons up to permutation) *)
Lemma cf_snoc : forall Γ X, Pcf (Γ ++ [X]) -> Pcf (X :: Γ).
Proof.
  intros Γ X H. apply (c_exch (Γ ++ [X]) (X :: Γ));
    [ apply Permutation_sym, Permutation_cons_append | exact H ].
Qed.

(* the Okada atom valuation: v(n) := {[at_ n]}^perp  (a fact, by orth_fact) *)
Definition Sv (n:nat) : Ens (list Frm) :=
  orth (list Frm) (@app Frm) Pcf (fun G => Permutation G [at_ n]).

Definition Ssem : Frm -> Ens (list Frm) :=
  sem (list Frm) (@Permutation Frm) (@app Frm) (@nil Frm) Pcf Sv.
Definition SDen : list Frm -> Ens (list Frm) :=
  Den (list Frm) (@Permutation Frm) (@app Frm) (@nil Frm) Pcf Sv.

(* atoms are facts -> the Vfact hypothesis of the phase model *)
Lemma Sv_fact : forall n, Fact (list Frm) (@app Frm) Pcf (Sv n).
Proof.
  intro n. unfold Sv.
  apply (orth_fact (list Frm) (@Permutation Frm) (@app Frm)
                   (@Permutation_app_comm Frm) Pcf Pcf_proper).
Qed.

Print Assumptions Pcf_Prov.
Print Assumptions cf_snoc.

(* accessors for orth at the syntactic space (avoid unfolding) *)
Lemma orth_app : forall (X:Ens (list Frm)) Γ x,
  orth (list Frm) (@app Frm) Pcf X Γ -> X x -> Pcf (Γ ++ x).
Proof. intros X Γ x H Hx. exact (H x Hx). Qed.

Lemma orth_intro : forall (X:Ens (list Frm)) Γ,
  (forall x, X x -> Pcf (Γ ++ x)) -> orth (list Frm) (@app Frm) Pcf X Γ.
Proof. intros X Γ H. exact H. Qed.

(* THE OKADA REFLECTION: every member of [[A]] is cut-free derivable with A. *)
Lemma reflect : forall A Γ, Ssem A Γ -> Pcf (A :: Γ).
Proof.
  unfold Ssem.
  induction A as [ n | n | A1 IH1 A2 IH2 | A1 IH1 A2 IH2 | | | A1 IH1 A2 IH2 | A1 IH1 A2 IH2 | | ];
    intros G H.
  - (* at_ n : [[at n]] = {[at n]}^perp *)
    apply cf_snoc. apply (orth_app _ G [at_ n] H). apply Permutation_refl.
  - (* dat_ n : [[dat n]] = {[at n]}^perp^perp *)
    apply cf_snoc. apply (orth_app _ G [dat_ n] H).
    apply orth_intro. intros y Hy.
    apply (c_exch [at_ n; dat_ n] (dat_ n :: y)).
    + apply Permutation_trans with (dat_ n :: [at_ n]);
        [ apply perm_swap | apply perm_skip, Permutation_sym, Hy ].
    + apply c_ax.
  - (* tens A1 A2 : orth(orth(pmul [[A1]] [[A2]])) *)
    apply cf_snoc. apply (orth_app _ G [tens A1 A2] H).
    apply orth_intro. intros m Hm. destruct Hm as [a [b [Ha [Hb Hm]]]].
    apply (c_exch (tens A1 A2 :: (a ++ b)) (tens A1 A2 :: m)).
    + apply perm_skip, Permutation_sym, Hm.
    + apply c_tens; [ apply IH1; exact Ha | apply IH2; exact Hb ].
  - (* par A1 A2 : orth(pmul (orth[[A1]]) (orth[[A2]])) *)
    apply c_par.
    apply (c_exch (G ++ [A1; A2]) (A1 :: A2 :: G)).
    + apply Permutation_app_comm.
    + apply (orth_app _ G ([A1] ++ [A2]) H).
      exists [A1], [A2]. split; [ | split; [ | apply Permutation_refl ] ].
      * apply orth_intro. intros x Hx. apply IH1; exact Hx.
      * apply orth_intro. intros x Hx. apply IH2; exact Hx.
  - (* one : orth(orth {[]}) *)
    apply cf_snoc. apply (orth_app _ G [one] H).
    apply orth_intro. intros m Hm. unfold unitSet in Hm.
    apply Permutation_sym, Permutation_nil in Hm. subst m. apply c_one.
  - (* bot : orth {[]} *)
    apply c_bot.
    assert (HG : Pcf (G ++ [])) by
      (apply (orth_app _ G [] H); unfold unitSet; apply Permutation_refl).
    rewrite app_nil_r in HG. exact HG.
  - (* awith A1 A2 : [[A1]] cap [[A2]] *)
    destruct H as [HA HB]. apply c_with; [ apply IH1; exact HA | apply IH2; exact HB ].
  - (* oplus A1 A2 : orth(orth([[A1]] cup [[A2]])) *)
    apply cf_snoc. apply (orth_app _ G [oplus A1 A2] H).
    apply orth_intro. intros m Hm. destruct Hm as [Hm | Hm].
    + apply c_oplus1. apply IH1; exact Hm.
    + apply c_oplus2. apply IH2; exact Hm.
  - (* top : whole space *)
    apply c_top.
  - (* zero : orth(whole space) *)
    apply cf_snoc. apply (orth_app _ G [zero] H). exact I.
Qed.

Print Assumptions reflect.

(* the canonical element: G itself lies in [[Den G]] -- needs only reflect *)
Lemma G_in_DenG : forall G, SDen G G.
Proof.
  unfold SDen. induction G as [|A G' IH].
  - simpl. unfold unitSet. apply Permutation_refl.
  - simpl. exists [A], G'. split; [ | split ].
    + apply orth_intro. intros x Hx. apply reflect. exact Hx.
    + exact IH.
    + apply Permutation_refl.
Qed.

(* ===================================================================== *)
(*  CUT-ELIMINATION for MALL, via the Okada semantic route.                *)
(*    Prov G --[setoid phase soundness @ syntactic space]--> Valid G       *)
(*           --[G in Den G, by reflection]--> pole G = Pcf G.              *)
(* ===================================================================== *)
Theorem cut_elim : forall G, Prov G -> Pcf G.
Proof.
  intros G HG.
  pose proof (context_phase_soundness Pcf Pcf_proper Sv Sv_fact G HG) as HV.
  apply HV. apply G_in_DenG.
Qed.

(* CUT ADMISSIBILITY: full and cut-free provability coincide. *)
Theorem cut_admissible : forall G, Prov G <-> Pcf G.
Proof. intro G. split; [ apply cut_elim | apply Pcf_Prov ]. Qed.

(* consistency of the cut-free (hence the full) calculus, structurally *)
Lemma Pcf_len : forall G, Pcf G -> 1 <= length G.
Proof.
  intros G H. induction H; simpl in *; try lia.
  match goal with Hp : Permutation _ _ |- _ => apply Permutation_length in Hp end. lia.
Qed.

Corollary cf_consistent : ~ Pcf [].
Proof. intro H. apply Pcf_len in H. simpl in H. lia. Qed.

Corollary consistent : ~ Prov [].
Proof. intro H. apply cf_consistent, cut_elim, H. Qed.

Print Assumptions cut_elim.
Print Assumptions cut_admissible.
Print Assumptions consistent.

End PhaseSetoid.

(* ============ APPENDED axiom-free roots: retention-center, star-rig, gamma ============ *)

Module RetCenter.
  Import List.
  Import ListNotations.
  Import Permutation.
  Import PeanoNat.
  Import RelationClasses.
  Import Morphisms.
  Import Setoid.

  (* --------------------------------------------------------------------- *)
  (*  THE CENTER : R^◇ = (Γ, D, T, L, Π, A, 𝔊)                              *)
  (* --------------------------------------------------------------------- *)
  Record RetentionSystem := {
    (* D : distinctions *)
    Dist  : Type ;
    (* Γ : graph on distinctions *)
    edge  : Dist -> Dist -> Prop ;
    (* T : transport — configurations of distinctions, composed, UP TO gauge *)
    Tcar  : Type ;
    gauge : Tcar -> Tcar -> Prop ;     (* admissible relabeling / reordering *)
    tunit : Tcar ;
    tcomp : Tcar -> Tcar -> Tcar ;
    (* L : propagation preorder on distinctions *)
    prop_le : Dist -> Dist -> Prop ;
    (* Π : retention threshold — resolution index + retained-at-resolution *)
    Res      : Type ;
    retained : Res -> Tcar -> Prop ;
    (* A : accessibility / record (lossy readout of a configuration) *)
    Rec    : Type ;
    record : Tcar -> Rec ;
    (* 𝔊 : consistency pole on configurations *)
    pole   : Tcar -> Prop ;
    (* ---- coherence laws (the minimum that makes this ONE object) ---- *)
    gauge_equiv  : Equivalence gauge ;
    tcomp_proper : forall a a' b b', gauge a a' -> gauge b b' ->
                                     gauge (tcomp a b) (tcomp a' b') ;
    tcomp_comm   : forall a b, gauge (tcomp a b) (tcomp b a) ;
    tcomp_assoc  : forall a b c, gauge (tcomp a (tcomp b c)) (tcomp (tcomp a b) c) ;
    tcomp_unit   : forall a, gauge (tcomp tunit a) a ;
    prop_le_preorder : PreOrder prop_le ;
    pole_proper  : forall a b, gauge a b -> (pole a <-> pole b) ;
    (* THE unifying law: the record reads ONLY gauge-invariant content       *)
    (* = readout-invariance (canon A8 'lens that does not distort')          *)
    record_gauge_invariant : forall a b, gauge a b -> record a = record b
  }.

  (* --------------------------------------------------------------------- *)
  (*  𝔊 : the consistency closure is the no-creation / obstruction-O=0 core *)
  (*       (Girard double-orthogonal), proven for EVERY center generically. *)
  (* --------------------------------------------------------------------- *)
  Section Consistency.
    Variable R : RetentionSystem.

    Definition orth (S : Tcar R -> Prop) : Tcar R -> Prop :=
      fun x => forall y, S y -> pole R (tcomp R x y).

    Lemma orth_antitone : forall (S T : Tcar R -> Prop),
        (forall z, S z -> T z) -> (forall x, orth T x -> orth S x).
    Proof. intros S T HST x Hx y Hy. apply Hx, HST, Hy. Qed.

    Lemma orth_expand : forall (S : Tcar R -> Prop) x, S x -> orth (orth S) x.
    Proof.
      intros S x Hx z Hz. specialize (Hz x Hx).            (* pole (z∘x) *)
      apply (proj1 (pole_proper R (tcomp R z x) (tcomp R x z)
                                (tcomp_comm R z x))).
      exact Hz.
    Qed.

    (* the closure is idempotent: orth∘orth∘orth = orth — physical content  *)
    (* lives at the fixed point (zero-SECTION of the obstruction bundle).    *)
    Theorem orth_triple : forall (S : Tcar R -> Prop) x,
        orth (orth (orth S)) x <-> orth S x.
    Proof.
      intros S x; split.
      - apply orth_antitone. intros z Hz. apply orth_expand; exact Hz.
      - apply orth_expand.
    Qed.
  End Consistency.

  (* A : the record of any center is a readout-invariant (sees only gauge).  *)
  Theorem readout_invariant :
    forall (R : RetentionSystem) a b, gauge R a b -> record R a = record R b.
  Proof. intros R a b H. exact (record_gauge_invariant R a b H). Qed.

  (* --------------------------------------------------------------------- *)
  (*  ONE SPOKE REALIZED : the canonical instance.                          *)
  (*  Γ = simple graph on ℕ ; D = ℕ ; T = (list ℕ, ++, [], Permutation)     *)
  (*  = transport up to relabeling/reorder (the graph-gauge, PGFT Table 10);*)
  (*  L = (≤) preorder ; Π = (ℕ, length ≤ n) ; A = length (lossy count) ;    *)
  (*  𝔊 = nonempty (a config is consistent iff it retains ≥1 distinction).   *)
  (* --------------------------------------------------------------------- *)
  Lemma perm_equiv : Equivalence (@Permutation nat).
  Proof.
    constructor.
    - exact (@Permutation_refl nat).
    - exact (@Permutation_sym nat).
    - exact (@Permutation_trans nat).
  Qed.

  Lemma app_perm_proper : forall a a' b b' : list nat,
      Permutation a a' -> Permutation b b' -> Permutation (a ++ b) (a' ++ b').
  Proof. intros; apply Permutation_app; assumption. Qed.

  Lemma app_perm_comm : forall a b : list nat, Permutation (a ++ b) (b ++ a).
  Proof. intros; apply Permutation_app_comm. Qed.

  Lemma app_perm_assoc : forall a b c : list nat,
      Permutation (a ++ (b ++ c)) ((a ++ b) ++ c).
  Proof. intros a b c; rewrite app_assoc; apply Permutation_refl. Qed.

  Lemma app_perm_unit : forall a : list nat, Permutation ([] ++ a) a.
  Proof. intros a; simpl; apply Permutation_refl. Qed.

  Lemma nat_le_preorder : PreOrder le.
  Proof.
    constructor.
    - intro x; apply Nat.le_refl.
    - intros x y z Hxy Hyz; exact (Nat.le_trans _ _ _ Hxy Hyz).
  Qed.

  Lemma pole_perm : forall a b : list nat,
      Permutation a b -> ((a <> []) <-> (b <> [])).
  Proof.
    intros a b Hp; split.
    - intros Hne Heq; subst b.
      apply Permutation_sym in Hp; apply Permutation_nil in Hp; contradiction.
    - intros Hne Heq; subst a.
      apply Permutation_nil in Hp; contradiction.
  Qed.

  Lemma length_perm_inv : forall a b : list nat,
      Permutation a b -> length a = length b.
  Proof. intros; apply Permutation_length; assumption. Qed.

  Definition R_canonical : RetentionSystem :=
    {| Dist     := nat ;
       edge     := fun x y => x <> y ;
       Tcar     := list nat ;
       gauge    := @Permutation nat ;
       tunit    := [] ;
       tcomp    := @app nat ;
       prop_le  := le ;
       Res      := nat ;
       retained := fun n l => length l <= n ;
       Rec      := nat ;
       record   := @length nat ;
       pole     := fun l => l <> [] ;
       gauge_equiv  := perm_equiv ;
       tcomp_proper := app_perm_proper ;
       tcomp_comm   := app_perm_comm ;
       tcomp_assoc  := app_perm_assoc ;
       tcomp_unit   := app_perm_unit ;
       prop_le_preorder := nat_le_preorder ;
       pole_proper  := pole_perm ;
       record_gauge_invariant := length_perm_inv |}.

  (* A8 lens: the record is a readout-invariant — relabeling cannot change it *)
  Theorem canonical_readout_invariant :
    forall l l', Permutation l l' -> record R_canonical l = record R_canonical l'.
  Proof. exact (record_gauge_invariant R_canonical). Qed.

  (* A4 observability≠existence: the record is STRICTLY lossy — R_O ≠ D_O.    *)
  (* Two distinct latent configs (different distinctions) share one record    *)
  (* yet are NOT gauge-equivalent.                                            *)
  Theorem canonical_record_lossy :
    exists x y, record R_canonical x = record R_canonical y
                /\ ~ gauge R_canonical x y.
  Proof.
    exists [0;0], [1;1]. split.
    - reflexivity.                                  (* length = 2 = length *)
    - intro H.                                      (* H : Permutation [0;0] [1;1] *)
      assert (HC : In 0 [1;1]).
      { eapply Permutation_in; [exact H | simpl; auto]. }
      destruct HC as [E | [E | []]]; discriminate.
  Qed.

  (* --------------------------------------------------------------------- *)
  (*  SPOKE  L → MODAL S4  (the L-projection of the center).                *)
  (*  The propagation preorder prop_le IS a Kripke accessibility; necessity *)
  (*  = the interior operator of its Alexandrov topology = S4's box.        *)
  (*  Uses ONLY prop_le + prop_le_preorder, so this is literally L of R^◇.   *)
  (* --------------------------------------------------------------------- *)
  Section ModalL.
    Variable R : RetentionSystem.
    Local Instance Rpre : PreOrder (prop_le R) := prop_le_preorder R.

    Definition Prp  := Dist R -> Prop.
    Definition BoxL (P : Prp) : Prp := fun w => forall w', prop_le R w w' -> P w'.
    Definition impP (P Q : Prp) : Prp := fun w => P w -> Q w.
    Definition andP (P Q : Prp) : Prp := fun w => P w /\ Q w.
    Definition TopP : Prp := fun _ => True.
    Definition ValidL (P : Prp) : Prop := forall w, P w.

    Lemma box_mono : forall P Q, (forall w, P w -> Q w) -> forall w, BoxL P w -> BoxL Q w.
    Proof. intros P Q H w HB w' Hacc. apply H, HB, Hacc. Qed.

    (* K : distribution over implication (normal modality) *)
    Theorem box_K : forall P Q w, BoxL (impP P Q) w -> BoxL P w -> BoxL Q w.
    Proof. intros P Q w HI HP w' Hacc. apply (HI w' Hacc), (HP w' Hacc). Qed.

    (* necessitation *)
    Theorem box_nec : forall P, ValidL P -> ValidL (BoxL P).
    Proof. intros P H w w' _. apply H. Qed.

    Lemma box_top : ValidL (BoxL TopP).
    Proof. intros w w' _. exact I. Qed.

    Lemma box_and : forall P Q w, BoxL (andP P Q) w <-> (BoxL P w /\ BoxL Q w).
    Proof.
      intros P Q w; split.
      - intro HB; split; intros w' Hacc; apply HB; exact Hacc.
      - intros [HP HQ] w' Hacc; split; [apply HP|apply HQ]; exact Hacc.
    Qed.

    (* T : reflexivity of prop_le  =>  Box P -> P *)
    Theorem box_T : forall P w, BoxL P w -> P w.
    Proof. intros P w HB. apply HB. reflexivity. Qed.

    (* 4 : transitivity of prop_le  =>  Box P -> Box Box P *)
    Theorem box_4 : forall P w, BoxL P w -> BoxL (BoxL P) w.
    Proof. intros P w HB w' H1 w'' H2. apply HB. transitivity w'; assumption. Qed.
  End ModalL.

  (* --------------------------------------------------------------------- *)
  (*  SPOKE  A → RECORD / READOUT MODALITY  (the A-projection of the center).*)
  (*  Rbox = "guaranteed by the record alone" = box over the record-fiber   *)
  (*  equivalence (same record).  It is a SOUND, normal modality on the      *)
  (*  coarse readout space (necessitation + distribution + factive over its  *)
  (*  own fiber) — yet NON-FACTIVE about LATENT content: latent truth        *)
  (*  strictly exceeds record-determined truth  (R_O ≠ D_O, canon A4).       *)
  (*  Uses ONLY record + record_gauge_invariant, so this is literally A.     *)
  (* --------------------------------------------------------------------- *)
  Section RecordA.
    Variable R : RetentionSystem.

    Definition fiber (x y : Tcar R) : Prop := record R y = record R x.
    Definition Rbox (P : Tcar R -> Prop) : Tcar R -> Prop :=
      fun x => forall y, fiber x y -> P y.
    Definition RValid (P : Tcar R -> Prop) : Prop := forall x, P x.

    Theorem R_nec : forall P, RValid P -> RValid (Rbox P).
    Proof. intros P H x y _. apply H. Qed.

    Theorem R_dist : forall P Q x, Rbox (fun z => P z -> Q z) x -> Rbox P x -> Rbox Q x.
    Proof. intros P Q x HI HP y Hf. apply (HI y Hf), (HP y Hf). Qed.

    (* factive over its OWN fiber: everything the record guarantees is true *)
    Theorem R_fiber_factive : forall P x, Rbox P x -> P x.
    Proof. intros P x HB. apply HB. unfold fiber. reflexivity. Qed.

    (* gauge is REFINED by the record-fiber: relabeling never changes the    *)
    (* record (ties A back to T — record collapses gauge, then some more).    *)
    Theorem gauge_refines_record : forall x y, gauge R x y -> fiber x y.
    Proof. intros x y Hg. unfold fiber. symmetry. exact (record_gauge_invariant R x y Hg). Qed.
  End RecordA.

  (* A4 / R_O ≠ D_O at the modal level (instance): a LATENT property true at  *)
  (* x but NOT guaranteed by x's record — record-determined truth ⊊ latent.   *)
  Theorem R_not_factive_canonical :
    exists (P : Tcar R_canonical -> Prop) x,
      P x /\ ~ Rbox R_canonical P x.
  Proof.
    exists (fun z => gauge R_canonical z [0;0]), [0;0]. split.
    - apply Permutation_refl.
    - intro H.
      assert (Hf : fiber R_canonical [0;0] [1;1]) by (unfold fiber; reflexivity).
      specialize (H [1;1] Hf).
      assert (HC : In 1 [0;0]) by (eapply Permutation_in; [exact H | simpl; auto]).
      destruct HC as [E | [E | []]]; discriminate.
  Qed.

  (* --------------------------------------------------------------------- *)
  (*  AXIOM-FREEDOM CHECK                                                    *)
  (* --------------------------------------------------------------------- *)
  (* spoke L -> S4 *)
  (* spoke A -> record modality *)
End RetCenter.

Module StarRig.
  Import List.
  Import ListNotations.
  Import PeanoNat.

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
End StarRig.

Module Gamma.
  Import List.
  Import ListNotations.
  Import Permutation.
  Import QArith.
  Import Lqa.
  Local Open Scope Q_scope.

  (* --- ℚ nonnegativity helpers --- *)
  Lemma Qplus_nonneg : forall a b, 0 <= a -> 0 <= b -> 0 <= a + b.
  Proof. intros; lra. Qed.
  Lemma Qsq_nonneg : forall d, 0 <= d * d.
  Proof. intro d; nra. Qed.
  Lemma Qmul_nonneg : forall a b, 0 <= a -> 0 <= b -> 0 <= a * b.
  Proof. intros; nra. Qed.

  (* ===== (1) Γ : weighted-graph Dirichlet energy ===== *)
  Definition Edge := (nat * nat * Q)%type.
  Definition w_of (e:Edge) : Q   := snd e.
  Definition u_of (e:Edge) : nat := fst (fst e).
  Definition v_of (e:Edge) : nat := snd (fst e).

  Definition term (x:nat->Q) (e:Edge) : Q :=
    w_of e * ((x (u_of e) - x (v_of e)) * (x (u_of e) - x (v_of e))).

  Definition energy (edges:list Edge) (x:nat->Q) : Q :=
    fold_right (fun e acc => term x e + acc) 0 edges.

  (* PSD : nonneg edge weights ⇒ Dirichlet energy ≥ 0  (the L_R ≽ 0 core) *)
  Theorem energy_nonneg : forall edges x,
    (forall e, In e edges -> 0 <= w_of e) -> 0 <= energy edges x.
  Proof.
    induction edges as [|e es IH]; intros x Hw.
    - simpl; lra.
    - simpl. apply Qplus_nonneg.
      + apply Qmul_nonneg.
        * apply Hw; left; reflexivity.
        * apply Qsq_nonneg.
      + apply IH. intros e' He'. apply Hw; right; exact He'.
  Qed.

  (* GRAPH-GAUGE (PGFT Table 10): permuting/relabeling the edge multiset     *)
  (* leaves the invariant graph readout (energy) unchanged.                  *)
  Theorem energy_edge_gauge : forall x edges edges',
    Permutation edges edges' -> energy edges x == energy edges' x.
  Proof.
    intros x edges edges' Hp. unfold energy. induction Hp.
    - reflexivity.
    - simpl. rewrite IHHp. reflexivity.
    - simpl. ring.
    - rewrite IHHp1; exact IHHp2.
  Qed.

  Theorem energy_zero_edges : forall x, energy [] x == 0.
  Proof. intro x; reflexivity. Qed.

  (* ===== (2) discrete continuum precursor (axiom-free half of L_R→−Δ_g) ==== *)
  Definition D2 (f:Q->Q) (x h:Q) : Q := f (x + h) - (2#1) * f x + f (x - h).
  Definition quad (a b c:Q) : Q -> Q := fun t => a*t*t + b*t + c.

  (* the [1,−2,1] stencil IS the discrete (negative) Laplacian *)
  Theorem laplacian_stencil : forall f x h,
    D2 f x h == f (x - h) - (2#1) * f x + f (x + h).
  Proof. intros; unfold D2; ring. Qed.

  (* 2nd difference of a quadratic = 2a·h²  EXACTLY (all x, all h) *)
  Theorem secondDiff_quadratic : forall a b c x h,
    D2 (quad a b c) x h == (2#1) * a * (h * h).
  Proof. intros; unfold D2, quad; ring. Qed.

  (* READOUT-INVARIANT : the scaled 2nd-difference reading is identical at    *)
  (* every resolution h and location x — value 2a disclosed at ALL            *)
  (* resolutions (NO division), exactly the π/φ readout-invariant pattern.    *)
  Theorem secondDiff_readout_invariant : forall a b c x x' h h',
    D2 (quad a b c) x h * (h' * h') == D2 (quad a b c) x' h' * (h * h).
  Proof. intros; unfold D2, quad; ring. Qed.

  (* --------------------------------------------------------------------- *)
End Gamma.


(* ===================================================================== *)
(*  FLAGSHIP RESULTS -- qualified, re-checked axiom-free at TOP LEVEL.     *)
(*  (Every module also prints its own assumptions above; these confirm     *)
(*  the cross-module headline theorems are reachable and clean here too.)  *)
(* ===================================================================== *)
Print Assumptions Sequent.sound.                 (* propositional FDE soundness (incl. cut) *)
Print Assumptions CutElim.cut_elim.              (* propositional cut-elimination *)
Print Assumptions FOL.soundF.                    (* first-order soundness (forall L/R, exists R/L) *)
Print Assumptions Linear.weakening_unsound.      (* substructural: weakening unsound *)
Print Assumptions Modal.s4_sound.                (* modal S4 over the retained order *)
Print Assumptions Graph.kernel_connected.        (* Fiedler: ker L_R = constants <-> connected *)
Print Assumptions Phase.dual_invol.              (* phase model: involution ~~X ~ X *)
Print Assumptions PhaseSound.soundness.          (* MALL phase soundness Prov => Valid *)
Print Assumptions PhaseSetoid.cut_elim.          (* MALL cut-elimination Prov G => Pcf G *)
Print Assumptions PhaseSetoid.cut_admissible.    (* full = cut-free *)
Print Assumptions PhaseSetoid.consistent.        (* ~ Prov [] *)


(* ---- appended axiom-free roots: disclosure (must all be Closed) ---- *)
Print Assumptions RetCenter.readout_invariant.
Print Assumptions RetCenter.orth_triple.
Print Assumptions StarRig.kraus_completeness.
Print Assumptions Gamma.secondDiff_readout_invariant.
Print Assumptions Gamma.energy_nonneg.
