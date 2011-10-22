# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::BinOp;

use Moose;
with 'Erlang::Parser::Node';

has 'op' => (is => 'rw', required => 1, isa => 'Str');
has 'a'  => (is => 'rw', required => 1, does => 'Erlang::Parser::Node');
has 'b'  => (is => 'rw', required => 1, does => 'Erlang::Parser::Node');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh '(';
    $self->a->print($fh, $depth);

    print $fh ' ';
    print $fh $self->op;
    print $fh ' ';

    $self->b->print($fh, $depth);
    print $fh ')';
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
