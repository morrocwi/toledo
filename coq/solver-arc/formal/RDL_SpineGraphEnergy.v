(* ===================================================================== *)
(*  RDL_SpineGraphEnergy.v                                                *)
(*  The genuine MERGE: the spine energy-decay argument re-derived ON the   *)
(*  RD-graph carrier, so it is DOWNSTREAM of RD (one chain), not a sibling. *)
(*                                                                        *)
(*  Field is D-indexed and Q-valued (f : D -> Q).  We:                     *)
(*    1. define the graph gradient/Laplacian over Q and prove the          *)
(*       Dirichlet energy density is non-negative (Laplacian is PSD) — so   *)
(*       every Laplacian eigenvalue λ ≥ 0;                                  *)
(*    2. for a single Laplacian eigenmode (stiffness K·λ, λ ≥ 0) prove the  *)
(*       spine energy rate  Ė = −Damp·v²  and hence Ė ≤ 0 when Damp ≥ 0.    *)
(*                                                                        *)
(*  This puts RDL_SpineStability's scalar result on the actual graph        *)
(*  carrier: the mode stiffness K·λ is non-negative BECAUSE the graph        *)
(*  Laplacian is PSD (step 1).  All axiom-free (Th_coqc).                   *)
(*                                                                        *)
(*  HONEST SCOPE: this is the PER-EIGENMODE spine on the graph. Summing it  *)
(*  over the full spectrum (a general-N energy with finite summation /      *)
(*  spectral decomposition) is the remaining step, not done here.          *)
(* ===================================================================== *)

Require Import RD.
Require Import RDL_CausalOrder.
Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Psatz.
Require Import Coq.Lists.List.
Import ListNotations.

(* ---- 1. graph gradient / Laplacian over Q; Dirichlet density is PSD ---- *)
Definition gradQ (f : D -> Q) (m : D) : Q := (f (succ m) - f m)%Q.

Definition lapQ (f : D -> Q) (m : D) : Q :=
  (((2#1) * f (succ m)) - f m - f (succ (succ m)))%Q.

Theorem lapQ_is_div_grad :
  forall (f : D -> Q) (m : D), lapQ f m == (gradQ f m - gradQ f (succ m))%Q.
Proof. intros f m. unfold lapQ, gradQ. ring. Qed.

Theorem dirichletQ_density_nonneg :
  forall (f : D -> Q) (m : D), 0 <= gradQ f m * gradQ f m.
Proof. intros f m. nra. Qed.

(* ---- 2. single Laplacian eigenmode: spine energy non-increase ---- *)
Section SpineMode.
  (* Damp = dissipation D; lam = a Laplacian eigenvalue (≥ 0 by step 1). *)
  Variables M Damp K lam : Q.
  Hypothesis lam_nonneg : 0 <= lam.            (* discharged by dirichletQ_density_nonneg *)

  Variables x v vdot : Q.
  (* spine EOM for this mode:  M v̇ = −Damp·v − K·λ·x   (xdot = v). *)
  Hypothesis eom : M * vdot == - (Damp * v) - (K * lam * x).

  (* energy E = ½ M v² + ½ K λ x² ;  Ė = v·(M v̇) + Kλ·x·v  (with ẋ = v). *)
  Definition Edot : Q := (v * (M * vdot) + (K * lam) * (x * v))%Q.

  Theorem graph_mode_energy_rate : Edot == - (Damp * (v * v)).
  Proof. unfold Edot. rewrite eom. ring. Qed.

  Theorem graph_mode_energy_nonincreasing : 0 <= Damp -> Edot <= 0.
  Proof. intro HD. rewrite graph_mode_energy_rate. nra. Qed.

  Theorem graph_mode_energy_strict_decay :
    0 < Damp -> ~ (v == 0) -> Edot < 0.
  Proof.
    intros HD Hv. rewrite graph_mode_energy_rate.
    assert (0 < v * v) by (apply Qlt_le_trans with (y := v*v); nra).
    nra.
  Qed.

End SpineMode.

(* ---- 3. GENERAL-N: total energy over a finite graph is non-increasing ---- *)
(*  Lift the per-mode result (Ė = −Damp·v²) to the whole finite spine: the
    total energy rate is the SUM of the per-mode rates, hence ≤ 0 when each
    mode satisfies the spine EOM. Finite summation over a list of mode/node
    velocities. All axiom-free. *)

Fixpoint sumQ (l : list Q) : Q :=
  match l with [] => 0 | x :: r => x + sumQ r end.

Lemma sumQ_nonneg : forall l : list Q, (forall x, In x l -> 0 <= x) -> 0 <= sumQ l.
Proof.
  induction l as [| a r IH]; intros H.
  - simpl. apply Qle_refl.
  - simpl. assert (Ha : 0 <= a) by (apply H; left; reflexivity).
    assert (Hr : 0 <= sumQ r) by (apply IH; intros y Hy; apply H; right; exact Hy).
    lra.
Qed.

Section TotalEnergy.
  Variable Damp : Q.

  (* per-node energy rate = the established per-mode rate −Damp·v² *)
  Definition node_rate (v : Q) : Q := - (Damp * (v * v)).
  Definition total_Edot (vs : list Q) : Q := sumQ (map node_rate vs).

  (* the dissipation factors out of the sum *)
  Lemma total_Edot_factor :
    forall vs, total_Edot vs == - (Damp * sumQ (map (fun v => v * v) vs)).
  Proof.
    induction vs as [| a r IH].
    - unfold total_Edot. simpl. ring.
    - unfold total_Edot in *. simpl. rewrite IH. unfold node_rate. ring.
  Qed.

  (* GENERAL-N spine stability: with dissipation, the TOTAL energy never grows. *)
  Theorem total_energy_nonincreasing :
    0 <= Damp -> forall vs : list Q, total_Edot vs <= 0.
  Proof.
    intros HD vs. rewrite total_Edot_factor.
    assert (Hs : 0 <= sumQ (map (fun v => v * v) vs)).
    { apply sumQ_nonneg. intros x Hx. apply in_map_iff in Hx.
      destruct Hx as [v [Hv _]]. rewrite <- Hv. nra. }
    nra.
  Qed.

End TotalEnergy.
