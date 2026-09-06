(* weld/M.03.v1 — CAN-007 — Definition — parents: weld — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-007 — reader-equivalence

    (* CAN-007 — root: z~z' iff O(F^k z)=O(F^k z') for all k<=L — domain: root — tier: Definition — occurrences: 2 *)

    No-early-collapse: two states are declared equivalent only relative to
    a declared question/reader/context and a declared finite horizon [L] —
    never an unbounded/continuum "eventually" claim.  [Nat.iter] is the
    discrete, terminating stand-in for "apply F, k times". *)

Section ReaderEquivalence.

  Variables StateT Val : Type.
  Variable F : StateT -> StateT.
  Variable O : StateT -> Val.

  Definition CAN_007_reader_equiv (z z' : StateT) (L : nat) : Prop :=
    forall k : nat, (k <= L)%nat -> O (Nat.iter k F z) = O (Nat.iter k F z').

  (* Witness (tier: Th_coqc): for every fixed horizon [L], [CAN_007_reader_equiv]
     with that [L] is a genuine equivalence relation on states — reflexive,
     symmetric, transitive — so "no-early-collapse" partitions states into
     honest equivalence classes rather than an ad-hoc relation. *)
  Theorem CAN_007_reader_equiv_is_equivalence :
    forall L : nat,
      (forall z, CAN_007_reader_equiv z z L)
      /\ (forall z z', CAN_007_reader_equiv z z' L -> CAN_007_reader_equiv z' z L)
      /\ (forall z z' z'', CAN_007_reader_equiv z z' L -> CAN_007_reader_equiv z' z'' L
                            -> CAN_007_reader_equiv z z'' L).
  Proof.
    intro L. split; [| split].
    - intros z k _. reflexivity.
    - intros z z' H k Hk. symmetry. apply H, Hk.
    - intros z z' z'' H1 H2 k Hk. rewrite (H1 k Hk). apply H2, Hk.
  Qed.

End ReaderEquivalence.

