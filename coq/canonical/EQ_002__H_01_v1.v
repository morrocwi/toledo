(* EQ-002/H.01.v1 — CAN-048 — Definition — parents: EQ-002/M.03.v1 — occurrences 13 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-048 — agency-conditional-chain

    (* CAN-048 — root: B[n]->Hbody[n]->N[n]<->A[n]->pi[n]->U[n]->B[n+1] — domain: human–AI — tier: Definition — occurrences: 13 *)

    CANONICAL.json tier: "definition". No Master River eq. citation
    (Mind as Information Horizon eq.(1)-(8), record 19640361; Readout
    Genesis Standalone Synthesis eq.(39)-(43), record 21529456) — a
    staged, one-arrow-per-step causal loop, typed as a well-typed
    composition of six discrete update maps, exactly in the
    "type-checking is the Definition-tier content" family already used
    by [next_state]/[dcp_closure_50]. *)

Section CAN_048_AgencyConditionalChain.

  Variables Body HBody Nervous SenseState Agency Policy2 : Type.

  Variable body_to_hbody   : Body -> HBody.
  Variable hbody_to_nerv   : HBody -> Nervous.
  Variable nerv_to_sense   : Nervous -> SenseState.
  Variable sense_to_agency : SenseState -> Agency.
  Variable agency_to_pol   : Agency -> Policy2.
  Variable pol_to_body     : Policy2 -> Body.

  Definition CAN_048_agency_conditional_chain (b : Body) : Body :=
    pol_to_body (
      agency_to_pol (
        sense_to_agency (
          nerv_to_sense (
            hbody_to_nerv (
              body_to_hbody b))))).

End CAN_048_AgencyConditionalChain.

