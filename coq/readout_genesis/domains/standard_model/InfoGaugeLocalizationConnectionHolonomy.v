(******************************************************************************)
(* InfoGaugeLocalizationConnectionHolonomy.v -- CLOSED (promoted 2026-07-24). *)
(*   TIER = Th_coqc (fully abstract, Type-polymorphic, axiom-free).           *)
(*   No Reals, no domain alphabet, no declared architecture. Explicit forall-  *)
(*   premises throughout (no Section/Variable/Hypothesis), per house style.    *)
(*   Compile: coqc -q InfoGaugeLocalizationConnectionHolonomy.v (standalone, no -R needed) *)
(*                                                                            *)
(* TARGETS SM-G0.3, SM-G0.4, SM-G0.5 from domains/standard_model/ROOT_TO_SM_DAG.md, *)
(* the last three sub-gates of R3/SM-G0 (the FIRST GATE). G0.1 and G0.2 closed *)
(* 2026-07-23 in InfoGaugeAutomorphismGroup.v. G0.6 closed earlier in          *)
(* InfoOrderDefectFromComposition.v. This file closes the remaining three.     *)
(*                                                                            *)
(* WHY THIS IS NECESSITY-TIER: every group (G, id, mul, inv) and every frame   *)
(* field f is an ARBITRARY Coq Type/function, quantified explicitly. Nothing  *)
(* is instantiated to a specific group (no Heisenberg Hb, no SO(3) matrices,   *)
(* no hand-picked witness). This GENERALIZES InfoConnectionFromFrame_attempt.v *)
(* (which proved coboundary telescoping only for the single Heisenberg group   *)
(* Hb) and generalizes what InfoRationalSO3Curvature only checked for one      *)
(* hand-picked rational rotation pair, to ANY group whatsoever.                *)
(*                                                                            *)
(* G0.3 -- LOCALIZATION: a frame field f : nat -> G assigns an ARBITRARY       *)
(*   internal representative at every node (that is what localization       *)
(*   means: each node's representative is free, not fixed). The frame-        *)
(*   difference connection Aedge f k := f(k+1) * f(k)^-1 and its ordered       *)
(*   product pathprod f n TELESCOPE to depend only on the endpoint frames      *)
(*   f(n) and f(0), for ANY choice of the intermediate f(1)..f(n-1) -- i.e.    *)
(*   the observable transport factors through the quotient regardless of how  *)
(*   each node's internal representative was chosen. A closed loop (f n =     *)
(*   f 0) is provably pure gauge (trivial holonomy), for ANY group.           *)
(*                                                                            *)
(* G0.4 -- CONNECTION TRANSFORMATION LAW, DERIVED not posited: given local     *)
(*   relabelings h_i, h_j at the two endpoints of a transport U, the          *)
(*   transformed connection U' := h_j * U * h_i^-1 is not merely A choice --  *)
(*   it is the UNIQUE transport satisfying the commutation requirement        *)
(*   U'(h_i . x) = h_j . (U . x) for every state x, for ANY group. This is    *)
(*   the derive-not-posit content: existence AND uniqueness, both proved.*)
(*                                                                            *)
(* G0.5 -- HOLONOMY INVARIANT, general: under a change of internal            *)
(*   representative, a loop's holonomy conjugates, H_C' = h * H_C * h^-1.     *)
(*   Whether the loop is flat (H_C = id) or genuinely curved (H_C <> id) is   *)
(*   PROVABLY a representative-independent (conjugation-invariant) fact, for  *)
(*   ANY group and ANY holonomy element -- not just the single SO(3) witness  *)
(*   pair InfoRationalSO3Curvature checked. Composing two representative      *)
(*   changes acts correctly (conjugation is a genuine group action), matching *)
(*   G0.2's automorphism-group closure.                                      *)
(*                                                                            *)
(* HONEST FENCE. CLOSED at this level: G0.3 (frame-field localization +       *)
(* coboundary telescoping + pure-gauge-is-flat, for ANY group), G0.4          *)
(* (connection transformation law existence + uniqueness, for ANY group), and *)
(* G0.5 (holonomy triviality is conjugation-invariant + conjugation is a      *)
(* group action, for ANY group) are all proved in full generality. [Open],    *)
(* NOT smuggled: this does NOT show any of these structures is NONTRIVIAL for *)
(* the actual retained-state root of Part I (no group/frame from the root is  *)
(* instantiated here) -- it proves the STRUCTURAL laws hold whenever such a   *)
(* group/frame exists, the same honest limit as G0.1/G0.2. It does not derive *)
(* representations, chirality, or anything downstream of R3/SM-G0. All        *)
(* quantities are over abstract Coq Type/Prop; no Reals, no floats, no domain *)
(* alphabet.                                                                  *)
(******************************************************************************)

Module InfoGaugeLocalizationConnectionHolonomy.

(* ========================================================================= *)
(* Shared group-cancellation lemma (no Section/Hypothesis; explicit premises) *)
(* ========================================================================= *)

(* mul (mul a (inv b)) (mul b c) = mul a c -- the core cancellation fact that *)
(* powers both the telescoping proof (G0.3) and the uniqueness proof (G0.4). *)
Theorem group_cancel_left :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul (inv a) a = id) ->
    forall b c : G, mul (inv b) (mul b c) = c.
Proof.
  intros G id mul inv assoc idl invl b c.
  rewrite <- assoc.
  rewrite invl.
  apply idl.
Qed.

Theorem group_cancel_middle :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul (inv a) a = id) ->
    forall a b c : G, mul (mul a (inv b)) (mul b c) = mul a c.
Proof.
  intros G id mul inv assoc idl invl a b c.
  rewrite assoc.
  rewrite (group_cancel_left G id mul inv assoc idl invl b c).
  reflexivity.
Qed.

(* ========================================================================= *)
(* G0.3 -- LOCALIZATION: frame-difference connection + coboundary telescoping *)
(* ========================================================================= *)

Definition Aedge (G : Type) (mul : G -> G -> G) (inv : G -> G)
                  (f : nat -> G) (k : nat) : G :=
  mul (f (S k)) (inv (f k)).

Fixpoint pathprod (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G)
                   (f : nat -> G) (n : nat) : G :=
  match n with
  | O => id
  | S k => mul (Aedge G mul inv f k) (pathprod G id mul inv f k)
  end.

Theorem pathprod_O :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G) (f : nat -> G),
    pathprod G id mul inv f O = id.
Proof. intros. reflexivity. Qed.

(* the observable transport (the ordered product of frame differences)        *)
(* depends ONLY on the endpoint frames f(n), f(0) -- for ANY intermediate      *)
(* frame choice f(1)..f(n-1), i.e. for ANY per-node localization.              *)
Theorem coboundary_telescopes :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul a id = a) ->
    (forall a : G, mul (inv a) a = id) ->
    (forall a : G, mul a (inv a) = id) ->
    forall (f : nat -> G) (n : nat),
      pathprod G id mul inv f n = mul (f n) (inv (f O)).
Proof.
  intros G id mul inv assoc idl idr invl invr f n.
  induction n as [| k IH].
  - simpl. rewrite invr. reflexivity.
  - simpl. unfold Aedge.
    rewrite IH.
    apply (group_cancel_middle G id mul inv assoc idl invl).
Qed.

(* PURE GAUGE IS FLAT: a closed frame loop (f n = f 0) has trivial holonomy,   *)
(* for ANY group and ANY frame field -- any relabeling that returns to its    *)
(* starting representative produces no genuine curvature.                    *)
Theorem closed_loop_pure_gauge_flat :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul a id = a) ->
    (forall a : G, mul (inv a) a = id) ->
    (forall a : G, mul a (inv a) = id) ->
    forall (f : nat -> G) (n : nat),
      f n = f O ->
      pathprod G id mul inv f n = id.
