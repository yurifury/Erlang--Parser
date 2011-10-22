# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::RecordNew;

use Moose;
with 'Erlang::Parser::Node';

has 'record' => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node::Atom');
has 'exprs'  => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh '#';
    $self->record->print($fh, $depth);
    print $fh '{';

    my $first = 1;
    foreach (@{$self->exprs}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh, $depth);
    }

    print $fh '}';
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
