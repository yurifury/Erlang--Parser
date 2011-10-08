#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

use Parse::Erlang::Lexer;
use Test::Simple tests => 2;

my $lexer = Parse::Erlang::Lexer->new;
ok( defined $lexer,				'new returns something' );
ok( $lexer->isa('Parse::Erlang::Lexer'),	'new returns a P::E::L' );

# vim: set sw=4:
