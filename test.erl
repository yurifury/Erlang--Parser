%-module(test).
%-export([test/0]).

test() ->
    %io:format("This is a ~p~n.", ["test"]),
    9/2/5,
    9/(2/5),
    42.

