use ExtUtils::MakeMaker;

my $YAPP_COMMAND = "(yapp -v -m 'Erlang::Parser::Parser' -o lib/Erlang/Parser/Parser.pm lib/Erlang/Parser/Parser.yp)";
`$YAPP_COMMAND`;

# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

WriteMakefile(
    NAME => 'Erlang::Parser',
    ABSTRACT_FROM => 'lib/Erlang/Parser.pm',
    VERSION_FROM => 'lib/Erlang/Parser.pm',
    AUTHOR => 'Anneli Cuss <anneli@cpan.org>',
    PREREQ_PM => {qw(
	Parse::Lex	2.20
	Parse::Yapp	0
    )},
);

sub MY::postamble {
    return <<"MAKE_FRAG";
lib/Erlang/Parser/Parser.pm: lib/Erlang/Parser/Parser.yp
	$YAPP_COMMAND
MAKE_FRAG
}

# vim: set sw=4:
