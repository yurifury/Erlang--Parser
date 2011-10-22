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

    if ($kind eq 'record-new') {
	print $fh '#';
	$class->print_node($fh, 'atom', $_[0]);
	print $fh '{';

	my $first = 1;
	foreach (@{$_[1]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh '}';
    } elsif ($kind eq 'variable-record-access') {
	$class->print_node($fh, 'variable', $_[0]);
	print $fh '#';
	$class->print_node($fh, 'atom', $_[1]);
    } elsif ($kind eq 'variable-record-update') {
	$class->print_node($fh, 'variable', $_[0]);
	print $fh '#';
	$class->print_node($fh, 'atom', $_[1]);
	print $fh '{';

	my $first = 1;
	foreach (@{$_[2]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh '}';
    } elsif ($kind eq 'binary') {
	print $fh '<<';

	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh '>>';
    } elsif ($kind eq 'binaryexpr') {
	print $fh '(';
	$class->print_node($fh, @{$_[0]});
	print $fh ')';
	if (defined $_[1]) {
	    print $fh ':';
	    $class->print_node($fh, @{$_[1]});
	}
	print $fh "/$_[2]" if defined $_[2];
    } elsif ($kind eq 'receive') {
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
    } elsif ($kind eq 'base-integer') {
	print $fh $_[0];
    } elsif ($kind eq 'comprehension') {
	print $fh '[';
	$class->print_node($fh, @{$_[0]});
	print $fh ' || ';
	
	my $first = 1;
	foreach (@{$_[1]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ']';
    } elsif ($kind eq 'binary-comprehension') {
	print $fh '<<';
	$class->print_node($fh, @{$_[0]});
	print $fh ' || ';
	
	my $first = 1;
	foreach (@{$_[1]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh '>>';
    } elsif ($kind eq 'begin') {
	print $fh "begin\n";

	$depth++;
	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;

	print $fh "\n", "\t" x $depth, 'end';
    } elsif ($kind eq 'not') {
	print $fh '(not ';
	$class->print_node($fh, @{$_[0]});
	print $fh ')';
    } elsif ($kind eq 'catch-expr') {
	print $fh 'catch(';
	$class->print_node($fh, @{$_[0]});
	print $fh ')';
    } elsif ($kind eq 'if') {
	print $fh "if\n";

	$depth++;
	print $fh "\t" x $depth;
	my $outfirst = 1;
	foreach (@{$_[0]}) {
	    if ($outfirst) { $outfirst = 0 } else { print $fh ";\n", "\t" x $depth }

	    my $first = 1;
	    foreach (@{@$_[0]}) {
		if ($first) { $first = 0 } else { print $fh ', ' }
		$class->print_node($fh, @$_);
	    }
	    print $fh " ->\n";

	    $depth++;
	    print $fh "\t" x $depth;
	    
	    $first = 1;
	    foreach (@{@$_[1]}) {
		if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
		$class->print_node($fh, @$_);
	    }
	    $depth--;
	}

	$depth--;
	print $fh "\n", "\t" x $depth, "end";
    } else {
	print $fh "??<" . Dumper($kind) . ">??\n";
	exit 5;
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
