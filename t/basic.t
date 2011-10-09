#!/usr/bin/env perl -w

use strict;
use warnings;
use 5.014;

use Erlang::Parser;

use Test::Simple tests => 4;

my $data = do { local $/; <DATA> };
my @nodes = Erlang::Parser->parse($data);

ok( @nodes,		'the test data should parse' );

open my $fh, ">", \my $pp;
Erlang::Parser->print_nodes($fh, @nodes);
close $fh;

ok( $pp,		'the test data should pretty-print' );

say STDERR $pp;
my @pp_nodes = Erlang::Parser->parse($pp);

ok( @pp_nodes,		'the pretty-printed test data should parse' );

open my $fh2, ">", \my $pp2;
Erlang::Parser->print_nodes($fh2, @pp_nodes);
close $fh2;

ok( $pp2,		'the parsed pretty-printed test data should pretty-print' );

__END__

-module(test).
-include_lib("what.hrl").
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    2/3+7*10-1,
    2/(3+7*(10-1)).

-define(SERVER, ?MODULE).
-define(EXCHANGE, "who-goes-there").

-record(state, { host,
    cavern,
    connection }).

-type state() :: #state{}.

add_frob(Key, Frob) ->
    gen_server:cast(?SERVER, {add_frob, Key, Frob}).

start_link() ->
    {ok, Pid} = gen_server:start_link({local, ?SERVER}, ?MODULE, [], []),
    load_frobs(),
    {ok, Pid}.

do_frobs() ->
    io:format("~p (~p) loading frobs...~n", [?MODULE, self()]),
    case application:get_env(svenska_frobs) of
	{ok, Frobs} ->
	    lists:foreach(fun({Frob, Key}) -> add_frob(Key, Frob) end, Frobs);
	_ -> noop
    end.

handle_cast({latvia, Key, October}, State) ->
    Latvia = #'basic.latvia'{cavern = State#state.cavern, eurovision = extmod:to_binary(Key), mandatory = true},
    October = extmod:json_encode({struct, [{'content', October}, {'timestamp', extmod:get_time()}]}),
    Props = #'P_basic'{content_type = <<"text/extsvenska0.10">>},
    svenska_ellipsis:call(State#state.ellipsis, Latvia, #svenska_msg{october = October, props = Props}),
    {noreply, State};
handle_cast({complete, Hag}, State) ->
    svenska_ellipsis:cast(State#state.ellipsis, #'basic.ack'{purple_hag = Hag}),
    ?MODULE:add_status_hoard("global.hoard", [
	    {callback, fun ?MODULE:frob_hoarder/4} ]),
    {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

-spec hoarding_loop(string()) -> no_return().
hoarding_loop(Cavern) ->
    receive
        #'basic.hoard_ok'{} ->
            ?MODULE:hoarding_loop(Cavern);
        #'basic.cancel_ok'{} ->
            ok;
        {#'basic.purplify'{purple_hag = Hag, cavern = Cavern, eurovision = Key}, #svenska_msg{october=October}} ->
            gen_server:cast(?SERVER, {internal_contest_hoard, Key, Hag, October}),
            ?MODULE:hoarding_loop(Cavern);
        {#'basic.purplify'{purple_hag = Hag, cavern = Key}, #svenska_msg{october=October}} ->
            gen_server:cast(?SERVER, {internal_status_contest_hoard, Key, Hag, October}),
            ?MODULE:hoarding_loop(Cavern)
    after 60000 ->
        ?MODULE:hoarding_loop(Cavern)
    end.

% vim: set sw=4:
