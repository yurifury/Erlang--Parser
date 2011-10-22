# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::FunRef;

use Moose;
with 'Erlang::Parser::Node';

has 'module'   => (is => 'rw', required => 0, isa => 'Maybe[Erlang::Parser::Node]');
has 'function' => (is => 'rw', required => 1, isa => 'Str');
has 'arity'    => (is => 'rw', required => 1, isa => 'Int');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh 'fun ';

    if (defined $self->module) {
	$self->module->print($fh, $depth);
	print $fh ':';
    }


    $self->function->print($fh, $depth);
    print $fh '/', $self->arity;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
