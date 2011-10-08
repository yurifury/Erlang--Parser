use strict;
use warnings;
use 5.010;

use Data::Dumper;
use Parse::Lex;
use Parser;

our $lexer;
our $lexer_string;
our $lexer_skip;

sub skip_token { $lexer_skip = 1; }

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
    'DIV',		q!/!,
    'COMMA',		q!,!,
    'ERROR',		'.*', sub { die qq!can't analyse: "$_[1]"! },
    'SKIP',		q!!,
);

Parse::Lex->exclusive('dqstr');
$lexer = Parse::Lex->new(@token);
$lexer->from(\*DATA);

sub Lex {
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

my $parser = new Parser;
my $result = $parser->YYParse(yylex => \&Lex);

__END__
-module(test).
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    5,2/3.

