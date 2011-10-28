# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Receive;

use Moose;
with 'Erlang::Parser::Node';

has 'alts' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node::Alt]');
has 'aft'  => (is => 'rw', required => 0, isa => 'Maybe[Erlang::Parser::Node::ReceiveAfter]');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh "receive\n";

    $depth++;

    print $fh "\t" x $depth;

    my $first = 1;
    foreach (@{$self->alts}) {
	if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	$_->print($fh ,$depth);
    }

    $depth--;
    print $fh "\n", "\t" x $depth;
    
    $self->aft->print($fh, $depth) if defined $self->aft;
    
    print $fh "\n", "\t" x $depth, "end";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4: