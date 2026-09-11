# Toledo Human Governance Extensions v0.3

**Status:** normative protocol extension  
**Date:** 2026-09-11  
**Scope:** Toledo L0 and all downstream routing/handoff processes

This document adds six mechanisms required for Toledo to operate as a real-world knowledge-to-innovation routing protocol rather than a simple expert-matching or service-routing system:

1. `TRUST_GATE`
2. `RIGHTS_AND_CONSENT`
3. `EXPERT_SET`
4. `ABSORPTIVE_CAPACITY`
5. `PERSISTENT_CASE_STEWARD`
6. `IMPACT_LEDGER`

The six mechanisms are persistent constraints across the whole case lifecycle. They are not optional post-processing steps.

---

## 1. Core Toledo object

Toledo keeps the core relation:

```text
FIELD_PERSON
    +
AI_MEDIATED_EXCHANGE
    +
EXPERT_SET
    =
KNOWLEDGE_LIKE_THING
```

Formally:

```text
K* = Compose(
        F,
        A_exchange,
        E_set
        | R,
          D_own,
          D_public
     )
```

where:

```text
F        = field / lived / practical knowledge
A_exchange = AI-mediated translation, clarification and structuring
E_set    = one or more relevant experts / academics / professionals
R        = research literature
D_own    = own/internal data
D_public = public/shared data
```

AI remains a mediator, not a final authority and not an independent owner of the resulting knowledge object.

---

# 2. TRUST_GATE

Correct expert matching does not guarantee useful collaboration. Before deep exchange, Toledo must establish whether the parties can actually work together.

```text
TRUST_GATE = {
    shared_goal,
    role_clarity,
    language_fit,
    incentive_alignment,
    conflict_of_interest,
    expected_benefit,
    response_commitment,
    confidentiality_expectation,
    power_imbalance,
    prior_relationship
}
```

Pseudocode:

```text
FUNCTION TRUST_GATE(field_person, expert_set):

    CHECK:
        shared_problem_definition
        shared_goal
        respect_for_field_knowledge
        expert_willingness
        incentive_compatibility
        confidentiality_expectation
        power_imbalance
        conflict_of_interest

    IF trust_is_low:
        RETURN RELATIONSHIP_BUILDING_REQUIRED

    RETURN PASS
```

Possible relationship-building actions:

```text
informal conversation
facilitated dialogue
problem-framing workshop
community meeting
local facilitator
technology-clinic intake
student-assisted field work
```

**Rule:** Toledo must not confuse `expert found` with `collaboration established`.

---

# 3. RIGHTS_AND_CONSENT

Field knowledge, community knowledge, proprietary data and expert contributions must not silently become institution-owned assets merely because they have been formalized by AI or entered into a research/innovation workflow.

```text
RIGHTS_AND_CONSENT = {
    source_owner,
    contributor,
    consent_status,
    permitted_use,
    prohibited_use,
    confidentiality,
    commercial_use_permission,
    attribution_rule,
    community_rights,
    IP_expectation,
    benefit_sharing,
    withdrawal_or_revision_process
}
```

Pseudocode:

```text
FUNCTION RIGHTS_GATE(case):

    IDENTIFY:
        who_contributed_field_knowledge
        who_owns_original_data
        who_owns_existing_IP
        who_may_disclose_information
        whether_personal_or_confidential_information_exists
        whether_commercial_reuse_is_allowed
        whether_collective_or_community_consent_is_required

    IF material_rights_are_unresolved:
        RETURN HOLD

    RETURN PASS
```

**Hard rule:**

```text
NO KNOWLEDGE EXTRACTION
NO COMMERCIAL HANDOFF
NO PUBLICATION / SHARING

when required rights or consent remain unresolved.
```

---

# 4. EXPERT_SET

A real-world problem may span multiple disciplines. Toledo therefore replaces the single variable `EXPERT` with:

```text
EXPERT_SET = {E1, E2, ..., En}
```

The set should be the **minimum sufficient panel** for the actual problem.

```text
FUNCTION BUILD_EXPERT_SET(problem_dimensions):

    identify_domain_dimensions()
    identify_regulatory_dimensions()
    identify_business_dimensions()
    identify_social_context_dimensions()

    candidate_experts = retrieve_candidates()

    expert_set = MINIMUM_SUFFICIENT_COVER(candidate_experts)

    RETURN expert_set
```

Examples:

```text
food_product:
    food_science
    microbiology
    packaging
    regulation
    market/business

community_problem:
    field_practitioner
    social_science
    policy/legal
    local/community knowledge holder
```

**Rule:** Do not add disciplines merely for prestige. Add an expert only when that expertise closes a material uncertainty or decision dependency.

---

# 5. ABSORPTIVE_CAPACITY

Knowledge availability does not imply knowledge usability. Toledo must measure whether the receiving person, team, firm or community can understand, implement and maintain what is being transferred.

```text
ABSORPTIVE_CAPACITY = {
    basic_domain_knowledge,
    technical_skill,
    management_skill,
    data_skill,
    available_time,
    available_staff,
    financial_capacity,
    ability_to_execute,
    ability_to_document,
    maintenance_capacity
}
```

Pseudocode:

```text
FUNCTION ASSESS_ABSORPTIVE_CAPACITY(case):

    score:
        comprehension
        execution_skill
        team_capacity
        time_capacity
        finance_capacity
        data_literacy
        management_capacity
        maintenance_capacity

    IF LOW:
        RETURN {
            training,
            coaching,
            embedded_mentor,
            student_team,
            local_facilitator,
            simplified_tool,
            staged_implementation
        }

    IF MEDIUM:
        RETURN ADVANCED_SERVICE_PLUS_MENTORING

    RETURN DIRECT_SPECIALIST_ROUTING
```

**Rule:**

```text
Do not send more knowledge
when the actual bottleneck is implementation capacity.
```

---

# 6. PERSISTENT_CASE_STEWARD

A routing system without continuity can become referral abandonment. Every Toledo case therefore requires a persistent human or institutional steward.

```text
CASE_STEWARD = {
    case_id,
    responsible_person_or_unit,
    contact,
    history,
    current_state,
    failed_routes,
    active_commitments,
    next_followup,
    unresolved_conflicts,
    current_bottleneck
}
```

Responsibilities:

```text
maintain_case_history()
track_referrals()
track_expert_responses()
follow_up()
record_failures()
record_dropped_commitments()
prevent_repeated_dead_ends()
recompute_case_state()
trigger_next_routing_decision()
```

AI may preserve and summarize context, but accountability must remain attached to a human or institution.

---

# 7. IMPACT_LEDGER

Toledo must distinguish activity from effect.

```text
OUTPUT != OUTCOME != IMPACT
```

Example:

```text
OUTPUT:
    100 people trained

OUTCOME:
    60 people changed practice

INTERMEDIATE_IMPACT:
    average operating cost reduced 12%

LONG_TERM_IMPACT:
    net income remained higher after 24 months
```

Ledger schema:

```text
IMPACT_LEDGER = {
    baseline,
    intervention,
    date,
    output,
    outcome,
    intermediate_impact,
    long_term_impact,
    negative_effect,
    attribution_confidence,
    counterfactual_method_if_available,
    followup_date
}
```

Rules:

```text
Do not report outputs as outcomes.
Do not report outcomes as long-term impact.
Do not claim causal impact without a defensible comparison or counterfactual.
```

Minimum follow-up model:

```text
T0 = baseline
T1 = immediate output
T2 = short-term outcome
T3 = medium-term impact
T4 = long-term impact when material
```

---

# 8. Auditable AI mediation

The six extensions require AI translation itself to be inspectable.

```text
AI_TRANSLATION_RECORD = {
    original_statement,
    translated_statement,
    assumptions_added,
    ambiguity,
    unresolved_terms,
    confidence,
    evidence_links,
    omitted_context,
    alternative_interpretations
}
```

Field-to-expert path:

```text
FIELD_STATEMENT
    ↓
AI_TRANSLATION
    ↓
FIELD_CONFIRMATION
    ↓
EXPERT_SET
```

Expert-to-field path:

```text
EXPERT_RESPONSE
    ↓
AI_TRANSLATION_BACK
    ↓
EXPERT_CONFIRMATION
    ↓
FIELD_PERSON
```

No translated statement should be silently treated as equivalent to the original statement.

---

# 9. Persistent state

These mechanisms modify the Toledo state vector.

```text
S_t = {
    K,  # knowledge clarity
    T,  # trust / relationship quality
    R,  # rights / consent clarity
    E,  # expert-set adequacy
    A,  # absorptive capacity
    P,  # product / prototype maturity
    V,  # technical validation
    M,  # market / real-adoption evidence
    B,  # business-model maturity
    O,  # operational capacity
    F,  # finance readiness
    C,  # compliance readiness
    I,  # IP / ownership clarity
    N,  # network readiness
    G,  # growth readiness
    X   # global readiness
}
```

After each intervention:

```text
S_t
  ↓
Action_t
  ↓
Evidence_t
  ↓
S_(t+1)
```

Every state transition must retain provenance and failure history.

---

# 10. Integration into dynamic routing

```text
FUNCTION TOLEDO_HUMAN_GOVERNANCE_LAYER(case):

    case = assisted_entry(case)

    steward = assign_case_steward(case)

    IF RIGHTS_GATE(case) == HOLD:
        resolve_rights_before_progress()

    expert_set = BUILD_EXPERT_SET(case.problem_dimensions)

    IF TRUST_GATE(case.field_person, expert_set) != PASS:
        run_relationship_building()

    run_auditable_AI_exchange()

    K* = compose_knowledge_like_thing()

    capacity = ASSESS_ABSORPTIVE_CAPACITY(case)

    route_case_according_to_capacity_and_bottleneck()

    after_every_action:
        update_evidence_ledger()
        update_impact_ledger()
        update_failure_history()
        update_case_state()
        case_steward_review()

    RETURN current_state
```

---

# 11. Integration with Toledo → innovation → NIA handoff

These mechanisms do not replace the Toledo innovation path. They constrain it.

```text
Problem
    ↓
Rights + Trust
    ↓
Field Person ↔ AI ↔ Expert Set
    ↓
K*
    ↓
Absorptive Capacity
    ↓
Dynamic Tool Routing
    ↓
Solution / Prototype / Validation
    ↓
Real Adoption Environment
    ↓
Innovation-in-Real-Adoption
    ↓
Toledo Handoff
    ↓
NIA 4G / other scale system
```

Persistent across all nodes:

```text
CASE_STEWARD
EVIDENCE_LEDGER
IMPACT_LEDGER
RIGHTS_RECORD
FAILURE_RECORD
```

---

# 12. Normative invariants

```text
INVARIANT 1:
No unresolved rights → no silent extraction or commercialization.

INVARIANT 2:
No expert match is treated as collaboration until trust conditions are sufficient.

INVARIANT 3:
AI translations remain auditable and confirmable by the human source.

INVARIANT 4:
Expertise is composed as a set when the problem is multidisciplinary.

INVARIANT 5:
Routing must respect absorptive capacity.

INVARIANT 6:
Every live case has a persistent steward.

INVARIANT 7:
Every intervention updates an impact ledger.

INVARIANT 8:
Failure history is preserved; failed routes are not silently retried as if new.
```

---

# 13. Readout Universe relationship

The corresponding cross-repository semantic note is mirrored in:

```text
morrocwi/readout_universe
  docs/TOLEDO_HUMAN_GOVERNANCE_GATES_v0.3.md
```

Readout Universe carries the gate/traceability interpretation; Toledo carries the operational case-routing specification.
