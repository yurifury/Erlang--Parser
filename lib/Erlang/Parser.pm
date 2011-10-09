# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser;

use strict;
use warnings;
use 5.014;

our $VERSION = '0.1';

use Erlang::Parser::Dumper;
use Erlang::Parser::Lexer;
use Erlang::Parser::Parser;

sub parse {
    my ($class, $data) = @_;

    my $parser = new Erlang::Parser::Parser;
    my $lexerfn = Erlang::Parser::Lexer->lex($data);
    $parser->YYParse(yylex => $lexerfn);
}

sub print_tree {
    my ($class, $fh, $tree) = @_;
    Erlang::Parser::Dumper->print_tree($fh, $tree);
}

1;

=pod

=head1 NAME

Erlang::Parser - Erlang source code parser

=head1 SYNOPSIS

    use Erlang::Parser;

    my $tree = Erlang::Parser->parse(\*DATA);

=head1 DESCRIPTION

L<Erlang::Parser> is an Erlang source code parser.  You can feed C<parse()> any
fragment of code which would be acceptable at the top-level of a C<.erl> file,
including a full file.

=head1 SUPPORT

The source code repository can be found at
L<http://github.com/anneli/Erlang--Parser>.  If you find any bugs, please open
an L<issue|http://github.com/anneli/Erlang--Parser/issues>, or send a pull
request with your fix!

A mailing list is available at
L<http://groups.google.com/group/erlang--parser-devel>, or you can mail direct
to L<mailto:erlang--parser-devel@googlegroups.com>.

The author can also be found on L<Twitter|http://twitter.com/unnali>.

=head1 AUTHOR

Anneli Cuss <anneli@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Anneli Cuss.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=cut

# vim: set sw=4:
