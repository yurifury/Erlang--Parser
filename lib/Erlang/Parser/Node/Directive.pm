# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Directive;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'Directive';

sub new {
    my ($class, $name, $args) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{NAME} = $name;
    $self->{ARGS} = [map { $_->copy } @$args];

    bless $self, $class;
}

1;

# vim: set sw=4:
