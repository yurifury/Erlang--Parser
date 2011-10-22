# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::String;

use Moose;
with 'Erlang::Parser::Node';

has 'string' => (is => 'rw', required => 1, isa => 'Str');

sub print {
    my ($self, $fh, $depth) = @_;

    my $string = $self->string;
    $string =~ s/\\/\\\\/g;
    $string =~ s/"/\\"/g;

    print $fh "\"$string\"";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
