# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Call;

use Moose;
with 'Erlang::Parser::Node';

has 'module'   => (is => 'rw', required => 0, isa => 'Erlang::Parser::Node');
has 'function' => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node');
has 'args'     => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;

    if (defined $self->module) {
	$self->mod->print($fh, $depth);
	print $fh ':';
    }

    print $fh '(' if $self->function->blessed ne 'Erlang::Parser::Node::Atom';
    $self->function->print($fh, $depth);
    print $fh ')' if $self->function->blessed ne 'Erlang::Parser::Node::Atom';
    print $fh '(';
    my $first = 1;
    foreach (@{$self->args}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh, $depth);
    }
    print $fh ')';
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
