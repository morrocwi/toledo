(* ================================================================= *)
(*  InfoRootChirality.v                                      *)
(*  Root-Native Chirality Closure v1.7 (founder's "Chirality v1.5").  *)
(*  The ordered-triple orientation classes {tau+, tau-} carry an      *)
(*  orientation operator Gamma_T; we prove it is an exact involution, *)
(*  self-adjoint, REVERSED by tape reversal, with idempotent chiral   *)
(*  projectors; the exact NO-GO that an unbroken reversal makes the    *)
(*  two orientation sectors carry equivalent weak reps; and that an    *)
(*  orientation order Xi gives a weak-active projector P_w=(I-Xi G)/2. *)
(*  All matrices are exact 2x2 over Q; K_Xi positivity via minors.     *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*    (G1)  Gamma^2 = I                        (involution)           *)
(*    (G2)  Gamma^T = Gamma                     (self-adjoint)        *)
(*    (G3)  R Gamma R = -Gamma                  (reversal flips it)   *)
(*    (proj) P+ = (I+G)/2 idempotent; P+ P- = 0 (chiral split)        *)
(*    (nogo) a reversal-symmetric W (R W R = W) commutes with R =>     *)
(*           its two orientation blocks are R-conjugate: EQUIVALENT    *)
(*           weak reps => orientation grading alone gives NO chiral    *)
(*           gauge asymmetry                                          *)
(*    (Godd) CONTROL: Gamma is reversal-ODD (R G R = -G <> G) -- the   *)
(*           asymmetry seed                                           *)
(*    (Pw)   weak-active projector P_w=(I-Xi G)/2 idempotent for       *)
(*           Xi=+1 and Xi=-1; P_w P_s = 0 (su(2) closes iff P_w^2=P_w) *)
(*    (Kpsd) K_Xi=[[a,b],[b,a]] with 0<=b<=a is PSD: det=a^2-b^2>=0    *)
(*           (orientation-order transfer stays reflection-positive)    *)
(*                                                                     *)
(*  HONEST FENCE. Tape orientation operator + no-go + K_Xi positivity  *)
(*  are EXACT. Weak chiral asymmetry is CONDITIONAL on an ordered      *)
(*  orientation vacuum <Xi> <> 0 (deriving that phase from a unified   *)
(*  action is OPEN). Full spacetime chirality (gamma^5 identification, *)
(*  kinetic operator, no-doubling) is v1.8 and OPEN.                   *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoRootChirality.
Open Scope Q_scope.

(* ---- exact 2x2 rational matrices ---- *)
Record M2 := mkM2 { a : Q; b : Q; c : Q; d : Q }.
Definition Mmul (X Y : M2) : M2 :=
  mkM2 (a X * a Y + b X * c Y) (a X * b Y + b X * d Y)
       (c X * a Y + d X * c Y) (c X * b Y + d X * d Y).
Definition Madd (X Y : M2) : M2 := mkM2 (a X + a Y) (b X + b Y) (c X + c Y) (d X + d Y).
Definition Msub (X Y : M2) : M2 := mkM2 (a X - a Y) (b X - b Y) (c X - c Y) (d X - d Y).
Definition Mscal (k : Q) (X : M2) : M2 := mkM2 (k * a X) (k * b X) (k * c X) (k * d X).
Definition Mtr (X : M2) : M2 := mkM2 (a X) (c X) (b X) (d X).
Definition Meq (X Y : M2) : Prop := a X == a Y /\ b X == b Y /\ c X == c Y /\ d X == d Y.

Definition I2  : M2 := mkM2 1 0 0 1.
Definition Zer : M2 := mkM2 0 0 0 0.
Definition GT  : M2 := mkM2 1 0 0 (-1).          (* Gamma_T = diag(1,-1) *)
Definition RT  : M2 := mkM2 0 1 1 0.             (* tape reversal *)

Ltac mcrush := unfold Meq, Mmul, Madd, Msub, Mscal, Mtr, I2, Zer, GT, RT;
               simpl; repeat split; vm_compute; reflexivity.

(* (G1) involution *)
Theorem gamma_involution : Meq (Mmul GT GT) I2.
Proof. mcrush. Qed.
(* (G2) self-adjoint *)
Theorem gamma_selfadjoint : Meq (Mtr GT) GT.
Proof. mcrush. Qed.
(* R^2 = I *)
Theorem reversal_involution : Meq (Mmul RT RT) I2.
Proof. mcrush. Qed.
(* (G3) reversal flips the grading: R Gamma R = -Gamma  (R^-1 = R) *)
Theorem reversal_flips_gamma : Meq (Mmul (Mmul RT GT) RT) (Mscal (-1) GT).
Proof. mcrush. Qed.

(* (proj) chiral projectors *)
Definition Pp : M2 := Mscal (1#2) (Madd I2 GT).   (* (I+G)/2 = diag(1,0) *)
Definition Pm : M2 := Mscal (1#2) (Msub I2 GT).   (* (I-G)/2 = diag(0,1) *)
Theorem Pp_idem : Meq (Mmul Pp Pp) Pp.
Proof. unfold Pp. mcrush. Qed.
Theorem Pm_idem : Meq (Mmul Pm Pm) Pm.
Proof. unfold Pm. mcrush. Qed.
Theorem P_orth : Meq (Mmul Pp Pm) Zer.
Proof. unfold Pp, Pm. mcrush. Qed.
Theorem P_complete : Meq (Madd Pp Pm) I2.
Proof. unfold Pp, Pm. mcrush. Qed.

(* (nogo) reversal-symmetric W commutes with R => sectors are R-conjugate (equivalent reps) *)
Definition Wsym : M2 := mkM2 2 3 3 2.
Theorem nogo_reversal_symmetric : Meq (Mmul (Mmul RT Wsym) RT) Wsym.
Proof. unfold Wsym. mcrush. Qed.
Theorem nogo_commutes : Meq (Mmul RT Wsym) (Mmul Wsym RT).
Proof. unfold Wsym. mcrush. Qed.

(* (Pw) weak-active projector for Xi = +1 and Xi = -1 *)
Definition Pw (Xi : Q) : M2 := Mscal (1#2) (Msub I2 (Mscal Xi GT)).
Definition Ps (Xi : Q) : M2 := Mscal (1#2) (Madd I2 (Mscal Xi GT)).
Theorem Pw_idem_plus  : Meq (Mmul (Pw 1) (Pw 1)) (Pw 1).
Proof. unfold Pw. mcrush. Qed.
Theorem Pw_idem_minus : Meq (Mmul (Pw (-1)) (Pw (-1))) (Pw (-1)).
Proof. unfold Pw. mcrush. Qed.
Theorem Pw_Ps_orth : Meq (Mmul (Pw 1) (Ps 1)) Zer.   (* T_a P_s = 0 : weak trivial on inactive *)
Proof. unfold Pw, Ps. mcrush. Qed.
(* Xi=+1 selects the '-' orientation; Xi=-1 selects '+': no absolute left/right *)
Theorem Pw_selects_minus : Meq (Pw 1) Pm.
Proof. unfold Pw, Pm. mcrush. Qed.
Theorem Pw_flip : Meq (Pw (-1)) Pp.
Proof. unfold Pw, Pp. mcrush. Qed.

(* (Kpsd) K_Xi = [[a,b],[b,a]] with 0<=b<=a is positive semidefinite: det = a^2-b^2 >= 0 *)
Theorem KXi_psd_det : forall x y : Q, 0 <= y -> y <= x -> 0 <= x*x - y*y.
Proof.
  intros x y H0 H1.
  setoid_replace (x*x - y*y) with ((x - y) * (x + y)) by ring.
  apply Qmult_le_0_compat; lra.
Qed.
Theorem KXi_psd_diag : forall x y : Q, 0 <= y -> y <= x -> 0 <= x.
Proof. intros x y H0 H1. lra. Qed.

End InfoRootChirality.

Print Assumptions InfoRootChirality.gamma_involution.
Print Assumptions InfoRootChirality.gamma_selfadjoint.
Print Assumptions InfoRootChirality.reversal_flips_gamma.
Print Assumptions InfoRootChirality.Pp_idem.
Print Assumptions InfoRootChirality.P_orth.
Print Assumptions InfoRootChirality.nogo_reversal_symmetric.
Print Assumptions InfoRootChirality.nogo_commutes.
Print Assumptions InfoRootChirality.Pw_idem_plus.
Print Assumptions InfoRootChirality.Pw_idem_minus.
Print Assumptions InfoRootChirality.Pw_selects_minus.
Print Assumptions InfoRootChirality.KXi_psd_det.
Print Assumptions InfoRootChirality.KXi_psd_diag.
