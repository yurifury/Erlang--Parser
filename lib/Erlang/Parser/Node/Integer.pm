# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Integer;

use Moose;
with 'Erlang::Parser::Node';

has 'int' => (is => 'rw', required => 1, isa => 'Int');

sub print {
    my ($self, $fh, $depth) = @_;
    print $self->int;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
