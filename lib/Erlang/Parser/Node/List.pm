# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::List;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'List';

sub new {
    my ($class, $elems) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{ELEMS} = [map { $_->copy } @$elems];

    bless $self, $class;
}

sub copy {
    my $self = shift;
    Erlang::Parser::Node::List->new($self->{ELEMS});
}

sub print {
    my ($self, $fh) = @_;

    print $fh '[';
    my $first = 1;
    foreach (@{$self->{ELEMS}}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh);
    }
    print $fh ']';
}

1;

# vim: set sw=4:
