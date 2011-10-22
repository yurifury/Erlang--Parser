# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::BinOp;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'BinOp';

sub new {
    my ($class, $op, $a, $b) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{OP} = $op;
    $self->{A} = $a;
    $self->{B} = $b;

    bless $self, $class;
}

sub copy {
    my $self = shift;
    Erlang::Parser::Node::BinOp->new($self->{OP}, $self->{A}, $self->{B});
}

sub print {
    my ($self, $fh) = @_;

    print $fh '(';
    $self->{A}->print($fh);
    print $fh $self->{OP};
    $self->{B}->print($fh);
    print $fh ')';
}

1;

# vim: set sw=4:
