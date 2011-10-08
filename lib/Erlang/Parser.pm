# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser;

our $VERSION = '0.1';

use Erlang::Parser::Dumper;
use Erlang::Parser::Lexer;
use Erlang::Parser::Parser;

sub parse {
    my $class = shift;

    my $lexer = new Erlang::Parser::Lexer(@_);
    return (new Erlang::Parser::Parser)->YYParse(yylex => sub { $lexer->lex(@_) });
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
