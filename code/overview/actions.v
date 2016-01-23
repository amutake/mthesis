Inductive actions (state : Set) : Type :=
| new : forall child_state : Set,
    (child_state -> behavior child_state) ->
    child_state ->
    (name -> actions state) ->
    actions state
| send : name -> message -> actions state -> actions state
| self : (name -> actions state) -> actions state
| become : state -> actions state.
