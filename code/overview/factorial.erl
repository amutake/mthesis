-module(factorial).
-export([plus/2, mult/2, factorial_cont_behv/1, factorial_behv/1]).
-compile({inline, []}).

plus(N, M) -> 
    case N of
        {o} ->
            M;
        {s, P} ->
            {s, plus(P, M)}
    end.

mult(N, M) -> 
    case N of
        {o} ->
            {o};
        {s, P} ->
            plus(M, mult(P, M))
    end.

factorial_cont_behv(State) -> 
    receive
        Msg ->
            case Msg of
                {nat_msg, Arg} ->
                    case State of
                        {val_cust, Val, Cust} ->
                            Cust ! {nat_msg, mult(Val, Arg)},
                            factorial_cont_behv({cont_done});
                        {cont_done} ->
                            factorial_cont_behv(State)
                    end;
                _ ->
                    factorial_cont_behv(State)
            end
    end.

factorial_behv(State) -> 
    receive
        Msg ->
            case Msg of
                {tuple_msg, M, M0} ->
                    case M of
                        {nat_msg, N0} ->
                            case N0 of
                                {o} ->
                                    case M0 of
                                        {name_msg, Cust} ->
                                            Cust ! {nat_msg, {s, {o}}},
                                            factorial_behv({tt});
                                        _ ->
                                            factorial_behv({tt})
                                    end;
                                {s, N} ->
                                    case M0 of
                                        {name_msg, Cust} ->
                                            Cont = spawn(fun() ->
                                                factorial_cont_behv({val_cust, {s, N}, Cust})
                                            end),
                                            Me = self(),
                                            Me ! {tuple_msg, {nat_msg, N}, {name_msg, Cont}},
                                            factorial_behv({tt});
                                        _ ->
                                            factorial_behv({tt})
                                    end
                            end;
                        _ ->
                            factorial_behv({tt})
                    end;
                _ ->
                    factorial_behv({tt})
            end
    end.

