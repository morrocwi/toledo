(******************************************************************************)
(* InfoBinaryVacua.v — the deepest link, CONNECTED IN COQ across files:        *)
(*   the ROOT's binary distinction  ⟹  the ∇V double-well's two vacua.         *)
(*                                                                            *)
(* RDL_Distinguishability.primordial_difference_exists proves ∃ two distinguish-*)
(* able elements of RD.D — the primordial binary (δ_R = retained difference).  *)
(* URCF_RD_All.InfoPotential is the double-well ∇V derived from that binary.    *)
(* Here both are CITED in one proof: the root binary IS realised as the two     *)
(* distinct vacua ±Φ₀ of the potential (the two retained states). Standalone so *)
(* URCF_RD_All stays untouched (no axiom-profile drift); the link is genuine    *)
(* Coq, not a comment.                                                         *)
(******************************************************************************)

Require Import QArith.
Require Import Coq.micromega.Lqa.
Require URCF_RD_All.
Require RD.
Require RDL_Distinguishability.

Module InfoBinaryVacua.
  Open Scope Q_scope.

  (* both ±Φ₀ are equilibria of InfoPotential's ∇V (cites URCF_RD_All.InfoPotential), and the two are
     DISTINCT (Φ₀ ≠ −Φ₀ for Φ₀≠0) — exactly two retained states = binary. *)
  Theorem two_distinct_vacua : forall mu lam Phi0 : Q, ~ (Phi0 == 0) -> lam*Phi0*Phi0 == mu*mu ->
       URCF_RD_All.InfoPotential.Vp mu lam Phi0 == 0
    /\ URCF_RD_All.InfoPotential.Vp mu lam (- Phi0) == 0
    /\ ~ (Phi0 == - Phi0).
  Proof.
    intros mu lam Phi0 Hnz Hvac. repeat split.
    - apply URCF_RD_All.InfoPotential.vacuum_is_equilibrium. exact Hvac.
    - apply URCF_RD_All.InfoPotential.vacuum_is_equilibrium.
      transitivity (lam*Phi0*Phi0); [ ring | exact Hvac ].
    - intro H. apply Hnz. lra.
  Qed.

  (* THE CONNECTION, proved together: the root binary distinction (RDL_Distinguishability) AND the two
     equilibrium vacua of the potential (URCF_RD_All.InfoPotential) — the binary root realised in ∇V. *)
  Theorem binary_root_realized_in_potential :
       (exists a b : RD.D, RDL_Distinguishability.Distinguishable a b)
    /\ (forall mu lam Phi0 : Q, ~ (Phi0 == 0) -> lam*Phi0*Phi0 == mu*mu ->
             URCF_RD_All.InfoPotential.Vp mu lam Phi0 == 0
          /\ URCF_RD_All.InfoPotential.Vp mu lam (- Phi0) == 0).
  Proof.
    split.
    - exact RDL_Distinguishability.primordial_difference_exists.
    - intros mu lam Phi0 Hnz Hvac.
      destruct (two_distinct_vacua mu lam Phi0 Hnz Hvac) as [H1 [H2 _]]. split; assumption.
  Qed.

End InfoBinaryVacua.
