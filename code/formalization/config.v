Inductive name : Set :=
| toplevel : string -> name
| generated : nat -> name -> name.

Inductive message : Set :=
| empty_msg : message
| name_msg : name -> message
| str_msg : string -> message
| nat_msg : nat -> message
| bool_msg : bool -> message
| tuple_msg : message -> message -> message.

Inductive actions (state : Set) : Type :=
| new : forall child_state : Set,
    (child_state -> behavior child_state) ->
    child_state -> (name -> actions state) -> actions state
| send : name -> message -> actions state -> actions state
| self : (name -> actions state) -> actions state
| become : state -> actions state
with behavior (state : Set) : Type :=
| receive : (message -> actions state) -> behavior state.

Definition behavior_template (state : Set) :=
  state -> behavior state.

Record actor := {
  state_type : Set;
  actor_name : name;
  remaining_actions : actions state_type;
  next_num : nat;
  behv : behavior_template state_type;
  queue : seq message
}.

Definition config := seq actor.

Inductive label :=
| Receive (to : name) (msg : message)
| Send (from : name) (to : name) (content : message)
| New (child : name)
| Self (me : name).
