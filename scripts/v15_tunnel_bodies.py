# -*- coding: utf-8 -*-
"""Per-code Coq body text (Section...End Section) for Toledo v1.5 fix,
SCHEMA-CONSISTENCY-1: the 23 "The Recursive Epistemic Tunnel" entries
(RET-N01..N23, roots EQ-015/EQ-002/weld/A.5/A.8) whose coq.coq_status is
already "definition" or "open_prop" (assigned at merge time, toledo-v1.5-
tunnel) but had no coq/canonical/ file. Hand-authored, 2026-09-07, directly
from each entry's own registry/CANONICAL.json statement.latest -- every
symbol not already fixed by the statement itself is a `Parameter` local to
that entry's own Section, its type chosen only to make the statement
type-check as literally written; nothing about what any of these symbols
computes is asserted. Same pattern as scripts/v15_b2_bodies.py (BODIES
dict of (coq_status, suffix, body_template), NAME placeholder substituted
by the caller)."""

BODIES = {}

# --- root EQ-015 -----------------------------------------------------

BODIES["EQ-015/H.40.v1"] = ("definition", "def", """
Section SEC.
  Parameter AgentSet EdgeSet ProvStruct : Type.
  Parameter A_t : nat -> AgentSet.
  Parameter E_t : nat -> EdgeSet.
  Parameter P_t : nat -> ProvStruct.
  Definition NAME (t : nat) : AgentSet * EdgeSet * ProvStruct :=
    (A_t t, E_t t, P_t t).
End SEC.
""")

BODIES["EQ-015/H.41.v1"] = ("definition", "def", """
Section SEC.
  Parameter Agent : Type.
  Parameter Edge : Agent -> Agent -> Prop.
  Definition NAME (ai aj : Agent) : Prop :=
    Edge ai aj /\\ Edge aj ai.
End SEC.
""")

BODIES["EQ-015/H.42.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter ChiRecip DEff REx PInd Kappa : nat -> Q.
  Parameter KStatus : Type.
  Parameter K_status : nat -> KStatus.
  Definition NAME (t : nat) : Prop :=
    exists v : Q * Q * Q * Q * KStatus * Q,
      v = (ChiRecip t, DEff t, REx t, PInd t, K_status t, Kappa t).
End SEC.
""")

BODIES["EQ-015/H.43.v1"] = ("definition", "def", """
Section SEC.
  Parameter DeltaChi DeltaKappa DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Definition NAME (t : nat) : Prop :=
    (DeltaChi t > 0)%Q /\\ (DeltaKappa t > 0)%Q /\\ (DeltaDEff t < 0)%Q /\\
    (DeltaREx t <= 0)%Q /\\ (DeltaPInd t <= 0)%Q.
End SEC.
""")

BODIES["EQ-015/H.44.v1"] = ("definition", "def", """
Section SEC.
  Parameter Category : Type.
  Parameter RET Falsehood Consensus : Category.
  Definition NAME : Prop :=
    RET <> Falsehood /\\ RET <> Consensus.
End SEC.
""")

BODIES["EQ-015/H.45.v1"] = ("definition", "def", """
Section SEC.
  Parameter KStatus : Type.
  Parameter K_like K_assumed K_reinforced K_collectively_warranted : KStatus.
  Parameter forget_step recursion_step misattribution_step : KStatus -> KStatus -> Prop.
  Definition NAME : Prop :=
    forget_step K_like K_assumed /\\
    recursion_step K_assumed K_reinforced /\\
    misattribution_step K_reinforced K_collectively_warranted.
End SEC.
""")

BODIES["EQ-015/H.46.v1"] = ("open_prop", "hyp", """
Require Import ZArith.
Section SEC.
  Parameter Claim : Type.
  Parameter k : nat.
  Parameter accept_count : Claim -> nat.
  Definition NAME (c : Claim) : Prop :=
    exists consensus : Q,
      consensus = inject_Z (Z.of_nat (accept_count c)) / inject_Z (Z.of_nat k).
End SEC.
""")

BODIES["EQ-015/H.47.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Claim : Type.
  Parameter ConsensusIncreases ValidationIncreases : Claim -> Claim -> Prop.
  Definition NAME : Prop :=
    ~ (forall c c' : Claim, ConsensusIncreases c c' -> ValidationIncreases c c').
End SEC.
""")

BODIES["EQ-015/H.48.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter DeltaChi DeltaKappa DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Definition NAME (t : nat) : Prop :=
    (DeltaChi t > 0)%Q /\\ (DeltaKappa t > 0)%Q /\\
    (DeltaDEff t <= 0)%Q /\\ (DeltaREx t <= 0)%Q /\\ (DeltaPInd t <= 0)%Q.
End SEC.
""")

BODIES["EQ-015/H.49.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Session : Type.
  Parameter SessionReset EpistemicReset : Session -> Prop.
  Definition NAME : Prop :=
    ~ (forall s : Session, SessionReset s -> EpistemicReset s).
End SEC.
""")

# --- root EQ-002 -------------------------------------------------------

BODIES["EQ-002/H.05.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter State Msg Ctx Readout Agent : Type.
  Parameter q_D : State -> State.
  Parameter S_t : nat -> State.
  Parameter m_others : nat -> Agent -> Msg.
  Parameter c_it : nat -> Agent -> Ctx.
  Parameter R : nat -> Agent -> State -> Msg -> Ctx -> Readout.
  Parameter z : nat -> Agent -> Readout.
  Definition NAME (t : nat) (i : Agent) : Prop :=
    z t i = R t i (q_D (S_t t)) (m_others t i) (c_it t i).
End SEC.
""")

BODIES["EQ-002/H.06.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Readout Ctx Agent : Type.
  Parameter z : nat -> Agent -> Readout.
  Parameter c : nat -> Agent -> Ctx.
  Parameter R : nat -> Agent -> Readout -> Ctx -> Readout.
  Definition NAME (t : nat) (i j : Agent) : Prop :=
    z (S t) j = R (S t) j (z t i) (c (S t) j).
End SEC.
""")

