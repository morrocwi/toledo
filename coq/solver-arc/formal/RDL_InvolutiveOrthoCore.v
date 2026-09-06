(* =====================================================================
   RDL_InvolutiveOrthoCore.v            (complete core -- supersedes the
                                         earlier two-section draft)
   ---------------------------------------------------------------------
   ONE SHARED ROOT for the logic layer and the operator-algebra layer.

   Tracing the URCF/RD dependency graph upstream from CPTP, four downstream
   facts -- (i) dual_invol (~~phi = phi), (ii) adj_invol (the star-law),
   (iii) orth_triple (orth^3 = orth, the no-creation / Okada cut-elimination
   pole / obstruction O=0), and (iv) resolution-completeness (sum_j P_j = 1
   => sum_j adj(K_j) K_j = 1, PGFT Eq. 34) -- are NOT independent.  They all
   realize ONE abstract pattern: the INVOLUTION  j . j ~ id.

   This module makes that single root explicit and derives all four:

     * The SHARED PATTERN  InvolutiveAt eqv j x := eqv (j (j x)) x.

     * Source 1 -- a POLARITY (Section Polarity): from any symmetric
       relation R, the double-orthogonal cl = orth . orth is a closure with
           orth_triple             : orth^3 = orth                  (root iii)
           orth_involution_on_facts: orth realizes InvolutiveAt seteq
                                      on facts  (~~X = X)            (root i)

     * Source 2 -- an INVOLUTIVE SEMIRING (Section StarMonoid): an abstract
       (zero,one,add,mul,adj) with adj . adj = id gives
           adj_is_involutive       : adj realizes Involutive (= InvolutiveAt
                                      eq) -- the SAME pattern as (i)  (root ii)
           kraus_term              : the involution collapses Kraus terms
           resolution_completeness : sum_j adj(P_j U)(P_j U) = 1      (root iv)

   So BOTH orth (on facts) and adj satisfy InvolutiveAt; the polarity that
   yields orth's involution ALSO yields orth_triple (cut-elim/obstruction),
   and the operator involution yields resolution-completeness (CPTP Eq. 34).
   Strengthening this one root strengthens cut-elimination AND CPTP at once.

   Downstream witnesses this roots:
     orth_triple              -> RetentionCenter.orth_triple, Okada MALL
                                 cut-elimination pole, PGFT obstruction O=0
     orth_involution_on_facts -> RDL_Phase.dual_invol, RDL_Involution
     adj_is_involutive        -> RDL_Phase.dual_invol AND StarRig adj_invol
     resolution_completeness  -> RDL_StarRig.kraus_completeness,
                                 RDL_StarRigCPTP_General, PGFT Eq. 34 (CPTP)

   FUNEXT-FREE (set-equality); proofs are pure apply/rewrite.

   STATUS: candidate.  Must pass `coqc 8.18.0`; each `Print Assumptions`
   must report "Closed under the global context".
   ===================================================================== *)

Require Import List.
Import ListNotations.

(* =====================================================================
   THE SHARED ROOT: the involution pattern  j . j ~ id  (w.r.t. eqv).
   ===================================================================== *)
Definition InvolutiveAt {S : Type} (eqv : S -> S -> Prop) (j : S -> S) (x : S)
  : Prop := eqv (j (j x)) x.

Definition InvolutiveUpTo {S : Type} (eqv : S -> S -> Prop) (j : S -> S)
  : Prop := forall x, InvolutiveAt eqv j x.

Definition Involutive {S : Type} (j : S -> S) : Prop :=
  InvolutiveUpTo (@eq S) j.

(* =====================================================================
   SOURCE 1: a polarity yields the closure (orth^3 = orth) AND the
   involution-on-facts (~~X = X) -- roots (iii) and (i).
   ===================================================================== *)
Section Polarity.

  Variable A : Type.
  Variable R : A -> A -> Prop.
  Hypothesis Rsym : forall x y, R x y -> R y x.

  Definition Subset := A -> Prop.
  Definition sub   (X Y : Subset) : Prop := forall a, X a -> Y a.
  Definition seteq (X Y : Subset) : Prop := sub X Y /\ sub Y X.
  Definition orth  (X : Subset) : Subset := fun y => forall x, X x -> R x y.
  Definition cl    (X : Subset) : Subset := orth (orth X).
  Definition closed (X : Subset) : Prop := sub (cl X) X.

  Lemma orth_antitone : forall X Y, sub X Y -> sub (orth Y) (orth X).
  Proof. intros X Y H y Hy x Hx. apply Hy. apply H. exact Hx. Qed.

  Lemma orth_expand : forall X, sub X (orth (orth X)).
  Proof. intros X x Hx y Hy. apply Rsym. apply Hy. exact Hx. Qed.

  (* ROOT (iii): orth^3 = orth *)
  Theorem orth_triple : forall X, seteq (orth (orth (orth X))) (orth X).
  Proof.
    intro X. split.
    - apply orth_antitone. apply orth_expand.
    - apply orth_expand.
  Qed.

  Lemma cl_extensive : forall X, sub X (cl X).
  Proof. intro X. unfold cl. apply orth_expand. Qed.

  Lemma cl_idem : forall X, seteq (cl (cl X)) (cl X).
  Proof. intro X. unfold cl. apply (orth_triple (orth X)). Qed.

  (* ROOT (i): on facts, orth realizes the shared involution pattern.
     InvolutiveAt seteq orth X  is exactly  seteq (orth (orth X)) X. *)
  Theorem orth_involution_on_facts :
    forall X, closed X -> InvolutiveAt seteq orth X.
  Proof.
    intros X H. unfold InvolutiveAt, seteq. split.
    - exact H.
    - apply cl_extensive.
  Qed.

End Polarity.

(* =====================================================================
   SOURCE 2: an involutive semiring yields the operator involution
   (the SAME pattern, Leibniz) and resolution-completeness -- roots
   (ii) and (iv).
   ===================================================================== *)
Section StarMonoid.

  Variable T : Type.
  Variable zero one : T.
  Variable add mul : T -> T -> T.
  Variable adj : T -> T.

  Hypothesis adj_invol : forall x, adj (adj x) = x.
  Hypothesis adj_anti  : forall a b, adj (mul a b) = mul (adj b) (adj a).
  Hypothesis mul_assoc : forall a b c, mul (mul a b) c = mul a (mul b c).
  Hypothesis mul_one_r : forall a, mul a one = a.
  Hypothesis mul_0_l   : forall a, mul zero a = zero.
  Hypothesis mul_0_r   : forall a, mul a zero = zero.
  Hypothesis mul_add_l : forall a b c, mul a (add b c) = add (mul a b) (mul a c).
  Hypothesis mul_add_r : forall a b c, mul (add a b) c = add (mul a c) (mul b c).

  (* ROOT (ii): adj realizes the shared involution pattern (Leibniz).
     This is the SAME predicate that orth realizes on facts above. *)
  Remark adj_is_involutive : Involutive adj.
  Proof. unfold Involutive, InvolutiveUpTo, InvolutiveAt. exact adj_invol. Qed.

  (* the involution + antimultiplicativity collapse the Kraus terms *)
  Lemma kraus_term :
    forall P U, mul (adj P) P = P ->
      mul (adj (mul P U)) (mul P U) = mul (mul (adj U) P) U.
  Proof.
    intros P U HP.
    rewrite adj_anti.
    rewrite mul_assoc.
    rewrite <- (mul_assoc (adj P) P U).
    rewrite HP.
    rewrite <- (mul_assoc (adj U) P U).
    reflexivity.
  Qed.

  (* the completeness sum over a finite (list) family, and the sum of
     projectors resolving the identity *)
  Fixpoint comp (ks : list T) : T :=
    match ks with
    | [] => zero
    | k :: ks' => add (mul (adj k) k) (comp ks')
    end.

  Fixpoint Psum (ps : list T) : T :=
    match ps with
    | [] => zero
    | P :: ps' => add P (Psum ps')
    end.

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

  (* ROOT (iv): resolution of identity by self-adjoint idempotents plus an
     isometry gives Kraus completeness  sum_j adj(K_j) K_j = 1. *)
  Theorem resolution_completeness :
    forall ps U,
      Forall (fun P => mul (adj P) P = P) ps ->   (* self-adjoint idempotents *)
      Psum ps = one ->                            (* resolving the identity   *)
      mul (adj U) U = one ->                       (* U an isometry            *)
      comp (map (fun P => mul P U) ps) = one.
  Proof.
    intros ps U Hps HP HU.
    rewrite (comp_map_PU ps U Hps).
    rewrite HP, mul_one_r, HU.
    reflexivity.
  Qed.

End StarMonoid.

(* =====================================================================
   AXIOM AUDIT.  All four roots, from one structure.
   ===================================================================== *)
Print Assumptions orth_triple.                 (* root iii *)
Print Assumptions orth_involution_on_facts.    (* root i   *)
Print Assumptions adj_is_involutive.           (* root ii  *)
Print Assumptions resolution_completeness.     (* root iv  *)

(* End RDL_InvolutiveOrthoCore.v *)
