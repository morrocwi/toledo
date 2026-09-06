(* ================================================================= *)
(*  InfoFiniteTransferGap.v                                  *)
(*  Finite-Transfer Gap Theorem v1.3 -- the exact, conditional core   *)
(*  of the root-native mass-gap program. NOT the Clay Yang-Mills mass  *)
(*  gap (continuum) -- that stays OPEN. Here: the EIGENVALUE-GAP form  *)
(*  of the finite-transfer theorem, over Q.                          *)
(*                                                                     *)
(*  If the physical transfer operator 𝕋 is positive self-adjoint with *)
(*  a UNIQUE vacuum (top eigenvalue 1) and STRICTLY contracts the      *)
(*  nonvacuum sector (q = ‖𝕋 P_⊥‖ < 1), then the eigenvalue gap       *)
(*  1 - q > 0, and the physical gap Δ·a = -log q >= 1 - q > 0 (the     *)
(*  -log q >= 1-q step is a real inequality, tier Dr; the exact ℚ      *)
(*  content is the eigenvalue gap 1-q).                               *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*    (gap)    0<q -> q<1  =>  0 < 1-q         (strict contraction     *)
(*             => positive eigenvalue gap; the theorem's easy half)    *)
(*    (fixture) eigenvalues {1, 3/5}: gap 1 - 3/5 = 2/5 > 0            *)
(*    (posctrl) 𝕋 = diag(1,q): gap = 1-q > 0                          *)
(*    (contract) on P_⊥ (v=e_1): <e_1, diag(1,q) e_1> = q < 1          *)
(*    (degen)   q=1 (vacuum degeneracy): 1-1 = 0 => NO gap             *)
(*    (diff)    massless diffusion gap g(L)=1/L^2 > 0 at every L but   *)
(*             STRICTLY DECREASES toward 0 (g(2)>g(10)>0): a finite-L  *)
(*             gap is NOT sufficient (gap closes as L->infty)          *)
(*                                                                     *)
(*  HONEST FENCE. This is the FINITE-TRANSFER (easy) half. The HARD    *)
(*  half -- deriving q<1 from the root action with a UNIFORM bound as  *)
(*  L->infty and a->0, plus measure existence / reflection positivity  *)
(*  / nontrivial continuum -- is OPEN (gates MG-G7/G8/G9). See         *)
(*  MASS_GAP_INFORMATION_PHILOSOPHY.md. Next: v1.4 reflection-positive  *)
(*  slab (positivity BEFORE any eigenvalue is read as a physical mass).*)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoFiniteTransferGap.
Open Scope Q_scope.

(* (gap) strict neutral contraction q<1 => positive eigenvalue gap *)
Theorem strict_contraction_gives_gap : forall q : Q,
  0 < q -> q < 1 -> 0 < 1 - q.
Proof. intros q H0 H1. lra. Qed.

(* (fixture) eigenvalues {1, 3/5}: gap = 2/5 > 0 *)
Theorem fixture_gap : (1 - (3#5) == (2#5)) /\ 0 < (2#5).
Proof. split; [ vm_compute; reflexivity | lra ]. Qed.

(* (posctrl) 𝕋 = diag(1,q): the gap is exactly 1-q, positive iff q<1 *)
Definition posctrl_gap (q : Q) : Q := 1 - q.
Theorem positive_control : forall q : Q, 0 < q -> q < 1 -> 0 < posctrl_gap q.
Proof. intros q H0 H1. unfold posctrl_gap. lra. Qed.

(* (contract) on P_⊥ (v = e_1 = (0,1), orthogonal to the vacuum e_0 = (1,0)):
   <e_1, diag(1,q) e_1> = 0*1*0 + 1*q*1 = q, and q<1 is the strict contraction *)
Definition e0 : Q * Q := (1, 0).
Definition e1 : Q * Q := (0, 1).
Definition diagT (a b : Q) (v : Q * Q) : Q * Q := (a * fst v, b * snd v).
Definition dot (u v : Q * Q) : Q := fst u * fst v + snd u * snd v.
Theorem e0_e1_orthogonal : dot e0 e1 == 0.
Proof. unfold dot, e0, e1. simpl. ring. Qed.
Theorem contraction_on_perp : forall q : Q,
  dot e1 (diagT 1 q e1) == q /\ (q < 1 -> dot e1 (diagT 1 q e1) < 1).
Proof.
  intro q. unfold dot, diagT, e1. simpl. split.
  - ring.
  - intro H. setoid_replace (0*(1*0) + 1*(q*1)) with q by ring. exact H.
Qed.

(* (degen) vacuum degeneracy q=1 => gap = 0 => NO mass gap *)
Theorem degeneracy_no_gap : 1 - (1:Q) == 0.
Proof. vm_compute; reflexivity. Qed.

(* (diff) massless diffusion: gap g(L) = 1/L^2 is positive at every finite L
   but strictly decreases toward 0 -- a finite-L gap is NOT sufficient. *)
Definition diff_gap (L : Q) : Q := 1 / (L * L).
Theorem diffusion_gap_positive : forall L : Q, 0 < L -> 0 < diff_gap L.
Proof. intros L H. unfold diff_gap. apply Qlt_shift_div_l; [ nra | lra ]. Qed.
Theorem diffusion_gap_closes : diff_gap 2 > diff_gap 10 /\ diff_gap 10 > 0.
Proof. unfold diff_gap. split; vm_compute; reflexivity. Qed.

End InfoFiniteTransferGap.

Print Assumptions InfoFiniteTransferGap.strict_contraction_gives_gap.
Print Assumptions InfoFiniteTransferGap.fixture_gap.
Print Assumptions InfoFiniteTransferGap.positive_control.
Print Assumptions InfoFiniteTransferGap.e0_e1_orthogonal.
Print Assumptions InfoFiniteTransferGap.contraction_on_perp.
Print Assumptions InfoFiniteTransferGap.degeneracy_no_gap.
Print Assumptions InfoFiniteTransferGap.diffusion_gap_positive.
Print Assumptions InfoFiniteTransferGap.diffusion_gap_closes.
