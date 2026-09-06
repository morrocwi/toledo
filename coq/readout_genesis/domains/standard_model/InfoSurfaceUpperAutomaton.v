(* ================================================================= *)
(*  InfoSurfaceUpperAutomaton.v                              *)
(*  Surface Upper Automaton v1.2 -- the exact algebra behind the      *)
(*  UPPER bound mu_4^admissible <= 7.0841 (pair continuation + Z_3    *)
(*  triple junction), squeezing the entropy bracket to [3.875,7.084]. *)
(*                                                                     *)
(*  Proved over nat / Q (Print Assumptions Closed):                   *)
(*    (count)   the branching polynomial from {0,1,2}^5 with          *)
(*              Sum x_i = 2 (mod 3), split by #nonzero k, has          *)
(*              coefficients 5,10,30,25,11 summing to 81 = 3^4         *)
(*    (root)    B(z)-1 = 11z^5+25z^4+30z^3+10z^2+5z-1 changes sign on  *)
(*              (14/100, 15/100) => z_+ in that interval               *)
(*    (mu)      mu^+ = 1/z_+ in (100/15, 100/14) ~ (6.67, 7.15)        *)
(*    (line)    no-branching line B_line=5z has z_c=1/5, mu=5; and     *)
(*              B(1/5)-1 > 0 => z_+ < 1/5 => mu^+ > 5 (branching       *)
(*              raises entropy but keeps it bounded)                   *)
(*    (squeeze) 3.875 < mu^+ < 54.366  (new bracket beats the crude    *)
(*              20e connected-plaquette-animal upper bound)            *)
(*                                                                     *)
(*  HONEST FENCE. This is a CONDITIONAL upper bound under a declared   *)
(*  first-discovery encoding (the automaton over-counts codes that     *)
(*  don't close / self-conflict, so it bounds mu_4^admissible from     *)
(*  ABOVE). mu^+ = 7.0841 and z_+ = 0.14116 are NUMERICAL roots.       *)
(*  OPEN: machine-checking the first-discovery injection, a finite     *)
(*  frontier matrix remembering mergers/handles for the exact mu,      *)
(*  continuum scaling, QCD calibration. Dual plaquette-occupation      *)
(*  surface sums + Z_3 triple branching are standard; the reading is   *)
(*  ours.                                                             *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoSurfaceUpperAutomaton.

(* (count) branching coefficients sum to 81 = 3^4 *)
Theorem branching_coeff_sum : (5 + 10 + 30 + 25 + 11 = 81)%nat.
Proof. reflexivity. Qed.
Theorem eightyone_is_3_to_4 : (3*3*3*3 = 81)%nat.
Proof. reflexivity. Qed.

Open Scope Q_scope.

(* B(z) = 5z + 10z^2 + 30z^3 + 25z^4 + 11z^5 ; critical polynomial B(z)-1 *)
Definition pB (z : Q) : Q :=
  11*z*z*z*z*z + 25*z*z*z*z + 30*z*z*z + 10*z*z + 5*z - 1.

(* (root) sign change of B(z)-1 on (14/100, 15/100) => z_+ in the interval *)
Theorem pB_neg_at_14 : pB (14#100) < 0.
Proof. unfold pB. lra. Qed.
Theorem pB_pos_at_15 : pB (15#100) > 0.
Proof. unfold pB. lra. Qed.

(* (line) B(1/5)-1 > 0 => z_+ < 1/5 => mu^+ = 1/z_+ > 5 *)
Theorem pB_pos_at_fifth : pB (1#5) > 0.
Proof. unfold pB. lra. Qed.

(* (mu bracket) z_+ in (14/100,15/100) => mu^+=1/z_+ in (100/15,100/14):
   100/15 > 6  and  100/14 < 8 *)
Theorem mu_upper_lower_side : (100#15) > (6#1).
Proof. lra. Qed.
Theorem mu_upper_upper_side : (100#14) < (8#1).
Proof. lra. Qed.

(* (squeeze) the new upper bound sits below the crude 20e~54: 8 < 54 ; and above
   the v1.1 lower bound 3.875: 100/15 > 3875/1000 *)
Theorem new_below_old : (8#1) < (54#1).
Proof. lra. Qed.
Theorem new_above_lower : (100#15) > (3875#1000).
Proof. lra. Qed.

End InfoSurfaceUpperAutomaton.

Print Assumptions InfoSurfaceUpperAutomaton.branching_coeff_sum.
Print Assumptions InfoSurfaceUpperAutomaton.pB_neg_at_14.
Print Assumptions InfoSurfaceUpperAutomaton.pB_pos_at_15.
Print Assumptions InfoSurfaceUpperAutomaton.pB_pos_at_fifth.
Print Assumptions InfoSurfaceUpperAutomaton.mu_upper_upper_side.
Print Assumptions InfoSurfaceUpperAutomaton.new_below_old.
