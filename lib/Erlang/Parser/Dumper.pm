# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Erlang::Parser::Dumper;

use strict;
use warnings;
use 5.014;

use Data::Dumper;

sub print_tree {
    my $class = shift;
    my $fh = shift;
    $class->print_node($fh, @$_) foreach (@{$_[0]});
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
	print $fh "$_[0]";
    } elsif ($kind eq 'list') {
	my ($args) = @_;
	print $fh '[';
	my $first = 1;
	foreach (@$args) {
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
    } elsif ($kind eq 'integer') {
	print $fh $_[0];
    } elsif ($kind eq 'def') {
	my ($name, $stmts) = @_;
	print $fh "$name() ->\n\t";
	my $first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print $fh ",\n\t" }
	    $class->print_node($fh, @$_);
	}
	print $fh ".\n";
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
    } else {
	print $fh "<<", Dumper($kind), ">>";
    }
}

1;

# vim: set sw=4:
