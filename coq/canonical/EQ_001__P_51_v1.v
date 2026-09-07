(* EQ-001/P.51.v1 -- Toledo v1.1 lane B2 -- Th_coqc *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* discrete connection U_{j<-i} = V_j^-1 V_i (as an abstract group action);
   transport defect o_{i->j} = phi_j - U phi_i. Kept fully abstract
   (a group's mult/inv/action), no concrete matrix convention asserted. *)
Record EQ001_P51_Group := mkEQ001P51Group {
  p51_G : Type;
  p51_mult : p51_G -> p51_G -> p51_G;
  p51_inv : p51_G -> p51_G;
  p51_V : Type;
  p51_act : p51_G -> p51_V -> p51_V;
}.

Definition EQ001_P51_connection (Gr : EQ001_P51_Group) (Vj Vi : p51_G Gr) : p51_G Gr :=
  p51_mult Gr (p51_inv Gr Vj) Vi.

Definition EQ001_P51_defect (Gr : EQ001_P51_Group) (phi_j phi_i : p51_V Gr)
  (U : p51_G Gr) (sub : p51_V Gr -> p51_V Gr -> p51_V Gr) : p51_V Gr :=
  sub phi_j (p51_act Gr U phi_i).
