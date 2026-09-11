(* ===================================================================== *)
(*  PROP_NS_TAPE_CLOSED_DOMAIN_01.v                                      *)
(*  Retained cut-current tape / exact tape-closed finite-mode domain      *)
(*  gate (Toledo proposal PROP-NS-TAPE-CLOSED-DOMAIN-01, code             *)
(*  weld/M.??.v1).                                                        *)
(*                                                                        *)
(*  Source: Yaoharee Lahtee, "Readout-Navier-Stokes Development Series",  *)
(*  Volume 6 "Readout-Navier-Stokes Discrete Crossing Theorem" (v0.6,     *)
(*  September 2026), Definition 3.1, Theorem 3.2, Theorem 4.1, Theorem    *)
(*  5.1.                                                                  *)
(*                                                                        *)
(*  The source's own honest_caveats already state this is EXACT FINITE   *)
(*  LINEAR ALGEBRA -- a variation-of-constants recurrence over a fixed    *)
(*  grid, plus direct substitution to verify two weld identities -- and   *)
(*  that Remark 3.3 declares the tape chi_{M,n} a SEPARATELY DECLARED     *)
(*  INPUT, not derived by any integral of the source terms (tape-closed,  *)
(*  not autonomous). Consequently NONE of the three theorems              *)
(*  mechanized here needs Coq.Reals, Coquelicot, or any continuum/        *)
(*  analytic construction of A_{M,n} := e^{-h_n L_M} or of the integral   *)
(*  defining chi_{M,n}: A_n is treated as an ARBITRARY given function     *)
(*  V -> V at each step (its linearity is never used by any of the three  *)
(*  theorems below -- only "a function applied consistently" is needed),  *)
(*  and chi_n as an ARBITRARY given element of V at each step. The vector  *)
(*  space V itself is left fully abstract with only the one operation     *)
(*  the recurrence actually uses: an addition vadd : V -> V -> V.         *)
(*                                                                        *)
(*  Rational-native (no Coq.Reals), matching this repo's existing         *)
(*  precedent (PROP_CONF_03_union_bound.v): merely `Require`-ing          *)
(*  Coq.Reals.Reals and stating `0%R = 0%R` already pulls in the axiom    *)
(*  ClassicalDedekindReals.sig_forall_dec in this Coq version (confirmed  *)
(*  by direct test in this task) -- Theorem 4.1's defect terms are        *)
(*  therefore stated over Q (Coq.QArith.QArith), which needs no axioms,   *)
(*  rather than over R, since nothing about the theorem's content         *)
(*  actually requires the reals.                                         *)
(*                                                                        *)
(*  Content mechanized:                                                  *)
(*    1. tape_closed_recurrence (Theorem 3.2): the sequence I defined by  *)
(*       the primitive recursion I_0 given, I_{n+1} := A_n(I_n) + chi_n   *)
(*       satisfies that recurrence for every n -- immediate from the      *)
(*       Fixpoint definition (Print Assumptions: axiom-free).             *)
(*    2. exact_domain_gate (Theorem 4.1): given an abstract state space   *)
(*       S, a root stepper F_NS : nat -> S -> S, a domain-reading map     *)
(*       q : nat -> S -> V, a reader O : nat -> S -> Y and its domain     *)
(*       counterpart O#, and an invariant Inv : nat -> S -> Z and its     *)
(*       domain counterpart Inv# (per Readout-Genesis Gate 5,             *)
(*       READOUT_GENESIS_CORE.md section on the seven gates: Inv_alpha =  *)
(*       Inv#_alpha o q_alpha is the general third weld condition beyond  *)
(*       the dynamics weld and the reader weld of canonical weld/M.02.v1  *)
(*       -- the source's inline statement names the epsilon_inv           *)
(*       component of the standard defect vector but does not spell out   *)
(*       a third symbolic equation distinct from the shared Genesis       *)
(*       schema, so it is formalized here exactly as that schema's own    *)
(*       general Gate-5 invariant-weld condition, structurally identical  *)
(*       in shape to the reader weld already given explicitly), THEN the  *)
(*       three exact-arithmetic defect terms epsilon_dyn, epsilon_read,   *)
(*       epsilon_inv (each defined as a rational-valued distance between  *)
(*       the two sides of its identity, using an abstract distance        *)
(*       for each target type satisfying only reflexivity-gives-zero)     *)
(*       are all exactly 0 given the three weld hypotheses -- pure        *)
(*       substitution (Print Assumptions: axiom-free).                    *)
(*    3. future_readout_sufficiency (Theorem 5.1): if two trajectories    *)
(*       built from the SAME step family A but possibly DIFFERENT tapes   *)
(*       agree in state at step n, and their tapes agree on every entry   *)
(*       in [n, n+L), then the trajectories agree in state at every step  *)
(*       n+r for 0 <= r <= L -- proved by induction on r using exactly    *)
(*       the recurrence of (1) (Print Assumptions: axiom-free).           *)
(*                                                                        *)
(*  What this does NOT prove: nothing here concerns the Navier-Stokes     *)
(*  equation, Sobolev spaces, the semigroup e^{-hL_M}, or the integral     *)
(*  defining chi_{M,n} from the source/noise terms -- exactly as the      *)
(*  source's Remark 3.3 states, the tape is a separately declared input,  *)
(*  never derived here or in the source from an autonomous state map. It  *)
(*  also does not establish that any real physical Navier-Stokes state    *)
(*  ever supplies the hypotheses of Theorem 4.1 (weld_dynamics,           *)
(*  weld_reader, weld_invariant) -- those are formalized as explicit      *)
(*  hypotheses, exactly the idiom used throughout this repo's other weld  *)
(*  proofs (see PROP_NS_WITNESS_01_finite_weld.v, PROP_CONF_03_union_     *)
(*  bound.v).                                                             *)
(*                                                                        *)
(*  Expected: Print Assumptions tape_closed_recurrence,                  *)
(*  Print Assumptions exact_domain_gate,                                 *)
(*  Print Assumptions future_readout_sufficiency                         *)
(*    => Closed under the global context (all three, axiom-free).        *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.micromega.Lia.

(* QArith opens Q_scope globally on import, which would otherwise shadow  *)
(* the ordinary nat notations (<=, <, +) used on natural-number indices   *)
(* throughout Sections 1 and 3 below. Close it immediately; Section 2     *)
(* below tags every literal Q equality explicitly with %Q instead of      *)
(* relying on an ambient scope, so this stays closed everywhere.          *)
Close Scope Q_scope.

(* ===================================================================== *)
(*  1. Theorem 3.2 -- exact tape-closed recurrence.                       *)
(* ===================================================================== *)

Section TapeClosedRecurrence.

  (* The retained finite-mode vector space, left fully abstract: only     *)
  (* an addition operation is used by the recurrence.                     *)
  Variable V : Type.
  Variable vadd : V -> V -> V.

  (* A_n : the step-n linear map, treated here as an ARBITRARY function   *)
  (* V -> V -- linearity is never used below. *)
  Variable A : nat -> V -> V.

  (* chi_n : the step-n tape entry, an ARBITRARY given element of V       *)
  (* (Remark 3.3: declared, not derived). *)
  Variable chi : nat -> V.

  (* I_0 : the initial retained state. *)
  Variable I0 : V.

  (* F#_{M,n}(I, c) := A_n(I) + c, the exact finite update conditioned    *)
  (* on the declared tape entry c. *)
  Definition Fsharp (n : nat) (Iv c : V) : V := vadd (A n Iv) c.

  (* The sequence defined by the primitive recursion of Definition 3.1 /  *)
  (* Theorem 3.2: I_{n+1} := A_n(I_n) + chi_n. *)
  Fixpoint Itape (n : nat) : V :=
    match n with
    | O => I0
    | S n' => Fsharp n' (Itape n') (chi n')
    end.

  (* Theorem 3.2 (exact tape-closed recurrence). *)
  Theorem tape_closed_recurrence :
    forall n : nat, Itape (S n) = Fsharp n (Itape n) (chi n).
  Proof.
    intro n. reflexivity.
  Qed.

End TapeClosedRecurrence.

(* ===================================================================== *)
(*  2. Theorem 4.1 -- exact Readout-Genesis domain gate.                  *)
(* ===================================================================== *)

Section DomainGate.

  (* The retained finite-mode vector space V, the full state space S,     *)
  (* the reader's codomain Y, and the invariant's codomain Z -- all left  *)
  (* fully abstract. *)
  Variable V St Y Z : Type.
  Variable vadd : V -> V -> V.
  Variable A : nat -> V -> V.
  Variable chi : nat -> V.

  Let Fsharp (n : nat) (Iv c : V) : V := vadd (A n Iv) c.

  (* F_{NS,n} : the abstract root stepper on the full state space. *)
  Variable F_NS : nat -> St -> St.

  (* q_{M,n} : the domain-reading map at step n. *)
  Variable q : nat -> St -> V.

  (* O_{M,n} and its domain counterpart O#_{M,n}. *)
  Variable O : nat -> St -> Y.
  Variable Osharp : nat -> V -> Y.

  (* Inv_{M,n} and its domain counterpart Inv#_{M,n}, the general third   *)
  (* Readout-Genesis weld condition (Gate 5: Inv_alpha = Inv#_alpha o     *)
  (* q_alpha) underlying the epsilon_inv component of the standard        *)
  (* defect vector (see file header). *)
  Variable Inv : nat -> St -> Z.
  Variable Invsharp : nat -> V -> Z.

  (* An abstract rational-valued distance for each target type, used     *)
  (* only to state each defect as a rational number: the sole property    *)
  (* needed is that a value's distance to itself is exactly 0. *)
  Variable dV : V -> V -> Q.
  Variable dY : Y -> Y -> Q.
  Variable dZ : Z -> Z -> Q.
  Hypothesis dV_refl : forall x : V, dV x x = 0%Q.
  Hypothesis dY_refl : forall y : Y, dY y y = 0%Q.
  Hypothesis dZ_refl : forall z : Z, dZ z z = 0%Q.

  (* The two weld hypotheses stated explicitly in the source (eq 21-23):  *)
  (*   q_{M,n+1} o F_{NS,n} = F#_{M,n} o (q_{M,n}, chi_{M,n})              *)
  (*   O_{M,n} = O#_{M,n} o q_{M,n}                                       *)
  (* plus the general Gate-5 invariant weld of the same shape. *)
  Hypothesis weld_dynamics :
    forall (n : nat) (s : St), q (S n) (F_NS n s) = Fsharp n (q n s) (chi n).
  Hypothesis weld_reader :
    forall (n : nat) (s : St), O n s = Osharp n (q n s).
  Hypothesis weld_invariant :
    forall (n : nat) (s : St), Inv n s = Invsharp n (q n s).

  (* The three exact-arithmetic defect terms. *)
  Definition eps_dyn (n : nat) (s : St) : Q :=
    dV (q (S n) (F_NS n s)) (Fsharp n (q n s) (chi n)).
  Definition eps_read (n : nat) (s : St) : Q :=
    dY (O n s) (Osharp n (q n s)).
  Definition eps_inv (n : nat) (s : St) : Q :=
    dZ (Inv n s) (Invsharp n (q n s)).

  (* Theorem 4.1 (exact Readout-Genesis domain gate): with exact          *)
  (* arithmetic, all three defects are exactly zero. *)
  Theorem exact_domain_gate :
    forall (n : nat) (s : St),
      eps_dyn n s = 0%Q /\ eps_read n s = 0%Q /\ eps_inv n s = 0%Q.
  Proof.
    intros n s.
    unfold eps_dyn, eps_read, eps_inv.
    rewrite (weld_dynamics n s).
    rewrite (weld_reader n s).
    rewrite (weld_invariant n s).
    repeat split.
    - apply dV_refl.
    - apply dY_refl.
    - apply dZ_refl.
  Qed.

End DomainGate.

(* ===================================================================== *)
(*  3. Theorem 5.1 -- future readout sufficiency.                        *)
(* ===================================================================== *)

Section FutureReadoutSufficiency.

  Variable V : Type.
  Variable vadd : V -> V -> V.
  Variable A : nat -> V -> V.

  Let Fsharp (n : nat) (Iv c : V) : V := vadd (A n Iv) c.

  (* Two possibly-different tapes and the two trajectories they drive,   *)
  (* both using the SAME step family A. *)
  Variable chi chi' : nat -> V.
  Variable I I' : nat -> V.

  Hypothesis rec_I  : forall k : nat, I  (S k) = Fsharp k (I  k) (chi  k).
  Hypothesis rec_I' : forall k : nat, I' (S k) = Fsharp k (I' k) (chi' k).

  Variable n L : nat.

  (* State agreement at step n. *)
  Hypothesis state_agree : I n = I' n.

  (* Tape agreement on every entry in the window [n, n+L). *)
  Hypothesis tape_agree :
    forall j : nat, n <= j -> j < n + L -> chi j = chi' j.

  (* Theorem 5.1 (future readout sufficiency): state agreement at n plus  *)
  (* tape agreement on [n, n+L) forces state agreement at every step      *)
  (* n+r, 0 <= r <= L. *)
  Theorem future_readout_sufficiency :
    forall r : nat, r <= L -> I (n + r) = I' (n + r).
  Proof.
    induction r as [| r IH]; intro Hr.
    - rewrite Nat.add_0_r. exact state_agree.
    - assert (Hr' : r <= L) by lia.
      assert (Hlt : r < L) by lia.
      specialize (IH Hr').
      assert (Hstep : n + S r = S (n + r)) by lia.
      rewrite Hstep.
      rewrite (rec_I (n + r)).
      rewrite (rec_I' (n + r)).
      rewrite IH.
      assert (Hge : n <= n + r) by lia.
      assert (Hlt2 : n + r < n + L) by lia.
      rewrite (tape_agree (n + r) Hge Hlt2).
      reflexivity.
  Qed.

End FutureReadoutSufficiency.
