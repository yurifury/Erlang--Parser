# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Integer;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'Integer';

sub new {
    my ($class, $int) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{INT} = $int;

    bless $self, $class;
}

sub int {
    $_[0]->{INT};
}

sub print {
    my ($self, $fh) = @_;

    print $self->{INT};
}

1;

# vim: set sw=4:
