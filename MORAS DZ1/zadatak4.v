Set Implicit Arguments.
Require Import List.
Import ListNotations.
Require Import Omega.

(* Bit *)

Inductive B : Type :=
  | O : B
  | I : B.

Definition And (x y : B) : B :=
  match x with
    | O => O
    | I => y
  end.

Definition Or (x y : B) : B :=
  match x with
    | O => y
    | I => I
  end.

Definition Not (x : B) : B :=
  match x with
    | O => I
    | I => O
  end.

Definition Add (x y c : B) : B :=
  match x, y with
    | O, O => c
    | I, I => c
    | _, _ => Not c
  end.

Definition Rem (x y c : B) : B :=
  match x, y with
    | O, O => O
    | I, I => I
    | _, _ => c
  end.

(* List *)

Fixpoint AndL (x y : list B) : list B :=
  match x, y with
    | [], _ => []
    | _, [] => []
    | x :: xs, y :: ys => And x y :: AndL xs ys
  end.

Fixpoint OrL (x y : list B) : list B :=
  match x, y with
    | [], _ => []
    | _, [] => []
    | x :: xs, y :: ys => Or x y :: OrL xs ys
  end.

Fixpoint NotL (x : list B) : list B :=
  match x with
    | [] => []
    | x :: xs => Not x :: NotL xs
  end.

Fixpoint AddLr (x y : list B) (c : B) : list B :=
  match x, y with
    | [], _ => []
    | _, [] => []
    | x :: xs, y :: ys => Add x y c :: AddLr xs ys (Rem x y c)
  end.

Definition AddL (x y : list B) : list B := rev (AddLr (rev x) (rev y) O).

Fixpoint IncLr (x : list B) (c : B) : list B :=
  match x with
    | [] => []
    | x :: xs => Add x I c :: IncLr xs (Rem x I c)
  end.

Definition IncL (x : list B) : list B := rev (IncLr (rev x) O).

(* ALU *)

Definition flag_z (f : B) (x : list B) : list B :=
  match f with
    | I => repeat O (length x)
    | O => x
  end.

Definition flag_n (f : B) (x : list B) : list B :=
  match f with
    | I => NotL x
    | O => x
  end.

Definition flag_f (f : B) (x y : list B) : list B :=
  match f with
    | I => AddL x y
    | O => AndL x y
  end.

Definition ALU (x y : list B) (zx nx zy ny f no : B) : list B :=
  flag_n no (flag_f f (flag_n nx (flag_z zx x)) (flag_n ny (flag_z zy y))).

(* Teoremi *)

Lemma ALU_zero (x y : list B) :
  length x = length y -> ALU x y I O I O I O = repeat O (length x).
Proof.
  assert (P : forall (n : nat), AddL (repeat O n) (repeat O n) = repeat O n).
  {
    assert (P_rev_1 : forall (b : B) (n : nat), repeat b n ++ [b] = b :: repeat b n).
  {
    intros. induction n.
      - reflexivity.
      - simpl. rewrite IHn. reflexivity.
   }
   assert (P_rev_2 : forall (b : B) (n : nat), rev (repeat b n) = repeat b n).
   {
   intros. induction n.
   - reflexivity.
   - simpl. rewrite IHn. rewrite P_rev_1. reflexivity.
   }
   intros. unfold AddL.
   rewrite P_rev_2. 
   induction n.
   - reflexivity.
   - simpl. rewrite IHn. rewrite P_rev_1. reflexivity.
   }
   intros H. simpl. rewrite H. rewrite P. reflexivity.
Qed.

Lemma ALU_minus_one (x y : list B) : 
  length x = length y -> ALU x y I I I O I O = repeat I (length x).
Proof.
  intros H. simpl. rewrite H.

  assert (H_NotL : forall (n : nat), NotL (repeat O n) = repeat I n).
  {
    induction n.
    - simpl. reflexivity.
    - simpl. rewrite IHn. reflexivity.
  }

  rewrite H_NotL. unfold AddL.

  assert (H_RevL_1 : forall (b : B) (n : nat), repeat b n ++ [b] = b :: repeat b n).
  {
    intros. induction n.
    - simpl. reflexivity.
    - simpl. rewrite IHn. reflexivity.
  }

  assert (H_RevL_2 : forall (b : B) (n : nat), rev (repeat b n) = repeat b n).
  {
    intros. induction n.
    - simpl. reflexivity.
    - simpl. rewrite IHn. rewrite H_RevL_1. reflexivity.
  }

  rewrite ! H_RevL_2.

  assert (H_AddLr : forall (n : nat), AddLr (repeat I n) (repeat O n) O = repeat I n).
  {
    induction n.
    - simpl. reflexivity.
    - simpl. rewrite IHn. reflexivity.
  }

  rewrite H_AddLr. rewrite H_RevL_2. reflexivity.
Qed.

Lemma ALU_x (x y : list B) :
  length x = length y -> ALU x y O O I I O O = x.
Proof. Abort.

Lemma ALU_y (x y : list B) :
  length x = length y -> ALU x y I I O O O O = y.
Proof. Abort.

Lemma ALU_Not_x (x y : list B) :
  length x = length y -> ALU x y O O I I O I = NotL x.
Proof. Abort.

Lemma ALU_Not_y (x y : list B) :
  length x = length y -> ALU x y I I O O O I = NotL y.
Proof.
  simpl. intros H. rewrite H.

  assert (H_NotL : forall (n : nat), NotL (repeat O n) = repeat I n).
  {
    induction n.
    - simpl. reflexivity.
    - simpl. rewrite IHn. reflexivity.
  }

  rewrite H_NotL.

  assert (H_AndL : forall (l : list B), AndL (repeat I (length l)) l = l).
  {
    induction l.
    - simpl. reflexivity.
    - simpl. rewrite IHl. reflexivity.
  }

  rewrite H_AndL. reflexivity.
Qed.

Lemma ALU_Add (x y : list B) :
  length x = length y -> ALU x y O O O O I O = AddL x y.
Proof. Abort.

(* DZ *)

Lemma ALU_And (x y : list B) :
  length x = length y -> ALU x y O O O O O O = AndL x y.
Proof. 
  intros. now simpl. 
Qed.

Lemma ALU_Or (x y : list B) :
  length x = length y -> ALU x y O I O I O I = OrL x y.
Proof.
  simpl. revert x y. induction x, y; try now simpl.
  - simpl. intros. destruct a, b.
    -- simpl. f_equal. rewrite <- IHx. reflexivity. now inversion H. 
    -- simpl. f_equal. rewrite <- IHx. reflexivity. now inversion H.
    -- simpl. f_equal. rewrite <- IHx. reflexivity. now inversion H.
    -- simpl. f_equal. rewrite <- IHx. reflexivity. now inversion H. 
Qed.


Lemma ALU_one (n : nat) (x y : list B) :
  length x = n /\ length y = n /\ n <> 0 -> ALU x y I I I I I I = repeat O (pred n) ++ [I].
Proof. 
  intros. destruct H. destruct H0. simpl.
  assert (H_NotL : forall (n : nat), NotL (repeat O n) = repeat I n).
  {
    induction n0.
    - simpl. reflexivity.
    - simpl. rewrite IHn0. reflexivity.
  }
  rewrite ! H_NotL.
  unfold AddL.
  assert (H_RevL_1 : forall (b : B) (n : nat), repeat b n ++ [b] = b :: repeat b n).
  {
    intros. induction n0.
    - simpl. reflexivity.
    - simpl. rewrite IHn0. reflexivity.
  }
  assert (H_RevL_2 : forall (b : B) (n : nat), rev (repeat b n) = repeat b n).
  {
    intros. induction n0.
    - simpl. reflexivity.
    - simpl. rewrite IHn0. rewrite H_RevL_1. reflexivity.
  }
  rewrite ! H_RevL_2. 
  assert (H_AddLr : AddLr (repeat I n) (repeat I n) O = O :: repeat I (pred n)).
  {
    induction n.
    - intros. now destruct H1.
    - simpl. 
  assert (H1_AddLr : forall (n : nat), AddLr (repeat I n) (repeat I n) I = repeat I n).
  {
     intros. induction n0.
    - now simpl.
    - simpl. now rewrite IHn0. 
  }
   f_equal. now rewrite H1_AddLr.
  }
  rewrite H, H0. 
  assert (help : forall (n : nat), NotL (repeat I n ++ [O]) = repeat O n ++ [I]).
  {
    induction n0.
    - now simpl.
    - simpl. f_equal. exact IHn0.  
  }
  rewrite H_AddLr.
  assert (revBanalan : forall (n: nat), rev (O :: repeat I (pred n)) = repeat I (pred n) ++ [O]).
  {
    induction n0.
    - now simpl.
    - simpl. f_equal. apply H_RevL_2.
  }
  rewrite revBanalan. now rewrite help.
Qed.






