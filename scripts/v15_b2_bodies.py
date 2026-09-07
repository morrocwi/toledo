# -*- coding: utf-8 -*-
"""Per-code Coq body text (Section...End Section) for Toledo v1.5 lane B,
DEBT #45 part 2: the 55 file-less Effort/Economics/CES entries whose
coq.coq_status was already pre-assigned (definition/open_prop) at merge
time but had no coq/canonical/ file yet. Hand-authored, 2026-09-07,
directly from each entry's own registry/CANONICAL.json statement.latest
(quoted in a header comment in every generated file) -- every symbol not
already fixed by the statement itself (an index type, a threshold, an
abstract predicate) is introduced as a `Parameter`/`Variable` local to
that entry's own Section, its type chosen only to make the equation
type-check, never asserting what it computes. Needs QArith, List and this
lane's own _hrp_verdict_vocab.v (Verdict).
"""

BODIES = {}

# ---------------------------------------------------------------------
# Effort Across Stochastic, Controlled, and Adaptive Worlds v0.3
# (10.5281/zenodo.22622206)
# ---------------------------------------------------------------------

BODIES["A.5/H.20.v1"] = ("definition", "def", """
Section SEC.
  Parameter RB_Q : nat -> nat.
  Parameter Lambda_Q LC_Q : nat -> Verdict.
  Definition NAME (n : nat) : Prop :=
    LC_Q n = PASS <-> ((RB_Q n = 1)%nat /\\ Lambda_Q n = PASS).
End SEC.
""")

BODIES["A.5/H.21.v1"] = ("definition", "def", """
Section SEC.
  Parameter Gamma_Q : nat -> Q.
  Parameter tau_G : Q.
  Parameter LC_Q IC_Q : nat -> Verdict.
  Definition NAME (n : nat) : Prop :=
    IC_Q n = PASS <-> (LC_Q n = PASS /\\ (Gamma_Q n > tau_G)%Q).
End SEC.
""")

BODIES["A.5/H.22.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Stage : Type.
  Parameter ExposureStage RetainedRevisionStage CertifiedLearningStage ImprovementStage : Stage.
  Definition NAME : Prop :=
    ExposureStage <> RetainedRevisionStage /\\
    RetainedRevisionStage <> CertifiedLearningStage /\\
    CertifiedLearningStage <> ImprovementStage.
End SEC.
""")

BODIES["A.5/H.23.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Action : Type.
  Parameter V_learn V_act : nat -> Action -> Q.
  Definition NAME (n : nat) (u : Action) : Prop :=
    V_learn n u <> V_act n u.
End SEC.
""")

BODIES["EQ-015/H.38.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter WorldEvent Observation Model Effect Agent : Type.
  Parameter Y_world : nat -> WorldEvent.
  Parameter O_Q : WorldEvent -> Observation.
  Parameter mu_Q : Observation -> Model.
  Parameter E_Q : Model -> Effect.
  Parameter Retain_Q : Effect -> Agent -> Agent.
  Parameter A_Q : nat -> Agent.
  Definition NAME (n : nat) : Prop :=
    A_Q (S n) = Retain_Q (E_Q (mu_Q (O_Q (Y_world (S n))))) (A_Q n).
End SEC.
""")

BODIES["EQ-015/H.39.v1"] = ("definition", "def", """
Section SEC.
  Parameter Agent : Type.
  Parameter sim_Q : Agent -> Agent -> Prop.
  Parameter A_Q : nat -> Agent.
  Parameter RB_Q : nat -> nat.
  Definition NAME (n : nat) : Prop :=
    (RB_Q n = 1)%nat <-> ~ sim_Q (A_Q (S n)) (A_Q n).
End SEC.
""")

BODIES["weld/E.11.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Cause : Type.
  Parameter UncertaintyCause StochasticMechanismCause OtherAgentControlCause UnresolvedResidualCause : Cause.
  Definition NAME : Prop :=
    UncertaintyCause <> StochasticMechanismCause /\\
    StochasticMechanismCause <> OtherAgentControlCause /\\
    OtherAgentControlCause <> UnresolvedResidualCause.
End SEC.
""")

BODIES["weld/H.13.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter N_ext N_int : nat -> nat.
  Definition NAME : Prop :=
    exists m : nat, N_int m <> N_ext m.
End SEC.
""")

BODIES["weld/H.14.v1"] = ("definition", "def", """
Section SEC.
  Parameter SigState TState Context AgentState QModel : Type.
  Parameter S_n : nat -> SigState.
  Parameter T_n : nat -> TState.
  Parameter c_n : nat -> Context.
  Parameter Qm : QModel.
  Parameter q_A : SigState -> TState -> Context -> QModel -> AgentState.
  Parameter A_Q : nat -> AgentState.
  Definition NAME (n : nat) : Prop :=
    A_Q n = q_A (S_n n) (T_n n) (c_n n) Qm.
End SEC.
""")

BODIES["weld/H.15.v1"] = ("definition", "def", """
Section SEC.
  Parameter GState Context AgentState QModel IdState : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter I_Q : GState -> AgentState -> Context -> IdState.
  Parameter I_n_Q : nat -> IdState.
  Definition NAME (n : nat) : Prop :=
    I_n_Q n = I_Q (G_n n) (A_Q n) (c_n n).
End SEC.
""")

BODIES["weld/H.16.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter AgentState IdState : Type.
  Parameter A_Q : nat -> AgentState.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter sim_I : IdState -> IdState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter SameTrial_Q : nat -> nat -> nat.
  Definition NAME (n m : nat) : Prop :=
    (SameTrial_Q n m = 1)%nat <->
      ((SID_Q n m = SAME_mech \\/ SID_Q n m = EQUIV_Q) /\\
       sim_A (A_Q n) (A_Q m) /\\ sim_I (I_n_Q n) (I_n_Q m)).
End SEC.
""")

BODIES["weld/H.17.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter SameSourceReadout SameEffectiveAgent SameEncounter : Prop.
  Definition NAME : Prop :=
    ~ (SameSourceReadout -> SameEffectiveAgent) /\\
    ~ (SameEffectiveAgent -> SameEncounter).
End SEC.
""")

BODIES["weld/H.18.v1"] = ("definition", "def", """
Section SEC.
  Parameter GState AgentState Context IdSpace : Type.
  Parameter I_Q : GState -> AgentState -> Context -> IdSpace.
  Parameter O_I_Q : IdSpace -> IdSpace.
  Parameter d_I_Q : IdSpace -> IdSpace -> Q.
  Parameter tau_I : Q.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Definition NAME (g : GState) (a a' : AgentState) (c : Context) : Prop :=
    ISW_Q g a a' c = PASS <->
      (d_I_Q (O_I_Q (I_Q g a c)) (O_I_Q (I_Q g a' c)) > tau_I)%Q.
End SEC.
""")

BODIES["weld/H.19.v1"] = ("definition", "def", """
Section SEC.
  Parameter GState AgentState Context : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Definition NAME (n : nat) : Prop :=
    SID_Q n (S n) = SAME_mech /\\
    ~ sim_A (A_Q (S n)) (A_Q n) /\\
    ISW_Q (G_n n) (A_Q n) (A_Q (S n)) (c_n n) = PASS.
End SEC.
""")

BODIES["weld/H.20.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter IdState : Type.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_I : IdState -> IdState -> Prop.
  Definition NAME (n : nat) : Prop :=
    ~ sim_I (I_n_Q (S n)) (I_n_Q n).
End SEC.
""")

BODIES["weld/H.21.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter GState AgentState Context IdState : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Parameter ChangedAgentCredit : nat -> IdState -> Prop.
  Definition NAME (n : nat) : Prop :=
    (SID_Q n (S n) = SAME_mech /\\
     ~ sim_A (A_Q (S n)) (A_Q n) /\\
     ISW_Q (G_n n) (A_Q n) (A_Q (S n)) (c_n n) = FAIL) ->
    ~ ChangedAgentCredit n (I_n_Q (S n)).
End SEC.
""")

BODIES["weld/M.15.v1"] = ("definition", "def", """
Section SEC.
  Parameter Mech Readout : Type.
  Parameter M_Q_adm : Mech -> Prop.
  Parameter O_Q_G : Mech -> Readout.
  Parameter r_n : nat -> Readout.
  Definition NAME (n : nat) (m : Mech) : Prop :=
    M_Q_adm m /\\ O_Q_G m = r_n n.
End SEC.
""")

BODIES["weld/M.16.v1"] = ("definition", "def", """
Section SEC.
  Parameter Mech : Type.
  Parameter M_Q_adm : Mech -> Prop.
  Parameter AssumptionsExplicit : Mech -> Prop.
  Parameter CSML_Q : Mech -> Verdict.
  Definition NAME (m : Mech) : Prop :=
    CSML_Q m = PASS <-> (M_Q_adm m /\\ AssumptionsExplicit m).
End SEC.
""")

BODIES["weld/M.17.v1"] = ("definition", "def", """
Section SEC.
  Parameter Mech : Type.
  Parameter M_Q_r : nat -> Mech -> Prop.
  Parameter M_Q_stoch : Mech -> Prop.
  Parameter SAL_Q_strong : nat -> Verdict.
  Definition NAME (n : nat) : Prop :=
    SAL_Q_strong n = PASS <-> (forall m : Mech, M_Q_r n m -> M_Q_stoch m).
End SEC.
""")

BODIES["weld/M.18.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Mech : Type.
  Parameter M_Q_r : nat -> Mech -> Prop.
  Parameter M_Q_stoch M_Q_nonstoch : Mech -> Prop.
  Parameter SAL_Q_strong : nat -> Verdict.
  Definition NAME (n : nat) : Prop :=
    ((exists m, M_Q_r n m /\\ M_Q_stoch m) /\\
     (exists m, M_Q_r n m /\\ M_Q_nonstoch m)) ->
    SAL_Q_strong n = HOLD.
End SEC.
""")

BODIES["weld/M.19.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Mech : Type.
  Parameter CSML_Q : Mech -> Verdict.
  Parameter SAL_Q_strong_m : Mech -> Verdict.
  Definition NAME : Prop :=
    ~ (forall m : Mech, CSML_Q m = PASS -> SAL_Q_strong_m m = PASS).
End SEC.
""")

BODIES["weld/M.20.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter RSpace DSpace Out J_Q : Type.
  Parameter T_RtoD : RSpace -> DSpace.
  Parameter F_R : RSpace -> RSpace.
  Parameter F_D : DSpace -> DSpace.
  Parameter O_R : RSpace -> Out.
  Parameter O_D : DSpace -> Out.
  Parameter W_R_Q : J_Q -> RSpace -> Out.
  Parameter W_D_Q : J_Q -> DSpace -> Out.
  Definition NAME : Prop :=
    (forall r, T_RtoD (F_R r) = F_D (T_RtoD r)) /\\
    (forall r, O_D (T_RtoD r) = O_R r) /\\
    (forall (j : J_Q) (r : RSpace), W_D_Q j (T_RtoD r) = W_R_Q j r).
End SEC.
""")

BODIES["weld/M.21.v1"] = ("definition", "def", """
Section SEC.
  Parameter RSpace DSpace Out J_Q : Type.
  Parameter F_R : RSpace -> RSpace.
  Parameter F_D : DSpace -> DSpace.
  Parameter O_R : RSpace -> Out.
  Parameter O_D : DSpace -> Out.
  Parameter W_R_Q : J_Q -> RSpace -> Out.
  Parameter W_D_Q : J_Q -> DSpace -> Out.
  Parameter CDOL_Q : Verdict.
  Definition NAME : Prop :=
    CDOL_Q = PASS <->
      exists T : RSpace -> DSpace,
        (forall r, T (F_R r) = F_D (T r)) /\\
        (forall r, O_D (T r) = O_R r) /\\
        (forall (j : J_Q) (r : RSpace), W_D_Q j (T r) = W_R_Q j r).
End SEC.
""")

BODIES["weld/M.22.v1"] = ("definition", "def", """
Section SEC.
  Parameter Event : Type.
  Parameter e_n : nat -> Event.
  Parameter ECT_Q : Event -> Verdict.
  Definition NAME (n : nat) : Prop :=
    ECT_Q (e_n n) = E0 \\/ ECT_Q (e_n n) = E1 \\/ ECT_Q (e_n n) = E2 \\/
    ECT_Q (e_n n) = E3 \\/ ECT_Q (e_n n) = E4 \\/ ECT_Q (e_n n) = HOLD.
End SEC.
""")

BODIES["weld/M.23.v1"] = ("definition", "def", """
Section SEC.
  Parameter SID_Q : nat -> nat -> Verdict.
  Definition NAME (n m : nat) : Prop :=
    SID_Q n m = SAME_mech \\/ SID_Q n m = EQUIV_Q \\/
    SID_Q n m = DIFF_Q \\/ SID_Q n m = HOLD.
End SEC.
""")

BODIES["weld/M.24.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter GState : Type.
  Parameter G_n : nat -> GState.
  Parameter SID_Q : nat -> nat -> Verdict.
  Definition NAME : Prop :=
    ~ (forall n m : nat, SID_Q n m = EQUIV_Q -> G_n n = G_n m).
End SEC.
""")

BODIES["weld/M.25.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter DState Action Out : Type.
  Parameter U_D_adm : Action -> Prop.
  Parameter R_D : DState -> Action -> Out.
  Parameter d_Q : Out -> Out -> Q.
  Parameter tau_E : Q.
  Parameter s : DState.
  Parameter ERG_D : Verdict.
  Definition NAME : Prop :=
    ERG_D = PASS <->
      exists ua ub : Action, U_D_adm ua /\\ U_D_adm ub /\\
        (d_Q (R_D s ua) (R_D s ub) > tau_E)%Q.
End SEC.
""")

BODIES["weld/M.26.v1"] = ("definition", "def", """
Section SEC.
  Parameter Action Outcome : Type.
  Parameter ERG_D : Verdict.
  Parameter u : Action.
  Parameter Y : Outcome.
  Parameter ID_Q : Action -> Outcome -> Verdict.
  Parameter CER_Q : Verdict.
  Definition NAME : Prop :=
    CER_Q = PASS <-> (ERG_D = PASS /\\ ID_Q u Y = PASS).
End SEC.
""")

BODIES["weld/M.27.v1"] = ("definition", "def", """
Section SEC.
  Parameter Action : Type.
  Parameter C_int C_ext C_opp C_risk : nat -> Action -> Q.
  Parameter C_vec : nat -> Action -> (Q * Q * Q * Q).
  Definition NAME (n : nat) (u : Action) : Prop :=
    C_vec n u = (C_int n u, C_ext n u, C_opp n u, C_risk n u).
End SEC.
""")

BODIES["weld/M.28.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Action Filtration : Type.
  Parameter U_D_adm : Action -> Prop.
  Parameter C_vec : Action -> (Q * Q * Q * Q).
  Parameter le_budget : (Q * Q * Q * Q) -> (Q * Q * Q * Q) -> Prop.
  Parameter B_n : (Q * Q * Q * Q).
  Parameter P_exit : Filtration -> Action -> Q.
  Parameter F_n : Filtration.
  Parameter alpha : Q.
  Definition NAME (u : Action) : Prop :=
    U_D_adm u /\\ le_budget (C_vec u) B_n /\\ (P_exit F_n u <= alpha)%Q.
End SEC.
""")

BODIES["weld/M.29.v1"] = ("definition", "def", """
Section SEC.
  Parameter Event RouteLabel : Type.
  Parameter e_n : nat -> Event.
  Parameter ECT_Q : Event -> Verdict.
  Parameter A_M A_B A_P A_G A_X HOLD_route : RouteLabel.
  Parameter Route_Q : Event -> RouteLabel.
  Definition NAME (n : nat) : Prop :=
    (ECT_Q (e_n n) = E0 -> Route_Q (e_n n) = A_M) /\\
    (ECT_Q (e_n n) = E1 -> Route_Q (e_n n) = A_B) /\\
    (ECT_Q (e_n n) = E2 -> Route_Q (e_n n) = A_P) /\\
    (ECT_Q (e_n n) = E3 -> Route_Q (e_n n) = A_G) /\\
    (ECT_Q (e_n n) = E4 -> Route_Q (e_n n) = A_X) /\\
    (ECT_Q (e_n n) = HOLD -> Route_Q (e_n n) = HOLD_route).
End SEC.
""")

BODIES["weld/M.30.v1"] = ("definition", "def", """
Section SEC.
  Parameter Event RouteLabel Action Decision : Type.
  Parameter e_n : nat -> Event.
  Parameter Route_Q : Event -> RouteLabel.
  Parameter HOLD_route : RouteLabel.
  Parameter U_safe : nat -> Action -> Prop.
  Parameter D_star : nat -> Decision.
  Parameter HOLD_dec STOP_dec : Decision.
  Parameter D : nat -> Decision.
  Definition NAME (n : nat) : Prop :=
    (Route_Q (e_n n) = HOLD_route -> D (S n) = HOLD_dec) /\\
    (Route_Q (e_n n) <> HOLD_route -> (~ exists u, U_safe (S n) u) -> D (S n) = STOP_dec) /\\
    (Route_Q (e_n n) <> HOLD_route -> (exists u, U_safe (S n) u) -> D (S n) = D_star n).
End SEC.
""")

BODIES["weld/M.31.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Action Decision : Type.
  Parameter U_safe : nat -> Action -> Prop.
  Parameter STOP_dec : Decision.
  Parameter D : nat -> Decision.
  Definition NAME (n : nat) : Prop :=
    (~ exists u, U_safe (S n) u) -> D (S n) = STOP_dec.
End SEC.
""")

BODIES["weld/M.32.v1"] = ("definition", "def", """
Section SEC.
  Parameter EventT ReadoutT LicenseT ECTt WitnessBridgeT SensitivityT RetentionT ChangedAgentT AdapterT CostRiskT : Type.
  Parameter step1 : EventT -> ReadoutT.
  Parameter step2 : ReadoutT -> LicenseT.
  Parameter step3 : LicenseT -> ECTt.
  Parameter step4 : ECTt -> WitnessBridgeT.
  Parameter step5 : WitnessBridgeT -> SensitivityT.
  Parameter step6 : SensitivityT -> RetentionT.
  Parameter step7 : RetentionT -> ChangedAgentT.
  Parameter step8 : ChangedAgentT -> AdapterT.
  Parameter step9 : AdapterT -> CostRiskT.
  Parameter step10 : CostRiskT -> Verdict.
  Definition NAME (e : EventT) : Prop :=
    let v := step10 (step9 (step8 (step7 (step6 (step5 (step4 (step3 (step2 (step1 e)))))))))
    in v = CONTINUE \\/ v = SWITCH \\/ v = STOP \\/ v = HOLD.
End SEC.
""")

# ---------------------------------------------------------------------
# The Economics of Expertise in the Age of Generative AI v1.0.1
# (10.5281/zenodo.22636999)
# ---------------------------------------------------------------------

BODIES["weld/H.22.v1"] = ("definition", "def", """
Section SEC.
  Parameter Notion : Type.
  Parameter Credential Expertise : Notion.
  Definition NAME : Prop := Credential <> Expertise.
End SEC.
""")

BODIES["weld/H.23.v1"] = ("definition", "def", """
Section SEC.
  Parameter Notion : Type.
  Parameter ProjectRole ExpertiseType AISystem : Notion.
  Definition NAME : Prop :=
    ProjectRole <> ExpertiseType /\\ ExpertiseType <> AISystem.
End SEC.
""")

BODIES["weld/H.24.v1"] = ("definition", "def", """
Section SEC.
  Parameter Person Question Domain : Type.
  Inductive ExpertiseIdealType := N_type | I_type | C_type.
  Parameter chi : Person -> Question -> Domain -> nat -> ExpertiseIdealType.
  Definition NAME (i : Person) (Qq : Question) (D : Domain) (t : nat) : Prop :=
    chi i Qq D t = N_type \\/ chi i Qq D t = I_type \\/ chi i Qq D t = C_type.
End SEC.
""")

BODIES["weld/H.25.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter AI Practice World Resource : Type.
  Inductive ExpertiseIdealType25 := N25 | I25 | C25.
  Parameter TransProb : ExpertiseIdealType25 -> ExpertiseIdealType25 -> AI -> Practice -> World -> Resource -> Q.
  Definition NAME (a b : ExpertiseIdealType25) (At : AI) (Pt : Practice) (Wt : World) (Rt : Resource) : Prop :=
    (0 <= TransProb a b At Pt Wt Rt <= 1)%Q.
End SEC.
""")

BODIES["weld/H.26.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter C_NtoI_AI C_NtoI_baseline : Q.
  Definition NAME : Prop := (C_NtoI_AI < C_NtoI_baseline)%Q.
End SEC.
""")

BODIES["weld/H.27.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter DeltaC_ItoC_AI DeltaC_NtoI_AI : Q.
  Definition NAME : Prop := (Qabs DeltaC_ItoC_AI < Qabs DeltaC_NtoI_AI)%Q.
End SEC.
""")

BODIES["weld/H.28.v1"] = ("definition", "def", """
Section SEC.
  Parameter ExpHolder AIModel : Type.
  Parameter E_p_exp : ExpHolder.
  Parameter E_p_int : option ExpHolder.
  Parameter M_p_AI : list AIModel.
  Definition NAME : Prop :=
    E_p_int = None /\\ M_p_AI <> nil.
End SEC.
""")

BODIES["weld/H.29.v1"] = ("definition", "def", """
Section SEC.
  Parameter LiveProblem Actor Question CandidateSet Discrimination WorldTest Feedback Revision : Type.
  Parameter to_actors : LiveProblem -> Actor.
  Parameter to_question : Actor -> Question.
  Parameter to_candidates : Question -> CandidateSet.
  Parameter to_discrimination : CandidateSet -> Discrimination.
  Parameter to_worldtest : Discrimination -> WorldTest.
  Parameter to_feedback : WorldTest -> Feedback.
  Parameter to_revision : Feedback -> Revision.
  Definition NAME (p : LiveProblem) : Revision :=
    to_revision (to_feedback (to_worldtest (to_discrimination (to_candidates (to_question (to_actors p)))))).
End SEC.
""")

BODIES["weld/W.03.v1"] = ("definition", "def", """
Section SEC.
  Parameter Candidate : Type.
  Parameter w : Candidate -> Q.
  Parameter C_t_new : nat -> list Candidate.
  Definition NAME (t : nat) : Q :=
    fold_right (fun c acc => (w c + acc)%Q) 0%Q (C_t_new t).
End SEC.
""")

BODIES["weld/W.04.v1"] = ("definition", "def", """
Section SEC.
  Parameter ContribExp InteractExp World Data Resource AIval : Type.
  Parameter E_t_C : nat -> ContribExp.
  Parameter E_t_I : nat -> InteractExp.
  Parameter W_t : nat -> World.
  Parameter D_t : nat -> Data.
  Parameter R_t : nat -> Resource.
  Parameter A_v_t : nat -> AIval.
  Parameter Vfun : ContribExp -> InteractExp -> World -> Data -> Resource -> AIval -> Q.
  Parameter mu_t : nat -> Q.
  Definition NAME (t : nat) : Prop :=
    mu_t t = Vfun (E_t_C t) (E_t_I t) (W_t t) (D_t t) (R_t t) (A_v_t t).
End SEC.
""")

BODIES["weld/W.05.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter delta_B : Q.
  Parameter Lambda_t mu_t B : nat -> Q.
  Definition NAME (t : nat) : Prop :=
    B (S t) = Qmax 0 ((1 - delta_B) * B t + Lambda_t t - mu_t t).
End SEC.
""")

BODIES["weld/W.06.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Lambda mu delta_B B_star : Q.
  Definition NAME : Prop :=
    (Lambda > mu)%Q -> delta_B <> 0%Q -> B_star = ((Lambda - mu) / delta_B)%Q.
End SEC.
""")

BODIES["weld/W.07.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter dBstar_dAg dLambda_dAg delta_B : Q.
  Parameter dBstar_dAv dmu_dAv : Q.
  Parameter dBstar_dz dLambda_dz dmu_dz : Q.
  Definition NAME : Prop :=
    delta_B <> 0%Q /\\
    dBstar_dAg = (dLambda_dAg / delta_B)%Q /\\ (dBstar_dAg > 0)%Q /\\
    dBstar_dAv = (- dmu_dAv / delta_B)%Q /\\ (dBstar_dAv < 0)%Q /\\
    dBstar_dz = ((dLambda_dz - dmu_dz) / delta_B)%Q /\\
    ((dLambda_dz > dmu_dz)%Q <-> (dBstar_dz > 0)%Q).
End SEC.
""")

BODIES["weld/W.08.v1"] = ("definition", "def", """
Section SEC.
  Parameter Candidate : Type.
  Parameter v : Candidate -> Q.
  Parameter G : Candidate -> nat.
  Parameter P_t : nat -> list Candidate.
  Definition NAME_indicator (c : Candidate) : Q := if Nat.eqb (G c) 1 then 1%Q else 0%Q.
  Definition NAME (t : nat) : Q :=
    fold_right (fun c acc => (v c * NAME_indicator c + acc)%Q) 0%Q (P_t t).
  (* The source's further remark, "|C^new_t| uparrow does not imply
     Y_{K,t} uparrow proportionally", is a qualitative non-collapse note
     about this function, not a further equation with its own operator;
     recorded here as this comment, not separately formalised. *)
End SEC.
""")

BODIES["weld/W.09.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter X CandidateSetT : Type.
  Parameter U : Q -> Q.
  Parameter Cost : X -> Q.
  Parameter Phi : Q -> CandidateSetT -> Q.
  Parameter mu Y_K lambda_V : Q.
  Parameter Cset : CandidateSetT.
  Parameter x : X.
  Parameter Lagr : Q.
  Definition NAME : Prop :=
    Lagr = (U Y_K - Cost x + lambda_V * (Phi mu Cset - Y_K))%Q.
End SEC.
""")

BODIES["weld/W.10.v1"] = ("definition", "def", """
Section SEC.
  Parameter Budget SafetyRisk ProtocolBurden Bbar Sbar Ubar : Q.
  Parameter ProvenanceGatesPassed OpenExplorationProtected : Prop.
  Definition NAME : Prop :=
    (Budget <= Bbar)%Q /\\ (SafetyRisk <= Sbar)%Q /\\ (ProtocolBurden <= Ubar)%Q /\\
    ProvenanceGatesPassed /\\ OpenExplorationProtected.
  (* The optimisation OBJECT itself -- {Y_K, Delta R_H^return, W, T, N_v}
     -- is the portfolio tuple being Pareto-optimised subject to exactly
     these five named constraints; the source states no objective
     function beyond naming this tuple, so none is invented here. *)
End SEC.
""")

# ---------------------------------------------------------------------
# Core Epistemic Structure (CES) definitions, BBL-2026-09-07-217
# ---------------------------------------------------------------------

BODIES["weld/H.30.v1"] = ("definition", "def", """
Section SEC.
  Parameter ExpHolder AIModel : Type.
  Parameter X_p_exp : ExpHolder.
  Parameter X_p_int : option ExpHolder.
  Parameter M_p_AI : list AIModel.
  Definition NAME : (ExpHolder * option ExpHolder * list AIModel) :=
    (X_p_exp, X_p_int, M_p_AI).
End SEC.
""")

BODIES["weld/H.31.v1"] = ("definition", "def", """
Section SEC.
  Parameter AIModel : Type.
  Parameter M_p_AI : list AIModel.
  Definition NAME : Prop := M_p_AI <> nil.
End SEC.
""")

BODIES["weld/H.32.v1"] = ("definition", "def", """
Section SEC.
  Parameter ExpHolder : Type.
  Parameter X_p_int : option ExpHolder.
  Definition NAME : Prop := X_p_int = None.
End SEC.
""")

BODIES["weld/H.33.v1"] = ("open_prop", "hyp", """
Section SEC.
  Parameter Notion : Type.
  Parameter ExperienceBasedExpertise InteractionalExpertise AIModelNotion : Notion.
  Definition NAME : Prop :=
    ExperienceBasedExpertise <> InteractionalExpertise /\\
    InteractionalExpertise <> AIModelNotion.
End SEC.
""")

BODIES["weld/H.34.v1"] = ("definition", "def", """
Section SEC.
  Parameter LivedExperience Selection Interpretation : Type.
  Parameter Exp : LivedExperience.
  Parameter Sel : Selection.
  Parameter Int : Interpretation.
  Definition NAME : (LivedExperience * Selection * Interpretation) :=
    (Exp, Sel, Int).
End SEC.
""")

assert len(BODIES) == 55, len(BODIES)
