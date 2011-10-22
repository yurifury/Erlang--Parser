# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Directive;

use Moose;
with 'Erlang::Parser::Node';

has 'name' => (is => 'rw', required => 1, isa => 'Str');
has 'args' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;

    print $fh "-", $self->name, "(";
    my $first = 1;
    foreach (@{$self->args}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh, $depth);
    }
    print $fh ").\n";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