Proof.
  intros G id mul inv assoc idl idr invl invr f n Hclosed.
  rewrite (coboundary_telescopes G id mul inv assoc idl idr invl invr f n).
  rewrite Hclosed.
  apply invr.
Qed.

(* ========================================================================= *)
(* G0.4 -- CONNECTION TRANSFORMATION LAW, DERIVED not posited                 *)
(* ========================================================================= *)

(* EXISTENCE: defining U' := h_j * U * h_i^-1 makes transport commute with    *)
(* local relabeling: U'(h_i * x) = h_j * (U * x), for every state x -- for    *)
(* ANY group acting on itself by left multiplication.                        *)
Theorem connection_law_exists :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul (inv a) a = id) ->
    forall (hi hj U x : G),
      mul (mul (mul hj U) (inv hi)) (mul hi x) = mul hj (mul U x).
Proof.
  intros G id mul inv assoc idl invl hi hj U x.
  rewrite assoc.
  rewrite (group_cancel_left G id mul inv assoc idl invl hi x).
  apply assoc.
Qed.

(* UNIQUENESS -- the DERIVE-not-posit content: ANY transport U'' that     *)
(* satisfies the SAME commutation requirement for EVERY state x must equal    *)
(* h_j * U * h_i^-1 exactly. The transformation law is forced by requiring    *)
(* the diagram to commute, not chosen freely.                                *)
Theorem connection_law_unique :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul a id = a) ->
    (forall a : G, mul (inv a) a = id) ->
    (forall a : G, mul a (inv a) = id) ->
    forall (hi hj U Uprime : G),
      (forall x : G, mul Uprime (mul hi x) = mul hj (mul U x)) ->
      Uprime = mul (mul hj U) (inv hi).
Proof.
  intros G id mul inv assoc idl idr invl invr hi hj U Uprime Hcommute.
  specialize (Hcommute (inv hi)).
  assert (Hhi : mul hi (inv hi) = id) by (apply invr).
  rewrite Hhi in Hcommute.
  rewrite idr in Hcommute.
  rewrite Hcommute.
  rewrite assoc.
  reflexivity.
Qed.

(* ========================================================================= *)
(* G0.5 -- HOLONOMY INVARIANT: triviality is conjugation-invariant, general   *)
(* ========================================================================= *)

Definition conj (G : Type) (mul : G -> G -> G) (inv : G -> G) (h x : G) : G :=
  mul (mul h x) (inv h).

(* trivial holonomy stays trivial under ANY change of representative. *)
Theorem conj_preserves_identity :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul a id = a) ->
    (forall a : G, mul a (inv a) = id) ->
    forall h : G, conj G mul inv h id = id.
Proof.
  intros G id mul inv assoc idr invr h.
  unfold conj.
  rewrite idr.
  apply invr.
Qed.

(* the converse: if the CONJUGATED holonomy is trivial, the ORIGINAL holonomy *)
(* was already trivial -- i.e. flatness/curvature is a genuine representative- *)
(* independent (basis-independent) fact, not an artifact of which frame was   *)
(* used to compute it. This is exactly G0.5: loop readout independent of     *)
(* internal representative.                                                 *)
Theorem conj_trivial_iff :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a : G, mul id a = a) ->
    (forall a : G, mul a id = a) ->
    (forall a : G, mul (inv a) a = id) ->
    (forall a : G, mul a (inv a) = id) ->
    forall h x : G,
      conj G mul inv h x = id <-> x = id.
Proof.
  intros G id mul inv assoc idl idr invl invr h x.
  unfold conj. split.
  - intro Heq.
    assert (Hstep : mul (inv h) (mul (mul h x) (inv h)) = mul (inv h) id).
    { rewrite Heq. reflexivity. }
    rewrite idr in Hstep.
    rewrite <- assoc in Hstep.
    rewrite <- assoc in Hstep.
    rewrite invl in Hstep.
    rewrite idl in Hstep.
    (* Hstep : mul x (inv h) = inv h *)
    assert (Hstep2 : mul (mul x (inv h)) h = mul (inv h) h).
    { rewrite Hstep. reflexivity. }
    rewrite assoc in Hstep2.
    rewrite invl in Hstep2.
    rewrite idr in Hstep2.
    exact Hstep2.
  - intro Hx. rewrite Hx.
    rewrite idr. apply invr.
Qed.

(* composing two changes of representative acts correctly: conjugating by     *)
(* h2 after h1 equals conjugating by (h2*h1) directly -- conjugation is a      *)
(* genuine group action, consistent with G0.2's automorphism-group closure.  *)
Theorem conj_composes :
  forall (G : Type) (id : G) (mul : G -> G -> G) (inv : G -> G),
    (forall a b c : G, mul (mul a b) c = mul a (mul b c)) ->
    (forall a b : G, inv (mul a b) = mul (inv b) (inv a)) ->
    forall h1 h2 x : G,
      conj G mul inv h2 (conj G mul inv h1 x) = conj G mul inv (mul h2 h1) x.
Proof.
  intros G id mul inv assoc invmul h1 h2 x.
  unfold conj.
  rewrite invmul.
  repeat rewrite assoc.
  reflexivity.
Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions group_cancel_middle.
Print Assumptions coboundary_telescopes.
Print Assumptions closed_loop_pure_gauge_flat.
Print Assumptions connection_law_exists.
Print Assumptions connection_law_unique.
Print Assumptions conj_preserves_identity.
Print Assumptions conj_trivial_iff.
Print Assumptions conj_composes.

End InfoGaugeLocalizationConnectionHolonomy.
