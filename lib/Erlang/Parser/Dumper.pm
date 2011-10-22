# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Dumper;

use strict;
use warnings;

use Data::Dumper;

our $depth = 0;

sub depth {
    my $self = shift;
    if (defined $_[0]) {
	$depth = $_[0]
    } else {
	$depth
    }
}

sub print_node {
    my $class = shift;
    my $fh = shift;
    my $kind = shift;

    if ($kind eq 'neg') {
	print $fh '(';
	print $fh '-';
	$class->print_node($fh, @{$_[0]});
	print $fh ')';
    } elsif ($kind eq 'deflist') {
	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}
	print $fh ".\n";
    } elsif ($kind eq 'def') {
	my ($name, $args, $whens, $stmts) = @_;
	print $fh "$name(";
    
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	
	$depth++;

	print $fh ") ";

	if (@$whens) {
	    print $fh 'when ';
	    $first = 1;
	    foreach (@$whens) {
		if ($first) { $first = 0 } else { print $fh ', ' }
		$class->print_node($fh, @$_);
	    }
	    print $fh ' ';
	}
	
	print $fh "->\n", "\t" x $depth;
	$first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
    } elsif ($kind eq 'call') {
	my ($mod, $fun, $args) = @_;

	if (defined $mod) {
	    $class->print_node($fh, @$mod);
	    print $fh ':';
	}

	print $fh '(' if ${$fun}[0] ne 'atom';
	$class->print_node($fh, @$fun);
	print $fh ')' if ${$fun}[0] ne 'atom';
	print $fh '(';
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ')';
    } elsif ($kind eq 'string') {
	my $string = $_[0];
	$string =~ s/\\/\\\\/g;
	$string =~ s/"/\\"/g;

	print $fh "\"$string\"";
    } elsif ($kind eq 'variable') {
	print $fh $_[0];
    } elsif ($kind eq 'macro') {
	print $fh "?$_[0]";
    } elsif ($kind eq 'tuple') {
	print $fh '{';
	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh '}';
    } elsif ($kind eq 'case') {
	my ($expr, $alts) = @_;

	print $fh 'case ';
	$class->print_node($fh, @$expr);
	print $fh " of\n";

	$depth++;

	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@$alts) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
	print $fh "\n", "\t" x $depth, "end";
    } elsif ($kind eq 'alt' or $kind eq 'catchalt') {
	my $catchclass = $kind eq 'catchalt' ? shift : undef;
	my ($expr, $whens, $stmts) = @_;

	print $fh "$catchclass:" if $catchclass;
	$class->print_node($fh, @$expr);
	$depth++;
	print $fh ' ';

	if (@$whens) {
	    print $fh 'when ';
	    my $first = 1;
	    foreach (@$whens) {
		if ($first) { $first = 0 } else { print $fh ', ' }
		$class->print_node($fh, @$_);
	    }
	    print $fh ' ';
	}
	
	print $fh "->\n", "\t" x $depth;

	my $first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
    } elsif ($kind eq 'fun-local') {
	print $fh 'fun ';

	my $outfirst = 1;
	foreach (@{$_[0]}) {
	    my ($exprs, $whens, $stmts) = @$_;
	    if ($outfirst) { $outfirst = 0 } else { print $fh '; ' }

	    print $fh '(';
	    my $first = 1;
	    foreach (@$exprs) {
		if ($first) { $first = 0 } else { print $fh ', ' }
		$class->print_node($fh, @$_);
	    }

	    print $fh ') ';

	    if (@$whens) {
		print $fh 'when ';
		$first = 1;
		foreach (@$whens) {
		    if ($first) { $first = 0 } else { print $fh ', ' }
		    $class->print_node($fh, @$_);
		}
		print $fh ' ';
	    }
	   
	    print $fh '-> ';
	    $first = 1;
	    foreach (@$stmts) {
		if ($first) { $first = 0 } else { print $fh ', ' }
		$class->print_node($fh, @$_);
	    }

	}

	print $fh ' end';
    } elsif ($kind eq 'fun-ext') {
	print $fh 'fun ';
	$class->print_node($fh, 'atom', $_[0]);
	print $fh ':';
	$class->print_node($fh, 'atom', $_[1]);
	print $fh "/$_[2]";
    } elsif ($kind eq 'fun-ext-macro') {
	print $fh "fun ?$_[0]:";
	$class->print_node($fh, 'atom', $_[1]);
	print $fh "/$_[2]";
    } elsif ($kind eq 'fun-ext-var') {
	print $fh "fun $_[0]:";
	$class->print_node($fh, 'atom', $_[1]);
	print $fh "/$_[2]";
    } elsif ($kind eq 'fun-int') {
	print $fh "fun $_[0]/$_[1]";
    } elsif ($kind eq 'record-new') {
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
    } elsif ($kind eq 'literal') {
	print $fh '$';
	print $fh $_[0];
    } elsif ($kind eq 'try') {
	my ($exprs, $alts, $catches, $afters) = @_;

	print $fh "try\n";

	$depth++;
	print $fh "\t" x $depth;

	my $first = 1;
	foreach (@$exprs) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
	print $fh "\n", "\t" x $depth;

	if ($alts) {
	    print $fh "of\n";

	    $depth++;
	    print $fh "\t" x $depth;

	    my $first = 1;
	    foreach (@$alts) {
		if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
		$class->print_node($fh, @$_);
	    }

	    $depth--;
	    print $fh "\n", "\t" x $depth;
	}

	if ($catches) {
	    print $fh "catch\n";

	    $depth++;
	    print $fh "\t" x $depth;

	    my $first = 1;
	    foreach (@$catches) {
		if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
		$class->print_node($fh, @$_);
	    }

	    $depth--;
	    print $fh "\n", "\t" x $depth;
	}

	if ($afters) {
	    print $fh "after\n";

	    $depth++;
	    print $fh "\t" x $depth;

	    my $first = 1;
	    foreach (@$afters) {
		if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
		$class->print_node($fh, @$_);
	    }

	    $depth--;
	    print $fh "\n", "\t" x $depth;
	}
    
	print $fh "end";
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
