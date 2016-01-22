Require Import Actario.syntax Actario.semantics.

Inductive ContState : Set :=
| val_cust : nat -> name -> ContState
| cont_done : ContState.

Definition factorial_cont_behv (state : ContState)
    : behavior ContState :=
  receive (fun msg =>
    match msg, state with
    | nat_msg arg, val_cust val cust =>
      cust ! nat_msg (val * arg);
      become cont_done
    | _, _ => become state
    end).

Definition factorial_behv (state : unit) : behavior unit :=
  receive (fun msg =>
    match msg with
    | tuple_msg (nat_msg 0) (name_msg cust) =>
      cust ! nat_msg 1;
      become tt
    | tuple_msg (nat_msg (S n)) (name_msg cust) =>
      cont <- new factorial_cont_behv with (val_cust (S n) cust);
      me <- self;
      me ! tuple_msg (nat_msg n) (name_msg cont);
      become tt
    | _ => become tt
    end).

Definition initial_actions (n : nat) (parent : name) := (
  x <- new factorial_behv with tt;
  x ! tuple_msg (nat_msg n) (name_msg parent);
  become done).

Definition factorial_system (n : nat) (parent : name) : config :=
  init "factorial" (initial_actions n parent).
