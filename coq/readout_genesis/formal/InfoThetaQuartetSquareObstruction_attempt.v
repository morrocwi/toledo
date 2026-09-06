(* ===================================================================== *)
(*  InfoThetaQuartetSquareObstruction_attempt.v -- item 2 Attempt / Theta   *)
(*  program step 5.7: the quartet-square obstruction.  Companion:           *)
(*  theta_quartet_square_v1.py.  Reads (does not modify, does not re-file)  *)
(*  the Cq/quartetJ machinery of InfoCPEquivariantGenerationBound_attempt.v *)
(*  and the cyclic_product_switching_invariant_*/qsign_exists/               *)
(*  tree_gauge_fixable_* machinery of InfoThetaOrientedSkewObstruction_     *)
(*  attempt.v; per this arc's own house precedent (see                      *)
(*  InfoThetaCPSquareObstruction_attempt.v, which independently redeclares  *)
(*  its own local Cq/Cmul/Cconj rather than `Require`-ing across attempt    *)
(*  files), the Gaussian-rational representation is TRANSCRIBED here        *)
(*  verbatim (same field names, same Cmul/Cconj formulas) rather than       *)
(*  imported, so this file stays a single self-contained `coqc -q` unit.    *)
(*  `quartetJraw` below is the SAME construction as that file's `quartetJ`  *)
(*  (`Im(V01*V12*conj(V02)*conj(V11))`), restricted to its four read        *)
(*  entries directly as arguments -- the full `mat`/`entry`/list apparatus  *)
(*  is not needed by any theorem in this file and is not rebuilt.           *)
(*                                                                          *)
(*  ORCHESTRATOR RULINGS carried (binding, not re-litigated here; full      *)
(*  text in THETA_ROOT_PROGRAM.md 5.7 (the design record)  ): the          *)
(*  eigenbasis-mismatch route (R1) is diagnostic-only and NOT built in      *)
(*  Coq; this file is ONE primary route (holonomy/rephasing, R2) plus       *)
(*  grafts, filing the ONE shared rescaling lemma once (T1); numeric        *)
(*  fractions belong to a disclosed fresh python sweep, not this file; no   *)
(*  AI-model identity appears anywhere below (role words only); the        *)
(*  verdict this file supports is OBSTRUCTED -- nothing here states or     *)
(*  implies item 2's [Open] status changes, and nothing here identifies a   *)
(*  generation count, CKM entry, level, or color index (CRRC guard,         *)
(*  checked by inspection: the symbols `Phi_i, Psi_i, w_e, a_e, D_i, eps_v, *)
(*  V_ij, alpha_i, beta_j, Z_i` below are role-local to this square only).  *)
(*                                                                          *)
(*  SCOPE / TIER LEDGER (honest fence -- read before citing):               *)
(*   T1 quartet_rescale_invariant       -- Th_coqc, ring, unconditional     *)
(*      GIVEN the four unit-modulus hypotheses (general Cq entries).        *)
(*      Subsumes the three routes' independently-derived versions of the    *)
(*      same rephasing-invariance fact -- filed ONCE, per orchestrator      *)
(*      ruling 2.  T1b is a free unconditional bonus (real-scalar degree-4  *)
(*      homogeneity, no hypothesis needed at all).                          *)
(*   T2 family_B_K3_exact               -- Th_coqc, ring, unconditional.    *)
(*   T3 family_B_C4_vanishes            -- Th_coqc, ring, unconditional.    *)
(*   T4 family_C_rank1_vanishes         -- Th_coqc, ring, unconditional,    *)
(*      general 4 indices, no case split (the easiest, most general lemma   *)
(*      in this file).                                                      *)
(*   T5 family_A_not_switching_invariant -- Th_coqc, ONE concrete Q         *)
(*      witness (vm_compute); demonstrates non-invariance, does not claim   *)
(*      it for every configuration (a general 'for all A-embeddings, all    *)
(*      eps, non-invariance' statement is NOT attempted -- one witness is   *)
(*      exactly what an obstruction needs).                                 *)
(*   T6 skew_source_switching_covariant  -- Th_coqc, ring, unconditional     *)
(*      (holds for ANY Q-valued D_i, D_j, not only +-1; the D_i*D_i==1       *)
(*      hypotheses are carried in the signature to match the spec's stated  *)
(*      claim but are not needed by the proof -- flagged honestly, not      *)
(*      silently dropped).                                                  *)
(*   T7 symmetric_source_not_switching_covariant -- Th_coqc, ONE concrete    *)
(*      Q witness (the exact Phi=(1,2),Psi=(3,4),D=(1,-1) witness from the   *)
(*      spec: s'=21 <> D_i*D_j*s=-1).                                       *)
(*   T8 c4_reversal_is_gauge_witness / k3_no_uniform_reversal_gauge --       *)
(*      Th_coqc; the C4 half is an existence witness (one explicit          *)
(*      bipartite 2-coloring eps realizes cycle-reversal as a vertex-        *)
(*      switching); the K3 half is a general impossibility theorem (no      *)
(*      eps in {+1,-1}^3 realizes uniform reversal on an odd cycle -- a     *)
(*      three-line parity argument, general over all eps, not a witness).   *)
(*   T9 -- comment-only [Open] block, no Coq target.                        *)
(*                                                                          *)
(*  What this file does NOT do: build a general finite-n version of T1-T4;  *)
(*  attempt the Groebner/minimal-polynomial certification the eigenbasis    *)
(*  route would need to ever be reopened; touch any nonlinear (non-affine)  *)
(*  embedding; identify the real-side J_Theta(C) of                         *)
(*  InfoThetaOrientedSkewObstruction_attempt.v with this file's Cq-valued   *)
(*  quartetJraw in either direction (that identification is exactly the     *)
(*  admissibility square this whole file is ABOUT, and every theorem below  *)
(*  is a piece of why it does not close, not a proof that it does).         *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  Gaussian-rational complex numbers: pairs of Q.  Transcribed verbatim    *)
(*  from InfoCPEquivariantGenerationBound_attempt.v / InfoThetaCPSquare-     *)
(*  Obstruction_attempt.v (same field names, same formulas).                *)
(* ---------------------------------------------------------------------- *)
Record Cq : Type := mkC { cre : Q; cim : Q }.

Definition Cmul (x y : Cq) : Cq :=
  mkC (cre x * cre y - cim x * cim y) (cre x * cim y + cim x * cre y).
Definition Cconj (x : Cq) : Cq := mkC (cre x) (- cim x).

(* the same quartetJ construction as InfoCPEquivariantGenerationBound_      *)
(* attempt.v's `quartetJ`, restricted to its four read entries directly as  *)
(* arguments (v01, v12, v02, v11) rather than indexed out of a `mat`.       *)
Definition quartetJraw (v01 v12 v02 v11 : Cq) : Q :=
  cim (Cmul (Cmul v01 v12) (Cmul (Cconj v02) (Cconj v11))).

(* ========================================================================
   T1 -- quartet_rescale_invariant: the ONE shared rescaling/rephasing
   lemma (subsumes all three routes' independently-derived versions).
   Unit-Gaussian-rational rephasing V_ij -> alpha_i * V_ij * beta_j (i in
   {0,1} for the rows, j in {1,2} for the columns quartetJraw reads)
   leaves quartetJraw EXACTLY invariant, given alpha_0, alpha_1, beta_1,
   beta_2 all have unit modulus (alpha_i * conj(alpha_i) == 1, spelled out
   componentwise as p^2+q^2==1 since the imaginary part of x*conj(x) is
   always 0 unconditionally).

   Proof shape: quartetJraw of the rescaled entries equals EXACTLY
   K * quartetJraw of the original entries, for K := the product of the
   four moduli-squared -- an unconditional ring identity (no hypothesis
   needed for this decomposition step, matching this arc's own
   quartet_decomp pattern in InfoCPEquivariantGenerationBound_attempt.v).
   Substituting the four unit-modulus hypotheses collapses K to 1.
   ======================================================================== *)
Theorem quartet_rescale_invariant :
  forall alpha0 alpha1 beta1 beta2 v01 v12 v02 v11 : Cq,
    (cre alpha0 * cre alpha0 + cim alpha0 * cim alpha0 == 1)%Q ->
    (cre alpha1 * cre alpha1 + cim alpha1 * cim alpha1 == 1)%Q ->
    (cre beta1 * cre beta1 + cim beta1 * cim beta1 == 1)%Q ->
    (cre beta2 * cre beta2 + cim beta2 * cim beta2 == 1)%Q ->
    (quartetJraw (Cmul (Cmul alpha0 v01) beta1)
                 (Cmul (Cmul alpha1 v12) beta2)
                 (Cmul (Cmul alpha0 v02) beta2)
                 (Cmul (Cmul alpha1 v11) beta1)
     == quartetJraw v01 v12 v02 v11)%Q.
Proof.
  intros [p0 q0] [p1 q1] [r1 s1] [r2 s2] [a b] [c d] [e f] [g h]
         H0 H1 H2 H3.
  unfold quartetJraw in *.
  simpl in H0, H1, H2, H3.
  transitivity
    ((p0*p0+q0*q0)*(p1*p1+q1*q1)*(r1*r1+s1*s1)*(r2*r2+s2*s2)
     * cim (Cmul (Cmul (mkC a b) (mkC c d))
                 (Cmul (Cconj (mkC e f)) (Cconj (mkC g h)))))%Q.
  - simpl. ring.
  - rewrite H0, H1, H2, H3. simpl. ring.
Qed.

(* T1b -- bonus, cheap, unconditional: quartetJraw is exactly degree-4      *)
(* homogeneous under a single common REAL rational rescaling of all four    *)
(* entries (the 'sign-scaling variant for general nonzero rescaling' named  *)
(* in the spec) -- no unit-modulus hypothesis needed at all, since a real   *)
(* scalar is already its own conjugate up to the same real factor.          *)
Theorem quartet_real_scalar_rescale :
  forall lam : Q, forall v01 v12 v02 v11 : Cq,
    (quartetJraw (Cmul (mkC lam 0) v01) (Cmul (mkC lam 0) v12)
                 (Cmul (mkC lam 0) v02) (Cmul (mkC lam 0) v11)
     == lam*lam*lam*lam * quartetJraw v01 v12 v02 v11)%Q.
Proof.
  intros lam [a b] [c d] [e f] [g h].
  unfold quartetJraw. simpl. ring.
Qed.

(* ========================================================================
   T2 -- family_B_K3_exact.  Family B (the ONE gauge-clean, dynamically-
   realized combinatorial embedding, z_e := i*a_e-star) reproduces the K3
   three-edge oriented product exactly: Im((i*a1)*(i*a2)*conj(i*a3)) ==
   a1*a2*a3.  zB(a) := mkC 0 a represents i*a in the Cq encoding (Cmul
   (mkC 0 1) (mkC a 0) reduces to mkC 0 a, i.e. 'i times a real a' -- the
   same odd/conjugation-matching convention theta_oriented_skew_v1.py's
   directed_a uses: reversing an edge negates its real argument, and here
   negating a real argument fed to i* is the same operation as
   conjugating the resulting purely-imaginary Cq value).  a1,a2,a3 here
   correspond to the triangle's a01,a12,a20 in
   InfoThetaOrientedSkewObstruction_attempt.v's naming; the correspondence
   is by role only (not re-used across files, per CRRC).
   ======================================================================== *)
Definition zB (a : Q) : Cq := mkC 0 a.

Theorem family_B_K3_exact :
  forall a1 a2 a3 : Q,
    (cim (Cmul (Cmul (zB a1) (zB a2)) (Cconj (zB a3))) == a1*a2*a3)%Q.
Proof. intros. unfold zB. simpl. ring. Qed.

(* ========================================================================
   T3 -- family_B_C4_vanishes.  The bipartite-rectangle quartet of the
   pure-skew Family B embedding, read on C4's four edges (0,1),(1,2),
   (2,3),(3,0) -- which, as a bipartite graph on parts {0,2} and {1,3},
   supply exactly the four entries a rectangle-quartet reads -- is
   IDENTICALLY ZERO for every choice of the four edge values.  This is
   the unconditional i^4=1 parity fact named in the spec: two plain
   factors (zB a01, zB a23) and two conjugated factors (conj(zB a30),
   conj(zB a12)) are each purely imaginary, so their four-fold product is
   always real, hence its imaginary part is always 0 -- true for EVERY
   a01,a12,a23,a30, no hypothesis, general.
   ======================================================================== *)
Theorem family_B_C4_vanishes :
  forall a01 a12 a23 a30 : Q,
    (cim (Cmul (Cmul (zB a01) (zB a23))
               (Cmul (Cconj (zB a30)) (Cconj (zB a12))))
     == 0)%Q.
Proof. intros. unfold zB. simpl. ring. Qed.

(* ========================================================================
   T4 -- family_C_rank1_vanishes.  The vertex-phase Gram embedding
   N_ij := conj(Z_i)*Z_j (Z_i = Phi_i + i*Psi_i, a general Cq value) is a
   rank-1 outer product; its quartetJraw-style rectangle read on ANY four
   indices a,b,c,d is IDENTICALLY ZERO -- the real part collapses to
   |Za|^2*|Zb|^2*|Zc|^2*|Zd|^2 (a nonnegative real, not claimed here, only
   the vanishing of the imaginary part is a theorem target) and the
   imaginary part cancels exactly, unconditionally, for every Za, Zb, Zc,
   Zd.  General 4 indices, no case split, no topology-dependence at all
   (living or dead, K3 or C4 or anything else) -- the single most general
   lemma in this file, and (per the repaired-design writeup) the one that
   closes the 'omega/doubled-real-space complex structure' lever
   negatively.
   ======================================================================== *)
Definition Nij (Zi Zj : Cq) : Cq := Cmul (Cconj Zi) Zj.

Theorem family_C_rank1_vanishes :
  forall Za Zb Zc Zd : Cq,
    (cim (Cmul (Cmul (Nij Za Zb) (Nij Zc Zd))
               (Cmul (Cconj (Nij Za Zd)) (Cconj (Nij Zc Zb))))
     == 0)%Q.
Proof.
  intros [pa qa] [pb qb] [pc qc] [pd qd].
  unfold Nij. simpl. ring.
Qed.

(* ========================================================================
   T5 -- family_A_not_switching_invariant.  Family A (the one embedding
   nonzero AT the living C4 witness, z_e := w_e-star + i*a_e-star) is gauge-
   DEPENDENT: one explicit non-uniform eps on C4 changes its rectangle
   quartet's imaginary part.  PA reads the same rectangle as T3 but with
   w-parts carried alongside the a-parts (w_e unaffected by the abstract
   Z2^{|V|} switching group, which acts only on the a_e sourced by a_e* --
   see InfoThetaOrientedSkewObstruction_attempt.v's own switching
   definition, a_e -> eps_i*eps_j*a_e, transcribed here by role).  The
   concrete witness below (w01=1,a01=2, w12=3,a12=4, w23=5,a23=6,
   w30=7,a30=8, eps=(1,1,1,-1) -- i.e. only vertex 3 flips) gives
   Im(P) = 188 before switching and 144 after (both exact, disclosed
   here, self-derived for THIS file's own convention -- see the
   POST-REVIEW DISCLOSURE below, not a cross-file reproduction of any
   other file's number): 188 <> 144, so the readout is NOT invariant.

   POST-REVIEW DISCLOSURE (MINOR finding, both independent reviewers
   confirmed): PA reads an OPPOSITE-edge split -- (0,1)+(2,3) plain,
   (3,0)+(1,2) conjugated -- which is the more literal transliteration of
   quartetJ_general's (i,j)/(k,l)/(i,l)/(k,j) rectangle-corner pattern onto
   a C4-as-rectangle drawing. The companion python file
   theta_quartet_square_v1.py's P4/sup_c4_order instead reads an ADJACENT-
   edge split -- (0,1)+(1,2) plain, (2,3)+(0,3) conjugated. Neither this
   file header nor the 5.7 design record fixes one canonical formula for
   this edge-indexed "quartet" (both files' own text concedes it is an
   analogy to the vertex-indexed quartetJ, not that construction itself),
   so the divergence does not affect correctness: family_B_C4_vanishes
   (T3) holds under EITHER pairing (every zB entry is purely imaginary, so
   any four-fold product under any conjugation pattern is real -- an
   i^4=1 parity fact independent of which two edges get conjugated), and
   the 188/144 witness above is valid under THIS file's own pairing only
   -- it is NOT claimed to, and does not, match theta_quartet_square_v1.py's
   independently-derived Family-A C4 witness (Im(P): -557/40 -> 1301/360),
   which uses the other pairing. Do not read the two files' numeric C4
   witnesses as cross-corroborating the same claim; each independently
   demonstrates Family A gauge-dependence under its own internally-
   consistent convention -- two different witnesses for the same
   qualitative conclusion, which strengthens rather than weakens it.
   ======================================================================== *)
Definition PA (w01 a01 w12 a12 w23 a23 w30 a30 : Q) : Q :=
  cim (Cmul (Cmul (mkC w01 a01) (mkC w23 a23))
            (Cmul (Cconj (mkC w30 a30)) (Cconj (mkC w12 a12)))).

Theorem family_A_not_switching_invariant :
  exists eps0 eps1 eps2 eps3 : Q,
    (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\
    (eps2*eps2 == 1)%Q /\ (eps3*eps3 == 1)%Q /\
    Qeq_bool (PA 1 2 3 4 5 (eps2*eps3*6) 7 (eps3*eps0*8))
             (PA 1 2 3 4 5 6 7 8) = false.
Proof.
  exists (1#1), (1#1), (1#1), (-1#1).
  split. { ring. }
  split. { ring. }
  split. { ring. }
  split. { ring. }
  vm_compute. reflexivity.
Qed.

(* Named, for readability: the two concrete values PA takes above. *)
Theorem family_A_witness_original_value :
  (PA 1 2 3 4 5 6 7 8 == 188)%Q.
Proof. unfold PA. simpl. ring. Qed.

Theorem family_A_witness_switched_value :
  (PA 1 2 3 4 5 (-6) 7 (-8) == 144)%Q.
Proof. unfold PA. simpl. ring. Qed.

(* ========================================================================
   T6 -- skew_source_switching_covariant (the corrected positive lemma).
   t_e := Phi_i*Psi_j - Phi_j*Psi_i (the skew source, sources a_e-star)
   transforms EXACTLY D_i*D_j-covariantly under (Phi,Psi) -> (D.Phi,D.Psi)
   for ARBITRARY D_i, D_j -- uniform or not, and in fact for arbitrary Q
   values, not only +-1 (the D_i*D_i==1/D_j*D_j==1 hypotheses are carried
   in the signature to match the spec's stated claim exactly; the ring
   proof below does not need them, which is flagged honestly here rather
   than silently dropping the unused hypotheses from the statement).
   ======================================================================== *)
Theorem skew_source_switching_covariant :
  forall Phi_i Phi_j Psi_i Psi_j Di Dj : Q,
    (Di*Di == 1)%Q -> (Dj*Dj == 1)%Q ->
    ((Di*Phi_i)*(Dj*Psi_j) - (Dj*Phi_j)*(Di*Psi_i)
     == Di*Dj*(Phi_i*Psi_j - Phi_j*Psi_i))%Q.
Proof. intros. ring. Qed.

(* ========================================================================
   T7 -- symmetric_source_not_switching_covariant.  s_e :=
   (Phi_i-Phi_j)*(Psi_i-Psi_j) (the symmetric source, sources w_e-star) does
   NOT transform D_i*D_j-covariantly for non-uniform D: the exact witness
   from the spec, Phi_i=1,Phi_j=2,Psi_i=3,Psi_j=4,Di=1,Dj=-1, gives the
   actual switched value s' = (Di*Phi_i-Dj*Phi_j)*(Di*Psi_i-Dj*Psi_j) = 21
   but the naively-covariant prediction Di*Dj*s_e = -1 -- 21 <> -1.
   ======================================================================== *)
Definition sQ (Phi_i Phi_j Psi_i Psi_j : Q) : Q := (Phi_i - Phi_j)*(Psi_i - Psi_j).

Definition sQ_switched (Di Dj Phi_i Phi_j Psi_i Psi_j : Q) : Q :=
  (Di*Phi_i - Dj*Phi_j) * (Di*Psi_i - Dj*Psi_j).

Theorem symmetric_source_switched_value :
  (sQ_switched 1 (-1) 1 2 3 4 == 21)%Q.
Proof. unfold sQ_switched. ring. Qed.

Theorem symmetric_source_naive_covariant_prediction :
  (1 * (-1) * sQ 1 2 3 4 == -1)%Q.
Proof. unfold sQ. ring. Qed.

Theorem symmetric_source_not_switching_covariant :
  ~ (sQ_switched 1 (-1) 1 2 3 4 == 1 * (-1) * sQ 1 2 3 4)%Q.
Proof.
  rewrite symmetric_source_switched_value, symmetric_source_naive_covariant_prediction.
  lra.
Qed.

(* ========================================================================
   T8 -- c4_reversal_is_gauge_witness / k3_no_uniform_reversal_gauge.
   Reversing a cycle's traversal direction is exactly the operation of
   negating every edge value once (directed_a(a,q,p) = -directed_a(a,p,q)
   in theta_oriented_skew_v1.py's own convention).  Asking whether
   reversal 'is a gauge transformation' is asking whether some Z2
   vertex-switching eps realizes eps_i*eps_j = -1 on EVERY cycle edge
   simultaneously.

   C4 (even, bipartite on {0,2} vs {1,3}): YES -- the 2-coloring
   eps0=eps2=1, eps1=eps3=-1 gives eps_i*eps_j=-1 on all four edges at
   once (an explicit witness; this file does not re-derive
   InfoThetaOrientedSkewObstruction_attempt.v's general switching-
   invariance theorem -- that theorem already shows the CYCLIC PRODUCT is
   unaffected by ANY valid eps including this one, consistent with, but a
   logically separate fact from, this eps also happening to realize
   reversal edge-by-edge).

   K3 (odd, not bipartite): NO eps in {+1,-1}^3 can realize eps_i*eps_j=-1
   on all three edges simultaneously -- a three-line parity argument
   (multiplying the three edge conditions forces
   (eps0*eps0)*(eps1*eps1)*(eps2*eps2) = 1 on one side but (-1)*(-1)*(-1)
   = -1 on the other, and 1 <> -1 in Q), general over ALL eps, not a
   witness.  This is the Th_coqc formalization of the program's own
   already-disclosed (-1)^m telescoping fact (5.5), specialized to the
   bipartite-2-coloring characterization (m even <=> C_m bipartite <=>
   reversal sits inside the switching group) -- credited as connective,
   not as a new arithmetic discovery.
   ======================================================================== *)
Theorem c4_reversal_is_gauge_witness :
  exists eps0 eps1 eps2 eps3 : Q,
    (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\
    (eps2*eps2 == 1)%Q /\ (eps3*eps3 == 1)%Q /\
    (eps0*eps1 == -1)%Q /\ (eps1*eps2 == -1)%Q /\
    (eps2*eps3 == -1)%Q /\ (eps3*eps0 == -1)%Q.
Proof.
  exists (1#1), (-1#1), (1#1), (-1#1).
  repeat split; ring.
Qed.

Theorem k3_no_uniform_reversal_gauge :
  forall eps0 eps1 eps2 : Q,
    (eps0*eps0 == 1)%Q -> (eps1*eps1 == 1)%Q -> (eps2*eps2 == 1)%Q ->
    ~ ((eps0*eps1 == -1)%Q /\ (eps1*eps2 == -1)%Q /\ (eps2*eps0 == -1)%Q).
Proof.
  intros eps0 eps1 eps2 H0 H1 H2 [Ha [Hb Hc]].
  assert (Hprod : ((eps0*eps1)*(eps1*eps2)*(eps2*eps0) == 1)%Q).
  { assert (Hr : ((eps0*eps1)*(eps1*eps2)*(eps2*eps0)
                 == (eps0*eps0)*(eps1*eps1)*(eps2*eps2))%Q) by ring.
    rewrite Hr, H0, H1, H2. ring. }
  rewrite Ha, Hb, Hc in Hprod.
  lra.
Qed.

(* ========================================================================
   T9 -- [Open], named, not attempted here (comment only, no Coq target):
    - general finite-n versions of T1-T4 (arbitrary matrix size / arbitrary
      cycle length rectangle, rather than the fixed 01/12/02/11 read-out
      or the fixed 4-edge C4 rectangle) -- would need the same list/
      index-wraparound cycle encoding InfoThetaOrientedSkewObstruction_
      attempt.v's own [Open] general-n note already names as unbuilt.
    - the Groebner-basis / minimal-polynomial certification of a concrete
      C4 living fixed point's exact field, which is the named prerequisite
      before the eigenbasis-mismatch route (R1, diagnostic-only, ruled
      COMPLIANT for refutation purposes but not built here) could ever be
      reopened as a candidate readout.
    - any nonlinear (non-affine) embedding family z_e = f(w_e, a_e) beyond
      the three affine families (A, B, C) examined by T2-T5 above.
    - feeding G's actual eigenvalues into this file's holonomy/rephasing
      machinery (an unexplored fourth combination, named but not built).
    - the qualitative/inequality-relation escape hatch (relaxing '==0' to
      a signed inequality readout) named in the repaired-design writeup.
   ======================================================================== *)
