# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Atom;

use strict;
use warnings;

use Erlang::Parser::Node;
our @ISA = ('Erlang::Parser::Node');

our $KIND = 'Atom';

sub new {
    my ($class, $atom) = @_;
    my $self = $class->SUPER::new($KIND);

    $self->{ATOM} = $atom;

    bless $self, $class;
}

sub atom {
    $_[0]->{ATOM};
}

sub print {
    my ($self, $fh) = @_;

    if (not $self->{ATOM} =~ /^[^a-z]|[^a-zA-Z_0-9]/
	and not $self->{ATOM} =~ /^(case|receive|after|of|end|fun|when|div|bs[lr]|bx?or|band|rem|try|catch|andalso|and|orelse|or|begin|not|if)$/) {
	print $fh "$self->{ATOM}";
    } else {
	my $atom = $self->{ATOM};
	$atom =~ s/\\/\\\\/g;
	$atom =~ s/'/\\'/g;

	print $fh "'$atom'";
    }
}

1;

# vim: set sw=4:
