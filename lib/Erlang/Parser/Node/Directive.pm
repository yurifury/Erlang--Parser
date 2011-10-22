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

sub print {
    my ($self, $fh) = @_;

    print $fh "-$self->{NAME}(";
    my $first = 1;
    foreach (@{$self->{ARGS}}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh);
    }
    print $fh ").\n";
}

1;

# vim: set sw=4:
