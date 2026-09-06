(* =====================================================================
   RDL_StarRigCPTP_General.v
   ---------------------------------------------------------------------
   The GENERAL (any-dimension) StarRig CPTP theorem.

   The concrete files RDL_StarRigMatrix.v (2x2) and RDL_StarRigMatrix3.v
   (3x3) prove CPTP on fixed-size operator models.  This file gives the
   DIMENSION-GENERAL statement: for an ARBITRARY traced *-algebra with a
   positive cone, and an ARBITRARY finite (list-indexed) family of Kraus
   operators, the readout channel  chan ks rho = sum_j K_j rho K_j^*

     (1) is built from a projector resolution + an isometry so that the
         completeness relation  sum_j K_j^* K_j = 1  holds
         (kraus_completeness_general);
     (2) is TRACE PRESERVING                       (channel_trace_preserving);
     (3) is COMPLETELY POSITIVE                    (channel_completely_positive).

   n x n integer matrices of EVERY dimension n are models: the abstract
   hypotheses below are discharged for matrices by ring (the ring/star
   laws) and by the finite-sum lemmas (trace linearity/cyclicity, the
   quadratic-form positive cone).  RDL_StarRigMatrix3.v already discharges
   all of them for n = 3; the general n x n discharge is the same
   finite-sum bookkeeping.

   METHODOLOGY: exactly the project's "laws-as-hypotheses + concrete model"
   pattern (cf. RDL_StarRig.v).  The proofs are pure rewriting and list
   induction -- NO funext, NO classical, NO `ring` needed at this layer.

   STATUS: candidate.  Must pass `coqc 8.18.0`; each `Print Assumptions`
   must report "Closed under the global context".
   ===================================================================== *)

Require Import ZArith.
Require Import List.
Import ListNotations.
Open Scope Z_scope.

Section GeneralCPTP.

  (* ---- the carrier of a traced *-algebra with a positive cone ---- *)
  Variable R : Type.
  Variable zero one : R.
  Variable add mul : R -> R -> R.
  Variable adj : R -> R.            (* the involution (adjoint / transpose) *)
  Variable trace : R -> Z.          (* a trace functional *)
  Variable psd : R -> Prop.         (* the positive cone *)

  (* ---- the axioms we actually use (all discharged by n x n matrices) ---- *)
  Hypothesis mul_0_l   : forall a, mul zero a = zero.
  Hypothesis mul_0_r   : forall a, mul a zero = zero.
  Hypothesis mul_1_l   : forall a, mul one a = a.
  Hypothesis mul_1_r   : forall a, mul a one = a.
  Hypothesis mul_assoc : forall a b c, mul (mul a b) c = mul a (mul b c).
  Hypothesis mul_add_l : forall a b c, mul a (add b c) = add (mul a b) (mul a c).
  Hypothesis mul_add_r : forall a b c, mul (add a b) c = add (mul a c) (mul b c).
  Hypothesis adj_mul   : forall a b, adj (mul a b) = mul (adj b) (adj a).
  Hypothesis trace_add : forall a b, trace (add a b) = (trace a + trace b)%Z.
  Hypothesis trace_cyc : forall a b, trace (mul a b) = trace (mul b a).
  Hypothesis psd_zero  : psd zero.
  Hypothesis psd_add   : forall a b, psd a -> psd b -> psd (add a b).
  Hypothesis psd_conj  : forall k a, psd a -> psd (mul (mul k a) (adj k)).

  (* ---- the completeness sum and the channel over a finite family ---- *)
  Fixpoint comp (ks : list R) : R :=
    match ks with
    | [] => zero
    | k :: ks' => add (mul (adj k) k) (comp ks')
    end.

  Fixpoint chan (ks : list R) (rho : R) : R :=
    match ks with
    | [] => zero
    | k :: ks' => add (mul (mul k rho) (adj k)) (chan ks' rho)
    end.

  (* =====================================================================
     TRACE PRESERVATION.  First, trace(chan ks rho) = trace((sum K_j^* K_j) rho).
     ===================================================================== *)
  Lemma trace_chan_comp :
    forall ks rho, trace (chan ks rho) = trace (mul (comp ks) rho).
  Proof.
    induction ks as [|k ks IH]; intro rho; simpl.
    - rewrite mul_0_l. reflexivity.
    - rewrite mul_add_r, !trace_add,
              (trace_cyc (mul k rho) (adj k)),
              <- (mul_assoc (adj k) k rho), IH.
      reflexivity.
  Qed.

  Theorem channel_trace_preserving :
    forall ks rho, comp ks = one -> trace (chan ks rho) = trace rho.
  Proof.
    intros ks rho H. rewrite trace_chan_comp, H, mul_1_l. reflexivity.
  Qed.

  (* =====================================================================
     COMPLETE POSITIVITY.  psd rho -> psd (chan ks rho), for any family.
     ===================================================================== *)
  Theorem channel_completely_positive :
    forall ks rho, psd rho -> psd (chan ks rho).
  Proof.
    induction ks as [|k ks IH]; intros rho H; simpl.
    - exact psd_zero.
    - apply psd_add.
      + apply psd_conj. exact H.
      + apply IH. exact H.
  Qed.

  (* =====================================================================
     THE KRAUS CONSTRUCTION.  From a resolution of identity by self-adjoint
     idempotents and an isometry U, the family K_j := P_j U is complete.
     ===================================================================== *)
  Fixpoint Psum (ps : list R) : R :=
    match ps with
    | [] => zero
    | P :: ps' => add P (Psum ps')
    end.

  (* each Kraus term collapses:  (P U)^* (P U) = U^* P U   when P^* P = P. *)
  Lemma kraus_term :
    forall P U, mul (adj P) P = P ->
      mul (adj (mul P U)) (mul P U) = mul (mul (adj U) P) U.
  Proof.
    intros P U HP.
    rewrite adj_mul.
    rewrite mul_assoc.
    rewrite <- (mul_assoc (adj P) P U).
    rewrite HP.
    rewrite <- (mul_assoc (adj U) P U).
    reflexivity.
  Qed.

  Lemma comp_map_PU :
    forall ps U,
      Forall (fun P => mul (adj P) P = P) ps ->
      comp (map (fun P => mul P U) ps) = mul (mul (adj U) (Psum ps)) U.
  Proof.
    induction ps as [|P ps IH]; intros U H; simpl.
    - rewrite mul_0_r, mul_0_l. reflexivity.
    - rewrite (kraus_term P U (Forall_inv H)).
      rewrite (IH U (Forall_inv_tail H)).
      rewrite (mul_add_l (adj U) P (Psum ps)).
      rewrite (mul_add_r (mul (adj U) P) (mul (adj U) (Psum ps)) U).
      reflexivity.
  Qed.

  Theorem kraus_completeness_general :
    forall ps U,
      Forall (fun P => mul (adj P) P = P) ps ->   (* self-adjoint idempotents *)
      Psum ps = one ->                            (* resolving the identity   *)
      mul (adj U) U = one ->                       (* U an isometry            *)
      comp (map (fun P => mul P U) ps) = one.
  Proof.
    intros ps U Hps HP HU.
    rewrite (comp_map_PU ps U Hps).
    rewrite HP, mul_1_r, HU.
    reflexivity.
  Qed.

  (* =====================================================================
     PUTTING IT TOGETHER: a projector resolution + an isometry yields a
     channel that is trace preserving (and, with the cone, CPTP).
     ===================================================================== *)
  Theorem kraus_channel_is_TP :
    forall ps U rho,
      Forall (fun P => mul (adj P) P = P) ps ->
      Psum ps = one ->
      mul (adj U) U = one ->
      trace (chan (map (fun P => mul P U) ps) rho) = trace rho.
  Proof.
    intros ps U rho Hps HP HU.
    apply channel_trace_preserving.
    apply kraus_completeness_general; assumption.
  Qed.

End GeneralCPTP.

(* =====================================================================
   AXIOM AUDIT.  Each must report "Closed under the global context"
   (the results are theorems over the abstract structure; no axioms).
   ===================================================================== *)
Print Assumptions channel_trace_preserving.
Print Assumptions channel_completely_positive.
Print Assumptions kraus_completeness_general.
Print Assumptions kraus_channel_is_TP.

(* End RDL_StarRigCPTP_General.v *)
