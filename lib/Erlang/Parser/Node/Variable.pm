# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Variable;

use Moose;
with 'Erlang::Parser::Node';

has 'variable' => (is => 'rw', required => 1, isa => 'Str');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh $self->variable;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
