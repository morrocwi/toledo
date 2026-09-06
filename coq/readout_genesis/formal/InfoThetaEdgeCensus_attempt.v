(* ===================================================================== *)
(*  InfoThetaEdgeCensus_attempt.v — the Theta-direction census (n=3 case). *)
(*                                                                         *)
(*  CONTEXT (founder ruling 2026-08-08: Theta is elevated to a NEW ROOT    *)
(*  alongside reader Phi / record Psi / retained difference delta_R).      *)
(*  The living-geometry operator is affine in the geometry state:          *)
(*      G[Theta] = G_0 + Sum_a Theta^a G_a                                 *)
(*  but the index set of `a` was never declared anywhere in the corpus     *)
(*  (readout_universe survey, 2026-08-08).  This file closes that gap for  *)
(*  the 3-vertex case, from the root's OWN forced characterization:        *)
(*  admissible retained-difference operators are exactly the matrices      *)
(*  that are symmetric, zero-row-sum, off-diagonal <= 0 (the same three    *)
(*  properties that force L_R = D_W - W, readout_universe logic.md R-L /   *)
(*  R-L-uniq, Th_coqc there; re-used here as the DEFINITION of             *)
(*  admissibility, not re-proven).                                         *)
(*                                                                         *)
(*  Machine-checked here (all over Q, axiom-free — Print Assumptions):     *)
(*   T1 theta_census_exists_3 — every admissible 3x3 operator decomposes   *)
(*      as a NONNEGATIVE combination of the three single-edge Laplacians   *)
(*      L_{01}, L_{02}, L_{12}, with weights read directly off the         *)
(*      off-diagonal entries (w_e = -L_e-entry).                           *)
(*   T2 theta_census_unique_3 — that decomposition is UNIQUE.              *)
(*   T3 edge_generators_independent_3 — the three edge generators are      *)
(*      linearly independent (the census is exact: exactly 3 directions,   *)
(*      not fewer).                                                        *)
(*                                                                         *)
(*  READING (Dr tier, stated here as a comment, not a theorem): the        *)
(*  admissible deformation directions of the retained-difference operator  *)
(*  are ONE PER EDGE — one per retained pairwise distinction.  So the      *)
(*  natural realization of the affine law is G_0 = 0, a = edges,           *)
(*  G_a = L_e, Theta^e = the retained edge weight W_ij: Theta's component  *)
(*  structure is DISCRETE/COUNTABLE BY CONSTRUCTION (a finite edge set),   *)
(*  never an undeclared/continuous FAMILY of directions.  Scope of the     *)
(*  protection, stated precisely (per independent review): the             *)
(*  INDEX-CONTINUUM half of the retracted EQ-069..071 mistake — an         *)
(*  undeclared or continuous family of deformation directions — is         *)
(*  excluded at the index level (finite edge census).  The KNOB half —     *)
(*  sweeping one weight as a free tunable parameter and reading a smooth   *)
(*  bijection of it as an observable — is NOT excluded by this census:     *)
(*  each Theta^e remains a freely settable rational value, and the         *)
(*  standing discrete-only constraint (CONTINUUM_ARC_ERROR_NOTE.md         *)
(*  lessons 1 and 5) must still be enforced separately.  Nothing here      *)
(*  identifies edges with fermion generations or any physics — that would  *)
(*  be a new admissibility square, not built here (CRRC guard).            *)
(*                                                                         *)
(*  HONESTY NOTE on formalization depth: all three theorems are ENTRYWISE  *)
(*  transliterations — the matrix<->entry mapping (which Q-variable is     *)
(*  which entry of which single-edge Laplacian) is checked by inspection   *)
(*  of the canonical constants, not inside Coq.  Defining actual matrix    *)
(*  objects and proving the statements over them is the named next step    *)
(*  (THETA_ROOT_PROGRAM.md item 5.3), not claimed done here.               *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

Section ThetaCensus3.

(* a symmetric zero-row-sum matrix over Q, 3 vertices, entries named.      *)
Variables L00 L01 L02 L10 L11 L12 L20 L21 L22 : Q.

Hypothesis sym01 : (L01 == L10)%Q.
Hypothesis sym02 : (L02 == L20)%Q.
Hypothesis sym12 : (L12 == L21)%Q.
Hypothesis row0 : (L00 + L01 + L02 == 0)%Q.
Hypothesis row1 : (L10 + L11 + L12 == 0)%Q.
Hypothesis row2 : (L20 + L21 + L22 == 0)%Q.
Hypothesis offdiag01 : (L01 <= 0)%Q.
Hypothesis offdiag02 : (L02 <= 0)%Q.
Hypothesis offdiag12 : (L12 <= 0)%Q.

(* T1 · existence: weights w_e := -(off-diagonal entry) are nonnegative    *)
(* and reproduce every entry of L as  w01*L_{01} + w02*L_{02} + w12*L_{12} *)
(* (single-edge Laplacians: L_{01} = [[1,-1,0],[-1,1,0],[0,0,0]] etc.);    *)
(* the six independent components are listed, the mirrors follow by sym.   *)
Theorem theta_census_exists_3 :
  exists w01 w02 w12 : Q,
    (0 <= w01)%Q /\ (0 <= w02)%Q /\ (0 <= w12)%Q /\
    (L00 == w01 + w02)%Q /\ (L01 == - w01)%Q /\ (L02 == - w02)%Q /\
    (L11 == w01 + w12)%Q /\ (L12 == - w12)%Q /\ (L22 == w02 + w12)%Q.
Proof.
  exists (- L01)%Q, (- L02)%Q, (- L12)%Q.
  repeat split; lra.
Qed.

(* T2 · uniqueness: any two edge-weight decompositions coincide.           *)
Theorem theta_census_unique_3 :
  forall w01 w02 w12 v01 v02 v12 : Q,
    (L01 == - w01)%Q -> (L02 == - w02)%Q -> (L12 == - w12)%Q ->
    (L01 == - v01)%Q -> (L02 == - v02)%Q -> (L12 == - v12)%Q ->
    (w01 == v01)%Q /\ (w02 == v02)%Q /\ (w12 == v12)%Q.
Proof.
  intros w01 w02 w12 v01 v02 v12 Hw1 Hw2 Hw3 Hv1 Hv2 Hv3.
  repeat split; lra.
Qed.

End ThetaCensus3.

(* T3 · the three edge generators are linearly independent: the six        *)
(* independent components of a*L_{01} + b*L_{02} + c*L_{12} are            *)
(* (0,0)=a+b, (0,1)=-a, (0,2)=-b, (1,1)=a+c, (1,2)=-c, (2,2)=b+c;          *)
(* if all vanish, the coefficients vanish — the census is exactly 3        *)
(* directions.  (Corrected after independent review: an earlier draft      *)
(* hypothesized only the three off-diagonal slots, which understated the   *)
(* statement to a triviality; this version quantifies over the full        *)
(* entrywise vanishing, matching T1's six-component convention.)           *)
Theorem edge_generators_independent_3 :
  forall a b c : Q,
    (a + b == 0)%Q -> (- a == 0)%Q -> (- b == 0)%Q ->
    (a + c == 0)%Q -> (- c == 0)%Q -> (b + c == 0)%Q ->
    (a == 0)%Q /\ (b == 0)%Q /\ (c == 0)%Q.
Proof. intros; repeat split; lra. Qed.
