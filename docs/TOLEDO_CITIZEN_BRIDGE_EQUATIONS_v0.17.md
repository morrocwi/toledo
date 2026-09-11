# Toledo Citizen / Institutional / Cross-Actor Equation Register v0.17

**Status:** new derivation/proposal

**Date:** 2026-09-11

**Machine-readable registry:** `registry/proposals/TOLEDO_CITIZEN_BRIDGE_v0.17.json`

This document registers the Toledo equations/definitions developed for the citizen-facing, field-resolution, knowledge-utilization, Business-0, Thai institutional-routing, and cross-actor continuity layers.

These entries are now **repository-grounded proposals in `morrocwi/toledo`**. They are not yet promoted into `registry/CANONICAL.json`; promotion must follow `EQUATION_SOURCE_POLICY.md`, `registry/SCHEMA.md`, lineage, parentage, code assignment, and checker requirements.

## Governing non-collapse

```text
Citizen Experience != Verified General Knowledge
AI-first != AI-only
Observation != Interpretation != Diagnosis
Problem Solved != Innovation Created
Innovation != Business
Creator != Founder
Vehicle != Market Channel
Academic Capability != University Executability
Referral != Handoff != Collaboration
Institutional Output != Citizen Outcome
GrantPass != RegulatoryPass
```

## Citizen / epistemic entry

### TCB-E001 — Citizen Experiential Capital

```text
E_c = {
    Experience,
    Observation,
    Context,
    Practice,
    Failure,
    Constraint,
    Goal
}
```

### TCB-E002 — Provisional Knowledge-like Capital

```text
K*_0 = Compose(
    E_c,
    A_exchange
    | AccessibleEvidence
)
```

`K*_0` is a structured candidate, not truth.

### TCB-E003 — Institutionally Escalated Knowledge-like Capital

```text
K*_I = Compose(
    K*_0,
    E_set,
    I_service
    | R,
      D_own,
      D_public
)
```

## Minimum-sufficient routing

### TCB-R001 — Institutional Escalation Need

```text
E_inst = f(
    Risk,
    DiagnosticUncertainty,
    Irreversibility,
    SpecializedEvidenceNeed,
    ProfessionalAuthorityNeed,
    RegulatorySensitivity,
    PopulationExposure
)
```

### TCB-C001 — Total Citizen Route Cost

```text
C_total(r)
=
C_money(r)
+ lambda C_time(r)
+ mu C_cognitive(r)
+ nu C_access(r)
+ xi C_coordination(r)
+ rho C_opportunity(r)
```

### TCB-R002 — Minimum-Cost Sufficient Route

```text
r* = argmin_r C_total(r)
```

subject to:

```text
Safety(r) >= S_min
EvidenceAdequacy(r) >= E_needed
Rights(r) = PASS
DecisionUsability(r) = TRUE
AuthorityRequirements(r) satisfied
```

### TCB-A001 — Citizen Action Readiness

```text
ACTION_READY = TRUE
IFF
    ProblemStructured
AND HardRisksCleared
AND EvidenceSufficientForAction
AND ResidualUncertaintyAcceptable
AND ActionFeasibleForCitizen
```

## Field / pre-innovation

### TCB-F001 — Next-Best Information Action

```text
a*
=
argmax_a
[
    ExpectedInformationGain(a)
    * DecisionRelevance(a)
]
/
[
    Cost(a)
    + lambda Time(a)
    + mu RiskExposure(a)
    + epsilon
]
```

### TCB-F002 — Field Risk Exposure

```text
RiskExposure(a)
=
AssetAtRisk(a)
* HarmSeverity(a)
* Irreversibility(a)
```

### TCB-F003 — Counterfactual Difference-in-Differences Readout

```text
DeltaY
=
(Y_T,post - Y_T,pre)
-
(Y_C,post - Y_C,pre)
```

Use only where a meaningful comparison is practical. This readout does not by itself prove universal causality.

### TCB-F004 — Transferability Heuristic

```text
Transferability
=
f(
    MechanismStability,
    CrossSiteReplication,
    ImplementationSensitivity,
    ContextSimilarity,
    HumanDependence
)
```

### TCB-F005 — Innovation Promotion Gate

```text
INNOVATION_PROMOTE = TRUE
IFF
    PreInnovationDisposition = INNOVATION_CANDIDATE
AND LocalResultConfidence >= required_level
AND ExistingSolutionCheckCompleted
AND NoveltyScopeSufficientForClaim
AND TransferabilityStateAppropriateForIntendedClaim
AND RightsSafetyConstraintsPass
```

## Knowledge-like asset / utilization

### TCB-K001 — Knowledge-like Asset Map

```text
K_MAP(K*) = {
    K_claim,
    K_knowhow,
    K_process,
    K_data,
    K_artifact,
    K_rights,
    K_relational,
    K_context,
    K_brand_trust,
    K_market
}
```

### TCB-K002 — Knowledge Portability Vector

```text
P_K = [
    C_k,
    1-T_k,
    1-X_k,
    1-H_k,
    R_k,
    S_rights,
    1-Rel_k
]
```

### TCB-K003 — Knowledge Portability Heuristic

```text
Portability_K = GeometricMean(P_K)
```

Management heuristic only; do not allow a scalar to override a fatal rights/context dependency.

### TCB-U001 — Knowledge Utilization Route Value

```text
RouteValue_U(r)
=
KnowledgeRouteFit(r,K_MAP)
* CreatorRoleFitSoft(r)
* RecipientCapability(r)
* ExpectedValueRealized(r)
* MissionFit(r)
* RightsPreservation(r)
/
(
    TransferFriction(r)
    + GovernanceCost(r)
    + CapitalNeed(r)
    + Time(r)
    + StrategicRisk(r)
    + epsilon
)
```

### TCB-U002 — Knowledge Utilization Route Selection

```text
UtilizationRoute*
=
argmax_r RouteValue_U(r)
```

subject to hard route gates `G_U(r)=PASS`.

### TCB-U003 — Market Channel Conditional Value

```text
ChannelValue(c|r)
=
Reach(c,r)
* CounterpartyQuality(c,r)
* TransactionProbability(c,r)
/
(
    SearchCost(c,r)
    + Time(c,r)
    + DisclosureRisk(c,r)
    + epsilon
)
```

## Business-0 / venture formation

### TCB-B001 — Business-0 Formation Predicate

```text
B0_F = TRUE
IFF
    AccountableOwner
AND MinimumViableTeamAdequate
AND RightsGate = PASS
AND DemandRouteExists
AND LegalRouteReady
AND TransactionDesignDefined
AND MilestoneRunwayToFirstDelivery >= 0
AND InnovationVentureFitAcceptable
```

### TCB-B002 — First Economic Cycle Closure Predicate

```text
B0_C = TRUE
IFF
    B0_F
AND DemandIndependence >= required_rung
AND WorldBoundCommitment
AND FirstDeliveryCompleted
AND ValueExchangeOccurred
AND TrueCostRecorded
AND LearningLoopActive
```

### TCB-B003 — True Resource Cost

```text
TrueCost
=
CashCost
+ ImputedFounderLabor
+ InKindResourceCost
+ GrantSupportedCost
+ ComplianceAmortization
+ SharedInfrastructureCost
```

### TCB-B004 — Milestone Runway

```text
MilestoneRunway
=
AvailableCapital
-
CapitalToNextGate
```

## Business dynamics

### TCB-G001 — Business Regime Transition

```text
RegimeTransition_(t->t+1)
=
1[R_(t+1) != R_t]
```

### TCB-G002 — Sustainable Operating Capacity

```text
C_sustainable
=
min(
    C_people,
    C_asset,
    C_supplier,
    C_capital,
    C_space,
    C_approval,
    C_service,
    C_logistics
)
```

### TCB-G003 — Execution Debt

```text
D_exec
=
max(
    0,
    CommittedDemand - C_sustainable
)
```

### TCB-G004 — Incremental Growth Value

```text
DeltaV_growth
=
DeltaRevenue
- DeltaOperatingCost
- DeltaFormalizationCost
- DeltaCapitalCost
- DeltaMaintenanceCost
- DeltaExternalityCost
- DeltaDependencyRisk
- DeltaFailureReserve
```

## Thai institutional routing

### TCB-I001 — Institution Utility

```text
InstitutionUtility(i|s)
=
CapabilityFit(i,s)
* Accessibility(i,s)
* ExpectedDecisionGain(i,s)
* Timeliness(i,s)
/
(
    MoneyCost(i,s)
    + TimeCost(i,s)
    + AccessBurden(i,s)
    + CoordinationCost(i,s)
    + epsilon
)
```

Eligibility and mandatory legal/safety constraints remain hard gates.

## Cross-actor continuity

### TCB-X001 — Problem Representation Triplet

```text
P_C = CitizenProblem
P_S = AIStructuredProblem
P_D = DisciplinaryProblem
```

### TCB-X002 — Meaning Preservation State

```text
MeaningPreserved(P_next,P_C)
in
{PASS, HOLD_UNKNOWN, FAIL}
```

### TCB-X003 — Valid Handoff Predicate

```text
HANDOFF_VALID = TRUE
IFF
    MeaningPreserved = PASS
AND RequestedCapabilityNamed
AND DecisionOwnerNamed
AND ConsentPass
AND DataUseScopeKnown
AND ReturnRequired
AND ResponseTimeFit
AND FallbackRouteKnown
```

### TCB-X004 — Response-Time Fit

```text
TimeFit(i)
=
DecisionWindow
-
ExpectedResponseTime_i
```

### TCB-X005 — Return-to-Citizen Gate

```text
RETURN_GATE = PASS
IFF
    UsableResultReturned
AND KnownUnknownsStated
AND NextActionStated
AND RelevantDataReturned
AND CitizenCorrectionPossible
AND UnresolvedRiskAndRightsDisclosed
```

### TCB-X006 — Bridge Integrity Bottleneck

```text
BridgeIntegrity
=
min(
    MeaningLegibility,
    Access,
    IncentiveAlignment,
    EffectiveCoordinationAuthority,
    Continuity,
    RightsClarity,
    ResponseTimeFit
)
```

### TCB-X007 — Cross-Actor Route Utility

```text
CrossActorUtility(r)
=
CapabilityFit(r)
* BridgeIntegrity(r)
* ExpectedDecisionGain(r)
* ReturnProbability(r)
/
(
    MoneyCost(r)
    + TimeCost(r)
    + CoordinationCost(r)
    + RightsRisk(r)
    + epsilon
)
```

subject to safety, authority, and consent hard gates.

### TCB-X008 — Citizen Closure Predicate

```text
CITIZEN_CLOSURE = TRUE
IFF
    ReturnGate = PASS
AND UsableResultReachesDecisionOwner
AND OriginalCitizenGoal in {
    resolved,
    improved,
    safely_held,
    explicitly_rescoped_with_consent
}
```

### TCB-X009 — Citizen Success

```text
CitizenSuccess
=
SafeUsefulResolution
+
TraceableLearning
```

The `+` here is conceptual composition, not an asserted cardinal metric. Innovation is optional.

## Promotion requirements

Before any entry above becomes canonical:

1. identify compatible existing Toledo parent/root codes;
2. distinguish definitions, heuristics, predicates, and claims that are genuinely mathematically stronger;
3. check ontology through `morrocwi/readout_genesis` where required;
4. check epistemology through `morrocwi/readout_universe` where required;
5. check human–AI/collaboration interpretation through `morrocwi/glosa` where required;
6. add canonical lineage and occurrence evidence;
7. assign code under Toledo canonical grammar;
8. run registry/checker tests;
9. formalize only the subset for which formalization is meaningful; do not use Coq to manufacture false epistemic strength for planning heuristics.

## Implementation consumer

`morrocwi/toledo.biz` is the first implementation repository expected to consume this equation family through stable references rather than duplicating authority.
