(* ===================================================================== *)
(*  InfoThetaOrientedSkewObstruction_attempt.v — Coq witness for step      *)
(*  5.5 of THETA_ROOT_PROGRAM.md, PRIMARY branch (support-tied real skew   *)
(*  extension G = L[w] + A[a], repaired Route B; companion:                *)
(*  theta_oriented_skew_v1.py).                                            *)
(*                                                                         *)
(*  ORCHESTRATOR RULINGS (binding, recorded in the 5.5 spec, not re-argued *)
(*  here): (1) PRIMARY = real support-tied skew only; J_Theta is a real,   *)
(*  orientation-odd cyclic product of a_e* around a cycle lying in the     *)
(*  support; its identification with 5.4's Cq quartetJ is an UNBUILT       *)
(*  admissibility square, [Open], Q3 discipline.  (2) The FALLBACK Q(i)/   *)
(*  mu_4 branch is NOT built in 5.5 — no such file exists in this repo.    *)
(*  (3) B1/B2 (5.2b-1's forced balance law / dead-symmetry theorems, both  *)
(*  proven only for the SYMMETRIC-ONLY real system) are NOT assumed to     *)
(*  transfer to the extended (L+A)-coupled system; whether they do is a    *)
(*  named open item, stated-not-proved below.  (4) The V=U_A^dagger*U_B    *)
(*  eigenbasis bridge stays FORBIDDEN as a J readout (gauge-artifact trap  *)
(*  — not used anywhere in this file).                                    *)
(*                                                                         *)
(*  SCOPE OF THIS FILE (two lemma families, both Th_coqc once              *)
(*  `Print Assumptions` confirms axiom-freedom — see report):              *)
(*                                                                         *)
(*   cyclic_product_switching_invariant_{triangle,C4} — Z2 vertex          *)
(*     switching a_e -> eps_i*eps_j*a_e (eps_v*eps_v == 1, i.e.             *)
(*     eps_v in {+1,-1}) leaves the ORDERED cyclic product of the a_e's    *)
(*     around a closed cycle EXACTLY invariant.  Proved for the two        *)
(*     concrete small cycles this arc's living-fixed-point search can      *)
(*     actually reach (K3 = triangle at n=3, C4 = the 4-cycle at n=4, per  *)
(*     5.2b-1/5.2b-2's own inventory of which supports carry a cycle at    *)
(*     all).  The general finite-n-cycle version telescopes by the exact   *)
(*     same one-line argument (Sum of eps_v^2 around the cycle collapses   *)
(*     to 1 at every vertex, since each vertex touches exactly two cycle   *)
(*     edges) — but a general abstract-cycle Coq statement needs a list/   *)
(*     index-wraparound encoding this arc has not built; DECLARED [Open],  *)
(*     not proved here.  Concrete-and-closed over general-and-stuck, per   *)
(*     playbook Step 2.                                                    *)
(*                                                                         *)
(*   tree_gauge_fixable_{P3,star3,P4,star4} — on a TREE support, the Z2    *)
(*     switching group can gauge EVERY a_e to be >= 0 (existence).  Proved *)
(*     for the four concrete n=3/n=4 tree edge sets 5.2b-1's own search    *)
(*     actually visits (P3, star3 at n=3; P4, star4 at n=4), built on one  *)
(*     shared helper (`qsign_exists`) instantiating the spec's stated      *)
(*     recursion `eps_c := eps_p * sign(a_pc)` root-to-leaf.  General      *)
(*     structural induction over an abstract tree's edge set is a real     *)
(*     escalation in formalization difficulty (flagged by the playbook's   *)
(*     own risk ranking) — DECLARED [Open], not attempted here.            *)
(*                                                                         *)
(*  STATED-NOT-PROVED (comment only, per playbook Step 2's explicit        *)
(*  instruction — these are NOT Coq targets for this file):                *)
(*   - K3 / C4 extended-operator (L+A-coupled) livingness: whether the     *)
(*     multistart-Newton search on the reader-feels-+A / record-feels--A   *)
(*     system finds a living fixed point on K3 or C4 with J_Theta != 0 is  *)
(*     a NUMERIC question, decided (or not) in theta_oriented_skew_v1.py's *)
(*     finite_diagnostic sweep, never in Coq.                              *)
(*   - The quartetJ identification square: identifying THIS file's real    *)
(*     J_Theta with 5.4's Cq-valued quartetJ (Im of a Jarlskog-type        *)
(*     quartet) is an entirely unbuilt admissibility square.  5.4's own    *)
(*     Th_coqc obstruction (`real_quartet_no_cp_readout`: a real mixing    *)
(*     matrix's quartet has Im === 0) is NOT re-derived, re-used, or       *)
(*     assumed here in either direction — this file's J_Theta is a         *)
(*     different, real-valued object living on a different index set (an  *)
(*     edge-indexed cyclic product, not a mixing-matrix quartet), and the  *)
(*     two are Q3-distinct until a square is actually built.               *)
(*   - B1/B2 transfer: whether `<Phi^3,Psi> = 0` (B1) or the dead-symmetry *)
(*     theorems (B2a/B2b) survive once the operator is extended to         *)
(*     K(L[w]+A[a])Phi (reader) / K(L[w]-A[a])Psi (record) — i.e. whether  *)
(*     the skew term's Phi^T A Psi contribution telescopes away in the     *)
(*     same combination B1's proof used, or forces a genuinely NEW         *)
(*     balance identity — is undetermined here.  Paper sketch (Dr, not     *)
(*     Coq-checked): the B1 combination `Sum_i Psi_i*Reader_i -             *)
(*     Sum_i Phi_i*Record_i` picked up an extra term                       *)
(*     `Psi^T A Phi - (-Phi^T A Psi) = Psi^T A Phi + Phi^T A Psi`; since A  *)
(*     is antisymmetric, `Phi^T A Psi = -Psi^T A Phi` in general (NOT the  *)
(*     same as B1's all-symmetric-G telescoping), so this extra term is    *)
(*     `Psi^T A Phi - Psi^T A Phi = 0` ONLY if `Phi^T A Psi` is read as     *)
(*     `Psi^T A^T Phi`, i.e. the extra contribution is `Psi^T A Phi +      *)
(*     Phi^T A Psi = Psi^T A Phi - Psi^T A^T Phi`-style bookkeeping that    *)
(*     has NOT been carried through carefully enough to state as a         *)
(*     theorem candidate, let alone prove — left fully open, to be         *)
(*     checked numerically first (per orchestrator ruling 3c) before any  *)
(*     Coq attempt.                                                        *)
(*                                                                         *)
(*  CRRC guard: no edge, orientation, cyclic product, or J_Theta value in  *)
(*  this file is ever identified with a generation, CKM entry, level       *)
(*  count, or color index.  Q3 identity-by-role preserved: w_e, a_e,       *)
(*  eps_v stay distinct symbols from any physics-imported quantity.         *)
(*                                                                         *)
(*  HONESTY NOTE (house convention): the switching-invariance and tree-    *)
(*  gauge-fixing theorems below are entrywise, concrete-instance           *)
(*  transliterations of the spec's stated general claims (the vertex/edge  *)
(*  labeling is fixed by comment, checked by inspection, not inside Coq).  *)
(*  `qsign_exists` picks a canonical +/-1 sign for an arbitrary rational;  *)
(*  it is a pure existence lemma (no claim of uniqueness or of which       *)
(*  branch the SWITCHING GROUP as a whole prefers — only that the tree-    *)
(*  gauge recursion can reach all-nonnegative).                            *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  Shared helper: every rational has a Z2 sign witness e in {+1,-1} with  *)
(*  e*x >= 0.  Used by every tree_gauge_fixable_* instance below to build  *)
(*  the root-to-leaf recursion `eps_c := eps_p * sign(a_pc)` stated in the *)
(*  spec (§1, "Gauge invariance (repaired)").                              *)
(* ---------------------------------------------------------------------- *)
Lemma qsign_exists : forall x : Q, exists e : Q, (e*e == 1)%Q /\ (0 <= e*x)%Q.
Proof.
  intros x.
  destruct (Qlt_le_dec x 0) as [Hlt | Hge].
  - exists (- (1#1))%Q. split.
    + ring.
    + lra.
  - exists (1#1)%Q. split.
    + ring.
    + lra.
Qed.

(* ========================================================================
   Part 1 — cyclic_product_switching_invariant.
   Z2 vertex switching a_e -> eps_i*eps_j*a_e, eps_v*eps_v == 1 (eps_v in
   {+1,-1}), leaves the ordered cyclic product of a_e around a closed
   cycle exactly invariant.  Telescoping: every vertex around the cycle
   touches exactly two cycle edges, so its eps_v contributes eps_v*eps_v
   = 1 to the product, once per vertex, no leftover factor.
   ======================================================================== *)

(* Triangle (K3): vertices 0,1,2; cycle edges (0,1),(1,2),(2,0);
   weights a01,a12,a20.  This is the ONLY n=3 support carrying a cycle
   at all (5.2b-1's other living supports are trees — see Part 2). *)
Theorem cyclic_product_switching_invariant_triangle :
  forall a01 a12 a20 eps0 eps1 eps2 : Q,
    (eps0*eps0 == 1)%Q -> (eps1*eps1 == 1)%Q -> (eps2*eps2 == 1)%Q ->
    ((eps0*eps1*a01) * (eps1*eps2*a12) * (eps2*eps0*a20)
     == a01*a12*a20)%Q.
Proof.
  intros a01 a12 a20 eps0 eps1 eps2 H0 H1 H2.
  assert (Hexpand :
    ((eps0*eps1*a01) * (eps1*eps2*a12) * (eps2*eps0*a20)
    == (eps0*eps0)*(eps1*eps1)*(eps2*eps2)*(a01*a12*a20))%Q) by ring.
  rewrite Hexpand, H0, H1, H2. ring.
Qed.

(* 4-cycle (C4): vertices 0,1,2,3; cycle edges (0,1),(1,2),(2,3),(3,0);
   weights a01,a12,a23,a30.  This is 5.2b-2's newly-found n=4 living
   support carrying an independent cycle — the "newly-tractable escape
   hatch" the spec names as the decisive n=4 experiment. *)
Theorem cyclic_product_switching_invariant_C4 :
  forall a01 a12 a23 a30 eps0 eps1 eps2 eps3 : Q,
    (eps0*eps0 == 1)%Q -> (eps1*eps1 == 1)%Q ->
    (eps2*eps2 == 1)%Q -> (eps3*eps3 == 1)%Q ->
    ((eps0*eps1*a01) * (eps1*eps2*a12) * (eps2*eps3*a23) * (eps3*eps0*a30)
     == a01*a12*a23*a30)%Q.
Proof.
  intros a01 a12 a23 a30 eps0 eps1 eps2 eps3 H0 H1 H2 H3.
  assert (Hexpand :
    ((eps0*eps1*a01) * (eps1*eps2*a12) * (eps2*eps3*a23) * (eps3*eps0*a30)
    == ((eps0*eps0)*(eps1*eps1)) * ((eps2*eps2)*(eps3*eps3))
       * (a01*a12*a23*a30))%Q) by ring.
  rewrite Hexpand, H0, H1, H2, H3. ring.
Qed.

(* [Open], declared not proved: the general finite-n-cycle statement
   (vertices v_0..v_{k-1} on a closed cycle, edges (v_i,v_{i+1 mod k}))
   telescopes by the identical argument for every k >= 3 — each eps_{v_i}
   appears in exactly two consecutive edge factors, contributing
   eps_{v_i}*eps_{v_i} = 1 — but stating and proving this for an abstract
   k needs a list/index-wraparound cycle encoding not built anywhere in
   this arc.  Left [Open]; the two concrete instances above are the ones
   5.2b-1/5.2b-2's own living-fixed-point inventory can actually reach. *)

(* ========================================================================
   Part 2 — tree_gauge_fixable.
   On a TREE support, the Z2 switching group can gauge every a_e to be
   >= 0.  Built from qsign_exists via the root-to-leaf recursion
   eps_c := eps_p * sign(a_pc): telescoping gives eps_p*eps_c = eps_p^2 *
   sign(a_pc) = sign(a_pc), so eps_p*eps_c*a_pc = sign(a_pc)*a_pc >= 0 at
   every edge, independent of any other branch of the tree.
   Four concrete n=3/n=4 tree instances — the ones 5.2b-1's search
   actually visits (P3, star3 at n=3; P4, star4 at n=4).  General
   structural induction over an abstract tree's edge set is a real
   escalation in formalization difficulty (flagged by the playbook's own
   risk ranking) and is DECLARED [Open], not attempted here.
   ======================================================================== *)

(* P3 — path 0-1-2, edges (0,1) weight a01, (1,2) weight a12.  Root at 0. *)
Theorem tree_gauge_fixable_P3 :
  forall a01 a12 : Q,
    exists eps0 eps1 eps2 : Q,
      (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\ (eps2*eps2 == 1)%Q /\
      (0 <= eps0*eps1*a01)%Q /\ (0 <= eps1*eps2*a12)%Q.
Proof.
  intros a01 a12.
  destruct (qsign_exists a01) as [e1 [He1sq He1pos]].
  destruct (qsign_exists a12) as [e2 [He2sq He2pos]].
  exists (1#1)%Q, e1, (e1*e2)%Q.
  repeat split.
  (* the eps0*eps0==1 conjunct (eps0=(1#1)) is discharged by `repeat split`
     itself (a literal reflexive Qeq); four goals remain, matching the
     four bullets below. *)
  - exact He1sq.
  - assert (H : ((e1*e2)*(e1*e2) == (e1*e1)*(e2*e2))%Q) by ring.
    rewrite H, He1sq, He2sq. ring.
  - assert (H : ((1#1)*e1*a01 == e1*a01)%Q) by ring.
    rewrite H. exact He1pos.
  - assert (H : (e1*(e1*e2)*a12 == (e1*e1)*(e2*a12))%Q) by ring.
    rewrite H, He1sq.
    assert (H2 : ((1#1)*(e2*a12) == e2*a12)%Q) by ring.
    rewrite H2. exact He2pos.
Qed.

(* star3 — center 0, leaves 1,2; edges (0,1) weight a01, (0,2) weight a02. *)
Theorem tree_gauge_fixable_star3 :
  forall a01 a02 : Q,
    exists eps0 eps1 eps2 : Q,
      (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\ (eps2*eps2 == 1)%Q /\
      (0 <= eps0*eps1*a01)%Q /\ (0 <= eps0*eps2*a02)%Q.
Proof.
  intros a01 a02.
  destruct (qsign_exists a01) as [e1 [He1sq He1pos]].
  destruct (qsign_exists a02) as [e2 [He2sq He2pos]].
  exists (1#1)%Q, e1, e2.
  repeat split.
  (* eps0*eps0==1 auto-discharged by `repeat split`, as above. *)
  - exact He1sq.
  - exact He2sq.
  - assert (H : ((1#1)*e1*a01 == e1*a01)%Q) by ring.
    rewrite H. exact He1pos.
  - assert (H : ((1#1)*e2*a02 == e2*a02)%Q) by ring.
    rewrite H. exact He2pos.
Qed.

(* P4 — path 0-1-2-3, edges (0,1) a01, (1,2) a12, (2,3) a23.  Root at 0. *)
Theorem tree_gauge_fixable_P4 :
  forall a01 a12 a23 : Q,
    exists eps0 eps1 eps2 eps3 : Q,
      (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\
      (eps2*eps2 == 1)%Q /\ (eps3*eps3 == 1)%Q /\
      (0 <= eps0*eps1*a01)%Q /\ (0 <= eps1*eps2*a12)%Q /\
      (0 <= eps2*eps3*a23)%Q.
Proof.
  intros a01 a12 a23.
  destruct (qsign_exists a01) as [e1 [He1sq He1pos]].
  destruct (qsign_exists a12) as [e2 [He2sq He2pos]].
  destruct (qsign_exists a23) as [e3 [He3sq He3pos]].
  exists (1#1)%Q, e1, (e1*e2)%Q, (e1*e2*e3)%Q.
  repeat split.
  (* eps0*eps0==1 auto-discharged by `repeat split`, as above. *)
  - exact He1sq.
  - assert (H : ((e1*e2)*(e1*e2) == (e1*e1)*(e2*e2))%Q) by ring.
    rewrite H, He1sq, He2sq. ring.
  - assert (H : ((e1*e2*e3)*(e1*e2*e3)
                == ((e1*e1)*(e2*e2))*(e3*e3))%Q) by ring.
    rewrite H, He1sq, He2sq, He3sq. ring.
  - assert (H : ((1#1)*e1*a01 == e1*a01)%Q) by ring.
    rewrite H. exact He1pos.
  - assert (H : (e1*(e1*e2)*a12 == (e1*e1)*(e2*a12))%Q) by ring.
    rewrite H, He1sq.
    assert (H2 : ((1#1)*(e2*a12) == e2*a12)%Q) by ring.
    rewrite H2. exact He2pos.
  - assert (H : ((e1*e2)*(e1*e2*e3)*a23
                == ((e1*e1)*(e2*e2))*(e3*a23))%Q) by ring.
    rewrite H, He1sq, He2sq.
    assert (H2 : (((1#1)*(1#1))*(e3*a23) == e3*a23)%Q) by ring.
    rewrite H2. exact He3pos.
Qed.

(* star4 — center 0, leaves 1,2,3; edges (0,1) a01, (0,2) a02, (0,3) a03. *)
Theorem tree_gauge_fixable_star4 :
  forall a01 a02 a03 : Q,
    exists eps0 eps1 eps2 eps3 : Q,
      (eps0*eps0 == 1)%Q /\ (eps1*eps1 == 1)%Q /\
      (eps2*eps2 == 1)%Q /\ (eps3*eps3 == 1)%Q /\
      (0 <= eps0*eps1*a01)%Q /\ (0 <= eps0*eps2*a02)%Q /\
      (0 <= eps0*eps3*a03)%Q.
Proof.
  intros a01 a02 a03.
  destruct (qsign_exists a01) as [e1 [He1sq He1pos]].
  destruct (qsign_exists a02) as [e2 [He2sq He2pos]].
  destruct (qsign_exists a03) as [e3 [He3sq He3pos]].
  exists (1#1)%Q, e1, e2, e3.
  repeat split.
  (* eps0*eps0==1 auto-discharged by `repeat split`, as above. *)
  - exact He1sq.
  - exact He2sq.
  - exact He3sq.
  - assert (H : ((1#1)*e1*a01 == e1*a01)%Q) by ring.
    rewrite H. exact He1pos.
  - assert (H : ((1#1)*e2*a02 == e2*a02)%Q) by ring.
    rewrite H. exact He2pos.
  - assert (H : ((1#1)*e3*a03 == e3*a03)%Q) by ring.
    rewrite H. exact He3pos.
Qed.

(* [Open], declared not proved: general structural induction over an
   abstract tree's edge set (arbitrary depth, arbitrary branching) — the
   four concrete instances above cover every n=3/n=4 tree shape 5.2b-1's
   own search actually visits, but a general-n tree_gauge_fixable theorem
   is unwritten. *)
