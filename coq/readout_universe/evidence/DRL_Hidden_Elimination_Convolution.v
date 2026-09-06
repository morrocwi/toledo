(* ===================================================================== *)
(*  DRL_Hidden_Elimination_Convolution.v -- finite-rational hidden        *)
(*  elimination and convolution identity (C5 of v2/urr/                  *)
(*  URR_C_COQ_FORMAL_CHAIN.yaml's next_formal_targets, target:            *)
(*  finite_rational_hidden_elimination_and_convolution_identity).         *)
(*                                                                        *)
(*  Ground truth / motivating precedent: v2/urr/CLAIM_LEDGER.yaml's AP18  *)
(*  (ideal two-capacitor RC memory cell, finite_diagnostic, numeric     *)
(*  Python experiment) -- there, eliminating a HIDDEN linear degree of    *)
(*  freedom coupled to a VISIBLE one produces an effective memory kernel  *)
(*  K_mem(tau) = (1/(R C1))(1/(R C2)) exp(-tau/(R C2)), i.e. the visible  *)
(*  variable's history enters through a CONVOLUTION against an           *)
(*  exponential-decay kernel, checked only numerically there (a specific  *)
(*  RC circuit, floating point, exact-within-model not exact-within-      *)
(*  Coq. This file proves the DISCRETE, RATIONAL, EXACT analogue of       *)
(*  that elimination-produces-a-convolution-kernel structure: a general   *)
(*  linear hidden recurrence h[n+1] = r.h[n] + v[n] (r : Q, v : nat -> Q  *)
(*  an arbitrary visible forcing sequence) has the CLOSED FORM           *)
(*  h[n] = r^n.h[0] + Sum_{k<n} r^(n-1-k).v[k] -- a finite discrete        *)
(*  convolution of v against the geometric kernel K[j] := r^j, the        *)
(*  discrete/rational counterpart of AP18's continuous exp(-tau/RC)       *)
(*  kernel (r plays the role of exp(-1/RC) per time step) -- proved       *)
(*  EXACTLY equal to the recurrence's own value, by induction, over Q,    *)
(*  no floating point, no numeric tolerance.                              *)
(*                                                                        *)
(*  WHAT IT PROVES: (1) hidden_elimination_convolution -- the closed-form *)
(*  convolution sum exactly equals the recursively-defined hidden         *)
(*  variable, for ANY r, h0, v, n. (2) hidden_elimination_zero_forcing --  *)
(*  the v=0 special case collapses to the bare geometric decay r^n.h0     *)
(*  (sanity: with no visible forcing at all, elimination reduces to pure  *)
(*  autonomous decay, matching the no-hidden-growth-without-external-     *)
(*  coupling reading of AP18's own setup). (3) a concrete non-vacuous      *)
(*  numeric witness at r=1/2 (an explicit rational decay ratio, echoing   *)
(*  AP18's decay-not-growth regime without literally reproducing its RC   *)
(*  circuit numbers, which were floating-point and out of Coq's scope).   *)
(*                                                                        *)
(*  WHAT IT DOES NOT PROVE: that this closed form connects to any DRL     *)
(*  master-equation quantity by name (F5's visible/hidden/tape sectors,   *)
(*  or DRL_Finite_Cut_Balance.v's C3 result) -- this is the general        *)
(*  linear-recurrence elimination fact those constructions could be BUILT *)
(*  on, not a claim that they already use it; AP18's own RC-circuit       *)
(*  numbers or its exponential-vs-discrete-geometric correspondence       *)
(*  (r <-> exp(-1/RC)) are not re-derived or claimed identical here --    *)
(*  only the shared STRUCTURE (elimination produces a convolution against *)
(*  a decay kernel) is what this file formalizes.                        *)
(*                                                                        *)
(*  Over Q, axiom-free target (check Print Assumptions).                  *)
(* ===================================================================== *)

Require Import QArith.
Require Import Lia.

Open Scope Q_scope.

(* ===================================================================== *)
(*  Section 1: finite sums and rational powers (same Sum n f vocabulary   *)
(*  as evidence/DRL_Finite_Cut_Balance.v's Section 1, itself adapted from *)
(*  the author's information-discrete-math skill's IDM_Matrix.v).         *)
(* ===================================================================== *)

Fixpoint Sum (n : nat) (f : nat -> Q) : Q :=
  match n with O => 0 | S k => Sum k f + f k end.

Lemma Sum_plus : forall n f g, Sum n (fun k => f k + g k) == Sum n f + Sum n g.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_ext : forall n f g, (forall k, f k == g k) -> Sum n f == Sum n g.
Proof. induction n; intros f g H; simpl; [ reflexivity | rewrite (IHn f g H), H; reflexivity ]. Qed.

Lemma Sum_ext_lt : forall n f g, (forall k, (k < n)%nat -> f k == g k) -> Sum n f == Sum n g.
Proof.
  induction n as [| m IH]; intros f g H; simpl.
  - reflexivity.
  - rewrite (IH f g); [ rewrite (H m) by lia; reflexivity | intros k Hk; apply H; lia ].
Qed.

Lemma Sum_scale : forall n c f, Sum n (fun k => c * f k) == c * Sum n f.
Proof. induction n; intros; simpl; [ ring | rewrite IHn; ring ]. Qed.

Lemma Sum_zero : forall n, Sum n (fun _ => 0) == 0.
Proof. induction n; simpl; [ reflexivity | rewrite IHn; ring ]. Qed.

(* Rational power with a NAT exponent, defined from scratch (rather than
   reused from QArith's Z-exponent Qpower) to keep this file's induction
   arguments -- all of which walk a nat n -- syntactically uniform. *)
Fixpoint Qpow_nat (r : Q) (n : nat) : Q :=
  match n with O => 1 | S k => r * Qpow_nat r k end.

Lemma Qpow_nat_S : forall r n, Qpow_nat r (S n) == r * Qpow_nat r n.
Proof. intros r n. simpl. reflexivity. Qed.

Lemma Qpow_nat_add : forall r a b, Qpow_nat r (a + b) == Qpow_nat r a * Qpow_nat r b.
Proof.
  intros r a b. induction a as [| a IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

(* ===================================================================== *)
(*  Section 2: the hidden recurrence, its closed-form convolution         *)
(*  solution, and the elimination identity.                               *)
(* ===================================================================== *)

Section HiddenElimination.

Variable r : Q.
Variable h0 : Q.
Variable v : nat -> Q.

(* the HIDDEN variable's own recurrence: h[n+1] = r.h[n] + v[n] *)
Fixpoint hidden (n : nat) : Q :=
  match n with
  | O => h0
  | S k => r * hidden k + v k
  end.

(* the discrete convolution kernel: K[j] := r^j, the rational/discrete
   analogue of AP18's continuous exp(-tau/(R C2)) decay kernel. *)
Definition Kmem (j : nat) : Q := Qpow_nat r j.

(* the CLOSED FORM: h[n] should equal r^n.h0 plus the convolution of the
   visible forcing v against Kmem, evaluated over v's history 0..n-1. *)
Definition hidden_closed_form (n : nat) : Q :=
  Qpow_nat r n * h0 + Sum n (fun k => Kmem (n - 1 - k)%nat * v k).

(* THE ELIMINATION IDENTITY: the closed-form convolution EXACTLY equals
   the recursively-defined hidden variable, for every n -- proved by
   induction on n, using Qpow_nat_S to peel one power of r and a direct
   algebraic reindexing of the convolution sum (no approximation, no
   floating point, unlike AP18's numeric RC-circuit check). *)
Theorem hidden_elimination_convolution :
  forall n, hidden n == hidden_closed_form n.
Proof.
  intros n. induction n as [| m IH]; unfold hidden_closed_form in *.
  - simpl. ring.
  - simpl hidden.
    rewrite IH.
    assert (Hstep :
      Sum (S m) (fun k => Kmem (S m - 1 - k)%nat * v k)
      == r * Sum m (fun k => Kmem (m - 1 - k)%nat * v k) + v m).
    { simpl Sum.
      assert (Ha : Kmem (S m - 1 - m)%nat * v m == v m).
      { unfold Kmem. replace (S m - 1 - m)%nat with 0%nat by lia.
        simpl. ring. }
      rewrite Ha.
      assert (Hb :
        Sum m (fun k => Kmem (S m - 1 - k)%nat * v k)
        == r * Sum m (fun k => Kmem (m - 1 - k)%nat * v k)).
      { rewrite <- (Sum_scale m r (fun k => Kmem (m - 1 - k)%nat * v k)).
        apply Sum_ext_lt. intros k Hk.
        (* only for k < m: S m - 1 - k (= m - k, since S m - 1 = m) equals
           S (m - 1 - k), so Qpow_nat r (S m - 1 - k) = r * Qpow_nat r
           (m - 1 - k) by Qpow_nat_S -- both truncated subtractions are
           genuinely non-truncating in this range, no degenerate case. *)
        unfold Kmem.
        replace (S m - 1 - k)%nat with (S (m - 1 - k)) by lia.
        rewrite Qpow_nat_S. ring. }
      rewrite Hb. ring. }
    rewrite Hstep, (Qpow_nat_S r m). ring.
Qed.

(* SANITY COROLLARY: with no visible forcing at all (v=0), the closed
   form collapses to bare geometric decay r^n.h0 -- elimination without
   any external coupling reduces to pure autonomous decay, matching the
   "no hidden growth without external coupling" reading of AP18's setup
   (there, the hidden capacitor's voltage decays/redistributes purely
   through its own RC time constant absent further charge injection). *)
Corollary hidden_elimination_zero_forcing :
  (forall k, v k == 0) ->
  forall n, hidden n == Qpow_nat r n * h0.
Proof.
  intros Hv0 n.
  rewrite (hidden_elimination_convolution n).
  unfold hidden_closed_form.
  rewrite (Sum_ext n (fun k => Kmem (n - 1 - k)%nat * v k) (fun k => 0)).
  - rewrite Sum_zero. ring.
  - intro k. rewrite (Hv0 k). ring.
Qed.

End HiddenElimination.

Print Assumptions hidden_elimination_convolution.
Print Assumptions hidden_elimination_zero_forcing.

(* ===================================================================== *)
(*  Section 3: non-vacuousness -- a concrete rational decay ratio r=1/2,  *)
(*  non-trivial forcing v[k]=k, and an explicit numeric check that the    *)
(*  closed form and the recurrence genuinely agree at a real instance.    *)
(* ===================================================================== *)

Example hidden_elimination_witness :
  hidden (1#2) 3 (fun k => inject_Z (Z.of_nat k)) 3
  == hidden_closed_form (1#2) 3 (fun k => inject_Z (Z.of_nat k)) 3.
Proof. apply hidden_elimination_convolution. Qed.

(* independently confirm the actual numeric value both sides compute to,
   not just that the two forms agree with each other in the abstract:
   hidden(0)=3, hidden(1)=(1/2)*3+0=3/2, hidden(2)=(1/2)*(3/2)+1=7/4,
   hidden(3)=(1/2)*(7/4)+2=23/8. *)
Example hidden_elimination_witness_value :
  hidden (1#2) 3 (fun k => inject_Z (Z.of_nat k)) 3 == (23#8).
Proof. simpl. reflexivity. Qed.

Print Assumptions hidden_elimination_witness.
Print Assumptions hidden_elimination_witness_value.
