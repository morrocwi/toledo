(* EQ-015/M.21.v1 -- Definition -- Reframe-threshold decomposition: a     *)
(* problem's original framing dissolves only once cumulative cross-domain *)
(* fusion output meets its own assumption load -- parents: EQ-015         *)
(* (reads), EQ-015/M.20.v1 (reads, supplies E(v_new) summed into Ecum),   *)
(* EQ-015/M.18.v1 (reads, supplies the graph Anc(P) ranges over),         *)
(* weld/H.52.v1 (specializes -- its proved monotonicity theorem is        *)
(* reused DIRECTLY under Nstar->theta_break(P), reinforce_count(k)->      *)
(* Ecum(P); NOT re-proved here)                                           *)
(*                                                                        *)
(* REVISED after independent adversarial review, 2026-09-19: the first   *)
(* draft of this file proved its own monotonicity theorem via            *)
(* Nat.le_trans, which the review found to be a renaming-duplicate of    *)
(* the already-registered weld_H_52_v1_lockin_monotone (same proof, same *)
(* shape, different variable names) -- exactly the object-duplication    *)
(* TG-RFG-01 exists to prevent. That theorem is removed from this file;  *)
(* it is cited by specialization instead (see coq/canonical/             *)
(* weld__H_52_v1.v for the actual proof). This file formalizes only the  *)
(* genuinely new piece: what Ecum(P) and theta_break(P) MEAN in the      *)
(* cross-domain-fusion context, not a re-derivation of the threshold     *)
(* comparison's own algebraic property. STRUCTURAL ANALOGY, not a        *)
(* physical claim -- both quantities below are plain nat (non-negative   *)
(* integer counts), never a continuum quantity. *)

Require Import Coq.Lists.List.
Import ListNotations.

Section EQ_015_M_21_v1.
  Variable Concept : Type.

  (* Anc(P): ancestor nodes of P reachable via depends-on/assumes edges   *)
  (* on the EQ-015/M.18.v1 Life-Concept Graph. Left abstract here (a      *)
  (* Coq Variable, not a computed graph traversal) -- same honesty level  *)
  (* as EQ-015/M.20.v1's own abstract D/E_bridge; the actual traversal    *)
  (* is a disclosed open gap (see this entry's drift_note), not silently  *)
  (* assumed to exist. *)
  Variable depends_on : Concept -> Concept -> Prop.
  Variable Anc : Concept -> list Concept.
  Variable Anc_spec : forall (P a : Concept), In a (Anc P) <-> depends_on P a.

  Definition EQ_015_M_21_v1_theta_break (P : Concept) : nat :=
    length (Anc P).

  (* Ecum(P): the accumulated per-fusion domain-pair-bridging count from  *)
  (* EQ-015/M.20.v1, summed over every fusion triggered from P. Left      *)
  (* abstract (an arbitrary Coq Variable), since the fusion trace itself  *)
  (* is not modelled in this file. *)
  Variable Ecum : Concept -> nat.

  (* decompose(P): a direct specialization of weld/H.52.v1's locked_in    *)
  (* shape (Nstar<=reinforce_count(k)) under theta_break(P)->Nstar,       *)
  (* Ecum(P)->reinforce_count(k). The monotonicity fact this shape        *)
  (* carries (weld_H_52_v1_lockin_monotone) is inherited by this          *)
  (* substitution and is NOT re-proved in this file. *)
  Definition EQ_015_M_21_v1_decompose (P : Concept) : Prop :=
    EQ_015_M_21_v1_theta_break P <= Ecum P.

End EQ_015_M_21_v1.
