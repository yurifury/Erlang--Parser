use ExtUtils::MakeMaker;

# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

WriteMakefile(
    NAME => 'Parse::Erlang',
    ABSTRACT_FROM => 'lib/Parse/Erlang.pm',
    VERSION_FROM => 'lib/Parse/Erlang.pm',
    AUTHOR => 'Anneli Cuss <anneli@cpan.org>',
    PREREQ_PM => {qw(
	Parse::Lex	2.20
	Parse::Yapp	0
    )},
);

sub MY::postamble {
    return <<'MAKE_FRAG';
lib/Parse/Erlang/Parser.pm: lib/Parse/Erlang/Parser.yp
	yapp -v $<
MAKE_FRAG
}

# vim: set sw=4:
