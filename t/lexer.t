#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

use Parse::Erlang::Lexer;
use Test::Simple tests => 2;

my $lexer = Lexer->new;
ok( defined $lexer );
ok( $lexer->isa('Lexer') );

# vim: set sw=4:
