(* =====================================================================
   RDL_StarRigMatrix.v
   ---------------------------------------------------------------------
   CLOSURE CANDIDATE (joins URCF/RD math to Pixel Gravity Field Theory).

   Goal: strengthen the StarRig resolution-of-identity (Kraus) completeness
   law of RDL_StarRig.v.  That module proves

       sum_j  adj(K_j) . K_j  =  1

   in an ABSTRACT star-rig plus the COMMUTATIVE model natStarRig = (nat,+,* ).
   The weakest link in the math<->physics coherence map is exactly that the
   only concrete model is commutative, whereas Pixel Gravity Field Theory
   Eq. (34),  K0^dag K0 + sum_j K_j^dag K_j = I , is an OPERATOR statement
   underlying its CPTP "theorem core".

   This file closes the gap on a GENUINE NONCOMMUTATIVE OPERATOR MODEL:
   2x2 integer matrices with TRANSPOSE as the involution.  It proves

     * the star-rig laws (involution, antimultiplicativity, additivity,
       units) for (Mat2, madd, mmul, adj);
     * trace cyclicity  tr(AB) = tr(BA);
     * a concrete identity-resolving family {P1,P2} of self-adjoint
       idempotents with an isometry-like U (adj U . U = I);
     * kraus_completeness_matrix:  adj(K1).K1 + adj(K2).K2 = I   (Eq. 34);
     * channel_trace_preserving:  tr(chan rho) = tr(rho)  for ALL rho
       (the "TP" half of CPTP, now on an operator model).

   HONEST SCOPE.  This delivers the COMPLETENESS RELATION and TRACE
   PRESERVATION on a noncommutative operator model.  The remaining step to
   the full "CP" of CPTP is positive-semidefiniteness preservation
   (each K_j rho K_j^T preserves PSD), and beyond that the general
   n-dimensional / Hilbert-space statement.  Those stay OPEN/DES.

   STATUS: candidate.  Must pass `coqc 8.18.0` and `Print Assumptions`
   (expected: Closed under the global context) before it counts as
   VERIFIED.  No axioms are intended; everything closes by `ring`/compute.
   ===================================================================== *)

Require Import ZArith.
Open Scope Z_scope.

(* ---- 2x2 integer matrices  [[m11 m12];[m21 m22]] ---- *)
Record Mat2 := mk { m11 : Z; m12 : Z; m21 : Z; m22 : Z }.

Lemma mat2_eq : forall a b c d a' b' c' d',
  a = a' -> b = b' -> c = c' -> d = d' ->
  mk a b c d = mk a' b' c' d'.
Proof. intros; subst; reflexivity. Qed.

Definition mzero : Mat2 := mk 0 0 0 0.
Definition mone  : Mat2 := mk 1 0 0 1.

Definition madd (A B : Mat2) : Mat2 :=
  mk (m11 A + m11 B) (m12 A + m12 B) (m21 A + m21 B) (m22 A + m22 B).

Definition mmul (A B : Mat2) : Mat2 :=
  mk (m11 A * m11 B + m12 A * m21 B)
     (m11 A * m12 B + m12 A * m22 B)
     (m21 A * m11 B + m22 A * m21 B)
     (m21 A * m12 B + m22 A * m22 B).

(* involution = transpose *)
Definition adj (A : Mat2) : Mat2 :=
  mk (m11 A) (m21 A) (m12 A) (m22 A).

Definition tr (A : Mat2) : Z := m11 A + m22 A.

(* =====================================================================
   Star-rig laws for (Mat2, madd, mmul, adj):  this IS an involutive
   (noncommutative) ring, so it is a genuine StarRig carrier.
   ===================================================================== *)

Lemma adj_invol : forall A, adj (adj A) = A.
Proof. intros [a b c d]; reflexivity. Qed.

Lemma adj_one : adj mone = mone.
Proof. reflexivity. Qed.

Lemma adj_add : forall A B, adj (madd A B) = madd (adj A) (adj B).
Proof. intros [a b c d] [a' b' c' d']; reflexivity. Qed.

