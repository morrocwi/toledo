(* ================================================================= *)
(*  InfoTapeKineticGW.v                                      *)
(*  Tape Kinetic Operator Closure v1.8 (founder's "Kinetic v1.6").    *)
(*  A root-native kinetic operator D_T on the ordered tape with an     *)
(*  EXACT Ginsparg-Wilson modified chirality at finite spacing and NO  *)
(*  species doubling in the free fixture -- no gamma^5 / Dirac / cont- *)
(*  inuous time posited as roots.  Exact 2x2 rational matrices; the    *)
(*  no-doubling audit is arithmetic over Q/Z.                         *)
(*                                                                     *)
(*  Proved (Print Assumptions Closed):                                *)
(*   (cliff) isotropy Clifford witness sigma_x,sigma_z: A^2=I and      *)
(*           {A1,A2}=0 (KIN-G1, forced by first-order+isotropic cost)  *)
(*   (unit)  a rational unitary V (rotation 3/5,4/5): V^T V = I and     *)
(*           V Gamma V = Gamma  (the GW hypothesis; => Gamma V Gamma=V^T)*)
(*   (GW)    Gamma(I-V)+(I-V)Gamma = (I-V)Gamma(I-V)  -- the division-  *)
(*           free Ginsparg-Wilson relation (KIN-G5): chirality holds    *)
(*           at finite spacing WITHOUT naive anticommutation           *)
(*   (ghat)  Ghat = Gamma V is an involution (Ghat^2=I) and Ghat<>Gamma *)
(*           (record and conjugate use different lattice projectors)   *)
(*   (nodbl) no-doubling: M_n=m0-2rn with 0<m0<2r gives M_0>0 (one      *)
(*           physical zero) and M_n<0 for n>=1 (KIN-G6, all lifted)     *)
(*   (count) corner count 2^d = 1 + (2^d - 1): at d=4, 16 = 1 + 15      *)
(*                                                                     *)
(*  HONEST FENCE. EXACT under the channel assumptions (isotropy,       *)
(*  orientation compatibility {Gamma,A_mu}=0, spectral gap Q^2>=d^2).  *)
(*  The continuum linearity D(p)->-i A_mu p_mu and the Lorentz shadow  *)
(*  are Dr/+reals (need the small-ap limit) and CONDITIONAL on d=4.    *)
(*  OPEN: derive d=4 from the root, A_mu from the tape algebra without  *)
(*  a Clifford-target alphabet, <Xi> <> 0 from an action, interacting   *)
(*  gauge reflection positivity, anomaly coefficients, Yukawa/gens.    *)
(*  Uses Ginsparg-Wilson(1982)/overlap(Neuberger 1998) mechanism.     *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoTapeKineticGW.
Open Scope Q_scope.

(* ---- exact 2x2 rational matrices ---- *)
Record M2 := mkM2 { a : Q; b : Q; c : Q; d : Q }.
Definition Mmul (X Y : M2) : M2 :=
  mkM2 (a X * a Y + b X * c Y) (a X * b Y + b X * d Y)
       (c X * a Y + d X * c Y) (c X * b Y + d X * d Y).
Definition Madd (X Y : M2) : M2 := mkM2 (a X + a Y) (b X + b Y) (c X + c Y) (d X + d Y).
Definition Msub (X Y : M2) : M2 := mkM2 (a X - a Y) (b X - b Y) (c X - c Y) (d X - d Y).
Definition Mtr (X : M2) : M2 := mkM2 (a X) (c X) (b X) (d X).
Definition Meq (X Y : M2) : Prop := a X == a Y /\ b X == b Y /\ c X == c Y /\ d X == d Y.

Definition I2 : M2 := mkM2 1 0 0 1.
Definition Zer: M2 := mkM2 0 0 0 0.
Definition GT : M2 := mkM2 1 0 0 (-1).                 (* Gamma_T *)
Definition Ax : M2 := mkM2 0 1 1 0.                    (* sigma_x *)
Definition Az : M2 := mkM2 1 0 0 (-1).                 (* sigma_z *)
Definition V  : M2 := mkM2 (3#5) (4#5) (-(4#5)) (3#5). (* rational rotation *)

Ltac mcrush := unfold Meq, Mmul, Madd, Msub, Mtr, I2, Zer, GT, Ax, Az, V;
               simpl; repeat split; vm_compute; reflexivity.

(* (cliff) isotropy Clifford witness *)
Theorem clifford_Ax_sq : Meq (Mmul Ax Ax) I2.
Proof. mcrush. Qed.
Theorem clifford_Az_sq : Meq (Mmul Az Az) I2.
Proof. mcrush. Qed.
Theorem clifford_anticommute : Meq (Madd (Mmul Ax Az) (Mmul Az Ax)) Zer.
Proof. mcrush. Qed.

(* (unit) V unitary and the GW hypothesis V Gamma V = Gamma *)
Theorem V_unitary : Meq (Mmul (Mtr V) V) I2.
Proof. mcrush. Qed.
Theorem V_gamma_relation : Meq (Mmul (Mmul V GT) V) GT.
Proof. mcrush. Qed.
Theorem Gamma_V_Gamma_is_Vdag : Meq (Mmul (Mmul GT V) GT) (Mtr V).
Proof. mcrush. Qed.

(* (GW) the division-free Ginsparg-Wilson relation *)
Definition U : M2 := Msub I2 V.                        (* U = I - V = a-bar * D *)
Theorem ginsparg_wilson :
  Meq (Madd (Mmul GT U) (Mmul U GT)) (Mmul (Mmul U GT) U).
Proof. unfold U. mcrush. Qed.

(* (ghat) modified grading Ghat = Gamma V is an involution, and differs from Gamma *)
Definition Ghat : M2 := Mmul GT V.
Theorem ghat_involution : Meq (Mmul Ghat Ghat) I2.
Proof. unfold Ghat. mcrush. Qed.
Theorem ghat_neq_gamma : ~ Meq Ghat GT.
Proof. unfold Ghat, Meq, Mmul, GT, V. simpl. intros [H _]. vm_compute in H. discriminate. Qed.

(* (nodbl) free no-doubling: M_n = m0 - 2 r n *)
Definition Mn (m0 r n : Q) : Q := m0 - 2*r*n.
Theorem physical_zero : forall m0 r : Q, 0 < m0 -> m0 < 2*r -> 0 < Mn m0 r 0.
Proof. intros m0 r H0 H1. unfold Mn. lra. Qed.
Theorem corners_lifted : forall m0 r n : Q,
  0 < m0 -> m0 < 2*r -> 1 <= n -> Mn m0 r n < 0.
Proof.
  intros m0 r n H0 H1 Hn. unfold Mn.
  (* r>0 from 0<m0<2r; n>=1, r>0 => 2*r*n >= 2*r > m0 *)
  assert (0 < r) by lra.
  assert (2*r <= 2*r*n) by nra.
  lra.
Qed.

(* (count) corner accounting 2^d = 1 + (2^d - 1); at d=4, 16 = 1 + 15 *)
Open Scope Z_scope.
Theorem corner_count_d4 : (2^4 = 1 + 15)%Z.
Proof. reflexivity. Qed.
Theorem corner_count_general : forall d : Z, 0 <= d -> 2^d = 1 + (2^d - 1).
Proof. intros. ring. Qed.

End InfoTapeKineticGW.

Print Assumptions InfoTapeKineticGW.clifford_Ax_sq.
Print Assumptions InfoTapeKineticGW.clifford_anticommute.
Print Assumptions InfoTapeKineticGW.V_unitary.
Print Assumptions InfoTapeKineticGW.V_gamma_relation.
Print Assumptions InfoTapeKineticGW.ginsparg_wilson.
Print Assumptions InfoTapeKineticGW.ghat_involution.
Print Assumptions InfoTapeKineticGW.ghat_neq_gamma.
Print Assumptions InfoTapeKineticGW.physical_zero.
Print Assumptions InfoTapeKineticGW.corners_lifted.
Print Assumptions InfoTapeKineticGW.corner_count_d4.
Print Assumptions InfoTapeKineticGW.corner_count_general.
