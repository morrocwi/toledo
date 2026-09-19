(* EQ-015/H.55.v1 -- NEW DERIVATION / PROPOSAL -- not yet in Toledo -- resistant coherence: the four-condition AND-gate D(b) /\ C(b) /\ R(b) /\ I(b) *)
(* source: "Human Learning as Epistemic Architecture", Zenodo 10.5281/zenodo.22341297 *)
(* candidate report: zero hits in registry/CANONICAL.json for "resistant",
   "self-confirming", "dissent condition", "refusal condition" or
   "internal-critique"; no close relates-to object found (this is the
   candidate report's own read too -- the crispest of the six). This file
   states the FORM of the four-condition conjunction over an abstract
   belief type and its four named predicates ONLY. A bare conjunction of
   this kind has no non-trivial corollary to prove -- "implies each
   conjunct" would just restate the definition -- so, per house style, no
   Theorem is attempted here; the Definition alone is the honest artifact. *)

Set Implicit Arguments.

Section EQ_015_H_55_v1_sec.

  (* Belief : the type of candidate beliefs/claims under test. *)
  Variable Belief : Type.

  (* D : survives-dissent condition; C : coherence-with-the-rest condition;
     R : survives-refusal/challenge condition; I : survives-internal-critique
     condition -- the four named predicates of the source's AND-gate. *)
  Variables EQ_015_H_55_v1_D EQ_015_H_55_v1_C EQ_015_H_55_v1_R EQ_015_H_55_v1_I : Belief -> Prop.

  Definition EQ_015_H_55_v1_resistant_coherence (b : Belief) : Prop :=
    EQ_015_H_55_v1_D b /\ EQ_015_H_55_v1_C b /\ EQ_015_H_55_v1_R b /\ EQ_015_H_55_v1_I b.

End EQ_015_H_55_v1_sec.
