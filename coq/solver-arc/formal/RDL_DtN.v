(* =====================================================================
   RDL_DtN.v
   ---------------------------------------------------------------------
   TIER-0 NATIVE (axiom-free, over Q) — the machine-checked building blocks
   of the discrete Calderon / EIT inverse problem (Curtis-Morrow networks).

   The Dirichlet-to-Neumann (DtN) map of a resistor network is the Schur
   complement of the interior:  Lambda = L_BB - L_BI L_II^{-1} L_IB.
   This file proves, over Q, axiom-free:

     (1) BOUNDARY EDGE is directly recoverable: a single edge between two
         boundary nodes (no interior) has DtN Lambda = [[g,-g],[-g,g]], so
         g = Lambda_11 = -Lambda_12  EXACTLY  (the base case of CM peeling).

     (2) INTERIOR NODE collapses to the SERIES conductance: two edges g1,g2
         through one interior node give Lambda_11 = g1 g2/(g1+g2) — the
         harmonic/series law (explicit DtN formula).

     (3) INTERIOR NODE is UNDERDETERMINED: distinct (g1,g2) give the SAME
         DtN (e.g. (1,3) and (3,1), or (2,2) vs (1,1)+... ) -> the map
         (g1,g2) -> Lambda is NOT injective. This is the EXACT, honest reason
         EIT is hard: one boundary measurement cannot resolve interior
         conductances; many measurements / a 'critical' network are needed
         (Curtis-Morrow). spectrum->metric is worse still (Kac).

   coqc 8.20.1, Print Assumptions Closed under the global context.
   readout-not-truth: this certifies the STRUCTURE (recoverable base case +
   the precise underdetermination), NOT a full EIT reconstruction.
   ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Open Scope Q_scope.

(* ---- (1) boundary edge: DtN diagonal = the conductance, directly recoverable ---- *)
(* network: b1 -[g]- b2, no interior. L_BB = [[g,-g],[-g,g]] = the DtN itself. *)
Definition Lam_boundary_11 (g : Q) : Q := g.
Definition Lam_boundary_12 (g : Q) : Q := - g.

Theorem boundary_edge_recoverable : forall g,
  Lam_boundary_11 g == g  /\  Lam_boundary_12 g == - g  /\  g == Lam_boundary_11 g.
Proof. intro g. unfold Lam_boundary_11, Lam_boundary_12. repeat split; ring. Qed.

(* ---- (2) interior node: explicit DtN = series (harmonic) conductance ---- *)
(* network: b1 -[g1]- i -[g2]- b2.  L_II = g1+g2 (scalar), Schur complement gives
   Lambda_11 = g1 - g1^2/(g1+g2) = g1 g2/(g1+g2). *)
Definition Lam_series_11 (g1 g2 : Q) : Q := g1 - g1*g1/(g1+g2).

Theorem interior_is_series : forall g1 g2,
  0 < g1 + g2 ->
  Lam_series_11 g1 g2 == g1*g2/(g1+g2).
Proof.
  intros g1 g2 Hpos. unfold Lam_series_11.
  field. lra.
Qed.

(* symmetry: the (1,1) and (2,2) DtN diagonals coincide for the series cell *)
Definition Lam_series_22 (g1 g2 : Q) : Q := g2 - g2*g2/(g1+g2).
Theorem series_diag_symmetric : forall g1 g2,
  0 < g1 + g2 -> Lam_series_11 g1 g2 == Lam_series_22 g1 g2.
Proof. intros g1 g2 H. unfold Lam_series_11, Lam_series_22. field. lra. Qed.

(* ---- (3) interior node UNDERDETERMINED: distinct (g1,g2) give the SAME DtN ---- *)
(* the whole 2x2 DtN of the series cell is determined by the single number
   s = g1 g2/(g1+g2); so any two pairs with the same s are indistinguishable. *)
Definition series_val (g1 g2 : Q) : Q := g1*g2/(g1+g2).

Theorem interior_underdetermined :
  series_val (1#1) (3#1) == series_val (3#1) (1#1)  /\  ~ ((1#1) == (3#1)).
Proof.
  unfold series_val. split.
  - vm_compute. reflexivity.
  - intro H. vm_compute in H. discriminate.
Qed.

(* a non-permutation witness too: (2,6) and (3,3) both give series_val = 3/2 *)
Theorem interior_underdetermined_nonperm :
  series_val (2#1) (6#1) == series_val (3#1) (3#1)
  /\ ~ ((2#1) == (3#1)).
Proof.
  unfold series_val. split.
  - vm_compute. reflexivity.
  - intro H. vm_compute in H. discriminate.
Qed.

(* =====================================================================
   AXIOM AUDIT
   ===================================================================== *)
Print Assumptions boundary_edge_recoverable.
Print Assumptions interior_is_series.
Print Assumptions series_diag_symmetric.
Print Assumptions interior_underdetermined.
Print Assumptions interior_underdetermined_nonperm.

(* End RDL_DtN.v *)
