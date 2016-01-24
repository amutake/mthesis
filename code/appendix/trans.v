Reserved Notation "c1 '~(' t ')~>' c2" (at level 60).
Inductive trans : label -> config -> config -> Prop :=
(* receive transition *)
| trans_receive :
    forall to msg
           st next_state f gen msgs
           rest actors actors',
      Permutation actors (
                    {|
                      state_type := st;
                      actor_name := to;
                      remaining_actions := become next_state;
                      next_num := gen;
                      behv := f;
                      queue := (msg :: msgs)
                    |} :: rest) ->
      Permutation actors' (
                    {|
                      actor_name := to;
                      remaining_actions := interp (f next_state) msg;
                      next_num := gen;
                      behv := f;
                      queue := msgs
                    |} :: rest) ->
      actors ~(Receive to msg)~> actors'
(* send transition *)
| trans_send :
    forall from to msg
           from_st from_cont from_gen from_msgs from_f
           to_st to_actions to_gen to_msgs to_f
           rest actors actors',
      Permutation actors (
                    {|
                      state_type := from_st;
                      actor_name := from;
                      remaining_actions := send to msg from_cont;
                      next_num := from_gen;
                      behv := from_f;
                      queue := from_msgs
                    |} :: {|
                      state_type := to_st;
                      actor_name := to;
                      remaining_actions := to_actions;
                      next_num := to_gen;
                      behv := to_f;
                      queue := to_msgs
                       |} :: rest) ->
      Permutation actors' (
                    {|
                      state_type := from_st;
                      actor_name := from;
                      remaining_actions := from_cont;
                      next_num := from_gen;
                      behv := from_f;
                      queue := from_msgs
                    |} :: {|
                         state_type := to_st;
                         actor_name := to;
                         remaining_actions := to_actions;
                         next_num := to_gen;
                         behv := to_f;
                         queue := to_msgs ++ [:: msg]
                       |} :: rest) ->
      actors ~(Send from to msg)~> actors'
(* new transition *)
| trans_new :
    forall parent_st parent parent_behv parent_cont gen parent_msgs
           child_st child_behv child_ini
           rest actors actors',
      Permutation actors (
                    {|
                      state_type := parent_st;
                      actor_name := parent;
                      remaining_actions := new child_behv child_ini parent_cont;
                      next_num := gen;
                      behv := parent_behv;
                      queue := parent_msgs
                    |} :: rest) ->
      Permutation actors' (
                    {|
                      state_type := child_st;
                      actor_name := generated gen parent;
                      remaining_actions := become child_ini;
                      next_num := 0;
                      behv := child_behv;
                      queue := [::]
                    |} ::
                    {|
                      state_type := parent_st;
                      actor_name := parent;
                      remaining_actions := parent_cont (generated gen parent);
                      next_num := S gen;
                      behv := parent_behv;
                      queue := parent_msgs
                    |} :: rest) ->
      actors ~(New (generated gen parent))~> actors'
(* self transition *)
| trans_self :
    forall st me cont gen f msgs
           rest actors actors',
      Permutation actors (
                    {|
                      state_type := st;
                      actor_name := me;
                      remaining_actions := self cont;
                      next_num := gen;
                      behv := f;
                      queue := msgs
                    |} :: rest) ->
      Permutation actors' (
                    {|
                      state_type := st;
                      actor_name := me;
                      remaining_actions := cont me;
                      next_num := gen;
                      behv := f;
                      queue := msgs
                    |} :: rest) ->
      actors ~(Self me)~> actors'
where "c1 '~(' t ')~>' c2" := (trans t c1 c2).

Reserved Notation "c1 '~>*' c2" (at level 70).
Inductive trans_star : config -> config -> Prop :=
| trans_refl : forall c c',
    Permutation c c' ->
    c ~>* c'
| trans_trans : forall c1 c2 c3, (exists label, c1 ~(label)~> c2) -> c2 ~>* c3 -> c1 ~>* c3
where "c1 '~>*' c2" := (trans_star c1 c2).
