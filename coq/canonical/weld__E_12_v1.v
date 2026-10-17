(* weld/E.12.v1 -- Definition -- FAQR facts/options/unknowns projection.      *)
(* NEW DERIVATION / PROPOSAL. Claim boundary: facts/options projection; not a *)
(* fatwa, ruling, mediation, or religious verdict; EQ-015 CE structural only. *)
(* The ledger B_n is a record of facts, an options list and unknowns; the    *)
(* projection returns a Projection value, never an element chosen from the   *)
(* options (no argmax, no best_option, no winner is definable from it).      *)
(* Definition only: no theorem, no weld-commutation claim, no axiom beyond   *)
(* the local Parameters that fix the signature.                              *)

Require Import List.

Section weld__E_12_v1_sec.
  Parameter Claim Option Provenance JurisdictionNote ContextNote Diagnostic : Type.
  Parameter Unknown Constraint Projection : Type.

  Record Entry : Type := mkEntry {
    opt : Option;
    attrib : Provenance;
    jur : JurisdictionNote;
    ctx : ContextNote;
    diag : Diagnostic
  }.

  Record Ledger : Type := mkLedger {
    facts : list Claim;
    options : list Entry;
    unknowns : list Unknown
  }.

  (* P_n := Project(B_n | A) *)
  Parameter Project : Ledger -> list Constraint -> Projection.

  Definition weld__E_12_v1_projection (b : Ledger) (a : list Constraint)
    : Projection := Project b a.
End weld__E_12_v1_sec.
