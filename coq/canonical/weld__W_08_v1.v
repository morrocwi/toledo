(* weld/W.08.v1 -- not_yet_formalised -> definition -- Validated output value and its non-proportionality to candidate-set size *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Y_{K,t} = \sum_{c\in\mathcal P_t} v(c)\,\mathbf 1[G(c)=1] \\ |\mathcal C_t^{new}|\uparrow \not\Rightarrow Y_{K,t}\uparrow \text{ proportionally} *)
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

Section weld__W_08_v1_sec.
  Parameter Candidate : Type.
  Parameter v : Candidate -> Q.
  Parameter G : Candidate -> nat.
  Parameter P_t : nat -> list Candidate.
  Definition weld__W_08_v1_def_indicator (c : Candidate) : Q := if Nat.eqb (G c) 1 then 1%Q else 0%Q.
  Definition weld__W_08_v1_def (t : nat) : Q :=
    fold_right (fun c acc => (v c * weld__W_08_v1_def_indicator c + acc)%Q) 0%Q (P_t t).
  (* The source's further remark, "|C^new_t| uparrow does not imply
     Y_{K,t} uparrow proportionally", is a qualitative non-collapse note
     about this function, not a further equation with its own operator;
     recorded here as this comment, not separately formalised. *)
End weld__W_08_v1_sec.
