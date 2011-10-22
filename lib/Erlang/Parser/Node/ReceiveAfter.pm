# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::ReceiveAfter;

use Moose;
with 'Erlang::Parser::Node';

has 'time'  => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node');
has 'stmts' => (is => 'rw', required => 0, isa => 'ArrayRef[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh 'after ';
    $self->time->print($fh, $depth);

    $depth++;
    print $fh " ->\n", "\t" x $depth;

    my $first = 1;
    foreach (@{$self->stmts}) {
	if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	$_->print($fh, $depth);
    }

    $depth--;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
