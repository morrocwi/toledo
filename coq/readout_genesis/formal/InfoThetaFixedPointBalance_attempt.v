(* ===================================================================== *)
(*  InfoThetaFixedPointBalance_attempt.v — the forced balance law and the  *)
(*  dead-symmetry theorems, step 5.2b-1 of THETA_ROOT_PROGRAM.md           *)
(*  (companion to theta_dynamics_selection_v1.py).                         *)
(*                                                                         *)
(*  Founder's guiding directive (recorded): "ไม่สมมาตร แต่สมดุล" — not       *)
(*  symmetric, but balanced.  These theorems give that phrase its exact    *)
(*  mathematical content at the static fixed point of the reader/record    *)
(*  pair over a symmetric operator G (mother-potential gradient/Hessian    *)
(*  pair: grad V = a x + b x^3, hess V = a + 3 b x^2), in the CLOSED case: *)
(*  J = 0 AND the boundary currents R_Phi = R_Psi = 0 — both DECLARED      *)
(*  (per review; the core's equations carry R on the RHS).                 *)
(*                                                                         *)
(*  Machine-checked here, all over Q, axiom-free (Print Assumptions):      *)
(*                                                                         *)
(*   B1 fixed_point_balance_law — at ANY J=0 static fixed point (all six   *)
(*      component equations zero) with SYMMETRIC G and b <> 0:             *)
(*          Phi0^3 Psi0 + Phi1^3 Psi1 + Phi2^3 Psi2  ==  0.                *)
(*      The reader-cubed/record overlap is FORCED to vanish — balance,     *)
(*      not symmetry.  (General a, b, K, general symmetric G entries.)     *)
(*                                                                         *)
(*   B2a mirror_symmetry_is_dead — per component, for ANY graph term:      *)
(*      if Psi = -Phi satisfies both the reader and record equations and   *)
(*      b <> 0, then Phi = 0.  Perfect anti-alignment retains nothing.     *)
(*                                                                         *)
(*   B2b agreement_is_dead — per component, in the decoupled case (the     *)
(*      graph term vanishes — which is what 5.2a's support rule gives      *)
(*      when Psi = Phi: all pairs concordant, so every w_e = 0): if        *)
(*      Psi = Phi satisfies both equations and a <> 0, then Phi = 0.       *)
(*      Perfect agreement retains nothing either.                          *)
(*                                                                         *)
(*  READING (Dr, comment only): a LIVING fixed point (Psi <> 0) must       *)
(*  therefore be NOT-SYMMETRIC (Psi not equal to Phi or -Phi) yet obey     *)
(*  B1's forced balance — the founder's directive as a theorem pair.       *)
(*  The numeric selection experiment (which support the dynamics settles   *)
(*  into) is finite_diagnostic in the Python companion, NOT proven here.   *)
(*                                                                         *)
(*  HONESTY NOTE (house convention): statements are ENTRYWISE              *)
(*  transliterations (the G<->entry mapping is fixed in comments, checked  *)
(*  by inspection, not inside Coq).  B2b's decoupling hypothesis (zero     *)
(*  graph term) is JUSTIFIED by 5.2a's support rule, not re-proven here.   *)
(*  CRRC guard: no vertex/level/support is identified with generations.    *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  B1 · the forced balance law.  Symmetric G with entries g00,g01,g02,    *)
(*  g11,g12,g22; profiles Phi=(p0,p1,p2), Psi=(s0,s1,s2).                  *)
(*  Reader component i:  K*(G Phi)_i + a*p_i + b*p_i^3        == 0         *)
(*  Record component i:  K*(G Psi)_i + (a + 3 b p_i^2)*s_i    == 0         *)
(* ---------------------------------------------------------------------- *)
Section BalanceLaw.
Variables a b K : Q.
Variables g00 g01 g02 g11 g12 g22 : Q.
Variables p0 p1 p2 s0 s1 s2 : Q.

Hypothesis Hb : ~ (b == 0)%Q.

Hypothesis R0 :
  (K*(g00*p0 + g01*p1 + g02*p2) + a*p0 + b*(p0*p0*p0) == 0)%Q.
Hypothesis R1 :
  (K*(g01*p0 + g11*p1 + g12*p2) + a*p1 + b*(p1*p1*p1) == 0)%Q.
Hypothesis R2 :
  (K*(g02*p0 + g12*p1 + g22*p2) + a*p2 + b*(p2*p2*p2) == 0)%Q.
Hypothesis C0 :
  (K*(g00*s0 + g01*s1 + g02*s2) + (a + (3#1)*b*(p0*p0))*s0 == 0)%Q.
Hypothesis C1 :
  (K*(g01*s0 + g11*s1 + g12*s2) + (a + (3#1)*b*(p1*p1))*s1 == 0)%Q.
Hypothesis C2 :
  (K*(g02*s0 + g12*s1 + g22*s2) + (a + (3#1)*b*(p2*p2))*s2 == 0)%Q.

Theorem fixed_point_balance_law :
  (p0*p0*p0*s0 + p1*p1*p1*s1 + p2*p2*p2*s2 == 0)%Q.
Proof.
  (* the combination Sum_i s_i*Reader_i - Sum_i p_i*Record_i telescopes the
     symmetric-G terms away and leaves exactly -2b * <Phi^3,Psi>.           *)
  assert (Hcombo :
    (s0*(K*(g00*p0 + g01*p1 + g02*p2) + a*p0 + b*(p0*p0*p0))
     + s1*(K*(g01*p0 + g11*p1 + g12*p2) + a*p1 + b*(p1*p1*p1))
     + s2*(K*(g02*p0 + g12*p1 + g22*p2) + a*p2 + b*(p2*p2*p2))
     - (p0*(K*(g00*s0 + g01*s1 + g02*s2) + (a + (3#1)*b*(p0*p0))*s0)
        + p1*(K*(g01*s0 + g11*s1 + g12*s2) + (a + (3#1)*b*(p1*p1))*s1)
        + p2*(K*(g02*s0 + g12*s1 + g22*s2) + (a + (3#1)*b*(p2*p2))*s2))
     == - (2#1) * (b * (p0*p0*p0*s0 + p1*p1*p1*s1 + p2*p2*p2*s2)))%Q)
    by ring.
  rewrite R0, R1, R2, C0, C1, C2 in Hcombo.
  ring_simplify in Hcombo.
  assert (Hprod : (b * (p0*p0*p0*s0 + p1*p1*p1*s1 + p2*p2*p2*s2) == 0)%Q) by lra.
  destruct (Qmult_integral _ _ Hprod) as [Hb0 | Hs]; [ contradiction | exact Hs ].
Qed.

End BalanceLaw.

(* ---------------------------------------------------------------------- *)
(*  B2a · mirror symmetry is dead (per component, ANY graph term gp: the   *)
(*  record's graph term at Psi = -Phi is -gp, and everything linear        *)
(*  cancels, leaving -2 b p^3 = 0).                                        *)
(* ---------------------------------------------------------------------- *)
Theorem mirror_symmetry_is_dead :
  forall a b gp p : Q,
    ~ (b == 0)%Q ->
    (gp + a*p + b*(p*p*p) == 0)%Q ->                       (* reader, Psi=-Phi *)
    ((- gp) + (a + (3#1)*b*(p*p))*(- p) == 0)%Q ->          (* record, Psi=-Phi *)
    (p == 0)%Q.
Proof.
  intros a b gp p Hb Hr Hc.
  assert (Hsum : (- (2#1) * (b * (p*(p*p))) ==
                  (gp + a*p + b*(p*p*p)) + ((- gp) + (a + (3#1)*b*(p*p))*(- p)))%Q)
    by ring.
  rewrite Hr, Hc in Hsum. ring_simplify in Hsum.
  assert (Hcube : (b * (p*(p*p)) == 0)%Q) by lra.
  destruct (Qmult_integral _ _ Hcube) as [Hb0 | Hp3]; [ contradiction |].
  destruct (Qmult_integral _ _ Hp3) as [Hp | Hpp]; [ exact Hp |].
  destruct (Qmult_integral _ _ Hpp) as [Hp | Hp]; exact Hp.
Qed.

(* ---------------------------------------------------------------------- *)
(*  B2b · perfect agreement is dead (decoupled case: Psi = Phi makes every *)
(*  pair concordant, so 5.2a's support rule gives w = 0 and the graph      *)
(*  terms vanish; then 3*reader - record = 2 a p = 0).                     *)
(* ---------------------------------------------------------------------- *)
Theorem agreement_is_dead :
  forall a b p : Q,
    ~ (a == 0)%Q ->
    (a*p + b*(p*p*p) == 0)%Q ->                             (* reader, G = 0 *)
    ((a + (3#1)*b*(p*p))*p == 0)%Q ->                        (* record, Psi=Phi, G = 0 *)
    (p == 0)%Q.
Proof.
  intros a b p Ha Hr Hc.
  assert (Hcombo : ((2#1) * (a * p) ==
                    (3#1)*(a*p + b*(p*p*p)) - (a + (3#1)*b*(p*p))*p)%Q) by ring.
  rewrite Hr, Hc in Hcombo. ring_simplify in Hcombo.
  assert (Hap : (a * p == 0)%Q) by lra.
  destruct (Qmult_integral _ _ Hap) as [Ha0 | Hp]; [ contradiction | exact Hp ].
Qed.
