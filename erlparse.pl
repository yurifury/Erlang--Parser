use strict;
use warnings;
use 5.010;

use Parse::Lex;

my $lexer;
my @token = (
    'EXTCALL',		q!([[:alpha:]_]+):([[:alpha:]_]+)\(!,
    'INTCALL',		q!([[:alpha:]_]+)\(!,
    'ATOM',		q![[:alpha:]_]+!,
    'INTEGER',		q![[:digit:]]+!,
    'DIRECTIVE',	q!-([a-z]+)\(!,
    'STRINGSTART',	q!"!, sub {
	$lexer->start('string');
    },
    'string:LIT',	q!\\.!,
    'string:END',       q!"!, sub {
	$lexer->end('string');
    },
    'string:CONTENT',	q![^"]+!,
    'LPAREN',		q!\(!,
    'RPAREN',		q!\)!,
    'PERIOD',		q!\.!,
    'RARROW',		q!->!,
    'WHITESPACE',	q!\s!,
    'COMMENT',		q!%.*!,
    'LISTOPEN',		q!\[!,
    'LISTCLOSE',	q!\]!,
    'DIV',		q!/!,
    'COMMA',		q!,!,
    'ERROR',		'.*', sub {
	die qq!can't analyse: "$_[1]"!;
    }
);

Parse::Lex->trace;
Parse::Lex->exclusive('string');
$lexer = Parse::Lex->new(@token);
$lexer->from(\*DATA);

TOKEN:while (1) {
    my $token = $lexer->next;
    if (not $lexer->eoi) {
	print "Line $.\t";
	print "Type: ", $token->name, "\t";
	print "Content:->", $token->text, "<-\n";
    } else {
	last TOKEN;
    }
}

__END__
-module(test).
-export([test/0]).

test() ->
    io:format("This is a ~p~n.", ["te\"st"]),
    5,2/3.

