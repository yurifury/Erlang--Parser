# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::BinaryExpr;

use Moose;
with 'Erlang::Parser::Node';

has 'output'    => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node');
has 'size'      => (is => 'rw', required => 0, isa => 'Maybe[Erlang::Parser::Node]');
has 'qualifier' => (is => 'rw', required => 0, isa => 'Maybe[Str]');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh '(';
    $self->output->print($fh, $depth);
    print $fh ')';
    if (defined $self->size) {
	print $fh ':';
	$self->size->print($fh, $depth);
    }
    print $fh '/', $self->qualifier if defined $self->qualifier;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
