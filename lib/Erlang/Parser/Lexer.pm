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

our ($EXTCALL, $EXTFUN, $INTCALL, $ATOM, $INTEGER, $DIRECTIVE, $LIT, $STRING, $CONTENT);
our ($ACONTENT, $ALIT, $AATOM, $OPENATOM);
our ($OPENRECORD, $RECORDACCESS);
our ($OPENSTRING, $WHITESPACE, $COMMENT, $LPAREN, $RPAREN, $PERIOD, $RARROW);
our ($LISTOPEN, $LISTCLOSE, $DIVIDE, $ADD, $SUBTRACT, $MULTIPLY, $COMMA, $SEMICOLON);
our ($ERROR, $VARIABLE, $MACRO, $TUPLEOPEN, $TUPLECLOSE, $TODODIRECTIVE, $EQUALS);
our ($KW_CASE, $KW_RECEIVE, $KW_AFTER, $KW_OF, $KW_END, $KW_FUN);

our @tokens = (
    EXTCALL		=> q/(\w+):(\w+)\(/,
    EXTFUN		=> q/(\w+):(\w+)\/(\d+)/,
    KW_CASE		=> q/case(?!\w)/,
    KW_RECEIVE		=> q/receive(?!\w)/,
    KW_AFTER		=> q/after(?!\w)/,
    KW_OF		=> q/of(?!\w)/,
    KW_END		=> q/end(?!\w)/,
    KW_FUN		=> q/fun(?!\w)/,
    INTCALL		=> q/(\w+)\(/,
    ATOM		=> q/[a-z][\w.@]*/,
    VARIABLE		=> q/[A-Z_]\w*/,
    MACRO		=> q/\?(\w+)/,
    INTEGER		=> q/\d+/,
    DIRECTIVE		=> q/^-(\w+)\(/,
    TODODIRECTIVE	=> q/^-(type|opaque|spec)[^.]+./, sub {
	$skip_token = 1;
    },
    OPENRECORD		=> q/#/,
    RECORDACCESS	=> q/\.(\w+)/,

    'sqatom:ALIT'	=> q/\\\\./, sub {
	$lexer_string .= substr($_[1], 1);
	$skip_token = 1;
    },
    'sqatom:AATOM'	=> q/'/, sub {
	$_[0]->lexer->end('sqatom');
	$_[0]->lexer->setToken($ATOM);
	$lexer_string;
    },
    'sqatom:ACONTENT'	=> q/[^'\\\\]+/, sub {
	$lexer_string .= $_[1];
	$skip_token = 1;
    },
    OPENATOM		=> q/'/, sub {
	$_[0]->lexer->start('sqatom');
	$lexer_string = '';
	$skip_token = 1;
    },

    'dqstr:LIT'		=> q/\\\\./, sub {
	$lexer_string .= substr($_[1], 1);
	$skip_token = 1;
    },
    'dqstr:STRING'	=> q/"/, sub {
	$_[0]->lexer->end('dqstr');
	$lexer_string;
    },
    'dqstr:CONTENT'	=> q/[^"\\\\]+/, sub {
	$lexer_string .= $_[1];
	$skip_token = 1;
    },
    OPENSTRING		=> q/"/, sub {
	$_[0]->lexer->start('dqstr');
	$lexer_string = '';
	$skip_token = 1;
    },

    WHITESPACE		=> q/\s/, sub { $skip_token = 1 },
    COMMENT		=> q/%.*/, sub { $skip_token = 1 },

    LPAREN		=> q/\(/,
    RPAREN		=> q/\)/,
    PERIOD		=> q/\./,
    RARROW		=> q/->/,
    LISTOPEN		=> q/\[/,
    LISTCLOSE		=> q/\]/,
    TUPLEOPEN		=> q/{/,
    TUPLECLOSE		=> q/}/,
    EQUALS		=> q/=/,
    DIVIDE		=> q/\//,
    ADD			=> q/\+/,
    SUBTRACT		=> q/-/,
    MULTIPLY		=> q/\*/,
    COMMA		=> q/,/,
    SEMICOLON		=> q/;/,
    ERROR		=> q/.*/, sub { die qq{can't analyse: "$_[1]"} },
);

Parse::Lex->exclusive(qw(dqstr sqatom));
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

	print STDERR $token->name, "(", $token->text, ") ";
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
