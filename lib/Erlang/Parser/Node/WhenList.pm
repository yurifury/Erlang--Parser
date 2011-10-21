# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::WhenList;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'WhenList';

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{GROUPS} = [];
    $self->{EXPRS} = [];

    bless $self, $class;
}

sub _append {
    my ($self, $expr) = @_;
    $self->{EXPRS} = [@{$self->{EXPRS}}, $expr->copy];
    $self;
}

sub _group () {
    my $self = shift;
    $self->{GROUPS} = [@{$self->{GROUPS}}, $self->{EXPRS}];
    $self->{EXPRS} = [];
    $self;
}

1;

# vim: set sw=4:
