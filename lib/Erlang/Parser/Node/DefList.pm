# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::DefList;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'DefList';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new($KIND);

    $self->{DEFS} = [];

    bless $self, $class;
}

sub _append {
    my ($self, $expr) = @_;
    $self->{DEFS} = [@{$self->{DEFS}}, $expr->copy];
    $self;
}

1;

# vim: set sw=4:
