# Toledo Equation Source Policy

Status: Canonical repository governance rule

## Authoritative source

For Toledo mathematical work, the sole authoritative source for existing equations, symbols, definitions, constraints, and derivations is this repository:

`https://github.com/morrocwi/toledo`

## Required procedure

1. Before using an equation in Toledo-related analysis, inspect this repository and verify that the equation, or the definitions and derivation that license it, are present here.
2. Do not import equations from Readout Genesis, MEMK, Telodo/Toledo-adjacent notes, prior drafts, external papers, or other repositories as if they were Toledo equations unless this repository explicitly contains or references them.
3. If the needed equation is not present, first search this repository for related notation, definitions, constraints, invariants, and existing derivations.
4. Only after that repository check may a new equation be proposed.
5. Any newly proposed equation must be explicitly labeled as a **new derivation/proposal**, not as an existing Toledo equation, and must preserve compatibility with the repository's existing definitions, notation, constraints, and invariants.
6. When a conflict exists between an equation remembered or found elsewhere and the current contents of this repository, the current repository governs Toledo work unless a repository change explicitly supersedes it.

## Central Toledo-Genesis Reuse-First Gate

**Rule ID:** `TG-RFG-01`  
**Type:** repository governance rule, **not** an equation or theorem code.

This is the mandatory central derivation gate for Toledo-related mathematical work, including Clay-program work and any downstream repository that consumes Toledo mathematics.

The required order is:

```text
Toledo lookup
    ↓
Genesis compatibility
    ↓
reuse existing object
    ↓
derive only the missing piece
    ↓
mark PROPOSAL
```

The five stages are binding:

1. **Toledo lookup.** Search/check the current Toledo registry and source tree before writing or using a mathematical object. Prefer the verdict-aware Toledo tools (`toledo_check`, `toledo_search`, `toledo_get`, lineage/neighbour queries) when available.
2. **Genesis compatibility.** Before assigning ontological or translation meaning to the object, check compatibility with the current `morrocwi/readout_genesis` architecture, especially retention, sufficiency, quotient, dynamic-commutation, readout, invariant, lineage, and defect-accounting requirements.
3. **Reuse existing object.** If a usable Toledo object already exists, reuse its canonical code, status, assumptions, parents, and claim boundary. Do not create a local duplicate, renamed equivalent, or stronger restatement merely for convenience.
4. **Derive only the missing piece.** If the exact needed object is absent, derive only the smallest missing statement needed for the current obligation, from already registered objects and declared assumptions. Do not rebuild an existing chain under new notation and do not import the target conclusion into the derivation.
5. **Mark `PROPOSAL`.** A genuinely new derivation remains a proposal until it passes the normal Toledo human-review/registration workflow. It MUST NOT be cited as an existing Toledo equation/theorem or silently promoted by another repository.

### Gate outcomes

- `REUSE` — a current usable Toledo object already covers the need; use it.
- `PROPOSAL` — no current object covers the need, compatibility checks pass, and a new minimal derivation is being proposed.
- `HOLD` — the match is ambiguous, superseded, split, contradictory, or requires unresolved lineage/status review.
- `DRIFT` — the work bypasses Toledo lookup, conflicts with Genesis without declaring a revision, duplicates an existing object as new, derives more than the identified gap, or presents an unregistered derivation as established.

`HOLD` and `DRIFT` are fail-closed states. They do not license a stronger claim.

### Reuse and proposal discipline

```text
existing usable object  -> cite/reuse it
candidate/ambiguous      -> HOLD; do not guess
NOT_REGISTERED           -> derive only after the checks above; register as PROPOSAL
conflict with Toledo     -> current Toledo mathematics governs unless explicitly revised
conflict with Genesis    -> ontology/translation claim is HOLD until reconciled or proposed as a revision
```

A downstream repository may implement, test, visualize, or specialize a Toledo object, but it may not create a second mathematical authority. New local formulas remain locally labelled proposals until Toledo registration settles their status.

### Claim boundary

Passing `TG-RFG-01` establishes provenance discipline only. It does **not** prove a new theorem, validate a domain translation, close a Clay problem, or upgrade an `OPEN`/`HOLD` object. All ordinary tier, proof, sufficiency, domain, and claim-ceiling gates still apply.

## Cross-repository lens policy

When Toledo mathematical work requires philosophical or human–AI interpretation, use the following repositories as the governing lenses for their respective domains:

### Ontology

Questions about what exists, what kind of thing a state, distinction, relation, process, constraint, or readout is, and how ontological commitments are licensed MUST be examined through:

`https://github.com/morrocwi/readout_genesis`

**Rule:** Readout Genesis is the primary ontology lens. Do not assign an ontological interpretation to a Toledo symbol or equation that conflicts with the current Readout Genesis architecture unless the conflict is explicitly identified and justified as a proposed revision.

### Epistemology

Questions about access, observation, distinguishability, evidence, warrant, claim formation, truth conditions, uncertainty, admissible inference, or what can be known from a readout MUST be examined through:

`https://github.com/morrocwi/readout_universe`

**Rule:** Readout Universe is the primary epistemology lens. Do not treat an ontological possibility, mathematical state, or model variable as epistemically available, warranted, or known unless that move is licensed by the current Readout Universe framework or clearly labeled as a new proposal.

### Human–AI and collaboration

Questions about humans and AI, human–AI interaction, co-production, assistance, delegation, autonomy, capability, division of labour, collaboration, dependence, augmentation, learning, or the returning human state MUST be examined through:

`https://github.com/morrocwi/glosa`

**Rule:** GLOSA is the primary human–AI and collaboration lens. Toledo equations may be used within human–AI analysis only after their interpretation is checked against GLOSA's current concepts, boundaries, and collaboration architecture.

## Precedence and crossing rule

These lenses govern different questions and MUST NOT be collapsed into one another:

- **Mathematical source and equation provenance:** `morrocwi/toledo`
- **Ontology:** `morrocwi/readout_genesis`
- **Epistemology:** `morrocwi/readout_universe`
- **Human–AI and collaboration:** `morrocwi/glosa`

If a problem crosses more than one domain, inspect every relevant governing repository before interpretation. A result MUST distinguish which part is mathematical, ontological, epistemological, and human–AI/collaborative.

If a new equation is required for a cross-domain problem, the required order is:

1. inspect `morrocwi/toledo` for existing mathematics, notation, constraints, and derivations;
2. inspect each relevant lens repository for domain compatibility;
3. reuse the existing Toledo object when one covers the need;
4. derive only the smallest missing piece after those checks;
5. label the result explicitly as a **new derivation/proposal**;
6. do not retrospectively present the new derivation as an existing equation or theorem of any repository.

## Short rule

**Central rule:** `Toledo lookup -> Genesis compatibility -> reuse existing object -> derive only the missing piece -> mark PROPOSAL`.

**Toledo equation = repository-grounded equation. If absent, inspect Toledo first; derive second; label the derivation as new.**

**Interpretation rule = ontology through Readout Genesis; epistemology through Readout Universe; human–AI and collaboration through GLOSA. Cross-domain work must declare and preserve these boundaries.**
