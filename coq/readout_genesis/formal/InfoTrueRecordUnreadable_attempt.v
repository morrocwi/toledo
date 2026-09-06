(* ===================================================================== *)
(*  InfoTrueRecordUnreadable_attempt.v                                    *)
(*  THE TRUE STATE IS REAL BUT UNREADABLE FROM A LOSSY RECORD -- an       *)
(*  axiom-free, Type-polymorphic formalization of: there IS a true        *)
(*  record but we cannot read it.  Grounds, precisely, the informal       *)
(*  Face 10 claim in domains/standard_model/source_root/                  *)
(*  READOUT_GENESIS_CORE_SNAPSHOT.md -- every observer's record is        *)
(*  lossy, M_A[n] <> theta(E) for all n -- and                            *)
(*  SM_INFORMATION_PHILOSOPHY_MASTER.md section 1.2's own reader-record   *)
(*  relation r=O(X), X~X' iff O(X)=O(X'), physical state = [X] -- by      *)
(*  proving the exact, general mathematical content behind both:         *)
(*  whenever a readout O identifies two DISTINCT states, NO decoder can   *)
(*  recover both correctly from the shared readout value.                 *)
(*                                                                         *)
(*  CLAIMED HERE (candidate for coqc 8.18.0, axiom-free target):          *)
(*    no_decoder_recovers_state                                            *)
(*        if O collapses x1<>x2 to the same readout value, no decoder D   *)
(*        can simultaneously satisfy D(O x1)=x1 and D(O x2)=x2.           *)
(*    gauge_redundancy_forces_undecodability                              *)
(*        specialized to section 1.2's own O(hX)=O(X) gauge-redundancy    *)
(*        framing: any nontrivial gauge action (h x <> x for some x,      *)
(*        with O(h x)=O(x)) forces the same undecodability.               *)
(*    true_state_exists_but_no_total_decoder                              *)
(*        the positive half, stated carefully: the true pre-readout       *)
(*        state x always EXISTS (it is simply given, x : X) -- what      *)
(*        fails to exist, whenever O is non-injective anywhere, is a      *)
(*        single decoder D : R -> X correct on every state.  Existing    *)
(*        but unreadable is not a paradox: it is exactly this gap        *)
(*        between a value existing and a total correct decoder existing. *)
(*                                                                         *)
(*  HONESTLY NOT CLAIMED: that any SPECIFIC readout in this book's        *)
(*  physics content (the Reader/Record telegraph apparatus, Phi, Psi,     *)
(*  or any other concrete O) is non-injective in this exact sense --      *)
(*  that must be shown separately, case by case, for each concrete O.     *)
(*  This file proves only the general conditional: IF a readout is        *)
(*  non-injective (as section 1.2 says the physical-readout O generally   *)
(*  is, whenever gauge redundancy is nontrivial), THEN undecodability      *)
(*  follows necessarily -- a structural theorem about readouts in         *)
(*  general, not a new physics claim about any one of them. Nothing here  *)
(*  claims Psi specifically IS the true record -- matter/antimatter     *)
(*  exploration Attempt 2 already found that identification does not      *)
(*  hold structurally for the telegraph apparatus's own Phi/Psi pair.     *)
(*  This file is deliberately more general and more modest: it grounds    *)
(*  the abstract true-but-unreadable shape of the claim, not any        *)
(*  specific occupant of the true record role.                         *)
(*                                                                         *)
(*  Pre-verified by hand before authoring: both proofs are direct         *)
(*  equality-substitution arguments (Hneq applied to a chain of           *)
(*  rewrites), no case analysis, no classical axioms, no decidability     *)
(*  assumption needed anywhere.                                           *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Module TrueRecordUnreadable.

(* The true state x1 (or x2) is simply GIVEN -- it exists as an ordinary
   value of type X, nothing exotic. What this lemma shows is that when the
   readout O maps two distinct such values to the same record, no single
   function D can be trusted to recover the true state FROM the record
   alone in both cases at once -- unreadable is a fact about the decoder,
   not a denial that x1, x2 exist. *)
Lemma no_decoder_recovers_state :
  forall (X R : Type) (O : X -> R) (x1 x2 : X),
  x1 <> x2 ->
  O x1 = O x2 ->
  forall (D : R -> X), D (O x1) = x1 -> D (O x2) = x2 -> False.
Proof.
  intros X R O x1 x2 Hneq Heq D H1 H2.
  apply Hneq.
  rewrite <- H1, <- H2, Heq.
  reflexivity.
Qed.

(* Specialized to SM_INFORMATION_PHILOSOPHY_MASTER.md section 1.2's own
   gauge-redundancy framing: O(h X) = O(X) for the internal-renaming map h.
   Any nontrivial such h (moving some x to a genuinely different h x) makes
   the pre-gauge state x undecodable from the readout alone -- this IS the
   book's own stated root of gauge redundancy, now given its exact
   undecodability consequence. *)
Lemma gauge_redundancy_forces_undecodability :
  forall (X R : Type) (O : X -> R) (h : X -> X) (x : X),
  h x <> x ->
  O (h x) = O x ->
  forall (D : R -> X), D (O (h x)) = h x -> D (O x) = x -> False.
Proof.
  intros X R O h x Hneq Heq D H1 H2.
  apply (no_decoder_recovers_state X R O (h x) x Hneq Heq D H1 H2).
Qed.

(* The positive half, stated carefully so true but unreadable is not
   read as a contradiction: the true state x is an ordinary, existing
   value (trivial: it is simply handed in). What no_decoder_recovers_state
   rules out is only a single TOTAL decoder correct everywhere O is
   non-injective -- existence of x and existence of a universal correct
   decoder are two different claims, and only the second one fails. *)
Lemma true_state_exists_but_no_total_decoder :
  forall (X R : Type) (O : X -> R) (x1 x2 : X),
  x1 <> x2 ->
  O x1 = O x2 ->
  (exists x : X, x = x1) /\
  (exists x : X, x = x2) /\
  ~ (exists D : R -> X, D (O x1) = x1 /\ D (O x2) = x2).
Proof.
  intros X R O x1 x2 Hneq Heq.
  split; [exists x1; reflexivity |].
  split; [exists x2; reflexivity |].
  intros [D [H1 H2]].
  apply (no_decoder_recovers_state X R O x1 x2 Hneq Heq D H1 H2).
Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions no_decoder_recovers_state.
Print Assumptions gauge_redundancy_forces_undecodability.
Print Assumptions true_state_exists_but_no_total_decoder.

End TrueRecordUnreadable.
