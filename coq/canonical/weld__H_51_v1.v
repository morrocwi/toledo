(* weld/H.51.v1 -- open_prop -- Religious Attribution Non-Collapse (RANC): *)
(* model output, product policy, institutional normative commitment, an *)
(* actor's interior belief, and a person-specific religious classification *)
(* are five distinct objects; none may be silently identified with, or *)
(* taken to entail, another. *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* O \not\equiv P \not\equiv N \not\equiv B_i \not\equiv J_i \text{, and } O \nRightarrow J_i \text{ unless each transition is independently evidenced} *)
(* Toledo v1.8 (RANC merge): finite-model open_prop -- every symbol not *)
(* already fixed by the statement above is a local Section Parameter (its *)
(* type chosen only so the equation type-checks; nothing about what it *)
(* computes is asserted). Unproved by design (source's own "Definition", *)
(* not a proved theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_51_v1_sec.
  Parameter Level : Type.
  Parameter O_out P_pol N_norm B_bel J_cls : Level.
  Definition weld__H_51_v1_hyp : Prop :=
    O_out <> P_pol /\
    P_pol <> N_norm /\
    N_norm <> B_bel /\
    B_bel <> J_cls.
End weld__H_51_v1_sec.
