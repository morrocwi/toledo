(* ================================================================= *)
(*  InfoFourForceCirculationRecovery.v                        *)
(*  Four-Force Circulation Tomography v0.2 -- FINITE FORMAL WITNESS.  *)
(*                                                                     *)
(*  A = H + Omega  (H symmetric reciprocal load, Omega antisymmetric  *)
(*  circulation load), chi = A^{-1}. Over Q, on the four-sector ring   *)
(*  fixture, we witness -- WITHOUT computing an inverse in Coq, by     *)
(*  carrying the integer matrix X = 204*chi and proving A*X = 204*I -- *)
(*    (T2) the EXACT directed-response identity                        *)
(*            chi - chi^T = -2 chi^T Omega chi                         *)
(*         in integer-cleared form  204*(X - X^T) = - X^T (2 Omega) X, *)
(*    (REC) exact circulation recovery: the antisymmetric part of A    *)
(*         returns the planted circulation, A - A^T = 2 Omega,         *)
(*    (CTRL) reciprocal failing control: Omega = 0 => A = H symmetric  *)
(*         => A - A^T = 0 (no directed circulation is manufactured).   *)
(*                                                                     *)
(*  HONEST FENCE (tier discipline). CLOSED (Th_coqc, axiom-free over   *)
(*  Q): the response identity, the exact recovery, the control -- as   *)
(*  finite rational-matrix facts. STATUS = [SimulatedData /            *)
(*  FiniteFormalWitness]: (G,EM,W,S) are DECODER LABELS in a fixture,  *)
(*  NOT forces calibrated against nature. NOT closed / not claimed:    *)
(*  that the labels are the real forces, a physical separable source   *)
(*  per force, the true susceptibility, quantum measurement, unit      *)
(*  calibration, the gauge group, empirical novelty. This is a finite  *)
(*  linear-algebra witness of a tomography scheme, not physics.        *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Import ListNotations.

Module InfoFourForceCirculationRecovery.
Open Scope Q_scope.

Definition Vec := list Q.
Definition Mat := list Vec.

Definition get (m : Mat) (i j : nat) : Q := nth j (nth i m nil) 0.
Definition build (f : nat -> nat -> Q) : Mat :=
  map (fun i => map (fun j => f i j) (seq 0 4)) (seq 0 4).

Definition mmul (A B : Mat) : Mat :=
  build (fun i j => fold_right Qplus 0
                     (map (fun k => get A i k * get B k j) (seq 0 4))).
Definition madd (A B : Mat) : Mat := build (fun i j => get A i j + get B i j).
Definition msub (A B : Mat) : Mat := build (fun i j => get A i j - get B i j).
Definition mneg (A : Mat) : Mat := build (fun i j => - get A i j).
Definition mtrans (A : Mat) : Mat := build (fun i j => get A j i).
Definition mscalz (z : Z) (A : Mat) : Mat := build (fun i j => inject_Z z * get A i j).

Definition Meqb (A B : Mat) : bool :=
  forallb (fun i => forallb (fun j => Qeq_bool (get A i j) (get B i j)) (seq 0 4))
          (seq 0 4).

(* ----- the fixture ----- *)
Definition Hm : Mat :=
  [[4;1;0;1];[1;4;1;0];[0;1;4;1];[1;0;1;4]].
Definition Om : Mat :=   (* Omega, with the 1/2 entries *)
  [[0; 1#2; 0; -(1#2)];
   [-(1#2); 0; 1#2; 0];
   [0; -(1#2); 0; 1#2];
   [1#2; 0; -(1#2); 0]].
Definition Om2 : Mat :=  (* 2*Omega, integer antisymmetric circulation *)
  [[0;1;0;-1];[-1;0;1;0];[0;-1;0;1];[1;0;-1;0]].
Definition Am : Mat := madd Hm Om.                  (* A = H + Omega *)
Definition X : Mat :=    (* X = 204 * chi = 204 * A^{-1}, integer circulant *)
  [[58;-23;10;-11];[-11;58;-23;10];[10;-11;58;-23];[-23;10;-11;58]].
Definition Id : Mat := [[1;0;0;0];[0;1;0;0];[0;0;1;0];[0;0;0;1]].
Definition Zero : Mat := [[0;0;0;0];[0;0;0;0];[0;0;0;0];[0;0;0;0]].

(* (INV) X really is 204*A^{-1}: A * X = 204 * I. *)
Theorem A_times_X_is_204I : Meqb (mmul Am X) (mscalz 204 Id) = true.
Proof. vm_compute. reflexivity. Qed.

(* (T2) exact directed-response identity, integer-cleared:
        204*(X - X^T) = - X^T (2 Omega) X.
   Dividing by 204^2 gives chi - chi^T = -2 chi^T Omega chi with chi = X/204. *)
Theorem directed_response_identity :
  Meqb (mscalz 204 (msub X (mtrans X)))
       (mneg (mmul (mmul (mtrans X) Om2) X)) = true.
Proof. vm_compute. reflexivity. Qed.

(* (REC) exact circulation recovery: antisym part of A = the planted 2*Omega. *)
Theorem circulation_recovery : Meqb (msub Am (mtrans Am)) Om2 = true.
Proof. vm_compute. reflexivity. Qed.

(* (CTRL) reciprocal failing control: with Omega = 0, A = H is symmetric,
   so the recovered circulation is exactly zero (nothing manufactured). *)
Theorem reciprocal_control_zero : Meqb (msub Hm (mtrans Hm)) Zero = true.
Proof. vm_compute. reflexivity. Qed.

(* sanity: Omega is genuinely antisymmetric and nonzero (directionality is real). *)
Theorem omega_antisym : Meqb (madd Om (mtrans Om)) Zero = true.
Proof. vm_compute. reflexivity. Qed.
Theorem omega_nonzero : Meqb Om Zero = false.
Proof. vm_compute. reflexivity. Qed.

End InfoFourForceCirculationRecovery.

Print Assumptions InfoFourForceCirculationRecovery.directed_response_identity.
Print Assumptions InfoFourForceCirculationRecovery.circulation_recovery.
Print Assumptions InfoFourForceCirculationRecovery.A_times_X_is_204I.
Print Assumptions InfoFourForceCirculationRecovery.reciprocal_control_zero.
