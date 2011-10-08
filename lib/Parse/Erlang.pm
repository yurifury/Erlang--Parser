# Copyright 2011 Anneli Cuss. ( anneli AT cpan DOT org )
# This script is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself.

package Parse::Erlang;

our $VERSION = '0.1';

use Data::Dumper;
use Parse::Erlang::Lexer;
use Parse::Erlang::Parser;

sub print_tree {
    my $class = shift;
    $class->print_node(@$_) foreach (@{$_[0]});
}

sub print_node {
    my $class = shift;
    my $kind = shift;

    if ($kind eq 'directive') {
	my ($directive, $args) = @_;
	print "-$directive(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    $class->print_node(@$_);
	}
	print ").\n";
    } elsif ($kind eq 'atom') {
	print "$_[0]";
    } elsif ($kind eq 'list') {
	my ($args) = @_;
	print '[';
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    $class->print_node(@$_);
	}
	print ']';
    } elsif ($kind eq 'divide') {
	print '(';
	$class->print_node(@{$_[0]});
	print '/';
	$class->print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'multiply') {
	print '(';
	$class->print_node(@{$_[0]});
	print '*';
	$class->print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'add') {
	print '(';
	$class->print_node(@{$_[0]});
	print '+';
	$class->print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'subtract') {
	print '(';
	$class->print_node(@{$_[0]});
	print '-';
	$class->print_node(@{$_[1]});
	print ')';
    } elsif ($kind eq 'integer') {
	print $_[0];
    } elsif ($kind eq 'def') {
	my ($name, $stmts) = @_;
	print "$name() ->\n\t";
	my $first = 1;
	foreach (@$stmts) {
	    if ($first) { $first = 0 } else { print ",\n\t" }
	    $class->print_node(@$_);
	}
	print ".\n";
    } elsif ($kind eq 'extcall') {
	my ($mod, $fun, $args) = (split(':', $_[0]), $_[1]);
	print "$mod:$fun(";
	my $first = 1;
	foreach (@$args) {
	    if ($first) { $first = 0 } else { print ', ' }
	    $class->print_node(@$_);
	}
	print ')';
    } elsif ($kind eq 'string') {
	print "\"$_[0]\"";
    } else {
	print "<<", Dumper($kind), ">>";
    }
}

sub parse {
    my $class = shift;

    my $lexer = new Parse::Erlang::Lexer(@_);
    return (new Parse::Erlang::Parser)->YYParse(yylex => sub { $lexer->lex(@_) });
}

__END__

=head1 NAME

Parse::Erlang - parse Erlang source code

=cut

# vim: set sw=4:
