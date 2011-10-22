# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Node::Try;

use Moose;
with 'Erlang::Parser::Node';

has 'exprs' => (is => 'rw', required => 1, isa => 'ArrayRef[Erlang::Parser::Node]');
has 'of'    => (is => 'rw', required => 0, isa => 'Maybe[ArrayRef[Erlang::Parser::Node::Alt]]');
has 'catch' => (is => 'rw', required => 0, isa => 'Maybe[ArrayRef[Erlang::Parser::Node::Alt]]');
has 'aft'   => (is => 'rw', required => 0, isa => 'Maybe[ArrayRef[Erlang::Parser::Node]]');

sub print {
    my ($self, $fh, $depth) = @_;
    $depth ||= 0;

    print $fh "try\n";

    $depth++;
    print $fh "\t" x $depth;

    my $first = 1;
    foreach (@{$self->exprs}) {
	if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	$_->print($fh, $depth);
    }

    $depth--;
    print $fh "\n", "\t" x $depth;

    if (defined $self->of and @{$self->of}) {
	print $fh "of\n";

	$depth++;
	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@{$self->of}) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $_->print($fh, $depth);
	}

	$depth--;
	print $fh "\n", "\t" x $depth;
    }

    if (defined $self->catch and @{$self->catch}) {
	print $fh "catch\n";

	$depth++;
	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@{$self->catch}) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $_->print($fh, $depth);
	}

	$depth--;
	print $fh "\n", "\t" x $depth;
    }

    if (defined $self->aft and @{$self->aft}) {
	print $fh "after\n";

	$depth++;
	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@{$self->aft}) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $_->print($fh, $depth);
	}

	$depth--;
	print $fh "\n", "\t" x $depth;
    }

    print $fh "end";
}

__PACKAGE__->meta->make_immutable;

1;

# vim: set sw=4:
