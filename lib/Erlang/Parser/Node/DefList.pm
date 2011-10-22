# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::DefList;

use Moose;
with 'Erlang::Parser::Node';

has 'defs' => (is => 'rw', default => sub {[]}, isa => 'ArrayRef[Erlang::Parser::Node]');

sub _append {
    my ($self, $expr) = @_;
    push @{$self->defs}, $expr;
    $self;
}

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    my $first = 1;
    foreach (@{$self->defs}) {
	if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	$_->print($fh, $depth);
    }
    print $fh ".\n";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
