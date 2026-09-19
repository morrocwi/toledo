(* BridgeCommute/H.02.v1 -- Th_coqc -- Iterated/composed cross-agent          *)
(* commutation follows from per-step commutation (specializes                *)
(* BridgeCommute/H.01.v1's single-pair law to a chain of exchanges, e.g.      *)
(* AI-AI-AI) --                                                              *)
(* parents: BridgeCommute/H.01.v1 (specializes) *)
(* Gap identified 2026-09-19, requested as AI-AI drift under iterated       *)
(* recursive exchange. Honest finding, NOT the originally-guessed shape:    *)
(* under the EXACT equality BridgeCommute/H.01.v1 states, per-step           *)
(* commutation for a chain 3->2->1 DOES imply the composed translation       *)
(* T_{2->1} o T_{3->2} also commutes with Fsharp_1/Fsharp_3 -- proved below  *)
(* by direct substitution, no counterexample exists for the exact form.      *)
(* Drift compounding is NOT a property of this exact-equality object as    *)
(* stated: there is no error/distance term here to compound. A genuinely     *)
(* approximate version (each step commuting only up to a bounded distance,   *)
(* with the bound accumulating over a chain) would be a DIFFERENT, currently *)
(* unregistered object -- not derived here, since fabricating an error bound *)
(* with no principled source would violate this workspace's own discipline. *)
(* Left explicitly PROPOSAL/undeveloped, not silently answered. *)

Section BridgeCommute_H02_v1.
  Variable Agent : Type.
  Variable Signal : Type.
  Variable T : Agent -> Agent -> Signal -> Signal.
  Variable Fsharp : Agent -> Signal -> Signal.

  Definition commutes (i j : Agent) : Prop :=
    forall s : Signal, T j i (Fsharp j s) = Fsharp i (T j i s).

  (* the composed translation across a 3-agent chain 3 -> 2 -> 1 *)
  Definition composed3 (a1 a2 a3 : Agent) (s : Signal) : Signal :=
    T a2 a1 (T a3 a2 s).

  Theorem BridgeCommute_H02_v1_composition_preserves_commuting :
    forall a1 a2 a3 : Agent,
      commutes a1 a2 -> commutes a2 a3 ->
      forall s : Signal,
        composed3 a1 a2 a3 (Fsharp a3 s) = Fsharp a1 (composed3 a1 a2 a3 s).
  Proof.
    intros a1 a2 a3 H12 H23 s.
    unfold composed3.
    rewrite (H23 s).
    rewrite (H12 (T a3 a2 s)).
    reflexivity.
  Qed.
End BridgeCommute_H02_v1.

Print Assumptions BridgeCommute_H02_v1_composition_preserves_commuting.
