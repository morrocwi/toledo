(* ===================================================================== *)
(*  InfoThetaLivingOrientationSign_attempt.v — Coq witness for Theta 5.10  *)
(*  Phase P, item2 line: "living => J_Theta > 0" on the C4 support of the  *)
(*  extended (support-tied real skew) system, regime a=-1,b=1,K=mu=1,J=0   *)
(*  (companion: theta_oriented_skew_v1.py, theta_field_certification_v1.py,*)
(*  theta_living_sign_proof_v1.py).                                        *)
(*                                                                         *)
(*  ORCHESTRATOR-PROPOSED DECOMPOSITION (verified below, not taken on      *)
(*  faith — Lemma 1 confirmed EXACTLY as stated once the source files'     *)
(*  own sign/ordering conventions are tracked through; Lemma 2 remains the *)
(*  hard, [Open] part):                                                    *)
(*    Lemma 1 — on the vertex-reflection locus Z1=Z3 (Phi1=Phi3,           *)
(*      Psi1=Psi3), the ordered directed skew sources satisfy t23=-t12,    *)
(*      t30=-t01, hence J_Theta = t01*t12*t23*t30 = (t01*t12)^2 >= 0, and  *)
(*      > 0 once t01<>0 and t12<>0.  Symmetric statement on the rotated    *)
(*      locus Z0=Z2 (Phi0=Phi2, Psi0=Psi2): J_Theta = (t01*t23)^2.          *)
(*    Lemma 2 — every LIVING C4 fixed point lies on one of these two loci. *)
(*      Currently ONLY empirical (33/33 in theta_field_certification_v1.py *)
(*      Part 1: every regenerated living C4 FP classifies as class A       *)
(*      (Z1=Z3) or class B (Z0=Z2), 0 unclassified).  This file's Part 3   *)
(*      (T4) makes real but PARTIAL algebraic progress toward Lemma 2 —    *)
(*      the exact linearization of the vertex-1/vertex-3 difference        *)
(*      system decouples into a clean 2x2 matrix [[D,E],[F,D]] — a real    *)
(*      K_{2,2}-structure finding — but the FULL nonlinear closure         *)
(*      (that living-off-locus forces det=D^2-E*F=0 GLOBALLY, not just to  *)
(*      linear order) is NOT reached; the resultant eliminating the        *)
(*      quadratic remainder does not factor into a clean degenerate-       *)
(*      variety statement (checked with sympy, reported honestly below).   *)
(*      Lemma 2 stays [Open].                                              *)
(*                                                                         *)
(*  EXACT CONVENTIONS (verified against theta_oriented_skew_v1.py by       *)
(*  direct symbolic + 2000-trial exact-Fraction cross-check, not assumed): *)
(*  C4 support E = {(0,1),(1,2),(2,3),(0,3)}, cycle 0->1->2->3->0.  For an  *)
(*  edge (i,j) with i<j, t_{ij} := Phi_i*Psi_j - Phi_j*Psi_i (the file's    *)
(*  own `t[e]` skew source) and a_e := -t_e (Gate-D stationary, K=mu=1).    *)
(*  `directed_a`/`cyclic_product` in the source read a_e forward for i<j    *)
(*  and NEGATED for the reverse direction — for the C4 cycle this means    *)
(*  the ordered cyclic product of a's around 0->1->2->3->0 equals, after   *)
(*  the four uniform sign flips a_e=-t_e cancel over an EVEN 4-cycle, the   *)
(*  literal DIRECTED product t01*t12*t23*t30 where t30 := Phi3*Psi0 -       *)
(*  Phi0*Psi3 (the reverse-direction skew source, = -t_{03}).  This was     *)
(*  checked by direct exact-Fraction simulation of the source file's own   *)
(*  `directed_a`/`cyclic_product` functions, 2000 random trials, exact      *)
(*  match — see report.  J below is written out with this convention:      *)
(*  J := t01*t12*t23*t30, all four factors WRITTEN AS EXPLICIT              *)
(*  Phi/Psi polynomials in ordered (i<j or reversed) form, never as free    *)
(*  a_e symbols — this is what makes T1/T3 pure ring identities rather      *)
(*  than identities that need the a_e=-t_e substitution as a side lemma.   *)
(*                                                                         *)
(*  SCOPE (Th_coqc once `Print Assumptions` confirms axiom-freedom — see   *)
(*  report):                                                               *)
(*    T1  locus_Z1Z3_J_square   — Lemma 1, Z1=Z3 case, by ring.            *)
(*    T2a locus_Z1Z3_J_nonneg   — 0 <= J on that locus, by nra (square).    *)
(*    T2b locus_Z1Z3_J_pos      — t01<>0 /\ t12<>0 -> 0 < J on that locus. *)
(*    T3  locus_Z0Z2_J_square + corollaries — Lemma 1, rotated Z0=Z2 case, *)
(*        J = (t01*t23)^2 (NOT (t01*t12)^2 — the rotated pairing swaps      *)
(*        which two directed skew sources square together; verified        *)
(*        exactly below, not assumed by naive relabeling).                 *)
(*    T4  the difference-system linearization (K_{2,2} lever, per the      *)
(*        orchestrator's own hint that vertices 1,3 share neighborhood     *)
(*        {0,2}): T4a/T4b are exact ring (Taylor-decomposition) identities *)
(*        for the reader/record difference equations; T4c is a clean,      *)
(*        general 2x2-nondegeneracy corollary (nra/psatz).  STATED-NOT-    *)
(*        CLOSED: combining T4a-c into a full proof of Lemma 2 needs the    *)
(*        quadratic/cubic remainder terms (HOT_R, HOT_Rec below) to also   *)
(*        vanish off-locus, which is NOT shown — declared [Open]/Dr, see   *)
(*        the closing comment block.                                       *)
(*    T5  (Part 4, round 2) edge-locus exclusion: coinciding support-edge  *)
(*        endpoints force s_e = 0, contradicting the STRICT discordance    *)
(*        support rule — the four C4 edge instantiations + the two         *)
(*        edge-reflection corollaries close the J=0 edge-locus gap.        *)
(*                                                                         *)
(*  CRRC guard: no edge, orientation, skew value, cyclic product, or       *)
(*  J_Theta value in this file is ever identified with a generation, CKM   *)
(*  entry, mixing angle, color index, or family-slot count.  This file's   *)
(*  J_Theta is a real-valued oriented-cyclic-product readout of the        *)
(*  declared graph object ONLY — its identification with 5.4's Cq          *)
(*  quartet-J stays an UNBUILT, [Open] admissibility square (unchanged     *)
(*  from InfoThetaOrientedSkewObstruction_attempt.v's own guard).           *)
(*                                                                         *)
(*  Role-word discipline: authored/run by role (doer), not AI-model name;  *)
(*  no model name appears anywhere in this file's content.                 *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ========================================================================
   Part 1 — Lemma 1, vertex-reflection locus Z1=Z3 (Phi1=Phi3, Psi1=Psi3).
   J := t01*t12*t23*t30, the four directed skew sources around the cycle
   0->1->2->3->0, written explicitly (never as free a_e/t_e symbols):
     t01 := Phi0*Psi1 - Phi1*Psi0        (forward, edge (0,1))
     t12 := Phi1*Psi2 - Phi2*Psi1        (forward, edge (1,2))
     t23 := Phi2*Psi3 - Phi3*Psi2        (forward, edge (2,3))
     t30 := Phi3*Psi0 - Phi0*Psi3        (reverse direction of edge (0,3))
   ======================================================================== *)

Theorem locus_Z1Z3_J_square :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q -> (Psi1 == Psi3)%Q ->
    ((Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
     * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3)
     == ((Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1))
        * ((Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2.
  rewrite H1, H2. ring.
Qed.

(* Shared helper: any rational's square is nonnegative. *)
Lemma qsquare_nonneg : forall x : Q, (0 <= x*x)%Q.
Proof.
  intro x.
  destruct (Qlt_le_dec x 0) as [Hlt | Hge].
  - nra.
  - nra.
Qed.

Corollary locus_Z1Z3_J_nonneg :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q -> (Psi1 == Psi3)%Q ->
    (0 <= (Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
          * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2.
  rewrite (locus_Z1Z3_J_square Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2).
  apply qsquare_nonneg.
Qed.

(* Shared helper: a nonzero rational's square is strictly positive. *)
Lemma qsquare_pos_of_nonzero : forall x : Q, ~ (x == 0)%Q -> (0 < x*x)%Q.
Proof.
  intros x Hx.
  destruct (Qlt_le_dec x 0) as [Hlt | Hge].
  - nra.
  - destruct (Qle_lteq 0 x) as [Hiff _].
    destruct (Hiff Hge) as [Hpos | Heq0].
    + nra.
    + exfalso. apply Hx. symmetry. exact Heq0.
Qed.

Corollary locus_Z1Z3_J_pos :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q -> (Psi1 == Psi3)%Q ->
    ~ ((Phi0*Psi1 - Phi1*Psi0) == 0)%Q ->
    ~ ((Phi1*Psi2 - Phi2*Psi1) == 0)%Q ->
    (0 < (Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
         * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2 Ht01 Ht12.
  rewrite (locus_Z1Z3_J_square Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2).
  apply qsquare_pos_of_nonzero.
  intro Hz.
  (* (t01*t12) == 0 in Q forces t01==0 \/ t12==0 — standard field fact. *)
  apply (Qmult_integral (Phi0*Psi1 - Phi1*Psi0) (Phi1*Psi2 - Phi2*Psi1)) in Hz.
  destruct Hz as [Hz1 | Hz2].
  - apply Ht01. exact Hz1.
  - apply Ht12. exact Hz2.
Qed.

(* ========================================================================
   Part 2 — Lemma 1, ROTATED locus Z0=Z2 (Phi0=Phi2, Psi0=Psi2).  Under
   this locus J collapses to (t01*t23)^2 — NOT (t01*t12)^2 — verified
   exactly below, not assumed by naive relabeling of Part 1.
   ======================================================================== *)

Theorem locus_Z0Z2_J_square :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q -> (Psi0 == Psi2)%Q ->
    ((Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
     * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3)
     == ((Phi0*Psi1 - Phi1*Psi0) * (Phi2*Psi3 - Phi3*Psi2))
        * ((Phi0*Psi1 - Phi1*Psi0) * (Phi2*Psi3 - Phi3*Psi2)))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2.
  rewrite H1, H2. ring.
Qed.

Corollary locus_Z0Z2_J_nonneg :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q -> (Psi0 == Psi2)%Q ->
    (0 <= (Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
          * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2.
  rewrite (locus_Z0Z2_J_square Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2).
  apply qsquare_nonneg.
Qed.

Corollary locus_Z0Z2_J_pos :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q -> (Psi0 == Psi2)%Q ->
    ~ ((Phi0*Psi1 - Phi1*Psi0) == 0)%Q ->
    ~ ((Phi2*Psi3 - Phi3*Psi2) == 0)%Q ->
    (0 < (Phi0*Psi1 - Phi1*Psi0) * (Phi1*Psi2 - Phi2*Psi1)
         * (Phi2*Psi3 - Phi3*Psi2) * (Phi3*Psi0 - Phi0*Psi3))%Q.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2 Ht01 Ht23.
  rewrite (locus_Z0Z2_J_square Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2).
  apply qsquare_pos_of_nonzero.
  intro Hz.
  apply (Qmult_integral (Phi0*Psi1 - Phi1*Psi0) (Phi2*Psi3 - Phi3*Psi2)) in Hz.
  destruct Hz as [Hz1 | Hz2].
  - apply Ht01. exact Hz1.
  - apply Ht23. exact Hz2.
Qed.

(* ========================================================================
   Part 3 — T4, the difference-system lever toward Lemma 2 (attempt,
   PARTIAL, honestly fenced — see closing comment).

   Setting: the Gate-D-stationary C4 reader equations (K=mu=1, a=-1, b=1,
   support E={(0,1),(1,2),(2,3),(0,3)}, w_e*=-s_e, a_e*=-t_e, G=L[w*]+A[a*]
   reader / G^T=L[w*]-A[a*] record — theta_field_certification_v1.py's own
   `build_exact_system`, REUSED verbatim not re-derived) give, at vertex 1
   and vertex 3 (both neighbors of exactly {0,2} in C4 — the K_{2,2}
   structure the orchestrator named):
     Reader_1 - Reader_3 =: diffR(Phi0..Psi3)   (a cubic polynomial)
     Record_1 - Record_3 =: diffRec(Phi0..Psi3) (a cubic polynomial)
   Substituting Phi1 = Phi3 + dPhi, Psi1 = Psi3 + dPsi (an exact,
   invertible reparametrization — NOT an approximation), both diffR and
   diffRec are IDENTICALLY ZERO at dPhi=dPsi=0 (confirming the locus is
   trivially compatible with vertex-1/vertex-3 agreement, as expected),
   and admit an EXACT (Taylor, but exact since these are polynomials, not
   general functions) decomposition
     diffR   = D*dPhi + E*dPsi + HOT_R
     diffRec = F*dPhi + D*dPsi + HOT_Rec
   with D appearing on BOTH diagonal slots (a genuine, non-obvious
   K_{2,2}-symmetry finding, verified below by ring, not assumed) — see
   T4a/T4b.  HOT_R, HOT_Rec are the quadratic+cubic remainder in
   (dPhi,dPsi) (NOT shown to vanish off-locus — this is exactly what stays
   open, see below).

   T4c is the clean, general, PSATZ-provable fact: IF the remainder were
   absent (i.e. if HOT_R=HOT_Rec=0, e.g. to leading/tangent order), THEN
   det[[D,E],[F,D]] = D*D - E*F <> 0 forces dPhi=dPsi=0.  This is the
   honest, closed-form NECESSARY condition for local rigidity of the
   locus; it is NOT, by itself, a proof that every living FP lies on the
   locus, because HOT_R/HOT_Rec are not shown to vanish in general — see
   the closing comment block for exactly what remains [Open].
   ======================================================================== *)

Theorem diffR_taylor_identity :
  forall Phi0 Phi2 Phi3 Psi0 Psi2 Psi3 dPhi dPsi : Q,
    (
      (* diffR, exactly, with Phi1:=Phi3+dPhi, Psi1:=Psi3+dPsi substituted *)
      dPhi*dPhi*dPhi + (-1#1)*dPhi
      + Psi0*dPhi*dPhi + Psi2*dPhi*dPhi + (-2#1)*Psi3*dPhi*dPhi
      + (-2#1)*dPsi*Phi3*Phi3 + (-2#1)*dPsi*dPhi*dPhi
      + (3#1)*Phi3*dPhi*dPhi + (3#1)*dPhi*Phi3*Phi3
      + (-4#1)*Phi3*Psi3*dPhi + (-4#1)*Phi3*dPhi*dPsi
      + (-3#1)*Phi0*Psi0*dPhi + (-3#1)*Phi2*Psi2*dPhi
      + (2#1)*Phi0*Phi3*dPsi + (2#1)*Phi0*Psi3*dPhi + (2#1)*Phi0*dPhi*dPsi
      + (2#1)*Phi2*Phi3*dPsi + (2#1)*Phi2*Psi3*dPhi + (2#1)*Phi2*dPhi*dPsi
      + (2#1)*Phi3*Psi0*dPhi + (2#1)*Phi3*Psi2*dPhi
      ==
      (* D*dPhi + E*dPsi *)
      ( ((-1#1) + (3#1)*Phi3*Phi3 + (-4#1)*Phi3*Psi3
         + (-3#1)*Phi0*Psi0 + (-3#1)*Phi2*Psi2
         + (2#1)*Phi0*Psi3 + (2#1)*Phi2*Psi3
         + (2#1)*Phi3*Psi0 + (2#1)*Phi3*Psi2) * dPhi )
      + ( ((-2#1)*Phi3*Phi3 + (2#1)*Phi0*Phi3 + (2#1)*Phi2*Phi3) * dPsi )
      +
      (* HOT_R, the quadratic+cubic remainder *)
      ( (1#1)*dPhi*dPhi*dPhi + (1#1)*Psi0*dPhi*dPhi + (1#1)*Psi2*dPhi*dPhi
        + (-2#1)*Psi3*dPhi*dPhi + (-2#1)*dPsi*dPhi*dPhi + (3#1)*Phi3*dPhi*dPhi
        + (-4#1)*Phi3*dPhi*dPsi + (2#1)*Phi0*dPhi*dPsi + (2#1)*Phi2*dPhi*dPsi )
    )%Q.
Proof. intros. ring. Qed.

Theorem diffRec_taylor_identity :
  forall Phi0 Phi2 Phi3 Psi0 Psi2 Psi3 dPhi dPsi : Q,
    (
      (* diffRec, exactly, with Phi1:=Phi3+dPhi, Psi1:=Psi3+dPsi substituted *)
      (-1#1)*dPsi
      + Phi0*dPsi*dPsi + Phi2*dPsi*dPsi + (-2#1)*Phi3*dPsi*dPsi
      + (-2#1)*dPhi*Psi3*Psi3 + (-2#1)*dPhi*dPsi*dPsi
      + (3#1)*Psi3*dPhi*dPhi + (3#1)*dPsi*Phi3*Phi3 + (3#1)*dPsi*dPhi*dPhi
      + (-4#1)*Phi3*Psi3*dPsi + (-4#1)*Psi3*dPhi*dPsi
      + (-3#1)*Phi0*Psi0*dPsi + (-3#1)*Phi2*Psi2*dPsi
      + (2#1)*Phi0*Psi3*dPsi + (2#1)*Phi2*Psi3*dPsi
      + (2#1)*Phi3*Psi0*dPsi + (2#1)*Phi3*Psi2*dPsi
      + (2#1)*Psi0*Psi3*dPhi + (2#1)*Psi0*dPhi*dPsi
      + (2#1)*Psi2*Psi3*dPhi + (2#1)*Psi2*dPhi*dPsi
      + (6#1)*Phi3*Psi3*dPhi + (6#1)*Phi3*dPhi*dPsi
      ==
      (* F*dPhi + D*dPsi *)
      ( (((-2#1)*Psi3*Psi3 + (2#1)*Psi0*Psi3 + (2#1)*Psi2*Psi3
          + (6#1)*Phi3*Psi3) * dPhi) )
      + ( (((-1#1) + (3#1)*Phi3*Phi3 + (-4#1)*Phi3*Psi3
            + (-3#1)*Phi0*Psi0 + (-3#1)*Phi2*Psi2
            + (2#1)*Phi0*Psi3 + (2#1)*Phi2*Psi3
            + (2#1)*Phi3*Psi0 + (2#1)*Phi3*Psi2) * dPsi) )
      +
      (* HOT_Rec, the quadratic+cubic remainder *)
      ( (1#1)*Phi0*dPsi*dPsi + (1#1)*Phi2*dPsi*dPsi + (-2#1)*Phi3*dPsi*dPsi
        + (-2#1)*dPhi*dPsi*dPsi + (3#1)*Psi3*dPhi*dPhi + (3#1)*dPsi*dPhi*dPhi
        + (-4#1)*Psi3*dPhi*dPsi + (2#1)*Psi0*dPhi*dPsi + (2#1)*Psi2*dPhi*dPsi
        + (6#1)*Phi3*dPhi*dPsi )
    )%Q.
Proof. intros. ring. Qed.

(* T4c — the clean, general 2x2-nondegeneracy fact behind the [[D,E],[F,D]]
   structure T4a/T4b exposed: IF the difference system were exactly its
   own linear part (D*dPhi+E*dPsi == 0, F*dPhi+D*dPsi == 0 — i.e. HOT_R,
   HOT_Rec were 0), THEN D*D <> E*F forces dPhi==0 /\ dPsi==0.  Standard
   Cramer's-rule fact for a symmetric-diagonal 2x2 system, general over Q. *)
Theorem linear_diff_system_nondegenerate :
  forall D E F dPhi dPsi : Q,
    (D*dPhi + E*dPsi == 0)%Q ->
    (F*dPhi + D*dPsi == 0)%Q ->
    ~ (D*D == E*F)%Q ->
    (dPhi == 0)%Q /\ (dPsi == 0)%Q.
Proof.
  intros D E F dPhi dPsi H1 H2 Hdet.
  assert (Hcomb : (D*(D*dPhi + E*dPsi) - E*(F*dPhi + D*dPsi)
                   == (D*D - E*F)*dPhi)%Q) by ring.
  assert (Hcomb2 : (F*(D*dPhi + E*dPsi) - D*(F*dPhi + D*dPsi)
                    == (F*E - D*D)*dPsi)%Q) by ring.
  rewrite H1, H2 in Hcomb.
  rewrite H1, H2 in Hcomb2.
  assert (HdPhi : ((D*D - E*F)*dPhi == 0)%Q) by (rewrite <- Hcomb; ring).
  assert (HdPsi : ((F*E - D*D)*dPsi == 0)%Q) by (rewrite <- Hcomb2; ring).
  split.
  - apply (Qmult_integral (D*D - E*F) dPhi) in HdPhi.
    destruct HdPhi as [Hz | Hok].
    + exfalso. apply Hdet. lra.
    + exact Hok.
  - apply (Qmult_integral (F*E - D*D) dPsi) in HdPsi.
    destruct HdPsi as [Hz | Hok].
    + exfalso. apply Hdet. lra.
    + exact Hok.
Qed.

(* ========================================================================
   Part 4 — T5, EDGE-reflection loci close the J=0 gap analytically (round-2
   doer, Task 1).  Convention verified directly against
   theta_oriented_skew_v1.py's `ext_living_fp` (the file's own admissibility
   gate, not re-derived): for the discordance s_e := (Phi_i-Phi_j)*(Psi_i-
   Psi_j) on a support edge e=(i,j), i<j, a living FP is accepted only if
   `not any(s[e] >= -1e-9 for e in support)`, i.e. s_e STRICTLY NEGATIVE on
   EVERY support edge (the C4 support rule, 5.2a).  On an edge-reflection
   locus (e.g. Z0=Z1: Phi0==Phi1, Psi0==Psi1 — the reflection through the
   (0,1)-(2,3) edge-midpoint axis swapping 0<->1, 2<->3), the symmetric
   discordance s01 collapses to 0 * 0 = 0 by construction, which can never
   be strictly negative — so no admissible C4 support with edge (0,1) in it
   can have a living FP sitting on that locus.  Since ALL FOUR C4 edges
   (0,1),(1,2),(2,3),(0,3) are in the support, the same one-line argument
   closes EVERY edge coincidence, which is what "edge-reflection locus"
   (Z0=Z1 forces Z2=Z3 too, and symmetrically Z1=Z2 forces Z3=Z0) reduces
   to: it only takes ONE coinciding edge-pair for the contradiction to
   fire, so the two-edge "reflection" framing is not needed as a separate
   case — proven once, generically, then instantiated on all 4 edges.
   ======================================================================== *)

(* T5a — the generic one-line fact: equal vertex fields force zero
   discordance on that edge, for ANY pair of vertex-field readouts. *)
Theorem edge_locus_kills_support :
  forall Phi_i Phi_j Psi_i Psi_j : Q,
    (Phi_i == Phi_j)%Q -> (Psi_i == Psi_j)%Q ->
    ((Phi_i - Phi_j) * (Psi_i - Psi_j) == 0)%Q.
Proof.
  intros Phi_i Phi_j Psi_i Psi_j H1 H2.
  rewrite H1, H2. ring.
Qed.

(* T5b — the corollary that actually closes the gap: zero discordance is
   incompatible with the support rule's STRICT negativity requirement. *)
Corollary edge_locus_incompatible_with_strict_support_rule :
  forall Phi_i Phi_j Psi_i Psi_j : Q,
    (Phi_i == Phi_j)%Q -> (Psi_i == Psi_j)%Q ->
    ((Phi_i - Phi_j) * (Psi_i - Psi_j) < 0)%Q ->
    False.
Proof.
  intros Phi_i Phi_j Psi_i Psi_j H1 H2 Hneg.
  rewrite (edge_locus_kills_support Phi_i Phi_j Psi_i Psi_j H1 H2) in Hneg.
  apply (Qlt_irrefl 0). exact Hneg.
Qed.

(* T5c-f — the four named C4-support-edge instantiations, spelled out so a
   reader does not need to re-derive the substitution per edge.  Each says:
   no admissible living C4 FP (in the sense of the strict support rule
   above) can lie on the corresponding vertex-coincidence locus. *)
Corollary c4_edge01_locus_excluded :
  forall Phi0 Phi1 Psi0 Psi1 : Q,
    (Phi0 == Phi1)%Q -> (Psi0 == Psi1)%Q ->
    ((Phi0 - Phi1) * (Psi0 - Psi1) < 0)%Q -> False.
Proof. exact edge_locus_incompatible_with_strict_support_rule. Qed.

Corollary c4_edge12_locus_excluded :
  forall Phi1 Phi2 Psi1 Psi2 : Q,
    (Phi1 == Phi2)%Q -> (Psi1 == Psi2)%Q ->
    ((Phi1 - Phi2) * (Psi1 - Psi2) < 0)%Q -> False.
Proof. exact edge_locus_incompatible_with_strict_support_rule. Qed.

Corollary c4_edge23_locus_excluded :
  forall Phi2 Phi3 Psi2 Psi3 : Q,
    (Phi2 == Phi3)%Q -> (Psi2 == Psi3)%Q ->
    ((Phi2 - Phi3) * (Psi2 - Psi3) < 0)%Q -> False.
Proof. exact edge_locus_incompatible_with_strict_support_rule. Qed.

Corollary c4_edge03_locus_excluded :
  forall Phi0 Phi3 Psi0 Psi3 : Q,
    (Phi0 == Phi3)%Q -> (Psi0 == Psi3)%Q ->
    ((Phi0 - Phi3) * (Psi0 - Psi3) < 0)%Q -> False.
Proof. exact edge_locus_incompatible_with_strict_support_rule. Qed.

(* T5g — the two-edge "reflection" statements named in the round-2 brief,
   for completeness: the fixed locus of the (0,1)<->(2,3) edge-swap
   reflection (Z0=Z1 AND Z2=Z3) already fails via edge (0,1) alone; same
   for the (1,2)<->(3,0) reflection via edge (1,2) alone.  Stated as
   explicit conjunction hypotheses so the correspondence to "edge-
   reflection locus" (not just "one coinciding edge") is visible. *)
Corollary c4_reflection_01_23_excluded :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi1)%Q -> (Psi0 == Psi1)%Q ->
    (Phi2 == Phi3)%Q -> (Psi2 == Psi3)%Q ->
    ((Phi0 - Phi1) * (Psi0 - Psi1) < 0)%Q -> False.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2 _ _ Hneg.
  exact (edge_locus_incompatible_with_strict_support_rule Phi0 Phi1 Psi0 Psi1 H1 H2 Hneg).
Qed.

Corollary c4_reflection_12_30_excluded :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi2)%Q -> (Psi1 == Psi2)%Q ->
    (Phi3 == Phi0)%Q -> (Psi3 == Psi0)%Q ->
    ((Phi1 - Phi2) * (Psi1 - Psi2) < 0)%Q -> False.
Proof.
  intros Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 H1 H2 _ _ Hneg.
  exact (edge_locus_incompatible_with_strict_support_rule Phi1 Phi2 Psi1 Psi2 H1 H2 Hneg).
Qed.

(* ========================================================================
   HONEST CLOSING NOTE on T4 / Lemma 2 (Dr / [Open], not a Coq theorem):

   T4a+T4b are exact, machine-checked (ring) decompositions of the REAL
   vertex-1/vertex-3 difference equations into (linear part) + (quadratic/
   cubic remainder).  T4c is a machine-checked (psatz-style, via ring +
   Qmult_integral), fully general fact about 2x2 systems of THIS
   [[D,E],[F,D]] shape.  Composing them would require HOT_R = 0 and
   HOT_Rec = 0 off the locus too — this is NOT shown, and is very likely
   FALSE in general off-locus (HOT_R, HOT_Rec are honestly-nonzero cubic
   polynomials in dPhi,dPsi themselves).  Consequently:

   - What is PROVEN (Th_coqc, this file): the LINEARIZATION of the
     vertex-1/vertex-3 difference system at the locus has Jacobian
     [[D,E],[F,D]], and this SPECIFIC symmetric-diagonal 2x2 shape is
     non-degenerate (forces the trivial solution) whenever D*D <> E*F —
     a genuine, closed K_{2,2}-structure fact, not present in the naive
     8-variable system before exploiting vertex-1/vertex-3's shared
     neighborhood {0,2}.
   - What is Dr (paper-level, sympy-verified, NOT Coq-checked): at an
     actual class-A living FP found by theta_oriented_skew_v1.py's own
     Newton search (seed=551), D*D - E*F evaluates to a strictly positive
     rational-valued float (~2.95, computed in the accompanying report) —
     consistent with (not proof of) local rigidity of the locus at every
     living FP actually found, and consistent with the empirical 33/33
     on-locus finding in theta_field_certification_v1.py.
   - What stays [Open]: the FULL global algebraic closure of Lemma 2.  An
     attempted resultant elimination of dPsi from (diffR, diffRec) over Q
     (via sympy, reported in the companion report) produces `-dPhi *
     (a large, degree-5-in-dPhi, unfactored polynomial)` — i.e. dPhi=0
     (the locus) is CONFIRMED as always a solution branch (consistent
     with T4a/T4b), but the OTHER factor does not reduce to the clean
     "D*D == E*F" degenerate-variety statement T4c's hypothesis would
     need for a full off-locus exclusion; sympy's own `factor` leaves it
     irreducible over Q.  Whether that residual factor can ever vanish
     simultaneously with a genuine living-FP admissibility constraint
     (s_e < 0 on every C4 edge, etc.) is UNDETERMINED here.  Lemma 2
     itself therefore remains [Open]/finite_diagnostic-only (the 33/33
     empirical census), not Th_coqc — reported honestly, not overclaimed.
   ======================================================================== *)