Lemma adj_anti : forall A B, adj (mmul A B) = mmul (adj B) (adj A).
Proof.
  intros [a b c d] [a' b' c' d'].
  cbv [adj mmul m11 m12 m21 m22]; apply mat2_eq; ring.
Qed.

Lemma mmul_one_l : forall A, mmul mone A = A.
Proof.
  intros [a b c d].
  cbv [mmul mone m11 m12 m21 m22]; apply mat2_eq; ring.
Qed.

Lemma mmul_one_r : forall A, mmul A mone = A.
Proof.
  intros [a b c d].
  cbv [mmul mone m11 m12 m21 m22]; apply mat2_eq; ring.
Qed.

Lemma mmul_assoc : forall A B C, mmul (mmul A B) C = mmul A (mmul B C).
Proof.
  intros [a b c d] [a' b' c' d'] [a'' b'' c'' d''].
  cbv [mmul m11 m12 m21 m22]; apply mat2_eq; ring.
Qed.

(* trace is cyclic: the algebraic engine behind trace preservation *)
Lemma tr_cyclic : forall A B, tr (mmul A B) = tr (mmul B A).
Proof.
  intros [a b c d] [a' b' c' d'].
  cbv [tr mmul m11 m12 m21 m22]; ring.
Qed.

(* =====================================================================
   A concrete identity-resolving family and an isometry-like U.
   P1, P2 are the diagonal rank-1 projectors; U is a nontrivial
   permutation / orthogonal matrix (so the instance is NONVACUOUS).
   ===================================================================== *)

Definition P1 : Mat2 := mk 1 0 0 0.
Definition P2 : Mat2 := mk 0 0 0 1.
Definition U  : Mat2 := mk 0 1 1 0.

Lemma U_isometry : mmul (adj U) U = mone.
Proof. reflexivity. Qed.

Lemma P1_selfadj : adj P1 = P1.   Proof. reflexivity. Qed.
Lemma P2_selfadj : adj P2 = P2.   Proof. reflexivity. Qed.
Lemma P1_idem    : mmul (adj P1) P1 = P1.   Proof. reflexivity. Qed.
Lemma P2_idem    : mmul (adj P2) P2 = P2.   Proof. reflexivity. Qed.
Lemma resolution_of_identity : madd P1 P2 = mone.   Proof. reflexivity. Qed.

(* Kraus operators  K_j := P_j . U *)
Definition K1 : Mat2 := mmul P1 U.
Definition K2 : Mat2 := mmul P2 U.

(* =====================================================================
   MAIN 1.  The completeness relation on the operator model.
   PGFT Eq. (34) with K0 = 0 :   adj(K1).K1 + adj(K2).K2 = I.
   ===================================================================== *)
Theorem kraus_completeness_matrix :
  madd (mmul (adj K1) K1) (mmul (adj K2) K2) = mone.
Proof. reflexivity. Qed.

(* =====================================================================
   MAIN 2.  The induced Kraus channel is TRACE PRESERVING.
   chan rho := K1 rho K1^T + K2 rho K2^T ,   tr(chan rho) = tr rho.
   This is the "TP" half of CPTP, on a genuine 2x2 operator model.
   ===================================================================== *)
Definition chan (rho : Mat2) : Mat2 :=
  madd (mmul (mmul K1 rho) (adj K1))
       (mmul (mmul K2 rho) (adj K2)).

Theorem channel_trace_preserving :
  forall rho, tr (chan rho) = tr rho.
Proof.
  intros [p q r s].
  cbv [chan tr K1 K2 P1 P2 U mmul madd adj m11 m12 m21 m22]. ring.
Qed.

(* =====================================================================
   AXIOM AUDIT.  Run these; each must report
   "Closed under the global context" for the file to count as VERIFIED.
   ===================================================================== *)
Print Assumptions kraus_completeness_matrix.
Print Assumptions channel_trace_preserving.
Print Assumptions adj_anti.
Print Assumptions mmul_assoc.
Print Assumptions tr_cyclic.

(* End RDL_StarRigMatrix.v *)
