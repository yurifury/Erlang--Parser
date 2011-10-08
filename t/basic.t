#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

use Erlang::Parser;

use Test::Simple tests => 4;

my $data = do { local $/; <DATA> };
my $tree = Erlang::Parser->parse($data);

ok( $tree,		'the test data should parse' );

open my $fh, ">", \my $pp;
Erlang::Parser->print_tree($fh, $tree);

ok( $pp,		'the test data should pretty-print' );

say STDERR $pp;
my $pp_tree = Erlang::Parser->parse($pp);

ok( $pp_tree,		'the pretty-printed test data should parse' );

open my $fh2, ">", \my $pp2;
Erlang::Parser->print_tree($fh2, $pp_tree);

ok( $pp2,		'the parsed pretty-printed test data should pretty-print' );

__END__

-module(test).
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    5,
    2/3+7*10-1,
    2/(3+7*(10-1)).

% vim: set sw=4:
