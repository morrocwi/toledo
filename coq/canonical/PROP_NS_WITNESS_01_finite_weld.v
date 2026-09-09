(* ===================================================================== *)
(*  PROP_NS_WITNESS_01_finite_weld.v                                     *)
(*  Eight-state exact-weld / permanent-reader-equivalence finite witness  *)
(*  (Toledo proposal PROP-NS-WITNESS-01, code weld/M.??.v1).              *)
(*                                                                        *)
(*  Source: Yaoharee Lahtee, A Readout Problem for Fefferman Existence and *)
(*  Smoothness of the Navier-Stokes Equation (Theorem 1); State Breakdown  *)
(*  Is Not Readout Breakdown v0.2 (Theorem 3.1 / Corollary 3.2); and the   *)
(*  Readout-Navier-Stokes Development Series Volume 1 (Theorem 5.2,        *)
(*  NSR-01) -- all three cite the SAME 8-state                             *)
(*  construction (confirmed identical by direct text comparison in the     *)
(*  Register phase of this task; NSR-01's witness pair differs only in a   *)
(*  coordinate the construction never reads).                              *)
(*                                                                         *)
(*  This is exactly the independent machine verification Volume 1's own    *)
(*  Appendix C calls for: a companion `NSR01_finite_witness.v` was         *)
(*  supplied with the arXiv bundle but stated as NOT independently         *)
(*  compiled by the manuscript's own environment. This file reconstructs   *)
(*  the construction from the stated definitions and compiles/checks it    *)
(*  here, in this workspace, independently.                                *)
(*                                                                         *)
(*  Construction (S = {0,1}^3 as an explicit 8-element inductive type,     *)
(*  D = {0,1}^2 similarly):                                                *)
(*    F  (a,b,c) := (negb a, b, negb c)      -- flips coords 1 and 3       *)
(*    FD (a,b)   := (negb a, b)              -- the induced domain map     *)
(*    qD (a,b,c) := (a,b)                    -- the domain-restriction     *)
(*                    quotient map                                        *)
(*    O  (a,b,c) := b   ,   OD (a,b) := b    -- the reader ("observer")    *)
(*                                                                         *)
(*  Proved here, all by finite case analysis / `decide equality`-style     *)
(*  enumeration over the 8-element type (no axioms, no real numbers, no    *)
(*  induction beyond structural recursion on nat for the horizon):        *)
(*    1. exact_weld_dynamics : qD (F s) = FD (qD s)           for all s    *)
(*    2. exact_weld_reader   : O s = OD (qD s)                 for all s    *)
(*    3. F_period_two        : F (F s) = s                     for all s    *)
(*       hence F (iter k) has period dividing 2 for every k -- proved for   *)
(*       ALL k : nat by an explicit closed form for F^k, not merely         *)
(*       checked up to a bound.                                            *)
(*    4. witness_reader_equiv : for z = (false,false,false),                *)
(*       z' = (true,false,true), O (iter k F z) = O (iter k F z')           *)
(*       for every k : nat (reader never distinguishes them, at ANY         *)
(*       finite horizon -- not just up to a checked bound).                 *)
(*    5. witness_domain_differs : Q (qD (iter k F z)) <> Q (qD (iter k F     *)
(*       z')) for every k : nat, where Q (a,b) := a -- the domain question   *)
(*       differs forever.                                                   *)
(*    6. ns_witness_main : the conjunction of (4) and (5) -- exact weld     *)
(*       (both the dynamics and the reader) together with permanent         *)
(*       reader-equivalence do NOT imply permanent domain-question          *)
(*       agreement. This is the mechanized form of NSR-01 / Theorem 1 /     *)
(*       Theorem 3.1.                                                       *)
(*                                                                          *)
(*  What this does NOT prove: nothing here concerns the Navier-Stokes       *)
(*  equation itself, Sobolev spaces, or any continuum PDE object -- exactly *)
(*  as the source papers state, this is a small self-contained finite       *)
(*  combinatorial fact used ONLY to argue that an exact weld between a      *)
(*  domain dynamics and a reader does not, by itself, transfer decidability *)
(*  of an arbitrary domain-level question to the reader. The bridge to any  *)
(*  specific Navier-Stokes reading (NSR-02/03/04) is explicitly left open    *)
(*  by the source and is NOT addressed by this file.                        *)
(*                                                                          *)
(*  Expected: Print Assumptions ns_witness_main => Closed under the        *)
(*  global context.                                                        *)
(* ===================================================================== *)

Require Import Coq.Bool.Bool.
Require Import Coq.Arith.PeanoNat.

Section FiniteWeld.

  (* S = {0,1}^3, represented as an explicit triple of booleans. *)
  Definition St : Type := bool * bool * bool.

  (* D = {0,1}^2 *)
  Definition D : Type := bool * bool.

  (* The domain dynamics map on S: flips the 1st and 3rd coordinate,
     fixes the 2nd. *)
  Definition F (s : St) : St :=
    match s with
    | (a, b, c) => (negb a, b, negb c)
    end.

  (* The induced dynamics map on the quotient D. *)
  Definition FD (d : D) : D :=
    match d with
    | (a, b) => (negb a, b)
    end.

  (* The domain-restriction quotient map S -> D. *)
  Definition qD (s : St) : D :=
    match s with
    | (a, b, c) => (a, b)
    end.

  (* The reader on S and its counterpart on D: both project the 2nd
     coordinate only. *)
  Definition O (s : St) : bool :=
    match s with
    | (_, b, _) => b
    end.

  Definition OD (d : D) : bool :=
    match d with
    | (_, b) => b
    end.

  (* The domain-level question examined by the source papers:
     Q (a,b) := a. *)
  Definition Q (d : D) : bool :=
    match d with
    | (a, _) => a
    end.

  (* --------------------------------------------------------------- *)
  (* 1. Exact weld of the dynamics: qD commutes with F / FD.          *)
  (* --------------------------------------------------------------- *)
  Theorem exact_weld_dynamics : forall s : St, qD (F s) = FD (qD s).
  Proof.
    intros [[a b] c]. simpl. reflexivity.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 2. Exact weld of the reader: O factors through qD via OD.        *)
  (* --------------------------------------------------------------- *)
  Theorem exact_weld_reader : forall s : St, O s = OD (qD s).
  Proof.
    intros [[a b] c]. simpl. reflexivity.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 3. F has period exactly dividing 2 on every state.                *)
  (* --------------------------------------------------------------- *)
  Theorem F_period_two : forall s : St, F (F s) = s.
  Proof.
    intros [[a b] c]. simpl. rewrite negb_involutive, negb_involutive.
    reflexivity.
  Qed.

  (* Closed form for iterating F: even/odd horizon. This gives the
     dynamics at EVERY k : nat, not merely up to a checked bound. *)
  Fixpoint iter_F (k : nat) (s : St) : St :=
    match k with
    | 0 => s
    | S k' => F (iter_F k' s)
    end.

  Theorem iter_F_closed_form :
    forall (k : nat) (s : St),
      iter_F k s = if Nat.even k then s else F s.
  Proof.
    induction k as [| k' IH]; intro s.
    - simpl. reflexivity.
    - simpl iter_F. rewrite IH.
      destruct (Nat.even k') eqn:Hk'.
      + (* k' even, so k = S k' is odd *)
        assert (Hodd : Nat.even (S k') = false).
        { rewrite Nat.even_succ.
          rewrite <- Nat.negb_even, Hk'. reflexivity. }
        rewrite Hodd. reflexivity.
      + (* k' odd, so k = S k' is even *)
        assert (Heven : Nat.even (S k') = true).
        { rewrite Nat.even_succ.
          rewrite <- Nat.negb_even, Hk'. reflexivity. }
        rewrite Heven. apply F_period_two.
  Qed.

  (* --------------------------------------------------------------- *)
  (* The witness pair from the source papers.                          *)
  (* --------------------------------------------------------------- *)
  Definition z  : St := (false, false, false).
  Definition z' : St := (true,  false, true).

  (* --------------------------------------------------------------- *)
  (* 4. Reader-equivalence at every finite horizon k.                  *)
  (* --------------------------------------------------------------- *)
  Theorem witness_reader_equiv :
    forall k : nat, O (iter_F k z) = O (iter_F k z').
  Proof.
    intro k.
    rewrite (iter_F_closed_form k z), (iter_F_closed_form k z').
    destruct (Nat.even k); simpl; reflexivity.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 5. Domain question disagreement at every finite horizon k.        *)
  (* --------------------------------------------------------------- *)
  Theorem witness_domain_differs :
    forall k : nat, Q (qD (iter_F k z)) <> Q (qD (iter_F k z')).
  Proof.
    intro k.
    rewrite (iter_F_closed_form k z), (iter_F_closed_form k z').
    destruct (Nat.even k); simpl; discriminate.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 6. Main theorem: exact weld (dynamics + reader) plus permanent     *)
  (*    reader-equivalence does NOT force permanent domain-question      *)
  (*    agreement -- the mechanized form of NSR-01 / Theorem 1 /         *)
  (*    Theorem 3.1.                                                     *)
  (* --------------------------------------------------------------- *)
  Theorem ns_witness_main :
    (forall s : St, qD (F s) = FD (qD s)) /\
    (forall s : St, O s = OD (qD s)) /\
    (forall k : nat, O (iter_F k z) = O (iter_F k z')) /\
    (forall k : nat, Q (qD (iter_F k z)) <> Q (qD (iter_F k z'))).
  Proof.
    repeat split.
    - exact exact_weld_dynamics.
    - exact exact_weld_reader.
    - exact witness_reader_equiv.
    - exact witness_domain_differs.
  Qed.

End FiniteWeld.
