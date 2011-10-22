# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Macro;

use Moose;
with 'Erlang::Parser::Node';

has 'macro' => (is => 'rw', required => 1, isa => 'Str');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh '?', $self->macro;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
