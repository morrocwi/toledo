(* ===================================================================== *)
(*  InfoThetaSectorSpectrum_attempt.v — sector-census spectrum facts,      *)
(*  step 5.1 of THETA_ROOT_PROGRAM.md (companion to                        *)
(*  theta_sector_census_v1.py).                                            *)
(*                                                                         *)
(*  Machine-checked here, for EVERY rational edge weight w (not a fixture):*)
(*                                                                         *)
(*   S1 k3_invariance_forces_uniform / p3_invariance_forces_uniform —      *)
(*      symmetry-invariance of an admissible operator forces equal         *)
(*      weights on each edge-orbit (K3 under two generating S3             *)
(*      transpositions; P3 under the end swap): the ORBIT census IS the    *)
(*      surviving-parameter count.                                         *)
(*   S2 k3_spectrum_* — the S3-invariant K3 operator has eigenvalue 0 on   *)
(*      (1,1,1) and eigenvalue 3w on BOTH (1,-1,0) and (1,0,-1):           *)
(*      degenerate top level, for every w.                                 *)
(*   S3 p3_spectrum_* + p3_levels_distinct — the Z2-invariant P3 operator  *)
(*      has eigenvalues 0, w, 3w on (1,1,1), (1,0,-1), (1,-2,1), and for   *)
(*      every w > 0 the three levels are pairwise DISTINCT.                *)
(*                                                                         *)
(*  READING (Dr, comment only): with the SAME retained-parameter budget    *)
(*  (one invariant direction each — S1), the path topology yields three    *)
(*  distinct spectral levels while the complete topology cannot:           *)
(*  distinguishing power lives in TOPOLOGY.  Re-derives item1 Attempt      *)
(*  10's K3/S3 degeneracy at the census level.                             *)
(*                                                                         *)
(*  HONESTY NOTE on formalization depth (same convention as                *)
(*  InfoThetaEdgeCensus_attempt.v): all statements are ENTRYWISE           *)
(*  transliterations — the matrix<->entry mapping (which expression is     *)
(*  which entry of the K3/P3 Laplacian, which triple is which              *)
(*  eigenvector) is fixed by the canonical constants in the comments and   *)
(*  checked by inspection, not inside Coq.  Completeness of the listed     *)
(*  spectra (that each eigenvector triple spans Q^3, so no further         *)
(*  eigenvalue exists) is established by exact determinant in the Python   *)
(*  companion (theta_sector_census_v1.py), not inside Coq.  Matrix-level   *)
(*  objects remain the named next step (THETA_ROOT_PROGRAM.md item 5.3).   *)
(*                                                                         *)
(*  CRRC guard (binding): nothing here identifies P3, its levels, or any   *)
(*  graph with fermion generations — that admissibility square is NOT      *)
(*  built here.  These are structural facts future candidates are          *)
(*  measured against.                                                      *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  S1 · invariance forces per-orbit uniform weights.                      *)
(*                                                                         *)
(*  K3 Laplacian entries: L01=-w01, L02=-w02, L12=-w12 (off-diagonal).     *)
(*  Invariance under the transposition (0 1) maps entry (0,2)->(1,2):     *)
(*  -w02 = -w12; under (1 2) maps (0,1)->(0,2): -w01 = -w02.               *)
(* ---------------------------------------------------------------------- *)
Theorem k3_invariance_forces_uniform :
  forall w01 w02 w12 : Q,
    (- w02 == - w12)%Q ->      (* invariance under transposition (0 1) *)
    (- w01 == - w02)%Q ->      (* invariance under transposition (1 2) *)
    (w01 == w02)%Q /\ (w02 == w12)%Q /\ (w01 == w12)%Q.
Proof. intros; repeat split; lra. Qed.

(*  P3 Laplacian (path 0-1-2) off-diagonal entries: L01=-w01, L12=-w12,    *)
(*  L02=0.  The end swap (0 2) maps entry (0,1)->(2,1): -w01 = -w12.       *)
Theorem p3_invariance_forces_uniform :
  forall w01 w12 : Q,
    (- w01 == - w12)%Q ->      (* invariance under the end swap (0 2) *)
    (w01 == w12)%Q.
Proof. intros; lra. Qed.

(* ---------------------------------------------------------------------- *)
(*  S2 · K3 with uniform weight w:                                         *)
(*  L = [[2w,-w,-w],[-w,2w,-w],[-w,-w,2w]].                                *)
(*  Each theorem lists the three components of L*v = lambda*v.             *)
(* ---------------------------------------------------------------------- *)
Theorem k3_spectrum_zero :
  forall w : Q,
    (2*w*1 + (-w)*1 + (-w)*1 == 0*1)%Q /\
    ((-w)*1 + 2*w*1 + (-w)*1 == 0*1)%Q /\
    ((-w)*1 + (-w)*1 + 2*w*1 == 0*1)%Q.
Proof. intros; repeat split; ring. Qed.

Theorem k3_spectrum_top_a :   (* eigenvector (1,-1,0), eigenvalue 3w *)
  forall w : Q,
    (2*w*1 + (-w)*(-1) + (-w)*0 == 3*w*1)%Q /\
    ((-w)*1 + 2*w*(-1) + (-w)*0 == 3*w*(-1))%Q /\
    ((-w)*1 + (-w)*(-1) + 2*w*0 == 3*w*0)%Q.
Proof. intros; repeat split; ring. Qed.

Theorem k3_spectrum_top_b :   (* eigenvector (1,0,-1), SAME eigenvalue 3w *)
  forall w : Q,
    (2*w*1 + (-w)*0 + (-w)*(-1) == 3*w*1)%Q /\
    ((-w)*1 + 2*w*0 + (-w)*(-1) == 3*w*0)%Q /\
    ((-w)*1 + (-w)*0 + 2*w*(-1) == 3*w*(-1))%Q.
Proof. intros; repeat split; ring. Qed.

(* ---------------------------------------------------------------------- *)
(*  S3 · P3 (path 0-1-2) with uniform weight w:                            *)
(*  L = [[w,-w,0],[-w,2w,-w],[0,-w,w]].                                    *)
(* ---------------------------------------------------------------------- *)
Theorem p3_spectrum_zero :
  forall w : Q,
    (w*1 + (-w)*1 + 0*1 == 0*1)%Q /\
    ((-w)*1 + 2*w*1 + (-w)*1 == 0*1)%Q /\
    (0*1 + (-w)*1 + w*1 == 0*1)%Q.
Proof. intros; repeat split; ring. Qed.

Theorem p3_spectrum_mid :     (* eigenvector (1,0,-1), eigenvalue w *)
  forall w : Q,
    (w*1 + (-w)*0 + 0*(-1) == w*1)%Q /\
    ((-w)*1 + 2*w*0 + (-w)*(-1) == w*0)%Q /\
    (0*1 + (-w)*0 + w*(-1) == w*(-1))%Q.
Proof. intros; repeat split; ring. Qed.

Theorem p3_spectrum_top :     (* eigenvector (1,-2,1), eigenvalue 3w *)
  forall w : Q,
    (w*1 + (-w)*(-2) + 0*1 == 3*w*1)%Q /\
    ((-w)*1 + 2*w*(-2) + (-w)*1 == 3*w*(-2))%Q /\
    (0*1 + (-w)*(-2) + w*1 == 3*w*1)%Q.
Proof. intros; repeat split; ring. Qed.

(*  the three P3 levels are pairwise distinct for every positive weight.   *)
Theorem p3_levels_distinct :
  forall w : Q, (0 < w)%Q ->
    ~ (0 == w)%Q /\ ~ (0 == 3*w)%Q /\ ~ (w == 3*w)%Q.
Proof. intros w Hw; repeat split; lra. Qed.
