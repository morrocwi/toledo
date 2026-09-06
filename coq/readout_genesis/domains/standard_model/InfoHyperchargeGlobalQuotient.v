(* ================================================================= *)
(*  InfoHyperchargeGlobalQuotient.v                          *)
(*  Hypercharge-Anomaly-Global-Quotient Closure v1.5.  Interaction    *)
(*  closure + anomaly cancellation force the SM hypercharge ratios,   *)
(*  the gravitational and cubic anomalies factor into ONE condition,  *)
(*  and the invisible common center is Z_6 (global gauge structure).  *)
(*                                                                     *)
(*  Charges after interaction closure (free vars q,h):                *)
(*     u=-q-h,  d=-q+h,  l=-3q,  e=h-l=h+3q.                          *)
(*  Proved over Q / Z (Print Assumptions Closed):                     *)
(*    (grav)   A_grav = 6q+3u+3d+2l+e = h - 3q                        *)
(*    (cubic)  A_111  = 6q^3+3u^3+3d^3+2l^3+e^3 = (h-3q)^3 = A_grav^3  *)
(*             => gravitational and cubic anomalies force the SAME     *)
(*                condition h=3q (not two independent conditions)      *)
(*    (SM)     h=3q, q=1 => y=(1,-4,2,-3,6,3) => Y=(1/6,-2/3,1/3,      *)
(*             -1/2,1,1/2)  (SM, left-handed convention)              *)
(*    (Qem)    Q_em = T_3 + Y => (2/3,-1/3,0,-1)                       *)
(*    (center) center-lock 2t+3s+y = 0 (mod 6) for every record       *)
(*             => the invisible common center is Z_6                   *)
(*    (su2)    global SU(2): #doublets 3Q+L = 4 is even (Witten)       *)
(*    (nu)     with nu^c (n=3q-h): A_grav=A_111=0 for ALL q,h          *)
(*             => Y and B-L degenerate (anomalies do NOT fix Y)        *)
(*                                                                     *)
(*  HONEST FENCE. Exact CONDITIONAL on the minimal one-generation      *)
(*  skeleton (Q,u^c,d^c,L,e^c,H). OPEN: blind derivation of that       *)
(*  skeleton, root-native chirality, whether nu^c must exist,          *)
(*  generation multiplicity. Anomaly-fixes-hypercharge is a known      *)
(*  result; rebuilt here in the closure language with the exact        *)
(*  A_111=(A_grav)^3 factorization and the Z_6 center-lock.            *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.ZArith.ZArith.

Module InfoHyperchargeGlobalQuotient.

(* ---- Z-level facts: center-lock and doublet parity ---- *)
Open Scope Z_scope.
(* records (t, s, y):  Q(1,1,1) u^c(2,0,-4) d^c(2,0,2) L(0,1,-3) e^c(0,0,6) H(0,1,3) *)
Definition lock (t s y : Z) : Z := 2*t + 3*s + y.
Theorem center_lock_Q   : (lock 1 1 1)   mod 6 = 0.  Proof. reflexivity. Qed.
Theorem center_lock_uc  : (lock 2 0 (-4)) mod 6 = 0. Proof. reflexivity. Qed.
Theorem center_lock_dc  : (lock 2 0 2)   mod 6 = 0.  Proof. reflexivity. Qed.
Theorem center_lock_L   : (lock 0 1 (-3)) mod 6 = 0. Proof. reflexivity. Qed.
Theorem center_lock_ec  : (lock 0 0 6)   mod 6 = 0.  Proof. reflexivity. Qed.
Theorem center_lock_H   : (lock 0 1 3)   mod 6 = 0.  Proof. reflexivity. Qed.
(* global SU(2) (Witten): number of doublets 3*Q + 1*L = 4 is even *)
Theorem global_su2_even : (3 + 1) mod 2 = 0.  Proof. reflexivity. Qed.

Open Scope Q_scope.
Definition uq (q h : Q) : Q := - q - h.
Definition dq (q h : Q) : Q := - q + h.
Definition lq (q : Q)   : Q := - (3 * q).
Definition eq_ (q h : Q) : Q := h - lq q.
Definition cube (x : Q) : Q := x * x * x.

(* (grav) A_grav = 6q+3u+3d+2l+e = h - 3q *)
Theorem A_grav_is_h_minus_3q : forall q h : Q,
  6*q + 3*(uq q h) + 3*(dq q h) + 2*(lq q) + (eq_ q h) == h - 3*q.
Proof. intros q h. unfold eq_, uq, dq, lq. ring. Qed.

(* (cubic) A_111 = (h-3q)^3 = (A_grav)^3 : gravitational and cubic anomalies coincide *)
Theorem A111_factorizes : forall q h : Q,
  6*cube q + 3*cube (uq q h) + 3*cube (dq q h) + 2*cube (lq q) + cube (eq_ q h)
  == cube (h - 3*q).
Proof. intros q h. unfold cube, eq_, uq, dq, lq. ring. Qed.

(* (SM) at h=3q, q=1: the Standard-Model hypercharges *)
Theorem sm_hypercharges :
  uq 1 3 == -4 /\ dq 1 3 == 2 /\ lq 1 == -3 /\ eq_ 1 3 == 6.
Proof. unfold uq, dq, lq, eq_. repeat split; vm_compute; reflexivity. Qed.
Theorem Y_values :  (* Y = y/6 *)
  (1#6 == (1)/6) /\ (-(2#3) == (-4)/6) /\ (1#3 == 2/6)
  /\ (-(1#2) == (-3)/6) /\ (1 == 6/6) /\ (1#2 == 3/6).
Proof. repeat split; vm_compute; reflexivity. Qed.

(* (Qem) Q_em = T_3 + Y : (2/3, -1/3, 0, -1) for (u,d,nu,e) *)
Theorem Q_em_pattern :
  ((1#2) + (1#6) == (2#3)) /\ ((-(1#2)) + (1#6) == -(1#3))
  /\ ((1#2) + (-(1#2)) == 0) /\ ((-(1#2)) + (-(1#2)) == -(1)).
Proof. repeat split; vm_compute; reflexivity. Qed.

(* (nu) with nu^c (n = 3q - h): the anomalies vanish for ALL q,h => Y-(B-L) degeneracy *)
Definition nq (q h : Q) : Q := 3*q - h.
Theorem nu_grav_vanishes : forall q h : Q,
  6*q + 3*(uq q h) + 3*(dq q h) + 2*(lq q) + (eq_ q h) + (nq q h) == 0.
Proof. intros q h. unfold eq_, uq, dq, lq, nq. ring. Qed.
Theorem nu_cubic_vanishes : forall q h : Q,
  6*cube q + 3*cube (uq q h) + 3*cube (dq q h) + 2*cube (lq q) + cube (eq_ q h) + cube (nq q h) == 0.
Proof. intros q h. unfold cube, eq_, uq, dq, lq, nq. ring. Qed.

End InfoHyperchargeGlobalQuotient.

Print Assumptions InfoHyperchargeGlobalQuotient.A_grav_is_h_minus_3q.
Print Assumptions InfoHyperchargeGlobalQuotient.A111_factorizes.
Print Assumptions InfoHyperchargeGlobalQuotient.sm_hypercharges.
Print Assumptions InfoHyperchargeGlobalQuotient.center_lock_Q.
Print Assumptions InfoHyperchargeGlobalQuotient.global_su2_even.
Print Assumptions InfoHyperchargeGlobalQuotient.nu_grav_vanishes.
Print Assumptions InfoHyperchargeGlobalQuotient.nu_cubic_vanishes.
