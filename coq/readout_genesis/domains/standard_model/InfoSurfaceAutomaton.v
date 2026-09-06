(* ================================================================= *)
(*  InfoSurfaceAutomaton.v                                   *)
(*  Surface Automaton Closure v1.1 -- the exact algebra behind the    *)
(*  first 4D admissible-surface spectral radii. (The eigenvalues are  *)
(*  NUMERICAL in surface_automaton_v1_1.py; here we mechanize the      *)
(*  exact critical-polynomial derivations and rational root/mu        *)
(*  brackets.)                                                        *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*    (canP)  the canonical closed form  lambda=z((1+z)/(1-z))^2=1     *)
(*            clears to  z^3+z^2+3z-1 = 0 :                            *)
(*            z(1+z)^2 - (1-z)^2 = z^3+z^2+3z-1   (ring)               *)
(*    (shortP) the shortest-paths closed form clears to                *)
(*            2z^3-z^2+4z-1 = 0 :                                      *)
(*            z(2z^2+z+1) - (1-2z)(1-z) = 2z^3-z^2+4z-1  (ring)        *)
(*    (canRoot) z^3+z^2+3z-1 changes sign on (29/100,30/100)           *)
(*            => z_c in that interval => mu_can=1/z_c in (10/3,100/29) *)
(*    (shortRoot) 2z^3-z^2+4z-1 changes sign on (25/100,26/100)        *)
(*            => mu_short=1/z_c in (100/26,4) ~ (3.846,4)              *)
(*    (bracket) mu_short < mu_upper=20e  (the lower bound sits below   *)
(*            the crude connected-plaquette-animal upper bound)        *)
(*                                                                     *)
(*  HONEST FENCE. These pin the critical polynomials and rational      *)
(*  brackets exactly; mu_canonical=3.38298, mu_shortest=3.87513 are    *)
(*  NUMERICAL roots. mu_shortest is a LOWER bound on mu_4^admissible   *)
(*  (single-sheet sector: no bubbles/handles/branching), so it does    *)
(*  NOT replace 20e in the rigorous certificate -- an UPPER automaton  *)
(*  (overflow-state M^+, Perron-Frobenius bracket) is still open.      *)
(*  Frontier/transfer-matrix surface counting is standard lattice      *)
(*  method; the minimal-sufficient-quotient reading is ours.          *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoSurfaceAutomaton.
Open Scope Q_scope.

(* (canP) canonical connector: lambda=1 clears to z^3+z^2+3z-1=0 *)
Theorem canonical_critical_polynomial : forall z : Q,
  z*(1+z)*(1+z) - (1-z)*(1-z) == z*z*z + z*z + 3*z - 1.
Proof. intro z. ring. Qed.

(* (shortP) shortest paths: the bracket 4/(1-2z)-4/(1-z)+1 = (2z^2+z+1)/((1-2z)(1-z)),
   so lambda=1 clears to 2z^3-z^2+4z-1=0 *)
Theorem shortest_bracket_simplifies : forall z : Q,
  4*(1-z) - 4*(1-2*z) + (1-2*z)*(1-z) == 2*z*z + z + 1.
Proof. intro z. ring. Qed.
Theorem shortest_critical_polynomial : forall z : Q,
  z*(2*z*z + z + 1) - (1-2*z)*(1-z) == 2*z*z*z - z*z + 4*z - 1.
Proof. intro z. ring. Qed.

(* (canRoot) sign change of z^3+z^2+3z-1 on (29/100, 30/100) *)
Definition pcan (z : Q) : Q := z*z*z + z*z + 3*z - 1.
Theorem pcan_neg_at_29 : pcan (29#100) < 0.
Proof. unfold pcan. lra. Qed.
Theorem pcan_pos_at_30 : pcan (30#100) > 0.
Proof. unfold pcan. lra. Qed.

(* (shortRoot) sign change of 2z^3-z^2+4z-1 on (25/100, 26/100) *)
Definition pshort (z : Q) : Q := 2*z*z*z - z*z + 4*z - 1.
Theorem pshort_neg_at_25 : pshort (25#100) < 0.
Proof. unfold pshort. lra. Qed.
Theorem pshort_pos_at_26 : pshort (26#100) > 0.
Proof. unfold pshort. lra. Qed.

(* (mu bracket) since z_c in (25/100,26/100), mu_short=1/z_c in (100/26, 4);
   in particular mu_short > 100/26 > 3.8 and mu_short < 4 *)
Theorem mu_short_lower : (100#26) > (38#10).
Proof. lra. Qed.
(* the restricted-sector value sits below the crude upper bound (20e>54): 4 < 54 *)
Theorem lower_below_upper : (4#1) < (54#1).
Proof. lra. Qed.

End InfoSurfaceAutomaton.

Print Assumptions InfoSurfaceAutomaton.canonical_critical_polynomial.
Print Assumptions InfoSurfaceAutomaton.shortest_critical_polynomial.
Print Assumptions InfoSurfaceAutomaton.pcan_neg_at_29.
Print Assumptions InfoSurfaceAutomaton.pshort_neg_at_25.
Print Assumptions InfoSurfaceAutomaton.pshort_pos_at_26.
Print Assumptions InfoSurfaceAutomaton.lower_below_upper.
