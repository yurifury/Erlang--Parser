# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Atom;

use Moose;
with 'Erlang::Parser::Node';

has 'atom' => (is => 'rw', required => 1, isa => 'Str');

sub print {
    my ($self, $fh, $depth) = @_;

    if (not $self->atom =~ /^[^a-z]|[^a-zA-Z_0-9]/
	and not $self->atom =~ /^(case|receive|after|of|end|fun|when|div|bs[lr]|bx?or|band|rem|try|catch|andalso|and|orelse|or|begin|not|if)$/) {
	print $fh $self->atom;
    } else {
	my $atom = $self->atom;
	$atom =~ s/\\/\\\\/g;
	$atom =~ s/'/\\'/g;

	print $fh "'$atom'";
    }
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
