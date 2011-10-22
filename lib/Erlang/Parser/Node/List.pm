# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::List;

use Moose;
with 'Erlang::Parser::Node';

has 'elems' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');
has 'cdr'   => (is => 'rw', required => 1, isa => 'Maybe[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh '[';
    my $first = 1;
    foreach (@{$self->elems}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh, $depth);
    }

    if (defined $self->cdr) {
	print $fh '|';
	$self->cdr->print($fh, $depth);
    }

    print $fh ']';
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
