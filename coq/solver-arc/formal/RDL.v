(* ===================================================================== *)
(* RDL.v  --  Retained-Distinction Logic: paraconsistent propositional   *)
(*            core, machine-checked (axiom-free).                         *)
(* Proves: soundness; NON-EXPLOSION (paraconsistency); CONTRADICTION =    *)
(* OBSTRUCTION (A7 zero-section); ACCESSIBILITY gap (A4); CLASSICAL LIMIT; *)
(* NON-TRIVIALITY.  4-valued RETENTION semantics (T/F/B=obstruction/N=gap)*)
(* coincides with Belnap-Dunn FDE, read as retention states.             *)
(* SCOPE: propositional core only (monotone fragment); budget/modal/      *)
(* first-order-lift are the next targets, NOT proved here.               *)
(* ===================================================================== *)
Require Import List Bool.
Import ListNotations.

(* ---- Syntax ---- *)
Inductive form : Type :=
  | atom : nat -> form
  | rneg : form -> form
  | rand : form -> form -> form
  | ror  : form -> form -> form.

(* ---- 4-valued retention semantics ----
   vt = retained AS DRAWN (1 in v);  vf = retained AS REVERSED (0 in v).
   T={t,f}=({true,false}) ... B={true,true}=obstruction; N={false,false}=gap *)
Record val4 : Type := mkV { vt : bool ; vf : bool }.
Definition obstruction (v:val4) : bool := andb (vt v) (vf v).
Definition gap         (v:val4) : bool := andb (negb (vt v)) (negb (vf v)).
Definition consistent_at (v:val4) : Prop := obstruction v = false.

Fixpoint eval (g:nat->val4)(p:form) : val4 :=
  match p with
  | atom n   => g n
  | rneg q   => let v := eval g q in mkV (vf v) (vt v)
  | rand a b => let va:=eval g a in let vb:=eval g b in
                mkV (andb (vt va)(vt vb)) (orb (vf va)(vf vb))
  | ror  a b => let va:=eval g a in let vb:=eval g b in
                mkV (orb (vt va)(vt vb)) (andb (vf va)(vf vb))
  end.

Definition des (v:val4) : Prop := vt v = true.
Definition entails (G:list form)(p:form) : Prop :=
  forall g, (forall q, In q G -> des (eval g q)) -> des (eval g p).

(* ---- Proof system (FDE-sound; NO ex-falso, NO disjunctive syllogism) ---- *)
Inductive deriv : list form -> form -> Prop :=
  | d_asm  : forall G p, In p G -> deriv G p
  | d_wk   : forall G G' p, incl G G' -> deriv G p -> deriv G' p
  | d_cut  : forall G a b, deriv G a -> deriv (a::G) b -> deriv G b
  | d_andI : forall G a b, deriv G a -> deriv G b -> deriv G (rand a b)
  | d_andE1: forall G a b, deriv G (rand a b) -> deriv G a
  | d_andE2: forall G a b, deriv G (rand a b) -> deriv G b
  | d_orI1 : forall G a b, deriv G a -> deriv G (ror a b)
  | d_orI2 : forall G a b, deriv G b -> deriv G (ror a b)
  | d_dnI  : forall G a, deriv G a -> deriv G (rneg (rneg a))
  | d_dnE  : forall G a, deriv G (rneg (rneg a)) -> deriv G a.

(* ====================== SOUNDNESS ====================== *)
Theorem soundness : forall G p, deriv G p -> entails G p.
Proof.
  intros G p D. induction D; unfold entails in *; intros g Hg.
  - apply Hg; assumption.
  - apply IHD. intros q Hq. apply Hg. apply H; exact Hq.
  - apply IHD2. intros q Hin. destruct Hin as [Heq|Hin].
    + subst q. apply IHD1; exact Hg.
    + apply Hg; exact Hin.
  - unfold des in *; simpl. apply andb_true_intro. split;
    [apply IHD1 | apply IHD2]; exact Hg.
  - unfold des in *; simpl in *. specialize (IHD g Hg).
    apply andb_true_iff in IHD; destruct IHD as [Ha _]; exact Ha.
  - unfold des in *; simpl in *. specialize (IHD g Hg).
    apply andb_true_iff in IHD; destruct IHD as [_ Hb]; exact Hb.
  - unfold des in *; simpl in *. specialize (IHD g Hg).
    apply orb_true_iff; left; exact IHD.
  - unfold des in *; simpl in *. specialize (IHD g Hg).
    apply orb_true_iff; right; exact IHD.
  - unfold des in *; simpl in *. apply IHD; exact Hg.
  - unfold des in *; simpl in *. apply IHD; exact Hg.
