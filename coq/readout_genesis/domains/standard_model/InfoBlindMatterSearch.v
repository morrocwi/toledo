(* ================================================================= *)
(*  InfoBlindMatterSearch.v                                  *)
(*  Blind One-Generation Matter Search v1.6.  Derive the SM matter    *)
(*  skeleton from su(3)+su(2)+u(1) over the minimal carrier alphabet   *)
(*  {1,3,3bar}x{1,2} WITHOUT feeding particle names or multiplicities. *)
(*  Multiplicity vector n=(nA,nAb,nB,nBb,nC,nD) for records            *)
(*     A=(3,2) Ab=(3bar,2) B=(3,1) Bb=(3bar,1) C=(1,2) D=(1,1).        *)
(*                                                                     *)
(*  Proved over Z / Q (Print Assumptions Closed):                     *)
(*   (min)   under the gates, in the A-branch (nAb=0), for nonneg      *)
(*           integer multiplicities with the color anomaly, G1 and     *)
(*           closure, the total Weyl count D_total >= 15 -- an         *)
(*           UNBOUNDED minimality bound (not just a finite scan)       *)
(*   (mmult) same hypotheses => #multiplets N_mult >= 5                *)
(*   (wit)   the witness (1,0,0,2,1,1) passes every gate and hits      *)
(*           D_total=15, N_mult=5 (the minimum is attained)            *)
(*   (conj)  the conjugate (0,1,2,0,1,1) also passes with D_total=15   *)
(*   (lock)  on the DERIVED skeleton, charges u=-q-h,d=-q+h,l=-3q,     *)
(*           e=h+3q give A_grav=h-3q and A111=(h-3q)^3=(A_grav)^3      *)
(*           => one condition h=3q (reproduces v1.5 from a derived     *)
(*           skeleton, not a fed one)                                  *)
(*   (Z6)    every record satisfies 2t+3s+y=0 (mod 6) => center Z_6    *)
(*   (nuctl) NEGATIVE CONTROL: with nu^c the grav anomaly vanishes     *)
(*           for ALL (q,h) => Y and B-L degenerate (reported)          *)
(*                                                                     *)
(*  HONEST FENCE. EXACT within the DECLARED minimal alphabet and the   *)
(*  no-vectorlike/closure/left-orientation search rules. OPEN:         *)
(*  uniqueness over ALL representations (larger reps admit other       *)
(*  anomaly-free chiral sets), root-native chirality (WHY the          *)
(*  doublet/singlet split -- that is the chirality closure), nu^c      *)
(*  necessity, generation multiplicity. The Python verifier runs the   *)
(*  actual blind enumeration; here the Coq witnesses the arithmetic.   *)
(* ================================================================= *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.QArith.QArith.
Require Import Lia.

Module InfoBlindMatterSearch.

(* ---- Z-level: the blind-search minimality bound and witnesses ---- *)
Open Scope Z_scope.

(* D_total and N_mult as functions of the multiplicity vector *)
Definition Dtot (nA nAb nB nBb nC nD : Z) : Z :=
  6*(nA+nAb) + 3*(nB+nBb) + 2*nC + nD.
Definition Nmult (nA nAb nB nBb nC nD : Z) : Z :=
  nA+nAb+nB+nBb+nC+nD.

(* (min) UNBOUNDED minimality: in the A-branch (nAb=0), with nonneg
   multiplicities, the [SU(3)]^3 color anomaly (2nA+nB-nBb=0), G1
   (1<=nA, 1<=nC) and the colorless closure (nC<=nD), D_total >= 15.
   Substituting nBb=2nA+nB gives D_total = 12nA+6nB+2nC+nD >= 15. *)
Theorem min_components : forall nA nB nBb nC nD : Z,
  0 <= nA -> 0 <= nB -> 0 <= nBb -> 0 <= nC -> 0 <= nD ->
  2*nA + nB - nBb = 0 ->      (* color anomaly, A-branch *)
  1 <= nA -> 1 <= nC ->       (* MAT-G1 *)
  nC <= nD ->                 (* MAT-G5 colorless closure *)
  15 <= Dtot nA 0 nB nBb nC nD.
Proof. intros. unfold Dtot. lia. Qed.

(* (mmult) same hypotheses => at least 5 multiplets *)
Theorem min_multiplets : forall nA nB nBb nC nD : Z,
  0 <= nA -> 0 <= nB -> 0 <= nBb -> 0 <= nC -> 0 <= nD ->
  2*nA + nB - nBb = 0 ->
  1 <= nA -> 1 <= nC ->
  nC <= nD ->
  5 <= Nmult nA 0 nB nBb nC nD.
Proof. intros. unfold Nmult. lia. Qed.

(* (wit) the found minimizer (1,0,0,2,1,1) attains the minimum *)
Theorem witness_minimum :
  Dtot 1 0 0 2 1 1 = 15 /\ Nmult 1 0 0 2 1 1 = 5.
Proof. unfold Dtot, Nmult. split; reflexivity. Qed.

(* the witness passes every gate (color anomaly, no-vectorlike, closure, G1) *)
Theorem witness_gates :
  (2*1 - 2*0 + 0 - 2 = 0)            (* MAT-G3 color anomaly *)
  /\ (0*2 = 0)                        (* MAT-G2 no-vectorlike (nB*nBb) *)
  /\ (1*0 = 0)                        (* MAT-G2 no-vectorlike (nA*nAb) *)
  /\ (2 >= 2*1) /\ (1 >= 1)           (* MAT-G5 closure: nBb>=2nA, nD>=nC *)
  /\ ((3*(1+0) + 1) mod 2 = 0).       (* MAT-G4 global SU(2): #doublets even *)
Proof. repeat split; lia. Qed.

(* (conj) the total-conjugate solution (0,1,2,0,1,1) also attains 15 and passes *)
Theorem conjugate_minimum :
  Dtot 0 1 2 0 1 1 = 15 /\ Nmult 0 1 2 0 1 1 = 5
  /\ (2*0 - 2*1 + 2 - 0 = 0)          (* color anomaly for the conjugate *)
  /\ (2 >= 2*1) /\ (1 >= 1).          (* closure in the conjugate branch: nB>=2nAb *)
Proof. unfold Dtot, Nmult. repeat split; lia. Qed.

(* ---- Z-level: Z_6 center-lock on the derived skeleton ---- *)
Definition lock (t s y : Z) : Z := 2*t + 3*s + y.
Theorem Z6_center_lock :
  (lock 1 1 1)   mod 6 = 0 /\ (lock 2 0 (-4)) mod 6 = 0
  /\ (lock 2 0 2) mod 6 = 0 /\ (lock 0 1 (-3)) mod 6 = 0
  /\ (lock 0 0 6) mod 6 = 0 /\ (lock 0 1 3)  mod 6 = 0.
Proof. unfold lock. repeat split; reflexivity. Qed.

(* ---- Q-level: hypercharge lock on the DERIVED skeleton ---- *)
Open Scope Q_scope.
Definition uq (q h : Q) : Q := - q - h.       (* x1 *)
Definition dq (q h : Q) : Q := - q + h.       (* x2 *)
Definition lq (q : Q)   : Q := - (3 * q).
Definition eq_ (q h : Q) : Q := h - lq q.
Definition cube (x : Q) : Q := x * x * x.

Theorem A_grav_lock : forall q h : Q,
  6*q + 3*(uq q h) + 3*(dq q h) + 2*(lq q) + (eq_ q h) == h - 3*q.
Proof. intros q h. unfold eq_, uq, dq, lq. ring. Qed.

Theorem A111_factorizes : forall q h : Q,
  6*cube q + 3*cube (uq q h) + 3*cube (dq q h) + 2*cube (lq q) + cube (eq_ q h)
  == cube (h - 3*q).
Proof. intros q h. unfold cube, eq_, uq, dq, lq. ring. Qed.

(* charge vector at h=3q, q=1: y = (1,-4,2,-3,6) *)
Theorem derived_charges :
  uq 1 3 == -4 /\ dq 1 3 == 2 /\ lq 1 == -3 /\ eq_ 1 3 == 6.
Proof. unfold eq_, uq, dq, lq. repeat split; vm_compute; reflexivity. Qed.

(* (nuctl) NEGATIVE CONTROL: with nu^c (n=3q-h) the grav anomaly vanishes for ALL (q,h) *)
Definition nq (q h : Q) : Q := 3*q - h.
Theorem nu_grav_vanishes : forall q h : Q,
  6*q + 3*(uq q h) + 3*(dq q h) + 2*(lq q) + (eq_ q h) + (nq q h) == 0.
Proof. intros q h. unfold eq_, uq, dq, lq, nq. ring. Qed.

End InfoBlindMatterSearch.

Print Assumptions InfoBlindMatterSearch.min_components.
Print Assumptions InfoBlindMatterSearch.min_multiplets.
Print Assumptions InfoBlindMatterSearch.witness_minimum.
Print Assumptions InfoBlindMatterSearch.witness_gates.
Print Assumptions InfoBlindMatterSearch.conjugate_minimum.
Print Assumptions InfoBlindMatterSearch.Z6_center_lock.
Print Assumptions InfoBlindMatterSearch.A_grav_lock.
Print Assumptions InfoBlindMatterSearch.A111_factorizes.
Print Assumptions InfoBlindMatterSearch.derived_charges.
Print Assumptions InfoBlindMatterSearch.nu_grav_vanishes.
