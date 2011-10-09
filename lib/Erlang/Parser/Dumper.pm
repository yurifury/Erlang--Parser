# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Dumper;

use strict;
use warnings;
use 5.014;

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

    if ($kind eq 'directive') {
	my ($directive, $args) = @_;
	print $fh "-$directive(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ").\n";
    } elsif ($kind eq 'atom') {
	if (not $_[0] =~ /^[^a-z]|[^a-zA-Z_0-9]/) {
	    print $fh "$_[0]";
	} else {
	    print $fh "'";
	    print $fh $_[0] =~ s/\\/\\\\/rg =~ s/'/\\'/rg;
	    print $fh "'";
	}
    } elsif ($kind eq 'list') {
	print $fh '[';
	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ']';
    } elsif ($kind eq 'divide') {
	print $fh '(';
	$class->print_node($fh, @{$_[0]});
	print $fh '/';
	$class->print_node($fh, @{$_[1]});
	print $fh ')';
    } elsif ($kind eq 'multiply') {
	print $fh '(';
	$class->print_node($fh, @{$_[0]});
	print $fh '*';
	$class->print_node($fh, @{$_[1]});
	print $fh ')';
    } elsif ($kind eq 'add') {
	print $fh '(';
	$class->print_node($fh, @{$_[0]});
	print $fh '+';
	$class->print_node($fh, @{$_[1]});
	print $fh ')';
    } elsif ($kind eq 'subtract') {
	print $fh '(';
	$class->print_node($fh, @{$_[0]});
	print $fh '-';
	$class->print_node($fh, @{$_[1]});
	print $fh ')';
    } elsif ($kind eq 'equals') {
	$class->print_node($fh, @{$_[0]});
	print $fh ' = ';
	$class->print_node($fh, @{$_[1]});
    } elsif ($kind eq 'integer') {
	print $fh $_[0];
    } elsif ($kind eq 'deflist') {
	my $first = 1;
	foreach (@{$_[0]}) {
	    if ($first) { $first = 0 } else { print $fh ";\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}
	print $fh ".\n";
    } elsif ($kind eq 'def') {
	my ($name, $args, $stmts) = @_;
	print $fh "$name(";
    
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	
	$depth++;

	print $fh ") ->\n", "\t" x $depth;
	$first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
    } elsif ($kind eq 'intcall') {
	my ($fun, $args) = @_;
	print $fh "$fun(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ')';
    } elsif ($kind eq 'extcall') {
	my ($mod, $fun, $args) = (split(':', $_[0]), $_[1]);
	print $fh "$mod:$fun(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}
	print $fh ')';
    } elsif ($kind eq 'string') {
	print $fh '"';
	print $fh $_[0] =~ s/\\/\\\\/rg =~ s/"/\\"/rg;
	print $fh '"';
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
    } elsif ($kind eq 'alt') {
	my ($expr, $stmts) = @_;

	$class->print_node($fh, @$expr);
	$depth++;
	print $fh " ->\n", "\t" x $depth;

	my $first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ",\n", "\t" x $depth }
	    $class->print_node($fh, @$_);
	}

	$depth--;
    } elsif ($kind eq 'fun-local') {
	my ($exprs, $stmts) = @_;
	print $fh 'fun(';

	my $first = 1;
	foreach (@$exprs) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh ') -> ';
	$first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh ' end';
    } elsif ($kind eq 'fun-ext') {
	print $fh "fun $_[0]";
    } elsif ($kind eq 'fun-int') {
	print $fh "fun $_[0]/$_[1]";
    } elsif ($kind eq 'record-new') {
	print $fh "#$_[0]\{";

	my $first = 1;
	foreach (@{$_[1]}) {
	    if ($first) { $first = 0 } else { print $fh ', ' }
	    $class->print_node($fh, @$_);
	}

	print $fh '}';
    } elsif ($kind eq 'variable-record-access') {
	print $fh "$_[0]#$_[1]";
    } elsif ($kind eq 'variable-record-update') {
	print $fh "$_[0]#$_[1]\{";

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
    } else {
	print $fh "??<", Dumper($kind), ">??";
    }
}

=over 4

=item C<print_node>

Prints a node to the given filehandle.

=cut

1;

# vim: set sw=4:
