# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Dumper;

use strict;
use warnings;

use Data::Dumper;

our $depth;

sub print_node {
    my $class = shift;
    my $fh = shift;
    my $kind = shift;

    if ($kind eq 'receive') {
	my ($alts, $after) = @_;

	print $fh "receive\n";

	$depth++;

	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@$alts) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
	print $fh "\n", "\t" x $depth;
	
	if (defined $after) {
	    print $fh 'after ';
	    $class->print_node($fh, @{$after->[0]});

	    $depth++;
	    print $fh " ->\n", "\t" x $depth;

	    $first = 1;
	    foreach (@{$after->[1]}) {
		if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
		$class->print_node($fh, @$_);
	    }

	    $depth--;
	}
	
	print $fh "\n", "\t" x $depth, "end";
    }
}

=over 4

=item C<depth>

Returns the current depth of the pretty-printer, or sets it to the argument if
one is given.

=item C<print_node>

Prints a node to the given filehandle.

=cut

1;

# vim: set sw=4:
