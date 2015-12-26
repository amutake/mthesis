Definition factorial_cont_behv (val : nat) (cust : name) :=
  receive (fun msg =>
    match msg with
    | nat_msg arg =>
      cust ! nat_msg (val * arg);
      become empty_behv
    | _ => become empty_behv
    end).

CoFixpoint factorial_behv :=
  receive (fun msg =>
    match msg with
    | tuple_msg (nat_msg 0) (name_msg cust) =>
      cust ! nat_msg 1;
      become factorial_behv
    | tuple_msg (nat_msg (S n)) (name_msg cust) =>
      cont <- new (factorial_cont_behv (S n) cust);
      me <- self;
      me ! tuple_msg (nat_msg n) (name_msg cont);
      become factorial_behv
    | _ => become factorial_behv
    end).

Definition factorial_system (n : nat) (cust : name) :=
  init "factorial" (
         x <- new factorial_behv;
         x ! tuple_msg (nat_msg n) (name_msg cust);
         become empty_behv
       )
