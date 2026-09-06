(* ================================================================= *)
(*  InfoElectroweakNullDirection.v                            *)
(*  Unified Force Closure v0.3 -- electroweak STRUCTURAL CORE.        *)
(*                                                                     *)
(*  The neutral selected-state obstruction matrix                     *)
(*      M2(g,g',v) = (v^2/4) * [[ g^2 , -g g'],[ -g g', g'^2 ]]       *)
(*                 = (v^2/4) * outer( (g,-g'), (g,-g') )              *)
(*  is a RANK-1 outer product. Over Q, for ALL g,g',v, we prove:      *)
(*    (det0)   det M2 = 0  IDENTICALLY -> a null (massless) direction *)
(*             MUST exist, WITHOUT importing "the photon is massless". *)
(*    (photon) M2 . (g',g)^T = 0     -- the massless photon direction *)
(*             ~ (g',g) == sin(thetaW) W3 + cos(thetaW) B.            *)
(*    (Z)      M2 . (g,-g')^T = m_Z^2 . (g,-g')  with                 *)
(*             m_Z^2 = (v^2/4)(g^2+g'^2)  -- the one massive direction.*)
(*    (ctrl)   a GENERIC rank-2 obstruction (identity) has det = 1 != *)
(*             0 => NO massless direction (FAIL_NO_MASSLESS_ABELIAN).  *)
(*                                                                     *)
(*  HONEST FENCE. CLOSED (Th_coqc over Q): the masslessness of the    *)
(*  photon EMERGES from rank-1 (det=0), and the mixing eigenvectors/  *)
(*  eigenvalues are exact. This is a CALIBRATED ELECTROWEAK DECODER   *)
(*  target, NOT "the Standard Model derived from the root": the gauge  *)
(*  algebra SU(2)xU(1), chirality, matter representations, the value  *)
(*  of thetaW, and the radiative corrections are NOT derived here and  *)
(*  must not be imported. The couplings g,g',v are free parameters    *)
(*  fixed by CODATA/PDG in electroweak_decoder_v0_3.py (calibration,  *)
(*  not prediction). Only the rank-1 => (massless + massive) STRUCTURE *)
(*  is the claim.                                                     *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoElectroweakNullDirection.
Open Scope Q_scope.

(* the four entries of M2(g,g',v), c = v^2/4 *)
Definition c (v : Q) : Q := v * v * (1 # 4).
Definition m11 (g gp v : Q) : Q := c v * (g * g).
Definition m12 (g gp v : Q) : Q := - (c v * (g * gp)).
Definition m21 (g gp v : Q) : Q := - (c v * (g * gp)).
Definition m22 (g gp v : Q) : Q := c v * (gp * gp).

(* m_Z^2 = (v^2/4)(g^2 + g'^2) *)
Definition mZ2 (g gp v : Q) : Q := c v * (g * g + gp * gp).

(* (det0) the neutral obstruction is singular for ALL g,g',v: det = 0. *)
Theorem det_neutral_zero : forall g gp v : Q,
  m11 g gp v * m22 g gp v - m12 g gp v * m21 g gp v == 0.
Proof. intros g gp v. unfold m11, m22, m12, m21, c. ring. Qed.

(* (photon) the null / massless direction is ~ (g', g): M2 . (g',g) = 0. *)
Theorem photon_null_direction : forall g gp v : Q,
  (m11 g gp v * gp + m12 g gp v * g == 0) /\
  (m21 g gp v * gp + m22 g gp v * g == 0).
Proof. intros g gp v. unfold m11, m12, m21, m22, c. split; ring. Qed.

(* (Z) the massive direction is ~ (g,-g') with eigenvalue m_Z^2. *)
Theorem Z_massive_eigenvector : forall g gp v : Q,
  (m11 g gp v * g + m12 g gp v * (- gp) == mZ2 g gp v * g) /\
  (m21 g gp v * g + m22 g gp v * (- gp) == mZ2 g gp v * (- gp)).
Proof. intros g gp v. unfold m11, m12, m21, m22, mZ2, c. split; ring. Qed.

(* the massive eigenvalue equals the trace (since the other eigenvalue is 0). *)
Theorem mZ2_is_trace : forall g gp v : Q,
  mZ2 g gp v == m11 g gp v + m22 g gp v.
Proof. intros g gp v. unfold mZ2, m11, m22, c. ring. Qed.

(* photon _|_ Z under G = I : (g',g).(g,-g') = 0. *)
Theorem photon_orthogonal_Z : forall g gp : Q, gp * g + g * (- gp) == 0.
Proof. intros g gp. ring. Qed.

(* (ctrl) FAILING control: a generic rank-2 obstruction (identity) has
   det = 1 != 0, so it admits NO nonzero null direction => no massless photon. *)
Theorem generic_rank2_det_is_one :
  (1 * 1 - 0 * 0 : Q) == 1.
Proof. ring. Qed.
Theorem generic_rank2_no_massless : ~ ((1 * 1 - 0 * 0 : Q) == 0).
Proof. intro H. rewrite generic_rank2_det_is_one in H. lra. Qed.

End InfoElectroweakNullDirection.

Print Assumptions InfoElectroweakNullDirection.det_neutral_zero.
Print Assumptions InfoElectroweakNullDirection.photon_null_direction.
Print Assumptions InfoElectroweakNullDirection.Z_massive_eigenvector.
Print Assumptions InfoElectroweakNullDirection.generic_rank2_no_massless.