Qed.

(* ====================== NON-EXPLOSION (paraconsistency) ====================== *)
Definition assignBN : nat -> val4 :=
  fun n => match n with 0 => mkV true true | _ => mkV false false end.

Lemma countermodel_DS : ~ entails [atom 0; rneg (atom 0)] (atom 1).
Proof.
  unfold entails; intro H.
  assert (Hd : des (eval assignBN (atom 1))).
  { apply H. intros q [Hq|[Hq|[]]]; subst q; unfold des; reflexivity. }
  unfold des in Hd; simpl in Hd; discriminate.
Qed.

Theorem non_explosion : ~ deriv [atom 0; rneg (atom 0)] (atom 1).
Proof. intro H. apply countermodel_DS, (soundness _ _ H). Qed.

(* ====================== CONTRADICTION = OBSTRUCTION (A7) ====================== *)
Theorem contradiction_is_obstruction :
  forall g n, des (eval g (atom n)) -> des (eval g (rneg (atom n))) ->
              obstruction (g n) = true.
Proof.
  intros g n H1 H2. unfold des in *; simpl in *.
  unfold obstruction. rewrite H1, H2. reflexivity.
Qed.

Corollary contradiction_breaks_zero_section :
  forall g n, des (eval g (atom n)) -> des (eval g (rneg (atom n))) ->
              ~ consistent_at (g n).
Proof.
  intros g n H1 H2 Hc. unfold consistent_at in Hc.
  rewrite (contradiction_is_obstruction g n H1 H2) in Hc. discriminate.
Qed.

(* a contradiction IS satisfiable in full RDL (value B) -- so it cannot explode *)
Theorem contradiction_satisfiable :
  exists g n, des (eval g (atom n)) /\ des (eval g (rneg (atom n))).
Proof. exists (fun _ => mkV true true), 0. split; unfold des; reflexivity. Qed.

(* ====================== ACCESSIBILITY: gap gives no assertion (A4) ====================== *)
Theorem gap_no_assertion :
  forall g n, gap (g n) = true ->
              ~ des (eval g (atom n)) /\ ~ des (eval g (rneg (atom n))).
Proof.
  intros g n Hg. unfold gap in Hg. apply andb_true_iff in Hg.
  destruct Hg as [Ht Hf]. apply negb_true_iff in Ht. apply negb_true_iff in Hf.
  split; unfold des; simpl; [rewrite Ht | rewrite Hf]; intro Hc; discriminate.
Qed.

(* ====================== CLASSICAL LIMIT: explosion returns ====================== *)
Definition two_valued (g:nat->val4) : Prop := forall n, vf (g n) = negb (vt (g n)).

Theorem classical_limit_no_contradiction :
  forall g n, two_valued g ->
              ~ (des (eval g (atom n)) /\ des (eval g (rneg (atom n)))).
Proof.
  intros g n Htv [H1 H2]. unfold des in *; simpl in *.
  rewrite (Htv n) in H2. rewrite H1 in H2. simpl in H2. discriminate.
Qed.

(* ====================== NON-TRIVIALITY ====================== *)
Theorem non_triviality : ~ deriv [] (atom 0).
Proof.
  intro H. apply soundness in H. unfold entails in H.
  assert (Hd : des (eval (fun _ => mkV false false) (atom 0))).
  { apply H. intros q Hq. destruct Hq. }
  unfold des in Hd; simpl in Hd; discriminate.
Qed.

(* derived (weak) implication, for the record; MP is NOT claimed for it *)
Definition rimp (a b:form) : form := ror (rneg a) b.

(* ---------- AXIOM AUDIT ---------- *)
Print Assumptions soundness.
Print Assumptions non_explosion.
Print Assumptions contradiction_is_obstruction.
Print Assumptions contradiction_breaks_zero_section.
Print Assumptions contradiction_satisfiable.
Print Assumptions gap_no_assertion.
Print Assumptions classical_limit_no_contradiction.
Print Assumptions non_triviality.
