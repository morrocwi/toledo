(* ===================================================================== *)
(*  PROP_EPSC_03_fail_closed_gate.v                                      *)
(*  Toledo PROP-EPSC-03, Fail-closed discrete epsilon-completion          *)
(*  acceptance gate, registered in                                       *)
(*  registry/proposals/discrete_epsilon_completion.json                  *)
(*                                                                        *)
(*  Registered claim (structural half only -- see below): ACCEPT_eps(K)  *)
(*  fires only when delta_K + beta_K <= eps for a PROVED beta_K; if no    *)
(*  proved beta_K is available, the gate returns HOLD rather than         *)
(*  silently treating the state as continuum-complete.                    *)
(*                                                                        *)
(*  This file mechanizes exactly the STRUCTURAL/logical half of the      *)
(*  claim: the gate's decision procedure is defined so that it is        *)
(*  IMPOSSIBLE for it to return ACCEPT without an actual proof witness    *)
(*  of a certified beta_K bound -- i.e. the fail-closed property is a     *)
(*  theorem about the gate's own type, not a runtime check that could be *)
(*  silently bypassed. This is done by making the gate a function of an  *)
(*  optional CERTIFICATE (option {beta : Q | delta_K + beta <= eps}):    *)
(*  when the certificate is None, the gate is DEFINED to return HOLD;    *)
(*  it can only return ACCEPT by pattern-matching on Some cert, and in    *)
(*  that branch cert itself carries the proof of delta_K+beta<=eps.       *)
(*                                                                        *)
(*  This file does NOT prove that beta_K actually goes to zero, nor       *)
(*  that any real omitted-information tail admits a provable beta_K --   *)
(*  both are the analytic content of the surrounding EPSC programme       *)
(*  (PROP-EPSC-04 and successors), explicitly out of scope here, exactly *)
(*  as the source's own claim_boundary states.                            *)
(*                                                                        *)
(*  Rational-native (Q), no Coq.Reals.                                    *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.

Section FailClosedGate.

  Variable delta_K eps : Q.

  Inductive Verdict := ACCEPT (beta_K : Q) | HOLD.

  (* The certificate a caller must supply to obtain ACCEPT: a rational   *)
  (* bound beta together with a PROOF that delta_K + beta <= eps.        *)
  Definition Certificate := { beta : Q | delta_K + beta <= eps }.

  Definition gate (cert : option Certificate) : Verdict :=
    match cert with
    | Some (exist _ beta _) => ACCEPT beta
    | None => HOLD
    end.

  (* The fail-closed property, as a theorem about the type of `gate`     *)
  (* rather than a side condition that could be forgotten: whenever the  *)
  (* gate returns ACCEPT beta, the bound delta_K + beta <= eps is        *)
  (* PROVABLY true -- there is no code path to ACCEPT without it. *)
  Theorem epsc03_fail_closed :
    forall cert beta,
      gate cert = ACCEPT beta -> delta_K + beta <= eps.
  Proof.
    intros cert beta H.
    unfold gate in H.
    destruct cert as [[b Hb] | ].
    - injection H as ->. exact Hb.
    - discriminate H.
  Qed.

  (* The other half of fail-closed: no certificate means HOLD, never a   *)
  (* silent accept. *)
  Theorem epsc03_no_certificate_holds :
    gate None = HOLD.
  Proof. reflexivity. Qed.

End FailClosedGate.
