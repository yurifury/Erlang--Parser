#!/usr/bin/env perl -w

use strict;
use warnings;

use Erlang::Parser;

use Test::Simple tests => 5;

my $data = do { local $/; <DATA> };
my @nodes = Erlang::Parser->parse($data);

ok( @nodes,		'the test data should parse' );

open my $fh, ">", \my $pp;
Erlang::Parser->print_nodes($fh, @nodes);
close $fh;

ok( $pp,		'the test data should pretty-print' );

my @pp_nodes = Erlang::Parser->parse($pp);

ok( @pp_nodes,		'the pretty-printed test data should parse' );

open my $fh2, ">", \my $pp2;
Erlang::Parser->print_nodes($fh2, @pp_nodes);
close $fh2;

ok( $pp2,		'the parsed pretty-printed test data should pretty-print' );

ok( $pp eq $pp2,	'the pretty-printed test data should equal the pretty-printed parsed pretty-printed test data' );

ok( 0, 'TODO' );

__END__

xyz() when a, b; c ->
    none.

% vim: set sw=4:
