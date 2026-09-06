(* =====================================================================
   RDL_TelescopeCore.v
   ---------------------------------------------------------------------
   ROOT C: the discrete Fundamental Theorem of Calculus (telescoping)
   as the shared root of cut-elimination's no-creation AND the continuum
   readout-invariant.  This completes the THREE-ROOTS program:

       Root A (involution, ~~ = id)        ) both in
       Root B (orthogonality, orth^3=orth) ) RDL_InvolutiveOrthoCore.v
       Root C (telescoping, this file)

   THE ROOT.  For Delta f k := f (S k) - f k  and  Sigma f n := sum_{k<n} f k,
   the difference and summation operators are mutually inverse up to the
   boundary -- the discrete FTC:

       telescope       : sum_{k<n} (f(S k) - f k) = f n - f 0     (Sigma o Delta)
       antidifference  : Sigma f (S n) - Sigma f n = f n          (Delta o Sigma)

   ITS TWO FACES.

     no_creation           -- a CLOSED loop (f n = f 0) sums to zero: the
                              interior telescopes away, nothing is created
                              net.  This is the root of:
                                * cut-elimination's NO-CREATION (RDL_CutElim):
                                  the cut formula is introduced and consumed,
                                  the interior cancels, only the boundary
                                  (end-sequents) survives;
                                * PGFT's obstruction ledger O = 0 (conservation).

     readout_endpoint_only -- the telescoped readout sees ONLY the endpoints:
                              functions agreeing on the boundary have equal
                              readout, whatever their interior.  This is the
                              root of the CONTINUUM READOUT-INVARIANT
                              (RDL_ContinuumReadout.secondDiff_readout_invariant):
                              the integral of a difference is boundary data,
                              invariant under interior refinement.

     telescope_second      -- the SECOND difference ([1,-2,1], PGFT's discrete
                              Laplacian stencil; RDL_GammaSpectral.laplacian_stencil)
                              telescopes too: sum of second differences =
                              boundary difference of first differences.

   All over Z (the RD number ladder); proofs are induction + `ring`,
   FUNEXT-FREE, axiom-free by construction.

   STATUS: candidate.  `Print Assumptions` on each must report
   "Closed under the global context".
   ===================================================================== *)

Require Import ZArith.
Open Scope Z_scope.

Fixpoint sumZ (n : nat) (f : nat -> Z) : Z :=
  match n with O => 0 | S k => sumZ k f + f k end.

(* =====================================================================
   THE ROOT: discrete FTC (telescoping), both directions.
   ===================================================================== *)

(* Sigma o Delta = boundary difference *)
Theorem telescope : forall f n,
  sumZ n (fun k => f (S k) - f k) = f n - f O.
Proof.
  intros f n. induction n; simpl.
  - ring.
  - rewrite IHn. ring.
Qed.

(* Delta o Sigma = identity: the partial-sum readout recovers the data *)
Theorem antidifference : forall f n,
  sumZ (S n) f - sumZ n f = f n.
Proof. intros f n. simpl. ring. Qed.

(* =====================================================================
   FACE 1 -- NO CREATION (conservation): closed loop sums to zero.
   Root of cut-elimination no-creation and PGFT obstruction O = 0.
   ===================================================================== *)
Theorem no_creation : forall f n,
  f n = f O -> sumZ n (fun k => f (S k) - f k) = 0.
Proof.
  intros f n H. rewrite telescope. rewrite H. ring.
Qed.

(* =====================================================================
   FACE 2 -- READOUT INVARIANT: the telescoped readout depends only on
   the endpoints (interior is invisible).  Root of the continuum
   readout-invariant.
   ===================================================================== *)
Theorem readout_endpoint_only : forall f g n,
  f O = g O -> f n = g n ->
  sumZ n (fun k => f (S k) - f k) = sumZ n (fun k => g (S k) - g k).
Proof.
  intros f g n H0 Hn.
  rewrite (telescope f n). rewrite (telescope g n).
  rewrite H0, Hn. reflexivity.
Qed.

(* =====================================================================
   The SECOND difference (PGFT Laplacian stencil [1,-2,1]) telescopes:
   sum of second differences = boundary difference of first differences.
   ===================================================================== *)
Theorem telescope_second : forall f n,
  sumZ n (fun k => (f (S (S k)) - f (S k)) - (f (S k) - f k))
  = (f (S n) - f n) - (f (S O) - f O).
Proof.
  intros f n. induction n; simpl.
  - ring.
  - rewrite IHn. ring.
Qed.

(* =====================================================================
   AXIOM AUDIT.  Each must report "Closed under the global context".
   ===================================================================== *)
Print Assumptions telescope.
Print Assumptions antidifference.
Print Assumptions no_creation.
Print Assumptions readout_endpoint_only.
Print Assumptions telescope_second.

(* End RDL_TelescopeCore.v *)
