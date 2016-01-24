Definition calc_trans (c : config) (l : label) : config :=
  match l with
  | Receive to msg =>
    map (fun a => match a with
      | {| state_type := st;
           actor_name := nm;
           remaining_actions := become s;
           next_num := nx;
           behv := b;
           queue := hd :: tl
        |} => if (nm == to) && (hd == msg) then (* ok because of no dup *)
                {| state_type := st;
                   actor_name := nm;
                   remaining_actions := interp (b s) hd;
                   next_num := nx;
                   behv := b;
                   queue := tl
                |}
              else
                a
      | _ => a
      end
        ) c
  | Send fr to msg =>
    map (fun a => match a with
      | {| state_type := st;
           actor_name := nm;
           remaining_actions := send t m cont;
           next_num := nx;
           behv := b;
           queue := q
        |} => if (nm == fr) && (m == msg) then (* ok because of no dup *)
                {| state_type := st;
                   actor_name := nm;
                   remaining_actions := cont;
                   next_num := nx;
                   behv := b;
                   queue := if (nm == to) then q ++ [:: msg] else q
                |}
              else a
      | {| state_type := st;
           actor_name := nm;
           remaining_actions := acts;
           next_num := nx;
           behv := b;
           queue := q
        |} => if (nm == to) then (* ok because of no dup *)
                {| state_type := st;
                   actor_name := nm;
                   remaining_actions := acts;
                   next_num := nx;
                   behv := b;
                   queue := q ++ [:: msg]
                |}
              else a
      end
        ) c
  | New (generated g p) =>
    flatten (map (fun a => match a with
      | {| state_type := st;
           actor_name := nm;
           remaining_actions := new child_st tmpl ini cont;
           next_num := nx;
           behv := b;
           queue := q
        |} => if (nm == p) && (nx == g) then (* ok because of no dup *)
                [:: {| state_type := st;
                       actor_name := nm;
                       remaining_actions := cont (generated nx nm);
                       next_num := S nx;
                       behv := b;
                       queue := q
                    |};
                  {| state_type := child_st;
                     actor_name := generated nx nm;
                     remaining_actions := become ini;
                     next_num := 0;
                     behv := tmpl;
                     queue := [::]
                  |}]
              else [:: a]
      | _ => [:: a]
      end) c)
  | Self me =>
    map (fun a => match a with
      | {| state_type := st;
           actor_name := nm;
           remaining_actions := self cont;
           next_num := nx;
           behv := b;
           queue := q
        |} => if (nm == me) then (* ok because of no dup *)
                {| state_type := st;
                   actor_name := nm;
                   remaining_actions := cont nm;
                   next_num := nx;
                   behv := b;
                   queue := q
                |}
              else a
      | _ => a
      end) c
  | _ => c
  end.
