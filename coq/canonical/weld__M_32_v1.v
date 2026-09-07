(* weld/M.32.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.41: NEW SYNTHESIS *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{Event} \to \text{Readout} \to \text{Conditional/Strong Stochastic License} \to \text{Event-Control Type} \to \text{Witness-Preserving Bridge} \to \text{Interaction Sensitivity} \to \text{Retention/Learning} \to \text{Changed Agent} \to \text{Mathematical Adapter} \to \text{Cost/Risk/Viability} \to \{\mathsf{CONTINUE}, \mathsf{SWITCH}, \mathsf{STOP}, \mathsf{HOLD}\} *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__M_32_v1_sec.
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
  Definition weld__M_32_v1_def (e : EventT) : Prop :=
    let v := step10 (step9 (step8 (step7 (step6 (step5 (step4 (step3 (step2 (step1 e)))))))))
    in v = CONTINUE \/ v = SWITCH \/ v = STOP \/ v = HOLD.
End weld__M_32_v1_sec.
