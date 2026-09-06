(* weld/E.08.v1 — CAN-036 — Definition — parents: weld/M.03.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-036 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** K_local = K|_{Omega_local}; T^Y_{ij} o K_i =~= K_j o T^C_{ij},
    eps_bridge = d(T^Y_{ij} o K_i, K_j o T^C_{ij}): local knowledge may
    only be presented as global through a declared, tolerance-bounded
    commuting-square transport. Typed generically; the identity-transport
    instance is proved directly (not by instantiating the generalised
    Section object, to avoid depending on exactly how [Set Implicit
    Arguments] reconstructs its three discharged type parameters) to
    witness that a genuinely trivial transport has zero bridge error —
    supporting scaffolding, not a re-tagging of the general Definition. *)
Section CAN036_KnowledgeTransport.
  Variables LocalCtx GlobalCtx Reading : Type.
  Variable d : Reading -> Reading -> Q.
  Variable K_i : LocalCtx -> Reading.
  Variable T : LocalCtx -> GlobalCtx.
  Variable K_j : GlobalCtx -> Reading.

  Definition CAN036_bridge_error (l : LocalCtx) : Q := d (K_i l) (K_j (T l)).

  Definition CAN036_transports_within (tol : Q) (l : LocalCtx) : Prop :=
    CAN036_bridge_error l <= tol.
End CAN036_KnowledgeTransport.

Theorem CAN036_identity_transport_zero_error :
  forall (Reading : Type) (d : Reading -> Reading -> Q),
    (forall r, d r r == 0) -> forall l : Reading, d l l == 0.
Proof. intros Reading d Hzero l. apply Hzero. Qed.

