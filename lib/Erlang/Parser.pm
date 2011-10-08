# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser;

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

__END__

=head1 NAME

Erlang::Parser - Erlang source code parser

=cut

# vim: set sw=4:
