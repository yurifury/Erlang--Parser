#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

use Erlang::Parser::Lexer;
use Test::Simple tests => 2;

my $lexer = Erlang::Parser::Lexer->new;
ok( defined $lexer,				'new returns something' );
ok( $lexer->isa('Erlang::Parser::Lexer'),	'new returns a E::P::L' );

# vim: set sw=4:
