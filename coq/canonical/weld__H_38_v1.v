(* weld/H.38.v1 -- MR16-01 -- Definition -- parents: weld/H.07.v1 (reads) -- occurrences 1 *)

Require Import MR.MR_Retention.

(* ==================================================================== *)
(** ** MR16-01 — AI-side semantic momentum reset across sessions

    CANONICAL.json statement.latest: m^{\mathrm{AI}}_{s+1,0}=0

    Origin: Master Equation River v1.5 (doi 10.5281/zenodo.22550491),
    sec:humanai2, Eq. 37. Master River v1.5 itself frames this as a
    scope-bound modelling condition of the Fusion/Tunnel model, not a
    constitutive or universal law about every AI architecture with
    persistent memory -- tier is Definition (a stated model convention),
    not Dr or Open, following the source's own framing.

    Direct reuse of [MR_Retention.ai_momentum_resets] (already formalized
    there as part of the same file's eq. 35-42 block) -- no re-derivation,
    per this workspace's own reuse-pipeline discipline (TG-RFG-01). *)

Definition weld__H_38_v1_def := MR_Retention.ai_momentum_resets.

Print Assumptions weld__H_38_v1_def.
