# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Def;

use Moose;
with 'Erlang::Parser::Node';

has 'def'   => (is => 'rw', required => 1, isa => 'Str');
has 'args'  => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');
has 'whens' => (is => 'rw', required => 1, isa => 'Erlang::Parser::Node::WhenList');
has 'stmts' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh $self->def, '(';

    my $first = 1;
    foreach (@{$self->args}) {
	if ($first) { $first = 0 } else { print $fh ', ' }
	$_->print($fh, $depth);
    }
    
    $depth++;

    print $fh ") ";

    $self->whens->print($fh, $depth);
    
    print $fh "->\n", "\t" x $depth;
    $first = 1;
    foreach (@{$self->stmts}) {
	if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	$_->print($fh, $depth);
    }

    $depth--;
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
