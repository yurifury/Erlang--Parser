# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This script is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself.

package Parse::Erlang;

our $VERSION = '0.1';

use Parse::Erlang::Dumper;
use Parse::Erlang::Lexer;
use Parse::Erlang::Parser;

sub parse {
    my $class = shift;

    my $lexer = new Parse::Erlang::Lexer(@_);
    return (new Parse::Erlang::Parser)->YYParse(yylex => sub { $lexer->lex(@_) });
}

sub print_tree {
    my ($class, $fh, $tree) = @_;
    Parse::Erlang::Dumper->print_tree($fh, $tree);
}

__END__

=head1 NAME

Parse::Erlang - parse Erlang source code

=cut

# vim: set sw=4:
