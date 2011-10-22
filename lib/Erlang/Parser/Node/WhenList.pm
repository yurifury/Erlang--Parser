# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::WhenList;

use Moose;
with 'Erlang::Parser::Node';

has 'groups' => (is => 'rw', default => sub {[]});#, isa => 'AraryRef[ArrayRef[Erlang::Parser::Node]]');
has 'exprs'  => (is => 'rw', default => sub {[]}, isa => 'ArrayRef[Erlang::Parser::Node]');

sub _append {
    my ($self, $expr) = @_;
    push @{$self->exprs}, $expr;
    $self;
}

sub _group () {
    my $self = shift;
    push @{$self->groups}, $self->exprs if @{$self->exprs};
    $self->exprs([]);
    $self;
}

sub print {
    my ($self, $fh, $depth) = @_;

    if (@{$self->groups}) {
	print $fh 'when ';
	my $first = 1;
	foreach (@{$self->groups}) {
	    if ($first) { $first = 0 } else { print $fh '; ' }

	    my $infirst = 1;
	    foreach (@$_) {
		if ($infirst) { $infirst = 0 } else { print $fh ', ' }
		$_->print($fh, $depth);
	    }
	}
	print $fh ' ';
    }
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
