# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Float;

use Moose;
with 'Erlang::Parser::Node';

has 'float' => (is => 'rw', required => 1, isa => 'Num');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;
    print $fh $self->float;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
