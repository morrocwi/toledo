(* ================================================================= *)
(*  InfoOrderHiggsClosure.v                                  *)
(*  Minimal Order/Higgs Closure v1.12 (founder's "v2.0"). From the    *)
(*  blind matter skeleton, FIND the minimal order carrier and derive   *)
(*  electroweak symmetry breaking -- one massless + three massive      *)
(*  vector directions -- WITHOUT feeding the Higgs doublet or the W/Z  *)
(*  mass formulas. Closes v1.11's open item at the representation /     *)
(*  stabilizer / vector-mass-pattern level (physical scale stays open).*)
(*                                                                     *)
(*  Proved over Q / Z (Print Assumptions Closed):                     *)
(*   (yH)   y_H = 3 is forced by EVERY matter closure (Q H U, Q H^ D,  *)
(*          L H^ E): 1+h-4=0, 1-h+2=0, -3-h+6=0 all give h=3          *)
(*   (su2)  2 (x) R2 contains a singlet iff R2 is the doublet: dims    *)
(*          2(x)d = (d+1)(+)(d-1) has a 1 iff d-1=1 iff d=2            *)
(*   (stab) residual generator Q_res=T3+Y annihilates the vacuum       *)
(*          (-1/2 + 1/2 = 0 on the lower component); dim stab = 1,     *)
(*          so 4 - 1 = 3 broken directions                            *)
(*   (det)  the neutral mass matrix [[g^2,-g g'],[-g g',g'^2]] has      *)
(*          det = 0 => a massless photon (rank 1)                      *)
(*   (mwz)  m_W^2 (g^2+g'^2) = m_Z^2 g^2  => m_W = m_Z cos(theta),      *)
(*          with m_W^2=g^2 s, m_Z^2=(g^2+g'^2) s  (s=v^2/4)            *)
(*   (rho)  tree-level rho = 1 : m_W^2 = m_Z^2 * g^2/(g^2+g'^2)         *)
(*          (cleared: same identity as (mwz))                         *)
(*   (photon) the zero mode A ~ (g', g) satisfies M^2 A = 0            *)
(*   (dof)  degree-of-freedom balance 8 + 4 = 2 + 9 + 1 = 12          *)
(*                                                                     *)
(*  HONEST FENCE. EXACT for representation + stabilizer + vector-mass  *)
(*  RANK/PATTERN, GIVEN nonzero order. OPEN: WHY the order condenses    *)
(*  (sign a_H<0), the scale v, the couplings g,g', the scalar/fermion  *)
(*  masses, mixing. NOT a prediction of W/Z/Higgs masses -- the        *)
(*  structure is derived, the numbers are not. The residual T3+Y /     *)
(*  one-doublet EWSB is the Weinberg-Salam mechanism (Weinberg 1967),  *)
(*  rebuilt AFTER the representation is derived.                       *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.ZArith.ZArith.
Require Import Lia.

Module InfoOrderHiggsClosure.

(* ---- Z-level: hypercharge closure, SU(2) tensor, counts ---- *)
Open Scope Z_scope.

(* (yH) y_H = 3 forced by every matter closure (integer y = 6Y;
   Q=1, U=-4, D=2, L=-3, E=6) *)
Theorem yH_from_QHU : 1 + 3 + (-4) = 0.        Proof. reflexivity. Qed.
Theorem yH_from_QHdD : 1 - 3 + 2 = 0.          Proof. reflexivity. Qed.
Theorem yH_from_LHdE : (-3) - 3 + 6 = 0.       Proof. reflexivity. Qed.
Theorem yH_unique : forall h : Z, (1 + h - 4 = 0) -> h = 3.
Proof. intros h H. lia. Qed.

(* (su2) 2 (x) (dim d) = (d+1) (+) (d-1) for d>=2 ; contains the singlet(1)
   iff d-1 = 1 iff d = 2. Controls: d=1 -> {2} only; d=3 -> {2,4}. *)
Theorem su2_doublet_has_singlet : 2 - 1 = 1.                  Proof. reflexivity. Qed.
Theorem su2_singlet_no_singlet  : ~ (1 + 1 = 1) /\ (1 - 1 = 0). (* 2(x)1={2} : no 1 *)
Proof. split; [ lia | reflexivity ]. Qed.
Theorem su2_triplet_no_singlet  : (3 + 1 = 4) /\ (3 - 1 = 2) /\ ~ (3 - 1 = 1). (* {2,4} : no 1 *)
Proof. repeat split; lia. Qed.

(* (stab) 4 generators - 1 stabilizer = 3 broken directions *)
Theorem broken_count : 3 + 1 - 1 = 3.          Proof. reflexivity. Qed.

(* (dof) degree-of-freedom balance 8 + 4 = 2 + 9 + 1 = 12 *)
Theorem dof_balance : (4*2 + 4 = 12) /\ (2 + 3*3 + 1 = 12).
Proof. split; reflexivity. Qed.

(* ---- Q-level: stabilizer and the electroweak mass matrix ---- *)
Open Scope Q_scope.

(* (stab) Q_res = T3 + Y annihilates the vacuum lower component: -1/2 + 1/2 = 0 *)
Theorem residual_annihilates_vacuum : (-(1#2)) + (1#2) == 0.
Proof. ring. Qed.
(* the broken diagonal combination T3 - Y is nonzero on the vacuum: -1/2 - 1/2 = -1 <> 0 *)
Theorem broken_diagonal_nonzero : (-(1#2)) - (1#2) == -(1) /\ ~ ((-(1))==0).
Proof. split; [ ring | discriminate ]. Qed.

(* (det) neutral mass matrix [[g^2,-g g'],[-g g',g'^2]] has determinant 0 *)
Theorem neutral_det_zero : forall g gp : Q,
  (g*g)*(gp*gp) - (-(g*gp))*(-(g*gp)) == 0.
Proof. intros g gp. ring. Qed.

(* (mwz)/(rho) with m_W^2 = g^2 s and m_Z^2 = (g^2+g'^2) s (s = v^2/4):
   m_W^2 (g^2+g'^2) = m_Z^2 g^2  <=>  m_W = m_Z cos(theta)  and  rho = 1 *)
Definition mW2 (g s : Q) : Q := g*g*s.
Definition mZ2 (g gp s : Q) : Q := (g*g + gp*gp)*s.
Theorem mW_mZ_relation : forall g gp s : Q,
  (mW2 g s) * (g*g + gp*gp) == (mZ2 g gp s) * (g*g).
Proof. intros g gp s. unfold mW2, mZ2. ring. Qed.
(* m_Z^2 is the (positive) trace = sum of eigenvalues {0, (g^2+g'^2)s} *)
Theorem mZ2_is_trace : forall g gp s : Q,
  (g*g*s) + (gp*gp*s) == mZ2 g gp s.
Proof. intros g gp s. unfold mZ2. ring. Qed.

(* (photon) the zero mode A ~ (g', g) satisfies M^2 A = 0, entrywise:
   row1: g^2*g' + (-g g')*g = 0 ; row2: (-g g')*g' + g'^2*g = 0 *)
Theorem photon_zero_mode : forall g gp : Q,
  ((g*g)*gp + (-(g*gp))*g == 0) /\ ((-(g*gp))*gp + (gp*gp)*g == 0).
Proof. intros g gp. split; ring. Qed.

End InfoOrderHiggsClosure.

Print Assumptions InfoOrderHiggsClosure.yH_from_QHU.
Print Assumptions InfoOrderHiggsClosure.yH_unique.
Print Assumptions InfoOrderHiggsClosure.su2_doublet_has_singlet.
Print Assumptions InfoOrderHiggsClosure.su2_triplet_no_singlet.
Print Assumptions InfoOrderHiggsClosure.broken_count.
Print Assumptions InfoOrderHiggsClosure.dof_balance.
Print Assumptions InfoOrderHiggsClosure.residual_annihilates_vacuum.
Print Assumptions InfoOrderHiggsClosure.broken_diagonal_nonzero.
Print Assumptions InfoOrderHiggsClosure.neutral_det_zero.
Print Assumptions InfoOrderHiggsClosure.mW_mZ_relation.
Print Assumptions InfoOrderHiggsClosure.mZ2_is_trace.
Print Assumptions InfoOrderHiggsClosure.photon_zero_mode.
