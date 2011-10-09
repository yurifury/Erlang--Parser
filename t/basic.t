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
    5,
    2/3+7*10-1,
    2/(3+7*(10-1)).

-define(SERVER, ?MODULE).
-define(EXCHANGE, "who-goes-there").

% vim: set sw=4:
