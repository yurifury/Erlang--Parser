####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Erlang::Parser::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -1,
		GOTOS => {
			'root' => 1
		}
	},
	{#State 1
		ACTIONS => {
			'' => 2,
			'DIRECTIVE' => 4,
			'INTCALL' => 5
		},
		GOTOS => {
			'rootstmt' => 3
		}
	},
	{#State 2
		DEFAULT => 0
	},
	{#State 3
		DEFAULT => -2
	},
	{#State 4
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'STRING' => 14,
			'EXTCALL' => 12,
			'LISTOPEN' => 10
		},
		DEFAULT => -8,
		GOTOS => {
			'expr' => 8,
			'exprlist' => 11,
			'list' => 13
		}
	},
	{#State 5
		ACTIONS => {
			'RPAREN' => 15
		}
	},
	{#State 6
		DEFAULT => -12
	},
	{#State 7
		DEFAULT => -11
	},
	{#State 8
		ACTIONS => {
			'DIVIDE' => 16,
			'SUBTRACT' => 17,
			'ADD' => 18,
			'MULTIPLY' => 19
		},
		DEFAULT => -9
	},
	{#State 9
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 20,
			'list' => 13
		}
	},
	{#State 10
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'STRING' => 14,
			'EXTCALL' => 12,
			'LISTOPEN' => 10
		},
		DEFAULT => -8,
		GOTOS => {
			'expr' => 8,
			'exprlist' => 21,
			'list' => 13
		}
	},
	{#State 11
		ACTIONS => {
			'RPAREN' => 22,
			'COMMA' => 23
		}
	},
	{#State 12
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'STRING' => 14,
			'EXTCALL' => 12,
			'LISTOPEN' => 10
		},
		DEFAULT => -8,
		GOTOS => {
			'expr' => 8,
			'exprlist' => 24,
			'list' => 13
		}
	},
	{#State 13
		DEFAULT => -14
	},
	{#State 14
		DEFAULT => -13
	},
	{#State 15
		ACTIONS => {
			'RARROW' => 25
		}
	},
	{#State 16
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 26,
			'list' => 13
		}
	},
	{#State 17
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 27,
			'list' => 13
		}
	},
	{#State 18
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 28,
			'list' => 13
		}
	},
	{#State 19
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 29,
			'list' => 13
		}
	},
	{#State 20
		ACTIONS => {
			'DIVIDE' => 16,
			'RPAREN' => 30,
			'SUBTRACT' => 17,
			'ADD' => 18,
			'MULTIPLY' => 19
		}
	},
	{#State 21
		ACTIONS => {
			'LISTCLOSE' => 31,
			'COMMA' => 23
		}
	},
	{#State 22
		ACTIONS => {
			'PERIOD' => 32
		}
	},
	{#State 23
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'expr' => 33,
			'list' => 13
		}
	},
	{#State 24
		ACTIONS => {
			'RPAREN' => 34,
			'COMMA' => 23
		}
	},
	{#State 25
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'stmt' => 36,
			'expr' => 37,
			'stmtlist' => 35,
			'list' => 13
		}
	},
	{#State 26
		DEFAULT => -15
	},
	{#State 27
		ACTIONS => {
			'DIVIDE' => 16,
			'MULTIPLY' => 19
		},
		DEFAULT => -18
	},
	{#State 28
		ACTIONS => {
			'DIVIDE' => 16,
			'MULTIPLY' => 19
		},
		DEFAULT => -17
	},
	{#State 29
		DEFAULT => -16
	},
	{#State 30
		DEFAULT => -20
	},
	{#State 31
		DEFAULT => -21
	},
	{#State 32
		DEFAULT => -3
	},
	{#State 33
		ACTIONS => {
			'DIVIDE' => 16,
			'SUBTRACT' => 17,
			'ADD' => 18,
			'MULTIPLY' => 19
		},
		DEFAULT => -10
	},
	{#State 34
		DEFAULT => -19
	},
	{#State 35
		ACTIONS => {
			'COMMA' => 38,
			'PERIOD' => 39
		}
	},
	{#State 36
		DEFAULT => -5
	},
	{#State 37
		ACTIONS => {
			'DIVIDE' => 16,
			'SUBTRACT' => 17,
			'ADD' => 18,
			'MULTIPLY' => 19
		},
		DEFAULT => -7
	},
	{#State 38
		ACTIONS => {
			'INTEGER' => 6,
			'ATOM' => 7,
			'LPAREN' => 9,
			'LISTOPEN' => 10,
			'STRING' => 14,
			'EXTCALL' => 12
		},
		GOTOS => {
			'stmt' => 40,
			'expr' => 37,
			'list' => 13
		}
	},
	{#State 39
		DEFAULT => -4
	},
	{#State 40
		DEFAULT => -6
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'root', 0,
sub
#line 10 "lib/Erlang/Parser/Parser.yp"
{ [] }
	],
	[#Rule 2
		 'root', 2,
sub
#line 11 "lib/Erlang/Parser/Parser.yp"
{ [@{$_[1]}, $_[2]] }
	],
	[#Rule 3
		 'rootstmt', 4,
sub
#line 15 "lib/Erlang/Parser/Parser.yp"
{ ['directive', substr($_[1], 1, -1), $_[2]->[1]] }
	],
	[#Rule 4
		 'rootstmt', 5,
sub
#line 16 "lib/Erlang/Parser/Parser.yp"
{ ['def', substr($_[1], 0, -1), $_[4]->[1]] }
	],
	[#Rule 5
		 'stmtlist', 1,
sub
#line 20 "lib/Erlang/Parser/Parser.yp"
{ ['stmtlist', [$_[1]]] }
	],
	[#Rule 6
		 'stmtlist', 3,
sub
#line 21 "lib/Erlang/Parser/Parser.yp"
{ ['stmtlist', [@{$_[1]->[1]}, $_[3]]] }
	],
	[#Rule 7
		 'stmt', 1, undef
	],
	[#Rule 8
		 'exprlist', 0,
sub
#line 28 "lib/Erlang/Parser/Parser.yp"
{ ['exprlist', []] }
	],
	[#Rule 9
		 'exprlist', 1,
sub
#line 29 "lib/Erlang/Parser/Parser.yp"
{ ['exprlist', [$_[1]]] }
	],
	[#Rule 10
		 'exprlist', 3,
sub
#line 30 "lib/Erlang/Parser/Parser.yp"
{ ['exprlist', [@{$_[1]->[1]}, $_[3]]] }
	],
	[#Rule 11
		 'expr', 1,
sub
#line 34 "lib/Erlang/Parser/Parser.yp"
{ ['atom', $_[1]] }
	],
	[#Rule 12
		 'expr', 1,
sub
#line 35 "lib/Erlang/Parser/Parser.yp"
{ ['integer', $_[1]] }
	],
	[#Rule 13
		 'expr', 1,
sub
#line 36 "lib/Erlang/Parser/Parser.yp"
{ ['string', $_[1]] }
	],
	[#Rule 14
		 'expr', 1,
sub
#line 37 "lib/Erlang/Parser/Parser.yp"
{ ['list', $_[1]->[1]] }
	],
	[#Rule 15
		 'expr', 3,
sub
#line 38 "lib/Erlang/Parser/Parser.yp"
{ ['divide', $_[1], $_[3]] }
	],
	[#Rule 16
		 'expr', 3,
sub
#line 39 "lib/Erlang/Parser/Parser.yp"
{ ['multiply', $_[1], $_[3]] }
	],
	[#Rule 17
		 'expr', 3,
sub
#line 40 "lib/Erlang/Parser/Parser.yp"
{ ['add', $_[1], $_[3]] }
	],
	[#Rule 18
		 'expr', 3,
sub
#line 41 "lib/Erlang/Parser/Parser.yp"
{ ['subtract', $_[1], $_[3]] }
	],
	[#Rule 19
		 'expr', 3,
sub
#line 42 "lib/Erlang/Parser/Parser.yp"
{ ['extcall', substr($_[1], 0, -1), $_[2]->[1]] }
	],
	[#Rule 20
		 'expr', 3,
sub
#line 43 "lib/Erlang/Parser/Parser.yp"
{ $_[2] }
	],
	[#Rule 21
		 'list', 3,
sub
#line 47 "lib/Erlang/Parser/Parser.yp"
{ ['list', $_[2]->[1]] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 49 "lib/Erlang/Parser/Parser.yp"


# vim: set sw=4 filetype=perl:

1;
