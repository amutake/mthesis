Inductive behavior (state : Set) : Type :=
| receive : (message -> actions state) -> behavior state.
