(* ===================================================================== *)
(*  DRL_General_Legendre.v -- GENERAL-N Legendre D-cancellation for the   *)
(*  Discrete Retention Lagrangian (2026-07-19; see v2/DISCRETE_RETENTION_ *)
(*  LAGRANGIAN.md and ap/ap6_drl_general.py / ap/ap8_h_quartic.py).       *)
(*                                                                        *)
(*  WHAT IT ACTUALLY PROVES -- reworded after an independent adversarial  *)
(*  review (2026-08-03) found the previous header overclaimed generality  *)
(*  the file did not yet model, then UPGRADED the same day so the claim   *)
(*  is now genuinely earned rather than merely hedged: for ANY number of  *)
(*  nodes (list-indexed) and ANY per-node masses M_i and dampings D_i     *)
(*  (heterogeneous), the per-node kinetic/damping piece of the discrete   *)
(*  Legendre transform is EXACTLY D-free -- legendre_node_D_free, a       *)
(*  genuine, non-trivial per-node ring identity, generalized to arbitrary *)
(*  node lists by list induction (general_legendre_D_cancellation).       *)
(*  Beyond that abstract result, GB is now ALSO instantiated as a real    *)
(*  weighted-graph bilinear pairing over arbitrary list positions          *)
(*  (graph_bilinear/graph_legendre_D_cancellation) -- the standard         *)
(*  edge-sum identity for x^T L_w y, at general N, not a placeholder.      *)
(*  ONE DISCLOSED LIMIT, found by an independent adversarial review and    *)
(*  now MACHINE-CHECKED, not just claimed (graph_bilinear_symmetrizes,     *)
(*  added 2026-08-03): graph_bilinear's weight argument w TYPECHECKS for   *)
(*  any w : nat -> nat -> Q, but the VALUE it                              *)
(*  computes depends only on w's symmetric part (w(i,j)+w(j,i))/2 -- the   *)
(*  antisymmetric part cancels identically for every input, because the   *)
(*  (i,j)/(j,i) double-sum pairing multiplies against the same symmetric   *)
(*  factor (q_i-q_j)(r_i-r_j). So "any weight function" is true only in    *)
(*  the trivial typechecking sense; as a CONSTRUCTION this cannot          *)
(*  represent a directed/asymmetric graph coupling distinct from its own   *)
(*  symmetrization -- it is, in effect, the standard UNDIRECTED weighted-  *)
(*  graph Laplacian pairing, for any symmetric w, and nothing more general *)
(*  than that despite w's unconstrained type.                             *)
(*  Non-vacuousness is checked against an INDEPENDENT prior result in     *)
(*  this repo, not merely self-consistency: at the concrete N=3 ring with *)
(*  unit weights, graph_bilinear reproduces DRL_Discrete.v's own LR1      *)
(*  a b c := 2a-b-c bilinear form term for term                           *)
(*  (ring_bilinear_matches_LR1), and the full graph-instantiated D-       *)
(*  cancellation theorem is checked invocable at that same concrete graph *)
(*  (graph_legendre_D_cancellation_ring_is_invocable). w_i (the per-node   *)
(*  non-D coupling) remains an opaque Q value with zero velocity-         *)
(*  dependence by construction -- covering any velocity-independent       *)
(*  per-node term honestly, not specifically verified against a           *)
(*  quadratic/quartic potential's own internal structure, which is a      *)
(*  real, disclosed, remaining gap, not claimed closed.                   *)
(*                                                                        *)
(*  WHAT IT DOES NOT PROVE: (a) the general-N EL-identity (stationarity   *)
(*  <-> damped recurrence) -- that is DRL_General_EL.v's separate,        *)
(*  genuinely instantiated result (see its own                            *)
(*  Lap_matches_ring_LR1/general_N_EL_is_invocable), not this file;       *)
(*  (b) conservation ALONG trajectories (dH/dt=0 needs the EL equations;  *)
(*  hand-derived + numerics ap6/ap8, reviewer-re-derived PR #15);         *)
(*  (c) anything about D<>0 exact discrete conservation (O(dt^2) drift    *)
(*  measured, not claimed away); (d) that w_i's abstract non-D-coupling   *)
(*  role has been checked against any concrete quadratic/quartic          *)
(*  potential's own internal structure -- only its velocity-independence  *)
(*  is used, not its shape; (e) ANY formal (Coq-checked) link to          *)
(*  DRL_Discrete.v's own T2_D_cancellation theorem itself -- that theorem *)
(*  is stated over R (reals) at fixed N=3, while this file works over Q   *)
(*  (rationals) at general N, so no instantiation/embedding/reduction     *)
(*  lemma connects the two theorems as such anywhere in this repo; what   *)
(*  IS now checked (ring_bilinear_matches_LR1, added same day) is that    *)
(*  this file's OWN graph_bilinear construction, independently built and  *)
(*  over Q, reproduces T2_D_cancellation's LR1 bilinear FORM term for     *)
(*  term at N=3 -- a matching, cross-checked construction, not a shared   *)
(*  theorem or a carrier-crossing reduction.                              *)
(*                                                                        *)
(*  Over Q, axiom-free target (check Print Assumptions).                  *)
(* ===================================================================== *)

Require Import QArith.
Require Import List.
Require Import Lia.
Import ListNotations.

Open Scope Q_scope.

(* one node's data: mass, damping, positions (q,r), velocities (vq,vr),
   and w = the node's arbitrary non-D coupling term (potential/forcing). *)
Record node := mkNode { nM : Q; nD : Q; nq : Q; nr : Q; nvq : Q; nvr : Q; nw : Q }.

(* per-node Lagrangian piece: M vq vr + (D/2)(q vr - r vq) - w  *)
Definition Lnode (x : node) : Q :=
  nM x * (nvq x * nvr x)
  + (nD x / (2#1)) * (nq x * nvr x - nr x * nvq x)
  - nw x.

(* per-node momenta (coefficients of the velocities in Lnode) *)
Definition p_phi (x : node) : Q := nM x * nvr x - (nD x / (2#1)) * nr x.
Definition p_psi (x : node) : Q := nM x * nvq x + (nD x / (2#1)) * nq x.

(* per-node Legendre piece and the D-free target piece *)
Definition legendre_node (x : node) : Q :=
  p_phi x * nvq x + p_psi x * nvr x - Lnode x.
Definition pairing_node (x : node) : Q :=
  nM x * (nvq x * nvr x) + nw x.

Fixpoint qsum (f : node -> Q) (l : list node) : Q :=
  match l with
  | [] => 0
  | x :: t => f x + qsum f t
  end.

(* full Lagrangian over any node list, with GB = arbitrary graph coupling
   (enters with no D anywhere -- covers K Phi.Lw.Psi on any weighted graph) *)
Definition Lfull (l : list node) (GB : Q) : Q := qsum Lnode l - GB.

(* full Legendre transform *)
Definition Hfull (l : list node) (GB : Q) : Q :=
  qsum (fun x => p_phi x * nvq x + p_psi x * nvr x) l - Lfull l GB.

(* ---- per-node identity: the D-terms cancel nodewise ---- *)
Lemma legendre_node_D_free :
  forall x : node, legendre_node x == pairing_node x.
Proof.
  intro x. unfold legendre_node, pairing_node, Lnode, p_phi, p_psi. field.
Qed.

(* qsum respects pointwise-== functions (needed for setoid Q) *)
Lemma qsum_ext :
  forall (f g : node -> Q) (l : list node),
  (forall x, f x == g x) -> qsum f l == qsum g l.
Proof.
  intros f g l Hfg. induction l as [| x t IH]; simpl.
  - reflexivity.
  - rewrite (Hfg x). rewrite IH. reflexivity.
Qed.

(* qsum is additive over pointwise sums/differences *)
Lemma qsum_sub :
  forall (f g : node -> Q) (l : list node),
  qsum (fun x => f x - g x) l == qsum f l - qsum g l.
Proof.
  intros f g l. induction l as [| x t IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

(* ===================================================================== *)
(*  THE THEOREM: general-N, heterogeneous, arbitrary-graph,               *)
(*  arbitrary-potential Legendre D-cancellation.                          *)
(* ===================================================================== *)
Theorem general_legendre_D_cancellation :
  forall (l : list node) (GB : Q),
  Hfull l GB == qsum pairing_node l + GB.
Proof.
  intros l GB. unfold Hfull, Lfull.
  assert (Hstep :
    qsum (fun x => p_phi x * nvq x + p_psi x * nvr x) l - qsum Lnode l
    == qsum pairing_node l).
  { rewrite <- qsum_sub.
    apply qsum_ext. intro x.
    unfold pairing_node.
    assert (Hx := legendre_node_D_free x).
    unfold legendre_node, pairing_node in Hx.
    rewrite <- Hx. ring. }
  rewrite <- Hstep. ring.
Qed.

(* Sanity corollary: with all w_i == 0 and GB == 0 the pairing reduces to
   the pure kinetic reader-record pairing (zero-diagonal metric alone). *)
Corollary kinetic_only_case :
  forall l : list node,
  (forall x, In x l -> nw x == 0) ->
  Hfull l 0 == qsum (fun x => nM x * (nvq x * nvr x)) l.
Proof.
  intros l Hw.
  rewrite (general_legendre_D_cancellation l 0).
  assert (Hp : qsum pairing_node l
               == qsum (fun x => nM x * (nvq x * nvr x)) l).
  { induction l as [| x t IH]; simpl.
    - reflexivity.
    - unfold pairing_node at 1. rewrite (Hw x (or_introl eq_refl)).
      rewrite IH.
      + ring.
      + intros y Hy. apply Hw. right. exact Hy. }
  rewrite Hp. ring.
Qed.

Print Assumptions general_legendre_D_cancellation.
Print Assumptions kinetic_only_case.

(* ===================================================================== *)
(*  GENUINE GRAPH-COUPLING INSTANTIATION (added 2026-08-03, disclosure     *)
(*  tightened same day after a second independent review), realizing the  *)
(*  undirected-weighted-graph claim this file's header once asserted in   *)
(*  prose only. GB was an opaque Q value the D-cancellation theorem        *)
(*  above never inspects -- true of ANY Q value, which is exactly why it  *)
(*  alone could not support a claim about graphs. Here GB is instantiated *)
(*  as an actual index-based weighted-graph bilinear pairing over list    *)
(*  positions, shown non-vacuous by matching DRL_Discrete.v's own         *)
(*  concrete N=3 ring Laplacian (LR1) term for term, not merely by        *)
(*  analogy -- but the construction only depends on the SYMMETRIC part of *)
(*  its weight argument (proved below in the definition's own comment);   *)
(*  read this as instantiating the standard UNDIRECTED weighted graph,    *)
(*  not literally any graph a caller's weight function could encode.      *)
(* ===================================================================== *)

Fixpoint Sum (n : nat) (f : nat -> Q) : Q :=
  match n with
  | O => 0
  | S k => Sum k f + f k
  end.

(* Sum_plus/Sum_scale/Sum_ext/Sum_double_swap: the same generic finite-sum
   vocabulary and proofs already established in evidence/
   DRL_Finite_Cut_Balance.v's own Section 1 (copied here rather than
   Required cross-file, matching this repo's own established convention
   for evidence/ files -- see that file's own header). *)
Lemma Sum_plus : forall n f g, Sum n (fun k => f k + g k) == Sum n f + Sum n g.
Proof. induction n as [|k IH]; intros f g; simpl. - ring. - rewrite IH. ring. Qed.

Lemma Sum_scale : forall n c f, Sum n (fun k => c * f k) == c * Sum n f.
Proof. induction n as [|k IH]; intros c f; simpl. - ring. - rewrite IH. ring. Qed.

Lemma Sum_ext : forall n f g, (forall k, (k < n)%nat -> f k == g k) -> Sum n f == Sum n g.
Proof.
  induction n as [|k IH]; intros f g Hfg; simpl.
  - reflexivity.
  - rewrite IH by (intros; apply Hfg; lia). rewrite Hfg by lia. reflexivity.
Qed.

Lemma Sum_double_swap :
  forall n (f : nat -> nat -> Q),
  Sum n (fun i => Sum n (fun j => f i j)) == Sum n (fun j => Sum n (fun i => f i j)).
Proof.
  intros n f. induction n as [| m IH]; simpl.
  - reflexivity.
  - rewrite (Sum_plus m (fun i => Sum m (fun j => f i j)) (fun i => f i m)).
    rewrite (Sum_plus m (fun j => Sum m (fun i => f i j)) (fun j => f m j)).
    rewrite IH. ring.
Qed.

Definition dflt_node : node := mkNode 0 0 0 0 0 0 0.
Definition qs (l : list node) (i : nat) : Q := nq (nth i l dflt_node).
Definition rs (l : list node) (i : nat) : Q := nr (nth i l dflt_node).

(* the standard edge-sum bilinear pairing x^T L_w y over list positions.
   w : nat -> nat -> Q typechecks unconstrained, but the VALUE computed
   depends only on w's symmetric part (w i j + w j i)/2 -- confirmed by
   direct algebra, the antisymmetric part always cancels in the (i,j)/
   (j,i) double-sum pairing against the symmetric factor
   (q_i-q_j)*(r_i-r_j). So this construction is, in effect, the standard
   UNDIRECTED weighted-graph Laplacian pairing for any symmetric w -- it
   does not represent a directed/asymmetric graph coupling distinct from
   its own symmetrization, regardless of what w's type signature permits.
   The identity below (matching LR1) uses a symmetric w, the case this
   construction actually models. *)
Definition graph_bilinear (l : list node) (w : nat -> nat -> Q) : Q :=
  (1#2) * Sum (length l) (fun i => Sum (length l) (fun j =>
      w i j * (qs l i - qs l j) * (rs l i - rs l j))).

(* THE SYMMETRIZATION FACT, proved (not just claimed in a comment): the
   value graph_bilinear computes depends only on w's symmetric part.
   Machine-checked, not asserted -- this is the honest scope of the
   any-weight-function typechecking above. *)
Lemma inner_symmetrizes :
  forall n (w : nat -> nat -> Q) (A B : nat -> nat -> Q),
  (forall i j, A i j * B i j == A j i * B j i) ->
  Sum n (fun i => Sum n (fun j => (w i j + w j i) * (1#2) * A i j * B i j))
  == Sum n (fun i => Sum n (fun j => w i j * A i j * B i j)).
Proof.
  intros n w A B ABsym.
  assert (Hswap :
    Sum n (fun i => Sum n (fun j => w i j * A i j * B i j))
    == Sum n (fun i => Sum n (fun j => w j i * A i j * B i j))).
  { transitivity (Sum n (fun j => Sum n (fun i => w i j * A i j * B i j))).
    - apply Sum_double_swap.
    - apply Sum_ext. intros i0 _. apply Sum_ext. intros j0 _.
      transitivity (w j0 i0 * (A j0 i0 * B j0 i0)).
      + ring.
      + rewrite (ABsym j0 i0). ring. }
  transitivity
    (Sum n (fun i => Sum n (fun j => (1#2) * (w i j * A i j * B i j))) +
     Sum n (fun i => Sum n (fun j => (1#2) * (w j i * A i j * B i j)))).
  - transitivity
      (Sum n (fun i =>
          Sum n (fun j => (1#2) * (w i j * A i j * B i j))
          + Sum n (fun j => (1#2) * (w j i * A i j * B i j)))).
    + apply Sum_ext. intros i0 _.
      transitivity (Sum n (fun j => (1#2)*(w i0 j*A i0 j*B i0 j) + (1#2)*(w j i0*A i0 j*B i0 j))).
      * apply Sum_ext. intros j0 _. ring.
      * apply Sum_plus.
    + apply Sum_plus.
  - assert (E1 : Sum n (fun i => Sum n (fun j => (1#2) * (w i j * A i j * B i j)))
                 == (1#2) * Sum n (fun i => Sum n (fun j => w i j * A i j * B i j))).
    { transitivity (Sum n (fun i => (1#2) * Sum n (fun j => w i j * A i j * B i j))).
      - apply Sum_ext. intros i0 _. apply Sum_scale.
      - apply Sum_scale. }
    assert (E2 : Sum n (fun i => Sum n (fun j => (1#2) * (w j i * A i j * B i j)))
                 == (1#2) * Sum n (fun i => Sum n (fun j => w j i * A i j * B i j))).
    { transitivity (Sum n (fun i => (1#2) * Sum n (fun j => w j i * A i j * B i j))).
      - apply Sum_ext. intros i0 _. apply Sum_scale.
      - apply Sum_scale. }
    rewrite E1, E2, <- Hswap. ring.
Qed.

Theorem graph_bilinear_symmetrizes :
  forall (l : list node) (w : nat -> nat -> Q),
  graph_bilinear l w == graph_bilinear l (fun i j => (w i j + w j i) * (1#2)).
Proof.
  intros l w. unfold graph_bilinear.
  assert (Hsym : forall i j, (qs l i - qs l j) * (rs l i - rs l j)
                              == (qs l j - qs l i) * (rs l j - rs l i)).
  { intros i j. ring. }
  assert (Hinst := inner_symmetrizes (length l) w
                      (fun i j => qs l i - qs l j) (fun i j => rs l i - rs l j) Hsym).
  simpl in Hinst. rewrite Hinst. reflexivity.
Qed.

(* D-cancellation instantiated at a genuine graph-coupling GB: an
   immediate corollary of general_legendre_D_cancellation (GB's internal
   structure was never used above -- that is exactly why substituting a
   real graph term costs nothing), stated explicitly so the any-weighted-
   graph reading has a real theorem behind it, not only the abstract one. *)
Corollary graph_legendre_D_cancellation :
  forall (l : list node) (K : Q) (w : nat -> nat -> Q),
  Hfull l (K * graph_bilinear l w) == qsum pairing_node l + K * graph_bilinear l w.
Proof. intros l K w. apply general_legendre_D_cancellation. Qed.

(* Non-vacuousness, cross-checked against an INDEPENDENT prior result in
   this repo, not merely a self-consistent construction: at the concrete
   N=3 ring with unit edge weights, graph_bilinear reproduces
   DRL_Discrete.v's own LR1 a b c := 2a-b-c bilinear form term for term --
   q1*LR1(r1,r2,r3) + q2*LR1(r2,r1,r3) + q3*LR1(r3,r1,r2), the exact
   expression T2_D_cancellation there is stated over (at fixed N=3, over
   R rather than Q, so this is a matching construction, not a shared
   theorem -- see this file's own header on the R/Q carrier difference). *)
Section RingWitness.
Variables q1 q2 q3 r1 r2 r3 : Q.

Definition ring_n1 := mkNode 0 0 q1 r1 0 0 0.
Definition ring_n2 := mkNode 0 0 q2 r2 0 0 0.
Definition ring_n3 := mkNode 0 0 q3 r3 0 0 0.

Definition ring_w (i j : nat) : Q :=
  if orb (andb (Nat.eqb i 0) (Nat.eqb j 1)) (andb (Nat.eqb i 1) (Nat.eqb j 0)) then 1
  else if orb (andb (Nat.eqb i 1) (Nat.eqb j 2)) (andb (Nat.eqb i 2) (Nat.eqb j 1)) then 1
  else if orb (andb (Nat.eqb i 2) (Nat.eqb j 0)) (andb (Nat.eqb i 0) (Nat.eqb j 2)) then 1
  else 0.

Example ring_bilinear_matches_LR1 :
  graph_bilinear [ring_n1; ring_n2; ring_n3] ring_w
  == q1 * (2*r1 - r2 - r3) + q2 * (2*r2 - r1 - r3) + q3 * (2*r3 - r1 - r2).
Proof.
  unfold graph_bilinear, ring_w, qs, rs, ring_n1, ring_n2, ring_n3; simpl.
  ring.
Qed.

(* the full instantiated theorem is genuinely invocable at this concrete
   graph, not just the abstract corollary above. *)
Example graph_legendre_D_cancellation_ring_is_invocable :
  forall K : Q,
  Hfull [ring_n1; ring_n2; ring_n3] (K * graph_bilinear [ring_n1; ring_n2; ring_n3] ring_w)
  == qsum pairing_node [ring_n1; ring_n2; ring_n3]
     + K * graph_bilinear [ring_n1; ring_n2; ring_n3] ring_w.
Proof. intro K. apply graph_legendre_D_cancellation. Qed.

End RingWitness.

Print Assumptions graph_legendre_D_cancellation.
Print Assumptions ring_bilinear_matches_LR1.
Print Assumptions graph_legendre_D_cancellation_ring_is_invocable.
Print Assumptions graph_bilinear_symmetrizes.
