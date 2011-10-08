#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

use Erlang::Parser;

use Test::Simple tests => 2;

my $tree = Erlang::Parser->parse(\*DATA);
Erlang::Parser->print_tree(*STDERR, $tree);

__END__

-module(test).
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    5,
    2/3+7*10-1,
    2/(3+7*(10-1)).

% vim: set sw=4:
