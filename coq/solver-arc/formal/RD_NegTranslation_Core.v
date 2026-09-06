(* =====================================================================
   RD_NegTranslation_Core.v
   ---------------------------------------------------------------------
   Removing the last `classic` axiom from RD.Con_PA_classical -- STEP 1:
   the constructive (axiom-free) double-negation core that every step of
   the Goedel-Gentzen elimination rests on.

   WHERE classic LIVES (RD.v).  The only use of `classic` is one line in
   `soundnessC` -- the C_lem (excluded-middle rule) case:

       | C_lem : forall p, ProvC T (For p (Fnot p))
       ...
       - apply classic.            (* goal: satD env p \/ ~ satD env p *)

   Everything else in soundnessC is constructive, and `Con_PA` (the
   INTUITIONISTIC consistency of PA) is already axiom-free.

   WHY the naive fix fails.  One might try to prove soundness into the
   double-negated semantics  ProvC T f -> ~~ satD env f,  so that C_lem
   becomes  ~~(satD env p \/ ~ satD env p) = nn_em (constructive).  But
   the C_gen case (universal generalisation, Fall) then needs

       (forall d, ~~ satD (consD d env) p) -> ~~ (forall d, satD (consD d env) p)

   which is the DOUBLE-NEGATION SHIFT -- NOT constructively valid.

   THE CORRECT FIX (Goedel-Gentzen).  Insert ~~ only at ATOMS, OR (For)
   and EXISTS (Fex); leave ->, /\, forall (Fall) untouched.  Define a
   guarded satisfaction  satD_gg  mirroring satD with these ~~ insertions.
   Then:
     * C_lem case:  satD_gg env (For p (Fnot p)) = ~~(satD_gg p \/ ~satD_gg p)
                    = nn_em  -- CONSTRUCTIVE, no classic;
     * C_gen case:  Fall is unchanged, so NO double-negation shift arises.
   Combined with  satD env f -> satD_gg env f  (double-negation
   introduction, by induction on f) applied to D_models_PA, and
   satD_gg env Fbot = False, this yields  ~ ProvC PA Fbot  axiom-free.

   The lemmas in THIS file are the reusable, axiom-free kernel of that
   argument (the ~~ monad, weak excluded middle, stability of the negative
   fragment).  They compile standalone; STEPS 2-4 (define satD_gg, prove
   the satD->satD_gg monotonicity and the satD_gg substitution lemmas,
   then soundnessC_gg) build on RD.v and are the next increments.

   STATUS: VERIFIED-FREE target.  `Print Assumptions` on every item below
   must report "Closed under the global context" (NO `classic`).
   ===================================================================== *)

(* =====================================================================
   The constructive ~~ kernel.
   ===================================================================== *)

(* P is stable iff double-negation elimination holds for P, constructively *)
Definition Stable (P : Prop) : Prop := ~ ~ P -> P.

(* weak excluded middle is CONSTRUCTIVE (no axiom) *)
Lemma nn_em : forall Q : Prop, ~ ~ (Q \/ ~ Q).
Proof. intros Q H. apply H. right. intro q. apply H. left. exact q. Qed.

(* THE TOOL: a stable goal may be proved using excluded middle on any Q,
   with NO classical axiom.  This is exactly the operational content that
   discharges the C_lem rule. *)
Theorem dn_lem : forall P Q : Prop, Stable P -> ((Q \/ ~ Q) -> P) -> P.
Proof.
  intros P Q SP h. apply SP. intro nP.
  apply (nn_em Q). intro qem. apply nP. apply h. exact qem.
Qed.

(* =====================================================================
   The NEGATIVE FRAGMENT is stable -- the class GG keeps untouched
   (->, /\, forall, and negations / decidable atoms).
   ===================================================================== *)

Lemma stable_False : Stable False.
Proof. intro H. apply H. intro f. exact f. Qed.

Lemma stable_not : forall P, Stable (~ P).
Proof. intros P H p. apply H. intro np. exact (np p). Qed.

Lemma stable_and : forall P Q, Stable P -> Stable Q -> Stable (P /\ Q).
Proof.
  intros P Q SP SQ H. split.
  - apply SP. intro nP. apply H. intros [p _]. exact (nP p).
  - apply SQ. intro nQ. apply H. intros [_ q]. exact (nQ q).
Qed.

Lemma stable_impl : forall P Q, Stable Q -> Stable (P -> Q).
Proof.
  intros P Q SQ H p. apply SQ. intro nQ. apply H. intro pq. exact (nQ (pq p)).
Qed.

Lemma stable_forall : forall (T : Type) (P : T -> Prop),
  (forall x, Stable (P x)) -> Stable (forall x, P x).
Proof.
  intros T P SP H x. apply (SP x). intro nPx. apply H. intro all. exact (nPx (all x)).
Qed.

Lemma dec_stable : forall P, (P \/ ~ P) -> Stable P.
Proof. intros P Hdec H. destruct Hdec as [p | np]. - exact p. - exfalso. apply H. exact np. Qed.

(* =====================================================================
   DEMONSTRATION on a Con_PA-shaped statement.
   Con_PA = ~ Prov PA Fbot is, semantically, a `forall n, ~ (...)` -- a
   forall of negations, i.e. a Pi^0_1 statement.  Such statements are in
   the stable fragment, and a proof that case-splits on a decidable atom
   (the move that naively reaches for `classic`) is constructive here.
   ===================================================================== *)
Section ConShaped.
  Variable T : nat -> Prop.                 (* a decidable atom family *)
  Definition Con : Prop := forall n, ~ T n.

  (* Con is stable: forall of negations *)
  Lemma Con_stable : Stable Con.
  Proof. unfold Con. apply stable_forall. intro n. apply stable_not. Qed.

  (* A proof that may use excluded middle on each atom T n is axiom-free *)
  Theorem Con_no_classic :
    (forall n, (T n \/ ~ T n) -> ~ T n) -> Con.
  Proof.
    intros h n. apply (dn_lem (~ T n) (T n)).
    - apply stable_not.
    - exact (h n).
  Qed.
End ConShaped.

(* =====================================================================
   AXIOM AUDIT.  Each MUST report "Closed under the global context".
   The whole kernel is constructive: there is no `Require Import Classical`
   and no use of `classic`.
   ===================================================================== *)
Print Assumptions dn_lem.
Print Assumptions stable_forall.
Print Assumptions stable_not.
Print Assumptions Con_no_classic.

(* End RD_NegTranslation_Core.v *)
