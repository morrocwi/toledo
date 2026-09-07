(* q_formal/M.15.v1 — wrapped_related — wraps formal/RDL_MetricReadout.v, formal/RDL_SpineStability.v, formal/RDL_StarRig.v (29 identifiers) — parents: q_formal *)
(* name: Green's identity *)
(* tier: untagged (<no tier tag in registry 'use' text> -- use_text: mechanized discrete analogue) *)
(* statement (Toledo canonical, latest): Green's identity *)
(* Gap (readout-not-truth, v1.1 lane wrap): registry/coq_map.json's own
   evidence for this q_formal reading cites the full theorem set of
   solver-arc's finite-model metric/spine/algebra toolkit (n-D discrete
   metric-readout invariance, the quantum/classical spine-discriminant split,
   and the star-rig Kraus-completeness relation) as the general discrete
   apparatus this reading is claimed to draw on. None of these 29 lemmas is a
   literal Coq restatement of this entry's own statement above -- no closure
   of the statement as written is claimed here. What is genuinely proved and
   imported below is each cited lemma itself, Closed under the global
   context, 0 axioms, per solver-arc's own verify_report.json (quoted, not
   asserted). *)

From RDL.formal Require Import RDL_MetricReadout.
From RDL.formal Require Import RDL_SpineStability.
From RDL.formal Require Import RDL_StarRig.

Definition q_formal__M_15_v1_reads_Sum_ext := Sum_ext.
Definition q_formal__M_15_v1_reads_Sum_plus := Sum_plus.
Definition q_formal__M_15_v1_reads_Sum_scal_l := Sum_scal_l.
Definition q_formal__M_15_v1_reads_row_add := row_add.
Definition q_formal__M_15_v1_reads_row_scale := row_scale.
Definition q_formal__M_15_v1_reads_bil_add_l := bil_add_l.
Definition q_formal__M_15_v1_reads_bil_scale_l := bil_scale_l.
Definition q_formal__M_15_v1_reads_bil_add_r := bil_add_r.
Definition q_formal__M_15_v1_reads_bil_scale_r := bil_scale_r.
Definition q_formal__M_15_v1_reads_lin_shift := lin_shift.
Definition q_formal__M_15_v1_reads_qform_shift := qform_shift.
Definition q_formal__M_15_v1_reads_qform_shift_pair := qform_shift_pair.
Definition q_formal__M_15_v1_reads_metric_form_readout := metric_form_readout.
Definition q_formal__M_15_v1_reads_metric_readout_invariant := metric_readout_invariant.
Definition q_formal__M_15_v1_reads_metric_readout_location_invariant := metric_readout_location_invariant.
Definition q_formal__M_15_v1_reads_metric_form_is_quadratic := metric_form_is_quadratic.
Definition q_formal__M_15_v1_reads_SumL_perm := SumL_perm.
Definition q_formal__M_15_v1_reads_metric_readout_graph_gauge := metric_readout_graph_gauge.
Definition q_formal__M_15_v1_reads_four_MK_pos := four_MK_pos.
Definition q_formal__M_15_v1_reads_split_classical := split_classical.
Definition q_formal__M_15_v1_reads_split_quantum := split_quantum.
Definition q_formal__M_15_v1_reads_split_boundary := split_boundary.
Definition q_formal__M_15_v1_reads_energy_rate := energy_rate.
Definition q_formal__M_15_v1_reads_energy_nonincreasing := energy_nonincreasing.
Definition q_formal__M_15_v1_reads_energy_strict_decay := energy_strict_decay.
Definition q_formal__M_15_v1_reads_adj_is_involution := adj_is_involution.
Definition q_formal__M_15_v1_reads_sum_mul_lr := sum_mul_lr.
Definition q_formal__M_15_v1_reads_term_eq := term_eq.
Definition q_formal__M_15_v1_reads_kraus_completeness := kraus_completeness.
