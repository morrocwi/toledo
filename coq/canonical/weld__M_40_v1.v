(* weld/M.40.v1 -- Th_coqc -- Anderson-Morley sharp curvature ceiling for a *)
(* graph Laplacian eigenpair, witness form over Q (no eigen-vocabulary, no *)
(* reals). This entry's OWN registered statement is the curvature-floor *)
(* corollary `sharp_curvature_ceiling` (lam <= 4 - Fmin) ONLY -- the base *)
(* inequality `anderson_morley_witness` (|lam| <= deg u + deg v) restates *)
(* the classical Anderson-Morley bound already bare-cited in Toledo as *)
(* q_formal/M.05.v1 (untagged/wrapped_related, no prior real Coq witness); *)
(* see this entry's relations[] (refines -> q_formal/M.05.v1) and *)
(* drift_note for the disclosed overlap. The base lemma is kept in this *)
(* file only as the load-bearing support the corollary is built on, not as *)
(* a second independent registration of the classical fact. *)
(* *)
(* source: InfoSpectralCeilingSharp.v (standalone Coq file, Downloads, not *)
(* previously deposited or registered); EQUATION OWNERSHIP per the file's *)
(* own header: the inequality is Anderson-Morley's (Linear and Multilinear *)
(* Algebra 18:141-145, 1985); new here (per the source) is the *)
(* machine-checked witness-form proof over Q and the curvature-floor *)
(* corollary. Toledo v1.8 (spectral-ceiling merge) copies the file *)
(* verbatim (self-contained, Coq stdlib only: PeanoNat, List, QArith, *)
(* Qabs, Lqa -- confirmed by re-reading its own Require lines). *)
(* *)
(* registered statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \forall (\lambda,x) \text{ an exact eigenpair witness}, \forall F_{\min} *)
(* \text{ a curvature floor}: \lambda \le 4 - F_{\min} *)

Require Coq.Arith.PeanoNat.
Require Coq.Lists.List.
Require Coq.QArith.QArith.
Require Coq.QArith.Qabs.
Require Coq.micromega.Lqa.

Module SpectralCeilingSharp.

Import Coq.Lists.List. Import ListNotations.
Import Coq.Arith.PeanoNat.
Import Coq.QArith.QArith.
Import Coq.QArith.Qabs.
Import Coq.micromega.Lqa.
Local Open Scope Q_scope.

Definition Edge : Type := (nat * nat)%type.

Definition esum (E : list Edge) (h : Edge -> Q) : Q :=
  fold_right (fun e acc => h e + acc) 0 E.

Definition share (e : Edge) (i : nat) : Q :=
  (if Nat.eqb (fst e) i then 1 else 0) + (if Nat.eqb (snd e) i then 1 else 0).

Definition deg (E : list Edge) (i : nat) : Q := esum E (fun e => share e i).

Definition forman (E : list Edge) (e : Edge) : Q :=
  4 - deg E (fst e) - deg E (snd e).

Definition ediff (x : nat -> Q) (e : Edge) : Q := x (fst e) - x (snd e).

(* per-node contribution of an edge, toward node w *)
Definition acontrib (x : nat -> Q) (w : nat) (e : Edge) : Q :=
  (if Nat.eqb (fst e) w then 1 else 0) * (x (fst e) - x (snd e))
  + (if Nat.eqb (snd e) w then 1 else 0) * (x (snd e) - x (fst e)).

Definition lnode (E : list Edge) (x : nat -> Q) (i : nat) : Q :=
  esum E (acontrib x i).

(* ------------------------------------------------------------------ *)
(* Toolbox                                                             *)
(* ------------------------------------------------------------------ *)

Lemma esum_ext : forall E (f h : Edge -> Q),
  (forall e, In e E -> f e == h e) ->
  esum E f == esum E h.
Proof.
  induction E as [| e r IH]; intros f h H; simpl.
  - reflexivity.
  - rewrite (H e); [| left; reflexivity].
    rewrite (IH f h); [reflexivity | intros e' He'; apply H; right; exact He'].
Qed.

Lemma esum_plus : forall E (f h : Edge -> Q),
  esum E (fun e => f e + h e) == esum E f + esum E h.
Proof.
  induction E as [| e r IH]; intros f h; simpl; [ring | rewrite IH; ring].
Qed.

Lemma esum_minus : forall E (f h : Edge -> Q),
  esum E (fun e => f e - h e) == esum E f - esum E h.
Proof.
  induction E as [| e r IH]; intros f h; simpl; [ring | rewrite IH; ring].
Qed.

Lemma esum_le : forall E (f h : Edge -> Q),
  (forall e, In e E -> f e <= h e) ->
  esum E f <= esum E h.
Proof.
  induction E as [| e r IH]; intros f h H; simpl.
  - lra.
  - assert (H1 : f e <= h e) by (apply H; left; reflexivity).
    assert (H2 : esum r f <= esum r h)
      by (apply IH; intros e' He'; apply H; right; exact He').
    lra.
Qed.

Lemma esum_scale_r : forall E (f : Edge -> Q) (c : Q),
  esum E (fun e => f e * c) == esum E f * c.
Proof.
  induction E as [| e r IH]; intros f c; simpl; [ring | rewrite IH; ring].
Qed.

Lemma esum_abs_triangle : forall E (f : Edge -> Q),
  Qabs (esum E f) <= esum E (fun e => Qabs (f e)).
Proof.
  induction E as [| e r IH]; intros f.
  - change (Qabs 0 <= 0). rewrite Qabs_pos by lra. lra.
  - simpl. eapply Qle_trans; [apply Qabs_triangle |].
    assert (H := IH f). lra.
Qed.

Lemma Qabs_pos_of_neq : forall a : Q, ~ a == 0 -> 0 < Qabs a.
Proof.
  intros a Hne.
  destruct (Q_dec 0 a) as [[Hlt | Hgt] | Heq].
  - rewrite Qabs_pos; lra.
  - rewrite Qabs_neg; lra.
  - exfalso. apply Hne. symmetry. exact Heq.
Qed.

Lemma exists_max_edge : forall (E : list Edge) (x : nat -> Q) (e0 : Edge),
  In e0 E ->
  exists em, In em E /\
    (forall e, In e E -> Qabs (ediff x e) <= Qabs (ediff x em)).
Proof.
  induction E as [| e r IH]; intros x e0 H0.
  - destruct H0.
  - destruct r as [| e1 r'].
    + exists e. split; [left; reflexivity |].
      intros e' He'. destruct He' as [<- | []]. lra.
    + destruct (IH x e1 (or_introl eq_refl)) as [em [Hin Hmax]].
      destruct (Qlt_le_dec (Qabs (ediff x em)) (Qabs (ediff x e)))
        as [Hlt | Hle].
      * exists e. split; [left; reflexivity |].
        intros e' He'. destruct He' as [<- | He'']; [lra |].
        assert (H := Hmax e' He''). lra.
      * exists em. split; [right; exact Hin |].
        intros e' He'. destruct He' as [<- | He'']; [exact Hle |].
        apply Hmax; exact He''.
Qed.

(* ------------------------------------------------------------------ *)
(* Pointwise domination by the maximizer                               *)
(* ------------------------------------------------------------------ *)

Lemma acontrib_bound :
  forall (x : nat -> Q) (w : nat) (e : Edge) (D : Q),
  Qabs (ediff x e) <= D ->
  Qabs (acontrib x w e) <= share e w * D.
Proof.
  intros x w e D He.
  assert (HD : 0 <= D)
    by (eapply Qle_trans; [apply Qabs_nonneg | exact He]).
  unfold acontrib, share, ediff in *.
  destruct (Nat.eqb (fst e) w) eqn:Ef;
  destruct (Nat.eqb (snd e) w) eqn:Es.
  - apply Nat.eqb_eq in Ef. apply Nat.eqb_eq in Es.
    assert (Hfs : fst e = snd e) by (rewrite Ef, Es; reflexivity).
    assert (HA : 1 * (x (fst e) - x (snd e)) + 1 * (x (snd e) - x (fst e)) == 0)
      by ring.
    rewrite HA.
    assert (HQ0 : Qabs 0 == 0) by (rewrite Qabs_pos; lra).
    rewrite HQ0. lra.
  - assert (HA : 1 * (x (fst e) - x (snd e)) + 0 * (x (snd e) - x (fst e))
                 == x (fst e) - x (snd e)) by ring.
    rewrite HA. lra.
  - assert (HA : 0 * (x (fst e) - x (snd e)) + 1 * (x (snd e) - x (fst e))
                 == - (x (fst e) - x (snd e))) by ring.
    rewrite HA. rewrite Qabs_opp. lra.
  - assert (HA : 0 * (x (fst e) - x (snd e)) + 0 * (x (snd e) - x (fst e)) == 0)
      by ring.
    rewrite HA.
    assert (HQ0 : Qabs 0 == 0) by (rewrite Qabs_pos; lra).
    rewrite HQ0. lra.
Qed.

Lemma pair_term_bound :
  forall (x : nat -> Q) (u v : nat) (e : Edge) (D : Q),
  Qabs (ediff x e) <= D ->
  Qabs (acontrib x u e - acontrib x v e) <= (share e u + share e v) * D.
Proof.
  intros x u v e D He.
  assert (Hu := acontrib_bound x u e D He).
  assert (Hv := acontrib_bound x v e D He).
  assert (Ht : Qabs (acontrib x u e - acontrib x v e)
               <= Qabs (acontrib x u e) + Qabs (acontrib x v e)).
  { assert (Hm : acontrib x u e - acontrib x v e
                 == acontrib x u e + (- acontrib x v e)) by ring.
    rewrite Hm.
    eapply Qle_trans; [apply Qabs_triangle |].
    rewrite Qabs_opp. lra. }
  eapply Qle_trans; [exact Ht |]. lra.
Qed.

(* ------------------------------------------------------------------ *)
(* THE SHARP CEILING                                                   *)
(* ------------------------------------------------------------------ *)

Theorem anderson_morley_witness :
  forall (E : list Edge) (x : nat -> Q) (lam : Q) (ew : Edge),
  (forall i, lnode E x i == lam * x i) ->
  In ew E ->
  ~ (ediff x ew == 0) ->
  exists em, In em E /\ Qabs lam <= deg E (fst em) + deg E (snd em).
Proof.
  intros E x lam ew Hpair Hin Hnz.
  destruct (exists_max_edge E x ew Hin) as [em [Hem Hmax]].
  set (u := fst em). set (v := snd em).
  set (D := Qabs (ediff x em)).
  assert (HD : 0 < D).
  { unfold D. eapply Qlt_le_trans;
      [apply Qabs_pos_of_neq; exact Hnz | apply Hmax; exact Hin]. }
  (* the two-endpoint identity *)
  assert (Hid : lam * ediff x em == esum E (fun e => acontrib x u e - acontrib x v e)).
  { rewrite esum_minus.
    change (esum E (acontrib x u)) with (lnode E x u).
    change (esum E (acontrib x v)) with (lnode E x v).
    rewrite (Hpair u), (Hpair v).
    unfold ediff, u, v. ring. }
  (* absolute bound on the sum *)
  assert (Hsum : Qabs (esum E (fun e => acontrib x u e - acontrib x v e))
                 <= (deg E u + deg E v) * D).
  { eapply Qle_trans; [apply esum_abs_triangle |].
    eapply Qle_trans.
    - apply (esum_le E
        (fun e => Qabs (acontrib x u e - acontrib x v e))
        (fun e => (share e u + share e v) * D)).
      intros e He. apply pair_term_bound. apply Hmax. exact He.
    - rewrite (esum_scale_r E (fun e => share e u + share e v) D).
      rewrite (esum_plus E (fun e => share e u) (fun e => share e v)).
      unfold deg. lra. }
  (* transfer through Qabs of the product *)
  assert (Hprod : Qabs lam * D <= (deg E u + deg E v) * D).
  { unfold D. rewrite <- Qabs_Qmult.
    assert (Hw : Qabs (lam * ediff x em)
                 == Qabs (esum E (fun e => acontrib x u e - acontrib x v e)))
      by (rewrite Hid; reflexivity).
    rewrite Hw. exact Hsum. }
  exists em. split; [exact Hem |].
  assert (Hfin : Qabs lam <= deg E u + deg E v) by nra.
  exact Hfin.
Qed.

(* the SHARP curvature ceiling -- THIS entry's own registered statement *)
Corollary sharp_curvature_ceiling :
  forall (E : list Edge) (x : nat -> Q) (lam Fmin : Q) (ew : Edge),
  (forall i, lnode E x i == lam * x i) ->
  In ew E ->
  ~ (ediff x ew == 0) ->
  (forall e, In e E -> Fmin <= forman E e) ->
  lam <= 4 - Fmin.
Proof.
  intros E x lam Fmin ew Hpair Hin Hnz Hfl.
  destruct (anderson_morley_witness E x lam ew Hpair Hin Hnz)
    as [em [Hem Hb]].
  assert (Hf := Hfl em Hem). unfold forman in Hf.
  assert (Hl := Qle_Qabs lam).
  lra.
Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions esum_abs_triangle.
Print Assumptions exists_max_edge.
Print Assumptions acontrib_bound.
Print Assumptions pair_term_bound.
Print Assumptions anderson_morley_witness.
Print Assumptions sharp_curvature_ceiling.

End SpectralCeilingSharp.
