# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::If;

use Moose;
with 'Erlang::Parser::Node';

has 'cases' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node::IfExpr]');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh "if\n";

    $depth++;
    print $fh "\t" x $depth;
    my $first = 1;
    foreach (@{$self->cases}) {
	if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	$_->print($fh, $depth);
    }

    $depth--;
    print $fh "\n", "\t" x $depth, "end";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
