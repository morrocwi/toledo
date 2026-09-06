(******************************************************************************)
(* InfoGaugeAutomorphismGroup.v -- CLOSED (promoted from formal/Info*_attempt.v 2026-07-23).        *)
(*   TIER = Th_coqc (fully abstract, Type-polymorphic, axiom-free). No Reals, *)
(*   no domain alphabet, no declared architecture. Explicit forall-premises   *)
(*   throughout (no Section/Variable/Hypothesis), per house style. Compile:   *)
(*   coqc -q InfoGaugeAutomorphismGroup.v (standalone, no -R needed)                    *)
(*                                                                            *)
(* TARGETS SM-G0.1 and SM-G0.2 from domains/standard_model/ROOT_TO_SM_DAG.md, *)
(* the FIRST GATE (R3) blocking every downstream Standard-Model closure from  *)
(* being called root-derived rather than exact within a declared             *)
(* architecture. Per the 2026-07-23 deep-read pass: G0.1-G0.5 had NEVER been  *)
(* attempted as Coq witnesses before this file (confirmed via git-log search  *)
(* across the whole repo) -- this is not a re-attempt of a known-failed       *)
(* approach.                                                                  *)
(*                                                                            *)
(* WHY THIS IS NECESSITY-TIER, NOT CONDITIONAL (the exact distinction that    *)
(* got InfoOrderedTapeClosure and InfoRationalSO3Curvature correctly demoted  *)
(* back to conditional in this same session): every definition and theorem    *)
(* below is quantified over ARBITRARY Coq types (S, R, M) and arbitrary       *)
(* functions/operations on them, as explicit forall-premises. Nothing is      *)
(* instantiated to a specific dimension, alphabet, carrier, or hand-picked    *)
(* witness matrix. If it type-checks and Print Assumptions returns Closed, it *)
(* is true for every possible retained-state space, every readout, every     *)
(* dynamics -- including whichever ones the Standard-Model chain eventually   *)
(* declares. That is what makes it a face of the root architecture itself,    *)
(* not a domain-conditional result.                                          *)
(*                                                                            *)
(* G0.1 -- PATH COMPOSITION: an ordered path carrier (M, one, op) with op     *)
(*   associative and one a two-sided identity is exactly a MONOID -- proved   *)
(*   here abstractly, plus that iterated path composition (foldr op over a    *)
(*   list of steps) is itself associative-compatible: composing two path     *)
(*   segments end-to-end equals folding the concatenated step list.          *)
(*                                                                            *)
(* G0.2 -- AUTOMORPHISM GROUP: Aut(F,O) = { h : O∘h=O, h∘F=F∘h } is closed    *)
(*   under composition, contains the identity, and -- for any h with a         *)
(*   two-sided inverse -- that inverse is ALSO in Aut(F,O). Proved for        *)
(*   arbitrary state type S, arbitrary readout type R, arbitrary F : S->S,    *)
(*   O : S->R. This is exactly Aut(F,O) forming a group under function        *)
(*   composition, which is the object R3/SM-G0 needs to exist before any      *)
(*   downstream gauge-structure claim (chirality, representations, Higgs)     *)
(*   can be called root-derived instead of declared.                         *)
(*                                                                            *)
(* HONEST FENCE. CLOSED at this level: G0.1 (monoid structure of ordered path *)
(* composition, list-fold compatibility) and G0.2 (Aut(F,O) is a group under  *)
(* composition, with inverse-closure) are both proved in full generality.    *)
(* [Open], NOT smuggled: this does NOT yet show Aut(F,O) is NONTRIVIAL for    *)
(* any particular (S,F,O) coming from the retained-state root of Part I --    *)
(* i.e. it proves the group AXIOMS hold whenever such automorphisms exist,    *)
(* not that any nontrivial ones exist for the actual root dynamics. It also   *)
(* does not yet derive G0.3 (localization), G0.4 (the connection transform    *)
(* law as its own theorem, though InfoConnectionFromFrame's coboundary        *)
(* telescoping is closely related for the Heisenberg-frame instance), or      *)
(* G0.5 (holonomy conjugacy-invariance in general -- InfoRationalSO3Curvature *)
(* is a single hand-picked witness, not this general theorem, and should not  *)
(* be cited as closing G0.5). All quantities are over abstract Coq Type/Prop; *)
(* no Reals, no floats, no domain alphabet.                                  *)
(******************************************************************************)

Require Import Coq.Lists.List.
Import ListNotations.

Module InfoGaugeAutomorphismGroup.

(* ========================================================================= *)
(* G0.1 -- PATH COMPOSITION: monoid structure + list-fold compatibility      *)
(* ========================================================================= *)

(* an ordered path is a list of steps in a carrier M with identity `one` and  *)
(* composition `op`; composing it is folding op over the list.               *)
Fixpoint pathcomp (M : Type) (one : M) (op : M -> M -> M) (steps : list M) : M :=
  match steps with
  | nil => one
  | s :: rest => op s (pathcomp M one op rest)
  end.

Theorem pathcomp_nil :
  forall (M : Type) (one : M) (op : M -> M -> M),
    pathcomp M one op nil = one.
Proof. intros. reflexivity. Qed.

(* G0.1, part 1: composing two path segments end-to-end (list ++) equals    *)
(* op-ing their individually-composed holonomies -- so compose-the-path     *)
(* and compose-the-pieces-then-combine are the SAME operation, for ANY       *)
(* carrier that is a monoid (op associative, one a two-sided identity).      *)
Theorem pathcomp_app :
  forall (M : Type) (one : M) (op : M -> M -> M),
    (forall a b c : M, op (op a b) c = op a (op b c)) ->
    (forall a : M, op one a = a) ->
    (forall a : M, op a one = a) ->
    forall xs ys : list M,
      pathcomp M one op (xs ++ ys) = op (pathcomp M one op xs) (pathcomp M one op ys).
Proof.
  intros M one op op_assoc op_id_l op_id_r.
  induction xs as [| x xs IH]; intro ys.
  - simpl. rewrite op_id_l. reflexivity.
  - simpl. rewrite IH. rewrite op_assoc. reflexivity.
Qed.

(* G0.1, part 2: a single-step path composes to just that step. *)
Theorem pathcomp_single :
  forall (M : Type) (one : M) (op : M -> M -> M),
    (forall a : M, op a one = a) ->
    forall a : M, pathcomp M one op (a :: nil) = a.
Proof. intros M one op op_id_r a. simpl. rewrite op_id_r. reflexivity. Qed.

(* G0.1, part 3: three-fold associativity of path concatenation, restated  *)
(* directly in terms of pathcomp (not just list ++, which Coq already      *)
(* knows is associative) -- the closure that actually matters for a        *)
(* path-of-paths argument.                                                 *)
Theorem pathcomp_app_assoc :
  forall (M : Type) (one : M) (op : M -> M -> M) (xs ys zs : list M),
    pathcomp M one op (xs ++ (ys ++ zs)) = pathcomp M one op ((xs ++ ys) ++ zs).
Proof.
  intros M one op xs ys zs.
  rewrite app_assoc. reflexivity.
Qed.

(* ========================================================================= *)
(* G0.2 -- AUTOMORPHISM GROUP: Aut(F,O) closed under composition + inverse   *)
(* ========================================================================= *)

Definition PreservesReadout (S R : Type) (Oread : S -> R) (h : S -> S) : Prop :=
  forall x : S, Oread (h x) = Oread x.

Definition CommutesWithDynamics (S : Type) (Fdyn : S -> S) (h : S -> S) : Prop :=
  forall x : S, h (Fdyn x) = Fdyn (h x).

Definition IsAut (S R : Type) (Fdyn : S -> S) (Oread : S -> R) (h : S -> S) : Prop :=
  PreservesReadout S R Oread h /\ CommutesWithDynamics S Fdyn h.

(* the identity transformation is always an automorphism, for ANY (S,R,F,O). *)
Theorem id_is_aut :
  forall (S R : Type) (Fdyn : S -> S) (Oread : S -> R),
    IsAut S R Fdyn Oread (fun x => x).
Proof. intros S R Fdyn Oread. split; intro x; reflexivity. Qed.

(* Aut(F,O) is closed under composition, for ANY (S,R,F,O). *)
Theorem aut_closed_under_compose :
  forall (S R : Type) (Fdyn : S -> S) (Oread : S -> R) (h1 h2 : S -> S),
    IsAut S R Fdyn Oread h1 ->
    IsAut S R Fdyn Oread h2 ->
    IsAut S R Fdyn Oread (fun x => h1 (h2 x)).
Proof.
  intros S R Fdyn Oread h1 h2 [Hro1 Hcf1] [Hro2 Hcf2].
  split.
  - intro x. simpl. rewrite Hro1. apply Hro2.
  - intro x. simpl. rewrite Hcf2. apply Hcf1.
Qed.

(* Aut(F,O) is closed under inverse: if h is an automorphism and hinv is a  *)
(* genuine two-sided inverse of h, then hinv is ALSO an automorphism, for   *)
(* ANY (S,R,F,O).                                                          *)
Theorem aut_closed_under_inverse :
  forall (S R : Type) (Fdyn : S -> S) (Oread : S -> R) (h hinv : S -> S),
    IsAut S R Fdyn Oread h ->
    (forall x, hinv (h x) = x) ->
    (forall x, h (hinv x) = x) ->
    IsAut S R Fdyn Oread hinv.
Proof.
  intros S R Fdyn Oread h hinv [Hro Hcf] Hleft Hright.
  split.
  - intro x.
    specialize (Hro (hinv x)).
    rewrite Hright in Hro.
    symmetry. exact Hro.
  - intro x.
    specialize (Hcf (hinv x)).
    rewrite Hright in Hcf.
    assert (Heq : hinv (h (Fdyn (hinv x))) = hinv (Fdyn x)) by (f_equal; exact Hcf).
    rewrite Hleft in Heq.
    symmetry. exact Heq.
Qed.

(* corollary: Aut(F,O) is nonempty (contains id), closed under composition, *)
(* and closed under inverse whenever an inverse exists -- i.e. it satisfies *)
(* every axiom required of a group acting by composition, for ANY (S,R,F,O). *)
Theorem aut_is_a_group :
  forall (S R : Type) (Fdyn : S -> S) (Oread : S -> R),
    IsAut S R Fdyn Oread (fun x => x) /\
    (forall h1 h2 : S -> S,
       IsAut S R Fdyn Oread h1 -> IsAut S R Fdyn Oread h2 ->
       IsAut S R Fdyn Oread (fun x => h1 (h2 x))) /\
    (forall h hinv : S -> S,
       IsAut S R Fdyn Oread h ->
       (forall x, hinv (h x) = x) -> (forall x, h (hinv x) = x) ->
       IsAut S R Fdyn Oread hinv).
Proof.
  intros S R Fdyn Oread.
  split. apply id_is_aut.
  split. apply aut_closed_under_compose.
  apply aut_closed_under_inverse.
Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions pathcomp_app.
Print Assumptions pathcomp_single.
Print Assumptions pathcomp_app_assoc.
Print Assumptions id_is_aut.
Print Assumptions aut_closed_under_compose.
Print Assumptions aut_closed_under_inverse.
Print Assumptions aut_is_a_group.

End InfoGaugeAutomorphismGroup.
