(* _hrp_verdict_vocab.v -- Toledo v1.5 lane B (DEBT #45, part 2).
   Shared finite vocabulary for the "not_yet_formalised"/file-less
   coq.coq_status=="definition"/"open_prop" entries from three papers
   already merged into registry/CANONICAL.json under root weld (Effort
   Across Stochastic, Controlled, and Adaptive Worlds v0.3, DOI
   10.5281/zenodo.22622206; The Economics of Expertise in the Age of
   Generative AI v1.0.1, DOI 10.5281/zenodo.22636999) plus a handful of
   readings under EQ-015 and A.5 that the Effort paper's own text names as
   readings of those existing roots.

   Every one of these papers repeatedly uses a small closed set of named
   verdict/label values (PASS/FAIL, HOLD/STOP/CONTINUE/SWITCH, the routing
   labels E0..E4, and the trial-identity labels SAME_mech/EQUIV_Q/DIFF_Q).
   Declaring ONE shared finite Inductive type for these -- rather than a
   fresh ad hoc one per file -- is more faithful to the source, not less:
   within one paper "PASS" names the same value everywhere it appears, and
   a shared type lets Coq's own decidable equality (`Verdict_eq_dec` below)
   be reused instead of re-declared per entry. Every OTHER symbol in these
   55 statements (the specific functions LC_Q, RB_Q, Gamma_Q, ... and the
   index/state types they act on) is left as an abstract `Parameter` LOCAL
   to that one entry's own file (Section-scoped, not shared here) --
   nothing about what those functions actually compute is asserted or
   invented anywhere in this corpus; only their type signature (arity and
   which of these finite/discrete sorts they land in) is fixed, exactly as
   much structure as the source's own equation states and no more. *)

Inductive Verdict : Type :=
  | PASS | FAIL | HOLD | STOP | CONTINUE | SWITCH
  | E0 | E1 | E2 | E3 | E4
  | SAME_mech | EQUIV_Q | DIFF_Q.

Lemma Verdict_eq_dec : forall a b : Verdict, {a = b} + {a <> b}.
Proof. decide equality. Defined.