BODIES["EQ-002/M.04.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Sim : Type.
  Parameter SimulationSuccess WorldValidation : Sim -> Prop.
  Definition NAME : Prop :=
    ~ (forall s : Sim, SimulationSuccess s -> WorldValidation s).
End SEC.
""")

# --- root weld -----------------------------------------------------------

BODIES["weld/H.35.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Claim : Type.
  Parameter N_A N_P : Claim -> nat.
  Definition NAME : Prop :=
    exists c : Claim, N_A c <> N_P c.
End SEC.
""")

BODIES["weld/H.36.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Claim : Type.
  Parameter AgentCountIncreases ProvRouteCountIncreases : Claim -> Claim -> Prop.
  Definition NAME : Prop :=
    ~ (forall c c' : Claim, AgentCountIncreases c c' -> ProvRouteCountIncreases c c').
End SEC.
""")

BODIES["weld/H.37.v1"] = ("definition", "def", """
Section SEC.
  Parameter DeltaDEff DeltaREx DeltaPInd : nat -> Q.
  Parameter WorldRecordState : Type.
  Parameter WorldRecord : nat -> WorldRecordState.
  Parameter Decisive : WorldRecordState.
  Definition NAME (t : nat) : Prop :=
    (DeltaDEff t < 0)%Q /\\ (DeltaREx t > 0)%Q /\\
    ((DeltaPInd t > 0)%Q \\/ WorldRecord t = Decisive).
End SEC.
""")

BODIES["weld/W.11.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter mu pi_RET mu_eff : nat -> Q.
  Definition NAME (t : nat) : Prop :=
    mu_eff t = mu t * (1 - pi_RET t).
End SEC.
""")

# --- root A.5 --------------------------------------------------------

BODIES["A.5/H.24.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Agent Network : Type.
  Parameter AccuracyGain : Agent -> Prop.
  Parameter CorrigibilityGain : Network -> Prop.
  Parameter network_of : Agent -> Network.
  Definition NAME : Prop :=
    ~ (forall a : Agent, AccuracyGain a -> CorrigibilityGain (network_of a)).
End SEC.
""")

# --- root A.8 --------------------------------------------------------

BODIES["A.8/M.20.v1"] = ("definition", "def", """
Section SEC.
  Parameter Claim VertexSet EdgeSet TypeMap : Type.
  Parameter V_c : Claim -> VertexSet.
  Parameter E_c : Claim -> EdgeSet.
  Parameter tau_c : Claim -> TypeMap.
  Definition NAME (c : Claim) : VertexSet * EdgeSet * TypeMap :=
    (V_c c, E_c c, tau_c c).
End SEC.
""")

BODIES["A.8/M.21.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Hyp_ Consequence Node : Type.
  Parameter entails : Hyp_ -> Consequence -> Prop.
  Parameter CausalAncestry : Consequence -> Node -> Prop.
  Parameter RecursiveNetworkUpTo : nat -> Node -> Prop.
  Parameter tau : nat.
  Definition NAME (H : Hyp_) : Prop :=
    exists y : Consequence,
      entails H y /\\
      exists n : Node, CausalAncestry y n /\\ ~ RecursiveNetworkUpTo tau n.
End SEC.
""")

BODIES["A.8/M.22.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter CycleStage : Type.
  Parameter ClaimStage FreezeStage AIOffStage WorldRecordStage FixedEvalStage RevisionStage : CycleStage.
  Parameter next : CycleStage -> CycleStage -> Prop.
  Definition NAME : Prop :=
    next ClaimStage FreezeStage /\\
    next FreezeStage AIOffStage /\\
    next AIOffStage WorldRecordStage /\\
    next WorldRecordStage FixedEvalStage /\\
    next FixedEvalStage RevisionStage.
End SEC.
""")

BODIES["A.8/M.23.v1"] = ("definition", "def", """
Section SEC.
  Parameter Hyp_ Test AcceptRegion WorldRecordT : Type.
  Parameter Freeze : Hyp_ -> nat -> Prop.
  Parameter Predeclare : Test -> AcceptRegion -> Prop.
  Parameter AI_decisive_execution AI_primary_evaluation : Test -> nat.
  Parameter Record_before_reinterp : WorldRecordT -> Prop.
  Parameter W_of : Test -> WorldRecordT.
  Parameter CountsAgainst : Test -> Hyp_ -> Prop.
  Definition NAME (H : Hyp_) (T : Test) (A_H : AcceptRegion) (tau : nat) : Prop :=
    Freeze H tau /\\
    Predeclare T A_H /\\
    AI_decisive_execution T = 0%nat /\\
    AI_primary_evaluation T = 0%nat /\\
    Record_before_reinterp (W_of T) /\\
    CountsAgainst T H.
End SEC.
""")

BODIES["A.8/M.24.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Artifact Outcome : Type.
  Parameter Frozen : Artifact -> Prop.
  Parameter AI_runtime : Artifact -> nat.
  Parameter Produces : Artifact -> Outcome -> Prop.
  Definition NAME : Prop :=
    forall a : Artifact, Frozen a /\\ AI_runtime a = 0%nat ->
      exists o : Outcome, Produces a o.
End SEC.
""")
