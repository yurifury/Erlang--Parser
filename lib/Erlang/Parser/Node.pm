# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node;

use strict;
use warnings;

use Erlang::Parser::Node::Directive;

sub new {
    my ($class, $kind) = @_;
    my $self = {KIND => $kind};
    bless $self, $class;
}

sub copy {
    die "copy called on an Erlang::Parser::Node::$_[0]->{KIND} w/o impl";
}

sub print {
    die "print called on an Erlang::Parser::Node::$_[0]->{KIND} w/o impl";
}

1;

# vim: set sw=4:
