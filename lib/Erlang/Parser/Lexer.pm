# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Lexer;

use strict;
use warnings;
use 5.014;

use Parse::Lex;

# NOTE: not re-entrant due to P::L fun.
our $lexer_string = '';
our $skip_token = 0;

our ($EXTCALL, $INTCALL, $ATOM, $INTEGER, $DIRECTIVE, $LIT, $STRING, $CONTENT);
our ($OPENSTRING, $WHITESPACE, $COMMENT, $LPAREN, $RPAREN, $PERIOD, $RARROW);
our ($LISTOPEN, $LISTCLOSE, $DIVIDE, $ADD, $SUBTRACT, $MULTIPLY, $COMMA);
our ($ERROR);

our @tokens = (
    'EXTCALL',		q!([[:alpha:]_]+):([[:alpha:]_]+)\(!,
    'INTCALL',		q!([[:alpha:]_]+)\(!,
    'ATOM',		q![[:alpha:]_]+!,
    'INTEGER',		q![[:digit:]]+!,
    'DIRECTIVE',	q!-([a-z]+)\(!,

    'dqstr:LIT',	q!\\\\"!, sub {
	$lexer_string .= substr($_[1], 1);
	$skip_token = 1;
    },
    'dqstr:STRING',	q!"!, sub {
	$_[0]->lexer->end('dqstr');
	$lexer_string;
    },
    'dqstr:CONTENT',	q![^"\\\\]+!, sub {
	$lexer_string .= $_[1];
	$skip_token = 1;
    },
    'OPENSTRING',	q!"!, sub {
	$_[0]->lexer->start('dqstr');
	$lexer_string = '';
	$skip_token = 1;
    },

    'WHITESPACE',	q!\s!, sub { $skip_token = 1 },
    'COMMENT',		q!%.*!, sub { $skip_token = 1 },

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
);

Parse::Lex->exclusive('dqstr');
our $lex = Parse::Lex->new(@tokens);
local $.;

sub lex {
    my $class = shift;
    $lex->from(@_);

    sub {
	my $token;

	$skip_token = 0;

	LOOP:while (1) {
	    $token = $lex->next;

	    if ($lex->eoi or not $token) {
		return ('', undef);
	    } elsif (not $skip_token) {
		last LOOP;
	    }
	    $skip_token = 0;
	}

	return ($token->name, $token->text);
    }
}

=over 4

=item C<lex>

Returns an anonymous subroutine that returns a token type/content pair on each
invocation, and C<('', undef)> when there's no more.

=cut

1;

# vim: set sw=4:
