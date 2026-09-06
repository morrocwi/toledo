(* ===================================================================== *)
(*  InfoThetaMinimalLiving_attempt.v — the n=2 reader/record/Theta system  *)
(*  admits NO living fixed point: the minimal living system needs >= 3     *)
(*  slots.  Step 5.2b-2 of THETA_ROOT_PROGRAM.md (companion:               *)
(*  theta_minimal_living_v1.py).                                          *)
(*                                                                         *)
(*  SETTING (declared, matching 5.2b-1): closed static case (J = 0,        *)
(*  R_Phi = R_Psi = 0), mother potential a = -1, b = 1, K = mu = 1;        *)
(*  two slots p0,p1 (reader) and s0,s1 (record); one possible edge with    *)
(*  5.2a's support rule w = max(0, -(p0-p1)(s0-s1)).                       *)
(*                                                                         *)
(*  Machine-checked here, all over Q, axiom-free (Print Assumptions):      *)
(*                                                                         *)
(*   M1 n2_empty_support_dead — if the edge is absent (w = 0, the          *)
(*      operator vanishes), the record dies componentwise: s = 0.          *)
(*   M2 n2_edge_present_dead — if both retained differences are nonzero    *)
(*      (D = p0-p1 <> 0, E = s0-s1 <> 0, the edge-present branch with      *)
(*      w = -DE substituted), the four fixed-point equations are           *)
(*      CONTRADICTORY: no solution exists at all.                          *)
(*                                                                         *)
(*   M3 n2_no_living_fixed_point — the TOP-LEVEL assembly, itself a Coq    *)
(*      theorem (added per review): under the 5.2a support rule (given as  *)
(*      its two-case disjunction) and the four componentwise fixed-point   *)
(*      equations, the record vanishes: s0 = 0 and s1 = 0.  The case       *)
(*      split uses the order comparison of the support rule (an ordered-   *)
(*      field step); M2's core stays order-free field algebra.             *)
(*                                                                         *)
(*  ASSEMBLY: now machine-checked as M3.  Combined with                    *)
(*  the (finite_diagnostic) existence of living fixed points at n = 3      *)
(*  (5.2b-1): THE MINIMAL LIVING SYSTEM HAS EXACTLY 3 SLOTS — a            *)
(*  root-native lower bound N >= 3, converging with item 2 Attempt 3's     *)
(*  CP-conditional N >= 3 from an entirely independent direction.          *)
(*                                                                         *)
(*  HONESTY NOTES (house convention):                                      *)
(*  - Entrywise transliteration; the reduction to sum/difference           *)
(*    variables (U,D,T,E) is itself machine-checked here as four ring      *)
(*    identities (red_rsum .. red_cdiff), so M2's hypotheses are exactly   *)
(*    4x the original componentwise equations.                             *)
(*  - Every proof step is field algebra in characteristic 0; the same      *)
(*    derivation is therefore valid over R (no square roots, no order      *)
(*    axioms are used in M2 — only ring operations and $\neq$).  A formal  *)
(*    Coq.Reals (+R-axioms) restatement is OPEN, noted not claimed.        *)
(*  - The n=3 living-existence side is numeric (finite_diagnostic), NOT    *)
(*    proven here; "exactly 3" additionally uses the minimal-living        *)
(*    selection reading (Dr) since n = 4 also lives (see the Python        *)
(*    companion's n-scan).  CRRC guard: no identification of slots or      *)
(*    levels with generations is made anywhere in this file.               *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  M1 · empty support (w = 0): the record dies, componentwise.            *)
(*  reader:  - p + p^3 == 0     record:  (-1 + 3 p^2) * s == 0             *)
(* ---------------------------------------------------------------------- *)
Theorem n2_empty_support_dead :
  forall p s : Q,
    (- p + p*p*p == 0)%Q ->
    ((- (1#1) + (3#1)*(p*p)) * s == 0)%Q ->
    (s == 0)%Q.
Proof.
  intros p s Hr Hc.
  assert (Hfac : (p * (p*p - 1) == 0)%Q) by lra.
  destruct (Qmult_integral _ _ Hfac) as [Hp0 | Hp1].
  - (* p = 0: coefficient is -1, so -s == 0 *)
    assert (Hc' : ((- (1#1)) * s == 0)%Q).
    { rewrite Hp0 in Hc. ring_simplify in Hc. lra. }
    lra.
  - (* p^2 = 1: coefficient is 2, so 2 s == 0 *)
    assert (Hpp : (p*p == 1)%Q) by lra.
    assert (Hc' : ((2#1) * s == 0)%Q).
    { rewrite Hpp in Hc. ring_simplify in Hc. lra. }
    lra.
Qed.

(* ---------------------------------------------------------------------- *)
(*  Reduction identities: 4x(sum/difference of the componentwise           *)
(*  equations) in the variables U=p0+p1, D=p0-p1, T=s0+s1, E=s0-s1,        *)
(*  with the edge-present substitution w = -DE.                            *)
(*  reader0 = -D^2 E - p0 + p0^3      reader1 =  D^2 E - p1 + p1^3         *)
(*  record0 = -D E^2 + (-1+3 p0^2) s0 record1 =  D E^2 + (-1+3 p1^2) s1    *)
(* ---------------------------------------------------------------------- *)
Section Reduction.
Variables p0 p1 s0 s1 : Q.

Let U := (p0 + p1)%Q.  Let D := (p0 - p1)%Q.
Let T := (s0 + s1)%Q.  Let E := (s0 - s1)%Q.

Lemma red_rsum :
  ((4#1) * ((- D*D*E - p0 + p0*p0*p0) + (D*D*E - p1 + p1*p1*p1))
   == U * (U*U + (3#1)*(D*D) - (4#1)))%Q.
Proof. unfold U, D. ring. Qed.

Lemma red_rdiff :
  ((4#1) * ((- D*D*E - p0 + p0*p0*p0) - (D*D*E - p1 + p1*p1*p1))
   == D * (- (8#1)*(D*E) - (4#1) + (3#1)*(U*U) + D*D))%Q.
Proof. unfold U, D, E. ring. Qed.

Lemma red_csum :
  ((4#1) * ((- D*E*E + (- (1#1) + (3#1)*(p0*p0))*s0)
            + (D*E*E + (- (1#1) + (3#1)*(p1*p1))*s1))
   == - (4#1)*T + (3#1)*T*(U*U + D*D) + (6#1)*(U*(D*E)))%Q.
Proof. unfold U, D, T, E. ring. Qed.

Lemma red_cdiff :
  ((4#1) * ((- D*E*E + (- (1#1) + (3#1)*(p0*p0))*s0)
            - (D*E*E + (- (1#1) + (3#1)*(p1*p1))*s1))
   == - (8#1)*(D*E)*E - (4#1)*E + (6#1)*(U*(D*T)) + (3#1)*E*(U*U + D*D))%Q.
Proof. unfold U, D, T, E. ring. Qed.

End Reduction.

(* ---------------------------------------------------------------------- *)
(*  M2 · the edge-present branch is contradictory.  Hypotheses are the     *)
(*  four reduced equations (each == 0 since the componentwise equations    *)
(*  vanish at a fixed point, via red_* above), plus D <> 0, E <> 0.        *)
(* ---------------------------------------------------------------------- *)
Theorem n2_edge_present_dead :
  forall U D T E : Q,
    (U * (U*U + (3#1)*(D*D) - (4#1)) == 0)%Q ->
    (D * (- (8#1)*(D*E) - (4#1) + (3#1)*(U*U) + D*D) == 0)%Q ->
    (- (4#1)*T + (3#1)*T*(U*U + D*D) + (6#1)*(U*(D*E)) == 0)%Q ->
    (- (8#1)*(D*E)*E - (4#1)*E + (6#1)*(U*(D*T)) + (3#1)*E*(U*U + D*D) == 0)%Q ->
    ~ (D == 0)%Q -> ~ (E == 0)%Q -> False.
Proof.
  intros U D T E H1 H2 H3 H4 HD HE.
  (* from H2 and D<>0: the rdiff bracket vanishes *)
  destruct (Qmult_integral _ _ H2) as [HD0 | Hq]; [ exact (HD HD0) |].
  (* from H1: U = 0 or the rsum bracket vanishes *)
  destruct (Qmult_integral _ _ H1) as [HU0 | HB].
  - (* ============ CASE A : U == 0 ============ *)
    assert (Hq' : (- (8#1)*(D*E) - (4#1) + D*D == 0)%Q).
    { rewrite HU0 in Hq. ring_simplify in Hq. lra. }
    assert (H3' : (T * ((3#1)*(D*D) - (4#1)) == 0)%Q).
    { rewrite HU0 in H3. ring_simplify in H3. lra. }
    destruct (Qmult_integral _ _ H3') as [HT0 | H43].
    + (* -- A1 : T == 0 -- *)
      assert (H4' : (E * (- (8#1)*(D*E) - (4#1) + (3#1)*(D*D)) == 0)%Q).
      { rewrite HU0, HT0 in H4. ring_simplify in H4. lra. }
      destruct (Qmult_integral _ _ H4') as [HE0 | Hq2]; [ exact (HE HE0) |].
      (* Hq' - Hq2 : -2 D^2 == 0  ->  D == 0, contradiction *)
      assert (HDD : (D * D == 0)%Q) by lra.
      destruct (Qmult_integral _ _ HDD) as [HD0 | HD0]; exact (HD HD0).
    + (* -- A2 : 3 D^2 == 4 -- *)
      assert (HDD : (D*D == 4#3)%Q) by lra.
      (* Hq' becomes: -8 DE - 4 + 4/3 == 0  ->  DE == -1/3 *)
      assert (HDE : (D*E == - (1#3))%Q).
      { rewrite HDD in Hq'. lra. }
      (* H4 with U=0: -8(DE)E - 4E + 3E D^2 == 0; substituting DE = -1/3
         and D^2 = 4/3 collapses it to (8/3) E == 0, so E == 0.            *)
      assert (HDEE : ((D*E)*E == - (1#3) * E)%Q).
      { rewrite HDE. ring. }
      assert (HEDD : (E*(D*D) == (4#3) * E)%Q).
      { rewrite HDD. ring. }
      assert (H4x : (- (8#1)*((D*E)*E) - (4#1)*E + (3#1)*(E*(D*D)) == 0)%Q).
      { assert (Hexp : (- (8#1)*(D*E)*E - (4#1)*E + (6#1)*(U*(D*T))
                        + (3#1)*E*(U*U + D*D)
                        == - (8#1)*((D*E)*E) - (4#1)*E + (3#1)*(E*(D*D))
                           + (6#1)*(U*(D*T)) + (3#1)*(E*(U*U)))%Q) by ring.
        assert (HUDT : (U*(D*T) == 0)%Q). { rewrite HU0. ring. }
        assert (HEUU : (E*(U*U) == 0)%Q). { rewrite HU0. ring. }
        rewrite Hexp in H4. rewrite HUDT, HEUU in H4. lra. }
      rewrite HDEE, HEDD in H4x.
      apply HE. lra.
  - (* ============ CASE B : U*U + 3 D^2 - 4 == 0, i.e. U*U == 4 - 3D^2 ==== *)
    assert (HUU : (U*U == (4#1) - (3#1)*(D*D))%Q) by lra.
    (* Hq: -8DE - 4 + 3U^2 + D^2 == 0  ->  DE == 1 - D^2 *)
    assert (HDE : (D*E == (1#1) - D*D)%Q).
    { rewrite HUU in Hq. lra. }
    (* H4: substitute DE and U^2; the E-terms collapse to 2 D^2 E + 6 UDT *)
    assert (HDEE : ((D*E)*E == E - (D*D)*E)%Q).
    { rewrite HDE. ring. }
    assert (HEUU : (E*(U*U) == (4#1)*E - (3#1)*((D*D)*E))%Q).
    { rewrite HUU. ring. }
    assert (H4' : ((2#1)*((D*D)*E) + (6#1)*(U*(D*T)) == 0)%Q).
    { (* -8(DE)E - 4E + 6UDT + 3E U^2 + 3E D^2 == 0 *)
      assert (Hexp : (- (8#1)*(D*E)*E - (4#1)*E + (6#1)*(U*(D*T))
                      + (3#1)*E*(U*U + D*D)
                      == - (8#1)*((D*E)*E) - (4#1)*E + (6#1)*(U*(D*T))
                         + (3#1)*(E*(U*U)) + (3#1)*((D*D)*E))%Q) by ring.
      rewrite Hexp in H4. rewrite HDEE, HEUU in H4. lra. }
    (* factor D: D*(2 D E + 6 U T) == 0 ... in monomials: 2 D^2 E + 6 UDT *)
    assert (Hfac : (D * ((2#1)*(D*E) + (6#1)*(U*T)) == (2#1)*((D*D)*E)
                    + (6#1)*(U*(D*T)))%Q) by ring.
    assert (HDF : (D * ((2#1)*(D*E) + (6#1)*(U*T)) == 0)%Q) by lra.
    destruct (Qmult_integral _ _ HDF) as [HD0 | HUT0]; [ exact (HD HD0) |].
    (* HUT0: 2 DE + 6 UT == 0; with DE = 1 - D^2: 3 UT == D^2 - 1 *)
    assert (HUT : ((3#1)*(U*T) == D*D - (1#1))%Q).
    { rewrite HDE in HUT0. lra. }
    (* H3: -4T + 3T U^2 + 3T D^2 + 6 U D E == 0; substitute U^2 and DE *)
    assert (HTUU : (T*(U*U) == (4#1)*T - (3#1)*(T*(D*D)))%Q).
    { rewrite HUU. ring. }
    assert (HUDE : (U*(D*E) == U - U*(D*D))%Q).
    { rewrite HDE. ring. }
    assert (H3' : ((8#1)*T - (6#1)*(T*(D*D)) + (6#1)*U - (6#1)*(U*(D*D)) == 0)%Q).
    { assert (Hexp : (- (4#1)*T + (3#1)*T*(U*U + D*D) + (6#1)*(U*(D*E))
                      == - (4#1)*T + (3#1)*(T*(U*U)) + (3#1)*(T*(D*D))
                         + (6#1)*(U*(D*E)))%Q) by ring.
      rewrite Hexp in H3. rewrite HTUU, HUDE in H3. lra. }
    (* multiply H3'/2 by 3U:  12 UT - 9 UT D^2 + 9 U^2 - 9 U^2 D^2 == 0    *)
    assert (Hmul : ((3#1)*U * ((4#1)*T - (3#1)*(T*(D*D)) + (3#1)*U
                               - (3#1)*(U*(D*D)))
                    == (4#1)*((3#1)*(U*T)) - (3#1)*(((3#1)*(U*T))*(D*D))
                       + (9#1)*(U*U) - (9#1)*((U*U)*(D*D)))%Q) by ring.
    assert (Hhalf : ((4#1)*T - (3#1)*(T*(D*D)) + (3#1)*U - (3#1)*(U*(D*D))
                     == 0)%Q) by lra.
    assert (Hzero : ((4#1)*((3#1)*(U*T)) - (3#1)*(((3#1)*(U*T))*(D*D))
                     + (9#1)*(U*U) - (9#1)*((U*U)*(D*D)) == 0)%Q).
    { rewrite <- Hmul. rewrite Hhalf. ring. }
    (* substitute 3UT = D^2-1 and U^2 = 4-3D^2 into Hzero (the composite
       occurrences are rewritten by the same two equations)                 *)
    rewrite HUT, HUU in Hzero. ring_simplify in Hzero.
    (* Hzero is now a polynomial in D*D alone:
       4(D^2-1) - 3(D^2-1)D^2 + 9(4-3D^2) - 9(4-3D^2)D^2
       = 24 (D^2)^2 - 56 D^2 + 32 == 0, i.e. 8(3D^2-4)(D^2-1) == 0.        *)
    assert (Hfac2 : (((3#1)*(D*D) - (4#1)) * ((D*D) - (1#1)) == 0)%Q)
      by (ring_simplify; lra).
    destruct (Qmult_integral _ _ Hfac2) as [H34 | H11].
    + (* -- B2 : 3 D^2 == 4  ->  U^2 == 0  ->  U == 0; then Hhalf forces
         T-terms: with U == 0, Hhalf: 4T - 3T D^2 == T(4 - 3D^2) == 0 gives
         nothing about D,E; instead use HUU directly. *)
      assert (HU0 : (U*U == 0)%Q).
      { rewrite HUU. lra. }
      destruct (Qmult_integral _ _ HU0) as [HU | HU].
      * (* U == 0: then HUT: 0 == D^2 - 1 -> D^2 == 1; but 3D^2 == 4 gives
           D^2 == 4/3: contradiction 1 == 4/3. *)
        assert (HUT' : ((3#1)*(U*T) == 0)%Q).
        { rewrite HU. ring. }
        assert (HDD1 : (D*D == 1#1)%Q) by lra.
        lra.
      * assert (HUT' : ((3#1)*(U*T) == 0)%Q).
        { rewrite HU. ring. }
        assert (HDD1 : (D*D == 1#1)%Q) by lra.
        lra.
    + (* -- B1 : D^2 == 1  ->  DE == 1 - 1 == 0  ->  D == 0 or E == 0 -- *)
      assert (HDE0 : (D*E == 0)%Q).
      { rewrite HDE. lra. }
      destruct (Qmult_integral _ _ HDE0) as [HD0 | HE0];
        [ exact (HD HD0) | exact (HE HE0) ].
Qed.

(* ---------------------------------------------------------------------- *)
(*  M3 · top-level: the n=2 system's record dies, as ONE theorem.          *)
(*  The support rule w = max(0, -(p0-p1)(s0-s1)) is supplied as its        *)
(*  two-case disjunction; the four hypotheses are the componentwise        *)
(*  fixed-point equations with the 2-vertex Laplacian coupling             *)
(*  (G Phi)_0 = w (p0-p1), (G Phi)_1 = -w (p0-p1), etc.                    *)
(* ---------------------------------------------------------------------- *)
Theorem n2_no_living_fixed_point :
  forall p0 p1 s0 s1 w : Q,
    ( ((w == 0)%Q /\ (0 <= (p0-p1)*(s0-s1))%Q)
      \/ ((w == - ((p0-p1)*(s0-s1)))%Q /\ ((p0-p1)*(s0-s1) < 0)%Q) ) ->
    (w*(p0-p1) - p0 + p0*p0*p0 == 0)%Q ->
    (- (w*(p0-p1)) - p1 + p1*p1*p1 == 0)%Q ->
    (w*(s0-s1) + (- (1#1) + (3#1)*(p0*p0))*s0 == 0)%Q ->
    (- (w*(s0-s1)) + (- (1#1) + (3#1)*(p1*p1))*s1 == 0)%Q ->
    (s0 == 0)%Q /\ (s1 == 0)%Q.
Proof.
  intros p0 p1 s0 s1 w Hrule He1 He2 He3 He4.
  destruct Hrule as [[Hw0 _] | [Hw Hlt]].
  - (* w = 0: componentwise M1 *)
    rewrite Hw0 in He1, He2, He3, He4.
    split.
    + apply (n2_empty_support_dead p0 s0).
      * (* reader0 with w=0 *) lra.
      * (* record0 with w=0 *) lra.
    + apply (n2_empty_support_dead p1 s1).
      * lra.
      * lra.
  - (* w = -DE with DE < 0: D <> 0, E <> 0, then M2 gives False *)
    assert (HD : ~ ((p0-p1) == 0)%Q).
    { intro H0. rewrite H0 in Hlt. ring_simplify in Hlt. lra. }
    assert (HE : ~ ((s0-s1) == 0)%Q).
    { intro H0. rewrite H0 in Hlt. ring_simplify in Hlt. lra. }
    rewrite Hw in He1, He2, He3, He4.
    exfalso.
    apply (n2_edge_present_dead (p0+p1) (p0-p1) (s0+s1) (s0-s1));
      [ | | | | exact HD | exact HE ].
    + (* rsum form: 4*(e1+e2) *)
      assert (Hid : ((p0+p1) * ((p0+p1)*(p0+p1) + (3#1)*((p0-p1)*(p0-p1)) - (4#1))
        == (4#1)*((- ((p0-p1)*(s0-s1)))*(p0-p1) - p0 + p0*p0*p0)
           + (4#1)*((- ((- ((p0-p1)*(s0-s1)))*(p0-p1))) - p1 + p1*p1*p1))%Q) by ring.
      rewrite Hid. rewrite He1, He2. ring.
    + (* rdiff form: 4*(e1-e2) *)
      assert (Hid : ((p0-p1) * (- (8#1)*((p0-p1)*(s0-s1)) - (4#1)
                                + (3#1)*((p0+p1)*(p0+p1)) + (p0-p1)*(p0-p1))
        == (4#1)*((- ((p0-p1)*(s0-s1)))*(p0-p1) - p0 + p0*p0*p0)
           - (4#1)*((- ((- ((p0-p1)*(s0-s1)))*(p0-p1))) - p1 + p1*p1*p1))%Q) by ring.
      rewrite Hid. rewrite He1, He2. ring.
    + (* csum form: 4*(e3+e4) *)
      assert (Hid : (- (4#1)*(s0+s1) + (3#1)*(s0+s1)*((p0+p1)*(p0+p1)
                       + (p0-p1)*(p0-p1))
                     + (6#1)*((p0+p1)*((p0-p1)*(s0-s1)))
        == (4#1)*((- ((p0-p1)*(s0-s1)))*(s0-s1)
                  + (- (1#1) + (3#1)*(p0*p0))*s0)
           + (4#1)*((- ((- ((p0-p1)*(s0-s1)))*(s0-s1)))
                    + (- (1#1) + (3#1)*(p1*p1))*s1))%Q) by ring.
      rewrite Hid. rewrite He3, He4. ring.
    + (* cdiff form: 4*(e3-e4) *)
      assert (Hid : (- (8#1)*((p0-p1)*(s0-s1))*(s0-s1) - (4#1)*(s0-s1)
                     + (6#1)*((p0+p1)*((p0-p1)*(s0+s1)))
                     + (3#1)*(s0-s1)*((p0+p1)*(p0+p1) + (p0-p1)*(p0-p1))
        == (4#1)*((- ((p0-p1)*(s0-s1)))*(s0-s1)
                  + (- (1#1) + (3#1)*(p0*p0))*s0)
           - (4#1)*((- ((- ((p0-p1)*(s0-s1)))*(s0-s1)))
                    + (- (1#1) + (3#1)*(p1*p1))*s1))%Q) by ring.
      rewrite Hid. rewrite He3, He4. ring.
Qed.
