# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Lexer;

use strict;
use warnings;
use 5.010;

use Parse::Lex;

sub new {
    my $class = shift;
    my $self = {};
    Parse::Lex->exclusive('dqstr');
    $self->{LEXER_STRING} = undef;
    $self->{LEXER_SKIP} = 0;
    bless $self, $class;

    $self->{LEXER} = Parse::Lex->new($self->tokens);
    $self->from($_[0]) if (@_);

    return $self;
}

sub from {
    my ($self, $src) = @_;
    $self->{LEXER}->from($src);
}

sub skip_token {
    my ($self) = @_;
    $self->{LEXER_SKIP} = 1;
}

sub lex {
    my ($self) = @_;
    my $token;

    my $lexer = $self->{LEXER};
    $self->{LEXER_SKIP} = 0;

    LOOP:while (1) {
	$token = $lexer->next;

	if ($lexer->eoi or not $token) {
	    return ('', undef);
	} elsif (not $self->{LEXER_SKIP}) {
	    last LOOP;
	}
	$self->{LEXER_SKIP} = 0;
    }

    say "Line $.\t", $token->name, "\t", $token->text;
    return ($token->name, $token->text);
}

# internal

sub tokens {
    my ($self) = @_;

    return (
	'EXTCALL',		q!([[:alpha:]_]+):([[:alpha:]_]+)\(!,
	'INTCALL',		q!([[:alpha:]_]+)\(!,
	'ATOM',			q![[:alpha:]_]+!,
	'INTEGER',		q![[:digit:]]+!,
	'DIRECTIVE',		q!-([a-z]+)\(!,

	'dqstr:LIT',		q!\\\\"!, sub {
	    $self->{LEXER_STRING} .= substr($_[1], 1);
	    $self->skip_token;
	},
	'dqstr:STRING',		q!"!, sub {
	    $self->{LEXER}->end('dqstr');
	    $self->{LEXER_STRING};
	},
	'dqstr:CONTENT',	q![^"\\\\]+!, sub {
	    $self->{LEXER_STRING} .= $_[1];
	    $self->skip_token;
	},
	'OPENSTRING',		q!"!, sub {
	    $self->{LEXER}->start('dqstr');
	    $self->{LEXER_STRING} = '';
	    $self->skip_token;
	},

	'WHITESPACE',		q!\s!, sub { $self->skip_token },
	'COMMENT',		q!%.*!, sub { $self->skip_token },

	'LPAREN',		q!\(!,
	'RPAREN',		q!\)!,
	'PERIOD',		q!\.!,
	'RARROW',		q!->!,
	'LISTOPEN',		q!\[!,
	'LISTCLOSE',		q!\]!,
	'DIVIDE',		q!/!,
	'ADD',			q!\+!,
	'SUBTRACT',		q!-!,
	'MULTIPLY',		q!\*!,
	'COMMA',		q!,!,
	'ERROR',		'.*', sub { die qq!can't analyse: "$_[1]"! },
    );
}

1;

# vim: set sw=4:
