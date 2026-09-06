(* ===================================================================== *)
(*  DRL_General_EL.v -- GENERAL-N Euler-Lagrange identity for the         *)
(*  Discrete Retention Lagrangian, on an arbitrary symmetric-weighted     *)
(*  graph (C2 of v2/urr/URR_C_COQ_FORMAL_CHAIN.yaml's next_formal_targets,*)
(*  target: general_N_Euler_Lagrange_theorem).                            *)
(*                                                                        *)
(*  Ground truth: v2/DISCRETE_RETENTION_LAGRANGIAN.md; the N=3 ring case  *)
(*  is DRL_Discrete.v's T1 (proved by unrolled hand computation, no list  *)
(*  induction). This file removes the N=3/ring restriction: nodes are a  *)
(*  `list nat` of arbitrary (finite) size, the graph coupling is an      *)
(*  arbitrary SYMMETRIC weight function W : nat -> nat -> Q (the ring's   *)
(*  concrete LR1 is the special case W i j = 1 if |i-j|=1 mod N, 0        *)
(*  otherwise -- not re-derived here, this file works at the abstract-W   *)
(*  level, same generality contract as DRL_General_Legendre.v's abstract  *)
(*  GB), and masses/dampings/potential-coefficients are per-node          *)
(*  (heterogeneous), matching DRL_General_Legendre.v.                     *)
(*                                                                        *)
(*  WHAT IT PROVES: for any NoDup node-index list, any symmetric W, any   *)
(*  per-node M_i<>0, D_i, K2_i, at ANY single node k in the list, the     *)
(*  central-difference stationarity of the discrete action w.r.t. Psi_k   *)
(*  at the interior time slice is algebraically equivalent (an iff, by    *)
(*  field/ring over Q, no approximation) to the per-node damped           *)
(*  recurrence -- the direct list-indexed generalization of DRL_Discrete  *)
(*  .v's T1_el_psi_node1/node2, now for ANY node of ANY graph, not just   *)
(*  nodes 1/2 of a 3-ring.                                                *)
(*                                                                        *)
(*  WHAT IT DOES NOT PROVE: (a) the Phi-variation (sign-flipped recurrence*)
(*  -- DRL_Discrete.v's T1_el_phi_node1 shows the pattern for N=3/node 1; *)
(*  the general-N Phi case is the same technique mirrored and is left for *)
(*  a follow-up, not attempted here to keep this file's scope honest);    *)
(*  (b) conservation ALONG trajectories (needs the EL equations chained   *)
(*  over many steps -- Gate/T3 territory, out of scope).                  *)
(*                                                                        *)
(*  SANITY CHECK (Section 4, below the main theorem): the concrete ring   *)
(*  LR1 of DRL_Discrete.v (LR1 a b c = 2a-b-c) IS mechanically checked    *)
(*  here to be exactly Lap idxs Wring at N=3 with unit ring weights --    *)
(*  i.e. this file's abstract W genuinely subsumes, not just resembles,  *)
(*  the earlier concrete case -- and the theorem is checked non-vacuous  *)
(*  by actually invoking it at that same N=3 ring instantiation.          *)
(*                                                                        *)
(*  Over Q, axiom-free target (check Print Assumptions).                  *)
(* ===================================================================== *)

Require Import QArith.
Require Import List.
Require Import Arith.
Import ListNotations.

Open Scope Q_scope.

(* ===================================================================== *)
(*  Section 1: list-indexed sums and the double-sum swap lemma.           *)
(* ===================================================================== *)

Fixpoint qsum_idx (idxs : list nat) (f : nat -> Q) : Q :=
  match idxs with
  | [] => 0
  | i :: t => f i + qsum_idx t f
  end.

Lemma qsum_idx_ext :
  forall (f g : nat -> Q) (idxs : list nat),
  (forall i, In i idxs -> f i == g i) -> qsum_idx idxs f == qsum_idx idxs g.
Proof.
  intros f g idxs Hfg. induction idxs as [| i t IH]; simpl.
  - reflexivity.
  - rewrite (Hfg i (or_introl eq_refl)). rewrite IH.
    + reflexivity.
    + intros j Hj. apply Hfg. right. exact Hj.
Qed.

Lemma qsum_idx_add :
  forall (f g : nat -> Q) (idxs : list nat),
  qsum_idx idxs (fun i => f i + g i) == qsum_idx idxs f + qsum_idx idxs g.
Proof.
  intros f g idxs. induction idxs as [| i t IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

Lemma qsum_idx_sub :
  forall (f g : nat -> Q) (idxs : list nat),
  qsum_idx idxs (fun i => f i - g i) == qsum_idx idxs f - qsum_idx idxs g.
Proof.
  intros f g idxs. induction idxs as [| i t IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

Lemma qsum_idx_scale :
  forall (c : Q) (f : nat -> Q) (idxs : list nat),
  qsum_idx idxs (fun i => c * f i) == c * qsum_idx idxs f.
Proof.
  intros c f idxs. induction idxs as [| i t IH]; simpl.
  - ring.
  - rewrite IH. ring.
Qed.

(* Fubini for finite list double sums: the double sum does not care which
   list is walked first. Pure structural induction on idxs1, using
   qsum_idx_add to merge/split the inner sums at each step. *)
Lemma qsum_idx_double_swap :
  forall (idxs1 idxs2 : list nat) (f : nat -> nat -> Q),
  qsum_idx idxs1 (fun i => qsum_idx idxs2 (fun j => f i j))
  == qsum_idx idxs2 (fun j => qsum_idx idxs1 (fun i => f i j)).
Proof.
  intros idxs1 idxs2 f. induction idxs1 as [| i t IH]; simpl.
  - induction idxs2 as [| j t2 IH2]; simpl.
    + reflexivity.
    + rewrite <- IH2. ring.
  - rewrite IH.
    rewrite <- qsum_idx_add.
    apply qsum_idx_ext. intros j _. simpl. reflexivity.
Qed.

(* ===================================================================== *)
(*  Section 2: the graph Laplacian and the key bilinear-swap identity.    *)
(* ===================================================================== *)

Section Graph.

Variable idxs : list nat.
Variable W : nat -> nat -> Q.
Hypothesis Wsym : forall i j, W i j == W j i.

Definition Lap (X : nat -> Q) (i : nat) : Q :=
  qsum_idx idxs (fun j => W i j * (X i - X j)).

(* THE KEY LEMMA: sum_i P_i (L S)_i == sum_i S_i (L P)_i, i.e. the graph
   Laplacian bilinear form P.(L S) is symmetric in (P,S). This is what
   lets a variation w.r.t. S at one node read off its coefficient as an
   L-applied-to-P quantity (matching T1's "the Psi-gradient's Laplacian
   term uses P, not S" observation, now derived instead of hand-checked
   at N=3). Proved by expanding both sides into (i,j)-indexed double
   sums, swapping the double sum via qsum_idx_double_swap, relabeling
   the swapped indices, and using symmetry of W. *)
Lemma qsum_bilinear_expand :
  forall (X Y : nat -> Q),
  qsum_idx idxs (fun i => X i * Lap Y i)
  == qsum_idx idxs (fun i => qsum_idx idxs (fun j => X i * W i j * Y i))
     - qsum_idx idxs (fun i => qsum_idx idxs (fun j => X i * W i j * Y j)).
Proof.
  intros X Y. unfold Lap.
  rewrite <- qsum_idx_sub.
  apply qsum_idx_ext. intros i _.
  rewrite <- qsum_idx_sub.
  rewrite <- qsum_idx_scale.
  apply qsum_idx_ext. intros j _.
  ring.
Qed.

Lemma bilinear_swap :
  forall (P S : nat -> Q),
  qsum_idx idxs (fun i => P i * Lap S i)
  == qsum_idx idxs (fun i => S i * Lap P i).
Proof.
  intros P S.
  rewrite (qsum_bilinear_expand P S), (qsum_bilinear_expand S P).
  (* Now: [sum_i sum_j P_i W_ij S_i] - [sum_i sum_j P_i W_ij S_j]
     == [sum_i sum_j S_i W_ij P_i] - [sum_i sum_j S_i W_ij P_j].
     First bracket on each side is termwise-equal by commutativity.
     Second brackets are equal after swapping the double-sum order and
     relabeling (i<->j), using symmetry of W. *)
  assert (Hfirst :
    qsum_idx idxs (fun i => qsum_idx idxs (fun j => P i * W i j * S i))
    == qsum_idx idxs (fun i => qsum_idx idxs (fun j => S i * W i j * P i))).
  { apply qsum_idx_ext. intros i _. apply qsum_idx_ext. intros j _. ring. }
  assert (Hsecond :
    qsum_idx idxs (fun i => qsum_idx idxs (fun j => P i * W i j * S j))
    == qsum_idx idxs (fun i => qsum_idx idxs (fun j => S i * W i j * P j))).
  { rewrite (qsum_idx_double_swap idxs idxs (fun i j => P i * W i j * S j)).
    apply qsum_idx_ext. intros j _.
    apply qsum_idx_ext. intros i _.
    rewrite (Wsym i j). ring. }
  rewrite Hfirst, Hsecond. reflexivity.
Qed.

(* Isolate one node k's term from a qsum_idx: rest depends only on
   (k, idxs'), NOT on the summed function -- so a single instantiation
   of `rest` works for every f uniformly, which is what letting a
   perturbation at k alone determine the whole sum's change needs. *)
Lemma isolate_index :
  forall (k : nat) (idxs' : list nat),
  NoDup idxs' -> In k idxs' ->
  exists rest : list nat,
    (~ In k rest)
    /\ (forall x, In x rest -> In x idxs')
    /\ (forall f : nat -> Q, qsum_idx idxs' f == f k + qsum_idx rest f).
Proof.
  intros k idxs' Hnd Hin.
  induction idxs' as [| i t IH]; simpl in Hin.
  - contradiction.
  - inversion Hnd as [| i0 t0 Hni Hnd' Heq]; subst.
    destruct Hin as [Heqik | Hin'].
    + subst i. exists t.
      split. { exact Hni. }
      split. { intros x Hx. right. exact Hx. }
      intros f. simpl. reflexivity.
    + destruct (IH Hnd' Hin') as [rest [Hnotin [Hsub Heqf]]].
      exists (i :: rest).
      split.
      { intro Hc. destruct Hc as [Heqki | Hc'].
        - subst i. apply Hni. exact Hin'.
        - apply Hnotin. exact Hc'. }
      split.
      { intros x Hx. destruct Hx as [Heqxi | Hx'].
        - subst x. left. reflexivity.
        - right. apply Hsub. exact Hx'. }
      intros f. simpl. rewrite (Heqf f). ring.
Qed.

End Graph.

(* ===================================================================== *)
(*  Section: overriding one node's value in a node-indexed function, and  *)
(*  how a qsum_idx that is LINEAR in that function changes when only one  *)
(*  index is overridden -- the general computational tool the EL theorem  *)
(*  needs, replacing the "unroll and let `field` do it" trick T1 used at  *)
(*  N=3 (which does not scale to an abstract list/abstract W).            *)
(* ===================================================================== *)

Definition override (X : nat -> Q) (k : nat) (v : Q) : nat -> Q :=
  fun i => if Nat.eq_dec i k then v else X i.

Lemma override_at : forall X k v, override X k v k = v.
Proof.
  intros X k v. unfold override. destruct (Nat.eq_dec k k) as [_ | Hne].
  - reflexivity.
  - contradiction Hne. reflexivity.
Qed.

Lemma override_other :
  forall X k v i, i <> k -> override X k v i = X i.
Proof.
  intros X k v i Hik. unfold override. destruct (Nat.eq_dec i k) as [Heq | _].
  - contradiction.
  - reflexivity.
Qed.

Lemma qsum_idx_override_diff :
  forall (idxs : list nat) (k : nat) (c X : nat -> Q) (a b : Q),
  NoDup idxs -> In k idxs ->
  qsum_idx idxs (fun i => c i * (override X k a) i)
  - qsum_idx idxs (fun i => c i * (override X k b) i)
  == c k * (a - b).
Proof.
  intros idxs k c X a b Hnd Hin.
  destruct (isolate_index k idxs Hnd Hin) as [rest [Hnotin [Hsub Heqf]]].
  rewrite (Heqf (fun i => c i * (override X k a) i)).
  rewrite (Heqf (fun i => c i * (override X k b) i)).
  simpl. rewrite (override_at X k a). rewrite (override_at X k b).
  assert (Hrest_eq :
    qsum_idx rest (fun i => c i * (override X k a) i)
    == qsum_idx rest (fun i => c i * (override X k b) i)).
  { apply qsum_idx_ext. intros x Hx.
    assert (Hxk : x <> k). { intro Heqxk. subst x. apply Hnotin. exact Hx. }
    rewrite (override_other X k a x Hxk).
    rewrite (override_other X k b x Hxk).
    reflexivity. }
  rewrite Hrest_eq. ring.
Qed.

(* ===================================================================== *)
(*  Section 3: the general-N discrete action and the EL-identity for the  *)
(*  Psi-variation at an arbitrary node k, arbitrary NoDup node list,      *)
(*  arbitrary symmetric W, arbitrary per-node M/D/K2 (heterogeneous).     *)
(* ===================================================================== *)

Section GeneralEL.

Variable idxs : list nat.
Hypothesis Hnd_idxs : NoDup idxs.
Variable W : nat -> nat -> Q.
Hypothesis Wsym : forall i j, W i j == W j i.
Variable Mn Dn K2n : nat -> Q.
Variable K dt : Q.

(* State at three consecutive time slices, as node-index -> Q functions.
   P = Phi (the "mirror"/momentum-doubled field, held fixed throughout --
   only Psi is varied below), S0/S2 = Psi at the boundary slices (also
   fixed); S1, the interior slice's Psi, is the one taken as an explicit
   argument to Sgen so it can be perturbed by `override`. *)
Variable P0 P1 P2 S0 S2 : nat -> Q.

(* The discrete action, direct list-indexed generalization of
   DRL_Discrete.v's Sfun: kinetic+damping between consecutive slice pairs
   (0,1) and (1,2), potential (graph coupling + per-node K2 term) at
   slices 0 and 1 only -- same shape as the N=3 file, just summed over
   idxs instead of unrolled over 3 named nodes. *)
Definition Sgen (S1 : nat -> Q) : Q :=
  let kin :=
    qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * (S1 i - S0 i)))
    + qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - S1 i)))
  in
  let damp :=
    qsum_idx idxs (fun i =>
      (Dn i / (2#1)) * (P0 i * (S1 i - S0 i) - S0 i * (P1 i - P0 i)))
    + qsum_idx idxs (fun i =>
      (Dn i / (2#1)) * (P1 i * (S2 i - S1 i) - S1 i * (P2 i - P1 i)))
  in
  let pot :=
    dt * ( K * qsum_idx idxs (fun i => P0 i * Lap idxs W S0 i)
           + qsum_idx idxs (fun i => K2n i * P0 i * S0 i)
           + K * qsum_idx idxs (fun i => P1 i * Lap idxs W S1 i)
           + qsum_idx idxs (fun i => K2n i * P1 i * S1 i) )
  in
  kin + damp - pot.

(* Central-difference probe at node k, slice 1, w.r.t. Psi. Only S1 at
   index k is perturbed (every other coordinate, including S1 at every
   OTHER node, is held fixed via `override`) -- the list-indexed analogue
   of DRL_Discrete.v's grad_S1_1/grad_S1_2, which perturbed one NAMED
   variable by hand at N=3. *)
Definition grad_Sgen_at (S1 : nat -> Q) (k : nat) (h : Q) : Q :=
  ( Sgen (override S1 k h) - Sgen (override S1 k (- h)) ) / (2 * h).

(* The per-node EL residual this variation must vanish against -- pure
   function of the FIXED data (Phi at all 3 slices; Psi never appears,
   exactly as in T1_el_psi_node1/node2, where the Psi-variation's
   stationarity condition is an equation purely in Phi). *)
Definition EL_psi_residual (k : nat) : Q :=
  (Mn k / dt^2) * (P2 k - (2#1) * P1 k + P0 k)
  + (Dn k / ((2#1) * dt)) * (P2 k - P0 k)
  + K * Lap idxs W P1 k + K2n k * P1 k.

(* THE KEY STEP: the central-difference numerator is exactly
   -2h dt (EL residual at k) -- a polynomial identity in h, requiring
   only `In k idxs` and W's symmetry, no h<>0/dt<>0 side condition yet
   (those are only needed to go from "numerator = 0" to "residual = 0"
   below). Each qsum_idx term that depends on the perturbed S1 is
   isolated via qsum_idx_override_diff (after the Laplacian term is
   first put in S-linear form via bilinear_swap); every other qsum_idx
   term is untouched by the override and cancels as an identical atom
   under `ring`. *)
Lemma Sgen_override_diff :
  forall (S1 : nat -> Q) (k : nat) (h : Q),
  In k idxs -> ~ dt == 0 ->
  Sgen (override S1 k h) - Sgen (override S1 k (- h))
  == - ((2#1) * h * dt) * EL_psi_residual k.
Proof.
  intros S1 k h Hin Hdt.
  unfold Sgen, EL_psi_residual.
  (* Split every qsum_idx term that could involve S1 ((override S1 k h)/(override S1 k (- h))) into a
     "coefficient * S1-value" part plus a part independent of S1, via
     pointwise ring identities, so qsum_idx_override_diff can apply. *)
  assert (Hkin1 :
    qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k h) i - S0 i)))
    - qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k (- h)) i - S0 i)))
    == (Mn k / dt) * (P1 k - P0 k) * ((2#1) * h)).
  { assert (E1 :
      qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k h) i - S0 i)))
      == qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * (override S1 k h) i)
         - qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * S0 i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    assert (E2 :
      qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k (- h)) i - S0 i)))
      == qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * (override S1 k (- h)) i)
         - qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * S0 i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    rewrite E1, E2.
    transitivity
      (qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * (override S1 k h) i)
       - qsum_idx idxs (fun i => ((Mn i / dt) * (P1 i - P0 i)) * (override S1 k (- h)) i)).
    { ring. }
    rewrite (qsum_idx_override_diff idxs k (fun i => (Mn i/dt)*(P1 i - P0 i)) S1 h (- h) Hnd_idxs Hin).
    ring. }
  assert (Hkin2 :
    qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k h) i)))
    - qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k (- h)) i)))
    == - (Mn k / dt) * (P2 k - P1 k) * ((2#1) * h)).
  { assert (E1 :
      qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k h) i)))
      == qsum_idx idxs (fun i => (Mn i / dt) * (P2 i - P1 i) * S2 i)
         - qsum_idx idxs (fun i => ((Mn i / dt) * (P2 i - P1 i)) * (override S1 k h) i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    assert (E2 :
      qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k (- h)) i)))
      == qsum_idx idxs (fun i => (Mn i / dt) * (P2 i - P1 i) * S2 i)
         - qsum_idx idxs (fun i => ((Mn i / dt) * (P2 i - P1 i)) * (override S1 k (- h)) i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    rewrite E1, E2.
    transitivity
      ( - (qsum_idx idxs (fun i => ((Mn i / dt) * (P2 i - P1 i)) * (override S1 k h) i)
           - qsum_idx idxs (fun i => ((Mn i / dt) * (P2 i - P1 i)) * (override S1 k (- h)) i))).
    { ring. }
    rewrite (qsum_idx_override_diff idxs k (fun i => (Mn i/dt)*(P2 i - P1 i)) S1 h (- h) Hnd_idxs Hin).
    ring. }
  assert (Hdamp1 :
    qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k h) i - S0 i) - S0 i * (P1 i - P0 i)))
    - qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k (- h)) i - S0 i) - S0 i * (P1 i - P0 i)))
    == (Dn k/(2#1)) * P0 k * ((2#1) * h)).
  { assert (E1 :
      qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k h) i - S0 i) - S0 i * (P1 i - P0 i)))
      == qsum_idx idxs (fun i => ((Dn i/(2#1)) * P0 i) * (override S1 k h) i)
         - qsum_idx idxs (fun i => (Dn i/(2#1)) * P0 i * S0 i + (Dn i/(2#1)) * S0 i * (P1 i - P0 i))).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    assert (E2 :
      qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k (- h)) i - S0 i) - S0 i * (P1 i - P0 i)))
      == qsum_idx idxs (fun i => ((Dn i/(2#1)) * P0 i) * (override S1 k (- h)) i)
         - qsum_idx idxs (fun i => (Dn i/(2#1)) * P0 i * S0 i + (Dn i/(2#1)) * S0 i * (P1 i - P0 i))).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    rewrite E1, E2.
    transitivity
      (qsum_idx idxs (fun i => ((Dn i/(2#1)) * P0 i) * (override S1 k h) i)
       - qsum_idx idxs (fun i => ((Dn i/(2#1)) * P0 i) * (override S1 k (- h)) i)).
    { ring. }
    rewrite (qsum_idx_override_diff idxs k (fun i => (Dn i/(2#1)) * P0 i) S1 h (- h) Hnd_idxs Hin).
    ring. }
  assert (Hdamp2 :
    qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k h) i) - (override S1 k h) i * (P2 i - P1 i)))
    - qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k (- h)) i) - (override S1 k (- h)) i * (P2 i - P1 i)))
    == - (Dn k/(2#1)) * P2 k * ((2#1) * h)).
  { assert (E1 :
      qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k h) i) - (override S1 k h) i * (P2 i - P1 i)))
      == qsum_idx idxs (fun i => (Dn i/(2#1)) * P1 i * S2 i)
         - qsum_idx idxs (fun i => ((Dn i/(2#1)) * P2 i) * (override S1 k h) i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    assert (E2 :
      qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k (- h)) i) - (override S1 k (- h)) i * (P2 i - P1 i)))
      == qsum_idx idxs (fun i => (Dn i/(2#1)) * P1 i * S2 i)
         - qsum_idx idxs (fun i => ((Dn i/(2#1)) * P2 i) * (override S1 k (- h)) i)).
    { rewrite <- qsum_idx_sub. apply qsum_idx_ext. intros i _. ring. }
    rewrite E1, E2.
    transitivity
      ( - (qsum_idx idxs (fun i => ((Dn i/(2#1)) * P2 i) * (override S1 k h) i)
           - qsum_idx idxs (fun i => ((Dn i/(2#1)) * P2 i) * (override S1 k (- h)) i))).
    { ring. }
    rewrite (qsum_idx_override_diff idxs k (fun i => (Dn i/(2#1)) * P2 i) S1 h (- h) Hnd_idxs Hin).
    ring. }
  assert (Hpot_lap :
    qsum_idx idxs (fun i => P1 i * Lap idxs W (override S1 k h) i)
    - qsum_idx idxs (fun i => P1 i * Lap idxs W (override S1 k (- h)) i)
    == Lap idxs W P1 k * ((2#1) * h)).
  { rewrite (bilinear_swap idxs W Wsym P1 (override S1 k h)), (bilinear_swap idxs W Wsym P1 (override S1 k (- h))).
    assert (E1 : qsum_idx idxs (fun i => (override S1 k h) i * Lap idxs W P1 i)
                 == qsum_idx idxs (fun i => Lap idxs W P1 i * (override S1 k h) i)).
    { apply qsum_idx_ext. intros i _. ring. }
    assert (E2 : qsum_idx idxs (fun i => (override S1 k (- h)) i * Lap idxs W P1 i)
                 == qsum_idx idxs (fun i => Lap idxs W P1 i * (override S1 k (- h)) i)).
    { apply qsum_idx_ext. intros i _. ring. }
    rewrite E1, E2.
    rewrite (qsum_idx_override_diff idxs k (Lap idxs W P1) S1 h (- h) Hnd_idxs Hin).
    ring. }
  assert (Hpot_k2 :
    qsum_idx idxs (fun i => K2n i * P1 i * (override S1 k h) i)
    - qsum_idx idxs (fun i => K2n i * P1 i * (override S1 k (- h)) i)
    == K2n k * P1 k * ((2#1) * h)).
  { rewrite (qsum_idx_override_diff idxs k (fun i => K2n i * P1 i) S1 h (- h) Hnd_idxs Hin).
    ring. }
  transitivity
    ( ( qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k h) i - S0 i)))
        - qsum_idx idxs (fun i => (Mn i / dt) * ((P1 i - P0 i) * ((override S1 k (- h)) i - S0 i))) )
      + ( qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k h) i)))
          - qsum_idx idxs (fun i => (Mn i / dt) * ((P2 i - P1 i) * (S2 i - (override S1 k (- h)) i))) )
      + ( qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k h) i - S0 i) - S0 i * (P1 i - P0 i)))
          - qsum_idx idxs (fun i => (Dn i/(2#1)) * (P0 i * ((override S1 k (- h)) i - S0 i) - S0 i * (P1 i - P0 i))) )
      + ( qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k h) i) - (override S1 k h) i * (P2 i - P1 i)))
          - qsum_idx idxs (fun i => (Dn i/(2#1)) * (P1 i * (S2 i - (override S1 k (- h)) i) - (override S1 k (- h)) i * (P2 i - P1 i))) )
      - dt * K *
        ( qsum_idx idxs (fun i => P1 i * Lap idxs W (override S1 k h) i)
          - qsum_idx idxs (fun i => P1 i * Lap idxs W (override S1 k (- h)) i) )
      - dt *
        ( qsum_idx idxs (fun i => K2n i * P1 i * (override S1 k h) i)
          - qsum_idx idxs (fun i => K2n i * P1 i * (override S1 k (- h)) i) ) ).
  { ring. }
  rewrite Hkin1, Hkin2, Hdamp1, Hdamp2, Hpot_lap, Hpot_k2.
  field. exact Hdt.
Qed.

(* THE THEOREM: general-N, heterogeneous, arbitrary-symmetric-graph
   Euler-Lagrange identity for the Psi-variation -- for ANY node k of
   ANY NoDup node list, the central-difference stationarity of the
   discrete action is algebraically equivalent, given h<>0 and dt<>0,
   to the per-node damped recurrence. Direct list-indexed generalization
   of DRL_Discrete.v's T1_el_psi_node1/T1_el_psi_node2 (which proved
   this by hand at N=3, nodes 1 and 2 of a ring only). *)
Theorem general_N_Euler_Lagrange_theorem :
  forall (S1 : nat -> Q) (k : nat) (h : Q),
  In k idxs -> ~ h == 0 -> ~ dt == 0 ->
  ( grad_Sgen_at S1 k h == 0 <-> EL_psi_residual k == 0 ).
Proof.
  intros S1 k h Hin Hh Hdt.
  unfold grad_Sgen_at.
  rewrite (Sgen_override_diff S1 k h Hin Hdt).
  assert (Hkey :
    - ((2#1) * h * dt) * EL_psi_residual k / ((2#1) * h)
    == - dt * EL_psi_residual k).
  { field. exact Hh. }
  rewrite Hkey.
  split.
  - intro Heq0.
    destruct (Qmult_integral (- dt) (EL_psi_residual k) Heq0) as [Hc | Hc].
    + exfalso. apply Hdt.
      assert (Hddt : dt == - (- dt)) by ring.
      rewrite Hddt, Hc. ring.
    + exact Hc.
  - intro Heq. rewrite Heq. ring.
Qed.

End GeneralEL.

Print Assumptions general_N_Euler_Lagrange_theorem.

(* ===================================================================== *)
(*  Section 4: sanity checks -- (a) the abstract W genuinely subsumes    *)
(*  DRL_Discrete.v's concrete N=3 ring Laplacian LR1, not merely resembles*)
(*  it; (b) the theorem's hypotheses are jointly satisfiable and the      *)
(*  theorem is actually invocable, i.e. not vacuously true.               *)
(* ===================================================================== *)

Definition Wring (i j : nat) : Q :=
  if orb (andb (Nat.eqb i 0) (Nat.eqb j 1))
     (orb (andb (Nat.eqb i 1) (Nat.eqb j 0))
     (orb (andb (Nat.eqb i 1) (Nat.eqb j 2))
     (orb (andb (Nat.eqb i 2) (Nat.eqb j 1))
     (orb (andb (Nat.eqb i 0) (Nat.eqb j 2))
          (andb (Nat.eqb i 2) (Nat.eqb j 0))))))
  then 1 else 0.

Lemma Wring_sym : forall i j, Wring i j == Wring j i.
Proof.
  intros i j. unfold Wring.
  destruct i as [|[|[|i]]]; destruct j as [|[|[|j]]]; simpl; reflexivity.
Qed.

Definition idxs3 : list nat := [0%nat;1%nat;2%nat].

Lemma idxs3_nodup : NoDup idxs3.
Proof. repeat constructor; simpl; intuition discriminate. Qed.

(* (a) Lap on the concrete ring weight, at node 0, is EXACTLY
   DRL_Discrete.v's LR1 P0_1 P0_2 P0_3 = 2*P0_1 - P0_2 - P0_3 -- not an
   analogy, a literal instantiation. *)
Example Lap_matches_ring_LR1 :
  forall X : nat -> Q,
  Lap idxs3 Wring X 0%nat == (2#1) * X 0%nat - X 1%nat - X 2%nat.
Proof. intro X. unfold Lap, idxs3. simpl. unfold Wring. simpl. ring. Qed.

(* (b) the theorem is genuinely invocable at that same N=3 ring
   instantiation, node 1 (an arbitrary interior node, matching
   T1_el_psi_node2's choice) -- not vacuous. *)
Example general_N_EL_is_invocable :
  forall (S1 P0 P1 P2 S0 S2 Mn Dn K2n : nat -> Q) (K dt h : Q),
  ~ h == 0 -> ~ dt == 0 ->
  ( grad_Sgen_at idxs3 Wring Mn Dn K2n K dt P0 P1 P2 S0 S2 S1 1%nat h == 0
    <-> EL_psi_residual idxs3 Wring Mn Dn K2n K dt P0 P1 P2 1%nat == 0 ).
Proof.
  intros. apply (general_N_Euler_Lagrange_theorem idxs3 idxs3_nodup Wring Wring_sym
                   Mn Dn K2n K dt P0 P1 P2 S0 S2 S1 1%nat h).
  - simpl. right. left. reflexivity.
  - assumption.
  - assumption.
Qed.

Print Assumptions Lap_matches_ring_LR1.
Print Assumptions general_N_EL_is_invocable.
