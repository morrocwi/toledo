(* EQ-015/M.20.v1 -- Definition -- Cross-domain keyword fusion: a         *)
(* bridge-conditioned operator that produces a genuinely new concept,     *)
(* not a restatement of either input -- parents: EQ-015 (reads),          *)
(* EQ-015/M.18.v1 (reads, Life-Concept Graph supplies V/E/l),             *)
(* weld/M.02.v1 (reads, domain-admissibility guard reused directly),      *)
(* EQ-002/M.03.v1 (reads, root readout gate defines D(v))                 *)
(*                                                                        *)
(* Founder-directed session synthesis, 2026-09-19: 'fusion', not          *)
(* 'crystallization' -- two keywords across DIFFERENT, socially-defined   *)
(* domains collide across an admissible bridge and produce a concept      *)
(* v_new outside the original vertex set. E(v_new) is the number of       *)
(* previously-disconnected domain-pairs that become reachable because     *)
(* of v_new -- a plain non-negative integer count (an information-        *)
(* discrete readout), never a continuum quantity. delta_min/delta_max     *)
(* are left as abstract, uninstantiated Variables: they are NOT yet       *)
(* empirically calibrated (see this entry's drift_note for the            *)
(* calibration protocol) -- this file formalizes the FORM of the guard    *)
(* only, and deliberately proves no theorem: 'fusion_fires' is a plain    *)
(* conjunction with no further provable structure, the same discipline    *)
(* already applied at EQ-015/H.55.v1 (no hollow theorem manufactured). *)

Section EQ_015_M_20_v1.
  Variable Concept : Type.
  Variable Domain : Type.

  (* D(v): the domain of a keyword is SOCIETY's own readout under         *)
  (* society's own existing classification -- an external given, not a   *)
  (* value this construct invents (reuses EQ-002/M.03.v1's root readout   *)
  (* gate Readout_{Q,O,c}(S)=z: Q=society, O=the classification already   *)
  (* in use, c=context). *)
  Variable D : Concept -> Domain.
  Variable domain_eq_dec : forall d1 d2 : Domain, {d1 = d2} + {d1 <> d2}.

  (* E_bridge: an admissible cross-domain edge, per weld/M.02.v1's own    *)
  (* domain-admissibility condition -- reused abstractly here (that       *)
  (* condition is proved/stated in its own file, not re-derived). *)
  Variable E_bridge : Concept -> Concept -> Prop.

  (* delta: hop-distance on the EQ-015/M.18.v1 Life-Concept Graph -- a    *)
  (* discrete, integer readout (never a continuum estimate). *)
  Variable delta : Concept -> Concept -> nat.
  Variable delta_min delta_max : nat.

  (* The fusion-firing guard: cross-domain, admissibly bridged, and       *)
  (* within the (not-yet-calibrated) fusable distance band. *)
  Definition EQ_015_M_20_v1_fusion_fires (v v' : Concept) : Prop :=
    D v <> D v'
    /\ E_bridge v v'
    /\ delta_min <= delta v v'
    /\ delta v v' <= delta_max.

  (* A domain-pair, used to count E(v_new)'s newly-bridged-pairs. *)
  Definition EQ_015_M_20_v1_domain_pair : Type := Domain * Domain.

  (* E(v_new): a domain-pair counts as newly bridged by v_new when v_new  *)
  (* connects two concepts a, b whose domains were unreachable from each  *)
  (* other before v_new existed. 'reachable_via'/'reachable_before' are   *)
  (* left abstract (graph-reachability predicates over the ambient        *)
  (* EQ-015/M.18.v1 graph) -- this file states only the counting FORM. *)
  Variable reachable_via reachable_before : Concept -> Concept -> Concept -> Prop.

  Definition EQ_015_M_20_v1_newly_bridged (v_new a b : Concept) : Prop :=
    reachable_via v_new a b /\ ~ reachable_before v_new a b.

End EQ_015_M_20_v1.
