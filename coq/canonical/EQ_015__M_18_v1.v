(* EQ-015/M.18.v1 -- NEW DERIVATION / PROPOSAL -- not yet in Toledo -- Life-Concept Graph: a labeled directed graph G=(V,E,l) *)
(* source: "Human Learning as Epistemic Architecture", Zenodo 10.5281/zenodo.22341297 *)
(* candidate report: Toledo lookup found no general multi-relation concept
   graph over a finite relation vocabulary anywhere in registry/CANONICAL.json
   (closest structural relative: A.5/E.03.v1's provenance PATH record, a
   single labeled chain, not a general graph). This file states the FORM of
   the candidate object only -- a finite labeled directed graph over abstract
   vertex/relation types -- as a Section + Record, per the A_5__E_03_v1.v /
   EQ_015__M_11_v1.v house pattern. The only theorem proved is a soundness
   fact about the one constructive operation the definition supports
   (closing a graph's vertex list under its own edge endpoints); no further
   property of the source's "life-concept graph" notion is claimed. *)

Require Import List.
Import ListNotations.
Set Implicit Arguments.

Section EQ_015_M_18_v1_sec.

  (* V : the vertex type -- life-concepts/events named by the learner. *)
  (* Rel : the finite relation vocabulary the paper's "l" labels edges with
     (e.g. causes/precedes/exemplifies/contradicts); left abstract because
     the source paper does not fix a closed enumeration. *)
  Variables V Rel : Type.

  (* A life-concept graph: a finite vertex list, a finite edge list over
     ordered vertex pairs, and a labeling of each edge by the relation
     vocabulary -- the direct Coq shape of G = (V, E, l). *)
  Record EQ_015_M_18_v1_LifeConceptGraph : Type := EQ_015_M_18_v1_mkGraph
    { hlea_m01_vertices : list V
    ; hlea_m01_edges     : list (V * V)
    ; hlea_m01_label     : (V * V) -> Rel
    }.

  (* Well-formedness: every edge endpoint is a declared vertex -- the one
     structural condition the source's own "G=(V,E,l)" notation already
     presupposes (an edge relates two vertices OF the graph). *)
  Definition EQ_015_M_18_v1_well_formed (G : EQ_015_M_18_v1_LifeConceptGraph) : Prop :=
    forall v1 v2 : V,
      In (v1, v2) (hlea_m01_edges G) ->
      In v1 (hlea_m01_vertices G) /\ In v2 (hlea_m01_vertices G).

  (* The endpoints occurring in an edge list, as a (possibly repeating)
     vertex list -- the one constructive closure operation the record
     admits without any further modelling choice. *)
  Fixpoint EQ_015_M_18_v1_endpoints (E : list (V * V)) : list V :=
    match E with
    | nil => nil
    | (v1, v2) :: rest => v1 :: v2 :: EQ_015_M_18_v1_endpoints rest
    end.

  Lemma EQ_015_M_18_v1_endpoints_in :
    forall (E : list (V * V)) (v1 v2 : V),
      In (v1, v2) E ->
      In v1 (EQ_015_M_18_v1_endpoints E) /\ In v2 (EQ_015_M_18_v1_endpoints E).
  Proof.
    induction E as [| [w1 w2] rest IH]; intros v1 v2 Hin.
    - simpl in Hin. contradiction.
    - simpl in Hin. destruct Hin as [Heq | Hin'].
      + inversion Heq; subst. simpl. split.
        * left; reflexivity.
        * right; left; reflexivity.
      + destruct (IH v1 v2 Hin') as [H1 H2]. simpl. split.
        * right; right; exact H1.
        * right; right; exact H2.
  Qed.

  (* Closing a raw edge list into a well-formed graph by taking its own
     endpoint list as the vertex list. *)
  Definition EQ_015_M_18_v1_close
      (E : list (V * V)) (l : (V * V) -> Rel) : EQ_015_M_18_v1_LifeConceptGraph :=
    EQ_015_M_18_v1_mkGraph (EQ_015_M_18_v1_endpoints E) E l.

  Theorem EQ_015_M_18_v1_close_well_formed :
    forall (E : list (V * V)) (l : (V * V) -> Rel),
      EQ_015_M_18_v1_well_formed (EQ_015_M_18_v1_close E l).
  Proof.
    intros E l v1 v2 Hin.
    unfold EQ_015_M_18_v1_close, EQ_015_M_18_v1_well_formed in *.
    simpl in Hin |- *.
    apply EQ_015_M_18_v1_endpoints_in; exact Hin.
  Qed.

End EQ_015_M_18_v1_sec.

Print Assumptions EQ_015_M_18_v1_close_well_formed.
