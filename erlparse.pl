#!/usr/bin/env perl
# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This script is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself.

use strict;
use warnings;
use 5.010;

use Data::Dumper;
use Parse::Lex;
use Parser;

our $lexer;
our $lexer_string;
our $lexer_skip;

sub skip_token { $lexer_skip = 1 }

my @token = (
    'EXTCALL',		q!([[:alpha:]_]+):([[:alpha:]_]+)\(!,
    'INTCALL',		q!([[:alpha:]_]+)\(!,
    'ATOM',		q![[:alpha:]_]+!,
    'INTEGER',		q![[:digit:]]+!,
    'DIRECTIVE',	q!-([a-z]+)\(!,

    'dqstr:LIT',	q!\\\\"!, sub {
	$lexer_string .= substr($_[1], 1);
	skip_token;
    },
    'dqstr:STRING',       q!"!, sub {
	$lexer->end('dqstr');
	$lexer_string;
    },
    'dqstr:CONTENT',	q![^"\\\\]+!, sub {
	$lexer_string .= $_[1];
	skip_token;
    },
    'OPENSTRING',	q!"!, sub {
	$lexer->start('dqstr');
	$lexer_string = '';
	skip_token;
    },

    'WHITESPACE',	q!\s!, sub { skip_token },
    'COMMENT',		q!%.*!, sub { skip_token },

    'LPAREN',		q!\(!,
    'RPAREN',		q!\)!,
    'PERIOD',		q!\.!,
    'RARROW',		q!->!,
    'LISTOPEN',		q!\[!,
    'LISTCLOSE',	q!\]!,
    'DIVIDE',		q!/!,
    'ADD',		q!\+!,
    'SUBTRACT',		q!-!,
    'MULTIPLY',		q!\*!,
    'COMMA',		q!,!,
    'ERROR',		'.*', sub { die qq!can't analyse: "$_[1]"! },
    'SKIP',		q!!,
);

Parse::Lex->exclusive('dqstr');
$lexer = Parse::Lex->new(@token);
$lexer->from(\*DATA);

sub lex {
    my $token;
    $lexer_skip = 0;
    LOOP:while (1) {
	$token = $lexer->next;

	if ($lexer->eoi or not $token) {
	    return ('', undef);
	} elsif (not $lexer_skip) {
	    last LOOP;
	}
	$lexer_skip = 0;
    }

    say "Line $.\t", $token->name, "\t", $token->text;
    return ($token->name, $token->text);
}

sub print_tree {
    print_node(@$_) foreach (@{$_[0]});
}

sub print_node {
    my $kind = shift;

    if ($kind eq 'directive') {
	my ($directive, $args) = @_;
	print "-$directive(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    print_node(@$_);
	}
	print ").\n";
    } elsif ($kind eq 'atom') {
	print "$_[0]";
    } elsif ($kind eq 'list') {
	my ($args) = @_;
	print '[';
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    print_node(@$_);
	}
	print ']';
    } elsif ($kind eq 'divide') {
	print '(';
	print_node(@{$_[0]});
	print '/';
	print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'multiply') {
	print '(';
	print_node(@{$_[0]});
	print '*';
	print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'add') {
	print '(';
	print_node(@{$_[0]});
	print '+';
	print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'subtract') {
	print '(';
	print_node(@{$_[0]});
	print '-';
	print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'integer') {
	print $_[0];
    } elsif ($kind eq 'def') {
	my ($name, $stmts) = @_;
	print "$name() ->\n\t";
	my $first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print ",\n\t" }
	    print_node(@$_);
	}
	print ".\n";
    } elsif ($kind eq 'extcall') {
	my ($mod, $fun, $args) = (split(':', $_[0]), $_[1]);
	print "$mod:$fun(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    print_node(@$_);
	}
	print ')';
    } elsif ($kind eq 'string') {
	print "\"$_[0]\"";
    } else {
	print "<<", Dumper($kind), ">>";
    }
}

my $parser = new Parser;
my $result = $parser->YYParse(yylex => \&lex);
print_tree $result;

__END__
-module(test).
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    5,
    2/3+7*10-1,
    2/(3+7*(10-1)).

