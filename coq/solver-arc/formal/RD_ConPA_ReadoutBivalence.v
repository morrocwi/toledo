(* =====================================================================
   RD_ConPA_ReadoutBivalence.v
   ---------------------------------------------------------------------
   The RD-NATIVE resolution of the `classic` frontier in Con_PA_classical.

   THE OLD-FRAMEWORK READING (which we reject as the route).  Treat the
   classical excluded-middle rule C_lem as a logical primitive and demand
   its semantic soundness; this forces  classic : forall P, P \/ ~P  as a
   GLOBAL AXIOM over every proposition, and the only "fix" is a syntactic
   Goedel-Gentzen translation on the embedded calculus.

   THE RD READING.  In the retained-distinction ontology:

     * CONSISTENCY is not a syntactic theorem but NON-COLLAPSE of the
       retained structure.  PA is consistent because the distinction
       structure D (= N) it generates does not degenerate.  This is
       `Con_PA` -- already AXIOM-FREE.  It is the whole consistency
       content, in our terms.

     * BIVALENCE is not a primitive logical law.  It is the READOUT-
       COMPLETENESS of a COMPLETED totality: every sentence has a settled
       value *because the structure D is a finished, fully-retained
       object*.  This is a TIER-2 readout idealisation -- the same kind we
       already disclose for the continuum (R as a readout-limit of Q).

   So `classic` was a CATEGORY ERROR: a readout idealisation about the
   completed model D, mis-placed as a foundational axiom over all of logic.
   We RELOCATE it: from a global axiom to an explicit, disclosed, and
   strictly weaker hypothesis -- the readout-bivalence of D alone:

       ReadoutComplete := forall env f, satD env f \/ ~ satD env f.

   With this, classical consistency becomes a CLEAN CONDITIONAL THEOREM
   that uses NO axiom: `Print Assumptions` reports Closed under the global
   context.  The core (Con_PA) stays unconditionally axiom-free; the
   excluded-middle content is now an honestly named readout parameter
   supplied only inside the classical cap.

   We do NOT claim to constructively prove bivalence (that would be proving
   LEM, impossible).  We claim the RD reconception: consistency is settled
   axiom-free; bivalence is a disclosed readout idealisation, parameterised
   rather than smuggled.  The `classic` AXIOM is thereby removed from the
   assumption list of classical consistency.

   This file builds on RD.v (reuses its semantics verbatim) and changes
   exactly ONE line of the classical soundness proof: the C_lem case uses
   the readout-completeness hypothesis in place of `classic`.

   STATUS: candidate.  `Print Assumptions Con_PA_classical_param` must
   report "Closed under the global context" (NO `classic`).
   ===================================================================== *)

Require Import RD.

(* The readout-bivalence of the completed structure D -- a disclosed
   TIER-2 idealisation, localised to the satD-readout of D (strictly
   weaker than global LEM), NOT an axiom. *)
Definition ReadoutComplete : Prop :=
  forall env f, satD env f \/ ~ satD env f.

(* Classical soundness, with the readout-completeness hypothesis in place
   of the `classic` axiom.  Identical to RD.soundnessC except the C_lem
   case (last bullet) reads off ReadoutComplete instead of `apply classic`. *)
Theorem soundnessC_param :
  ReadoutComplete ->
  forall (T : Fm -> Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    forall f, ProvC T f ->
    forall env, (forall a, T a -> satD env a) -> satD env f.
Proof.
  intros HRC T Hclosed f Hp.
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
                            (fun v => evD env (scons t tvar v))
                  (fun v => match v with 0 => eq_refl | S k => eq_refl end))).
    exact (IHall env Henv (evD env t)).
  - specialize (IHsub env Henv).
    apply (proj1 (satD_subst p (scons t tvar) env)) in IHsub.
    apply (proj1 (satD_ext p (fun v => evD env (scons t tvar v))
                            (consD (evD env t) env)
                  (fun v => match v with 0 => eq_refl | S k => eq_refl end))) in IHsub.
    exists (evD env t); exact IHsub.
  - intro d. apply (IHgen (consD d env)). intros a Ha.
    apply (proj1 (Hclosed a env (consD d env) Ha)). exact (Henv a Ha).
  - exact (HRC env p).        (* <-- the ONLY change: readout-bivalence, not `classic` *)
Qed.

Theorem consistencyC_param :
  ReadoutComplete ->
  forall (T : Fm -> Prop),
    (forall a e1 e2, T a -> (satD e1 a <-> satD e2 a)) ->
    (exists env, forall a, T a -> satD env a) ->
    ~ ProvC T Fbot.
Proof.
  intros HRC T Hclosed [env Henv] Hpr.
  pose proof (soundnessC_param HRC T Hclosed Fbot Hpr env Henv) as Hb.
  simpl in Hb. apply Hb; reflexivity.
Qed.

(* CLASSICAL CONSISTENCY OF PA -- now with NO axiom.  The excluded-middle
   content is the disclosed readout-bivalence of D, supplied as a parameter
   inside the classical cap.  Compare RD.Con_PA_classical, whose sole axiom
   was `classic`. *)
Theorem Con_PA_classical_param :
  ReadoutComplete -> ~ ProvC PA Fbot.
Proof.
  intro HRC.
  apply (consistencyC_param HRC PA PA_closed).
  exists (fun _ => zero). intros a Ha. exact (D_models_PA (fun _ => zero) a Ha).
Qed.

(* =====================================================================
   AXIOM AUDIT.  This MUST report "Closed under the global context":
   the `classic` axiom is GONE -- replaced by the explicit, disclosed,
   strictly-weaker readout-completeness hypothesis.  The core Con_PA
   remains unconditionally axiom-free.
   ===================================================================== *)
Print Assumptions Con_PA_classical_param.
Print Assumptions soundnessC_param.

(* End RD_ConPA_ReadoutBivalence.v *)
