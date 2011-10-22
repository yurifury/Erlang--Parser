# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::VariableRecordUpdate;

use Moose;
with 'Erlang::Parser::Node';

has 'variable' => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node::Variable');
has 'update'   => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node::RecordNew');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    $self->variable->print($fh, $depth);
    $self->update->print($fh, $depth);
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
