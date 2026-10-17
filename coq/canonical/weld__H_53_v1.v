(* weld/H.53.v1 -- Definition -- FAQR source-layer typed non-collapse.        *)
(* NEW DERIVATION / PROPOSAL. Claim boundary: facts/options projection; not a *)
(* fatwa, ruling, mediation, or religious verdict; EQ-015 CE structural only. *)
(* Typing only: the five layers W (revealed source), R (assessed reports),   *)
(* J (scholarly interpretation), G (jurisdiction/law), C (culture/origin)    *)
(* are separate types, so none can be used where another is expected without *)
(* an explicitly declared function. No theorem, no empirical claim, no axiom *)
(* beyond the local Parameters that fix the signature.                       *)

Section weld__H_53_v1_sec.
  Parameter W R J G C E Method Setting : Type.

  (* J_j := ScholarlyDerivation_j(W, R, E, interpretive_method_j, setting) *)
  Parameter ScholarlyDerivation : Method -> W -> R -> E -> Setting -> J.

  (* Any bridge between layers must be a declared function, never an identity. *)
  Definition weld__H_53_v1_derivation (m : Method) (s : Setting)
      (w : W) (r : R) (e : E) : J :=
    ScholarlyDerivation m w r e s.
End weld__H_53_v1_sec.
