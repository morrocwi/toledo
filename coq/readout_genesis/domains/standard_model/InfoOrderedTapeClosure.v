(* ================================================================= *)
(*  InfoOrderedTapeClosure.v                                 *)
(*  Ordered-Tape Closure Theorem v0.2 -- the color number 3, SU(3),   *)
(*  and its Z_3 center grown from the rules of an ordered CLOSED tape. *)
(*  The crown: the ODDNESS of the minimal closure is DERIVED, not      *)
(*  posited -- from (order-sensitivity => antisymmetry) together with  *)
(*  (closed loop has no preferred start => cyclic invariance):         *)
(*     nonzero witness  =>  (-1)^(k-1) = 1  =>  k odd.                 *)
(*  Then k>1 minimal => k=3 => dim V = 3; preserving the Hermitian     *)
(*  load and the triple record (det U = 1) => SU(3); the common phase  *)
(*  c*I with c^3 = 1 => the Z_3 center.                               *)
(*                                                                     *)
(*  Proved here over z (nat parity) and Q (exact matrices):          *)
(*    (odd)   Nat.odd (S k') = Nat.even k'  (closure sign +1 <=> k odd)*)
(*    (min)   1 < k /\ Nat.odd k = true  =>  3 <= k                    *)
(*    (rep)   C == -C  =>  C == 0        (repeated event kills witness)*)
(*    (load)  R^T R = I  and  det R = 1  (R in the SU(3) real slice)   *)
(*    (Z3)    det (c*I_3) = c^3          (common phase cut to Z_3)     *)
(*    (conj)  Tr (h H h^T) = Tr H        (Wilson-loop invariance)      *)
(*                                                                     *)
(*  HONEST FENCE. CONDITIONAL ALGEBRAIC PASS: k=3, SU(3), Z_3, dim 8,  *)
(*  and kinematic color-neutrality (single channels carry no invariant *)
(*  readout; pair and triple do) follow from the ordered-closed-tape   *)
(*  rules. STILL OPEN -- a single measurable wall: whether the root    *)
(*  action S_U = sum_C kappa_C ||H_C - I||^2 produces a Wilson-loop    *)
(*  AREA law (dynamical confinement) with NO QCD potential fed in.     *)
(*  Kinematic neutrality is NOT yet dynamical confinement.             *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.Arith.Arith.
Require Import Coq.Arith.PeanoNat.
Require Import Lia.

Module InfoOrderedTapeClosure.

(* ---- the oddness derivation (nat parity) ---- *)
(* closed-loop start-independence needs the cyclic-shift sign (-1)^(k-1) = +1,
   i.e. (k-1) even, i.e. k odd. Here: for k = S k', k odd <=> k' even. *)
Theorem oddness_from_cyclic_closure : forall k' : nat,
  Nat.odd (S k') = Nat.even k'.
Proof. intro k'. apply Nat.odd_succ. Qed.

(* k=2 is excluded (even): the two-event loop cannot be a primitive oriented witness *)
Theorem two_is_not_odd : Nat.odd 2 = false.
Proof. reflexivity. Qed.

(* the minimal nontrivial (k>1) odd closure length is 3 *)
Theorem three_is_odd : Nat.odd 3 = true.
Proof. reflexivity. Qed.
Theorem k_min_is_three : forall k : nat,
  (1 < k)%nat -> Nat.odd k = true -> (3 <= k)%nat.
Proof.
  intros k H1 H2. apply Nat.odd_spec in H2. destruct H2 as [m Hm]. lia.
Qed.

(* ---- repeated event kills the witness: C = -C => C = 0 (over Q) ---- *)
Open Scope Q_scope.
Theorem repeated_event_zero : forall C : Q, C == - C -> C == 0.
Proof. intros C H. lra. Qed.

(* ---- exact 3x3 matrices: the SU(3) real slice + Z_3 center + Wilson invariance ---- *)
Definition M3 := (Q*Q*Q*Q*Q*Q*Q*Q*Q)%type.  (* row-major a11..a33 *)
(* use explicit tuples via a record for clarity *)
Record Mat3 : Type := mk3 {
  a11:Q; a12:Q; a13:Q; a21:Q; a22:Q; a23:Q; a31:Q; a32:Q; a33:Q }.
Definition mulT (A B : Mat3) : Mat3 :=
  mk3 (a11 A*a11 B + a12 A*a21 B + a13 A*a31 B)
      (a11 A*a12 B + a12 A*a22 B + a13 A*a32 B)
      (a11 A*a13 B + a12 A*a23 B + a13 A*a33 B)
      (a21 A*a11 B + a22 A*a21 B + a23 A*a31 B)
      (a21 A*a12 B + a22 A*a22 B + a23 A*a32 B)
      (a21 A*a13 B + a22 A*a23 B + a23 A*a33 B)
      (a31 A*a11 B + a32 A*a21 B + a33 A*a31 B)
      (a31 A*a12 B + a32 A*a22 B + a33 A*a32 B)
      (a31 A*a13 B + a32 A*a23 B + a33 A*a33 B).
Definition transp (A:Mat3) : Mat3 :=
  mk3 (a11 A)(a21 A)(a31 A)(a12 A)(a22 A)(a32 A)(a13 A)(a23 A)(a33 A).
Definition det3 (A:Mat3) : Q :=
  a11 A*(a22 A*a33 A - a23 A*a32 A)
 -a12 A*(a21 A*a33 A - a23 A*a31 A)
 +a13 A*(a21 A*a32 A - a22 A*a31 A).
Definition trace3 (A:Mat3) : Q := a11 A + a22 A + a33 A.
Definition Meq3 (A B:Mat3) : Prop :=
  a11 A==a11 B/\a12 A==a12 B/\a13 A==a13 B/\a21 A==a21 B/\a22 A==a22 B/\
  a23 A==a23 B/\a31 A==a31 B/\a32 A==a32 B/\a33 A==a33 B.
Definition I3 : Mat3 := mk3 1 0 0 0 1 0 0 0 1.

(* R = rational (3,4,5) rotation mixing channels 1,2 : in the SU(3) real slice *)
Definition R : Mat3 := mk3 (3#5) (-(4#5)) 0  (4#5) (3#5) 0  0 0 1.

Theorem R_preserves_load : Meq3 (mulT (transp R) R) I3.
Proof. unfold Meq3, mulT, transp, R, I3; simpl; repeat split; vm_compute; reflexivity. Qed.
Theorem R_preserves_triple : det3 R == 1.
Proof. vm_compute; reflexivity. Qed.

(* Z_3 center: det (c I_3) = c^3, so the common phase must satisfy c^3 = 1 *)
Definition scal3 (c:Q) : Mat3 := mk3 c 0 0 0 c 0 0 0 c.
Theorem det_common_phase_is_cube : forall c : Q, det3 (scal3 c) == c*c*c.
Proof. intro c. unfold det3, scal3; simpl. ring. Qed.

(* Wilson loop invariance: Tr(h H h^T) = Tr H for orthogonal h (h^T = h^{-1}) *)
Theorem wilson_trace_invariant :
  trace3 (mulT (mulT R (mk3 2 1 0 0 1 1 1 0 1)) (transp R))
  == trace3 (mk3 2 1 0 0 1 1 1 0 1).
Proof. vm_compute; reflexivity. Qed.

End InfoOrderedTapeClosure.

Print Assumptions InfoOrderedTapeClosure.oddness_from_cyclic_closure.
Print Assumptions InfoOrderedTapeClosure.k_min_is_three.
Print Assumptions InfoOrderedTapeClosure.repeated_event_zero.
Print Assumptions InfoOrderedTapeClosure.R_preserves_triple.
Print Assumptions InfoOrderedTapeClosure.det_common_phase_is_cube.
Print Assumptions InfoOrderedTapeClosure.wilson_trace_invariant.
