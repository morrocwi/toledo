(* ===================================================================== *)
(*  Scratch_ShipOfTheseus_RD4.v  (SCRATCH — not committed to any manifest) *)
(*                                                                        *)
(*  Purpose: attempt a minimal, machine-checked statement of the content  *)
(*  that readout_universe/philosophy.md §5.1 and paradoxes.md §3 invoke   *)
(*  under the name "RD4, the retention axiom (distinct histories never    *)
(*  merge)" when reframing Ship of Theseus.                               *)
(*                                                                        *)
(*  WHERE RD4 (retention sense) ACTUALLY LIVES, FORMALLY:                 *)
(*  readout_universe/v2/INFORMATION_DNA.md and readout_universe/logic.md  *)
(*  §"RD1-RD9" both state RD4 as: "sigma x = sigma y => x = y (retention  *)
(*  = injectivity: distinct histories stay distinct)" and give its        *)
(*  formal source as `evidence/RD.v` (this repo's formal/RD.v).           *)
(*  formal/RD.v itself proves exactly this, as `RD4_succ_inj`:            *)
(*      Theorem RD4_succ_inj : forall x y : D, succ x = succ y -> x = y.  *)
(*  i.e. Peano successor injectivity, `D` being the RD1/RD2/RD5-generated  *)
(*  unary-history type (zero / succ chain).                               *)
(*                                                                        *)
(*  IMPORTANT CORRECTION to an initial framing of this task: the prompt   *)
(*  that spawned this file warned RD.v's RD4 ("succ injective") might be  *)
(*  a DIFFERENT, unrelated RD4 from the retention-axiom RD4 that          *)
(*  philosophy.md/paradoxes.md cite. Checking the corpus's own            *)
(*  cross-reference tables (logic.md's "RD1-RD9" table and                *)
(*  v2/INFORMATION_DNA.md's axiom table) shows this is FALSE: both        *)
(*  documents name RD.v (their own "evidence/RD.v") as the formal source  *)
(*  for RD4 and gloss it, verbatim, as "distinct histories stay distinct" *)
(*  / "retention = injectivity". So RD.v's RD4_succ_inj IS the (only)     *)
(*  existing formalization of the retention-sense RD4 — there is no       *)
(*  separate Coq file anywhere in this repo (checked: no hit for          *)
(*  "distinct histor*" in any .v file, only in .md prose) that states the *)
(*  retention axiom independently of RD.v's Peano development.            *)
(*                                                                        *)
(*  WHAT THIS FILE ADDS: RD4_succ_inj as stated is the INJECTIVITY        *)
(*  direction (succ x = succ y -> x = y). The Ship-of-Theseus-relevant    *)
(*  content in paradoxes.md ("two retained states reached by provably     *)
(*  distinct histories are NOT identified as the same state") is its      *)
(*  CONTRAPOSITIVE: distinct predecessor-histories x <> y never collapse  *)
(*  under one more retention step, i.e. succ x <> succ y. That specific   *)
(*  contrapositive statement does not appear as a named theorem in RD.v   *)
(*  itself, so it is derived here, directly from RD4_succ_inj, with no    *)
(*  new axioms.                                                          *)
(* ===================================================================== *)

Require Import RD.

(* "Two retained states reached by provably distinct histories are not    *)
(*  identified as the same state": read `x` and `y` as two distinct        *)
(*  retained histories (D-values built by RD1/RD2/RD5's zero/succ chain), *)
(*  and `succ x`, `succ y` as the states reached by extending each with   *)
(*  one more retained step (e.g. "one more plank replaced/kept"). RD4     *)
(*  (retention = injectivity) forbids these two extended states from      *)
(*  being merged/identified whenever the histories they extend already    *)
(*  differed.                                                            *)
Theorem distinct_histories_never_merge :
  forall x y : D, x <> y -> succ x <> succ y.
Proof.
  intros x y Hxy Heq.
  apply Hxy.
  apply RD4_succ_inj.
  exact Heq.
Qed.

(* Axiom-freedom check (this repo's own convention: `Print Assumptions`   *)
(* after every new theorem, per formal/AXIOM_STATUS.md's audit style).    *)
Print Assumptions distinct_histories_never_merge.
