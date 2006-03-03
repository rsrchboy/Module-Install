package Module::Install::Compiler;

use strict;
use Module::Install::Base;
use File::Basename ();

use vars qw{$VERSION @ISA};
BEGIN {
	$VERSION = '0.58';
	@ISA     = qw{Module::Install::Base};
}

sub cc_files {
    require Config;
    my $self = shift;
    $self->makemaker_args(
        OBJECT => join ' ', map { substr($_, 0, -2) . $Config::Config{_o} } @_
    );
}

sub cc_inc_paths {
    my $self = shift;
    $self->makemaker_args(
        INC => join ' ', map { "-I$_" } @_
    );
}

sub cc_lib_paths {
    my $self = shift;
    $self->makemaker_args(
        LIBS => join ' ', map { "-L$_" } @_
    );
}

sub cc_lib_links {
    my $self = shift;
    $self->makemaker_args(
        LIBS => join ' ', $self->makemaker_args->{LIBS}, map { "-l$_" } @_
    );
}

sub cc_optimize_flags {
    my $self = shift;
    $self->makemaker_args(
        OPTIMIZE => join ' ', @_
    );
}

1;

__END__

=pod

=head1 NAME

Module::Install::Compiler - Module::Install commands for interacting with the C compiler

=head1 SYNOPSIS

  To be completed

=head1 DESCRIPTION

Many Perl modules that contains C and XS code have fiendishly complex
F<Makefile.PL> files, because L<ExtUtils::MakeMaker> doesn't itself provide
a huge amount of assistance and automation in this area.

B<Module::Install::Compiler> provides a number of commands that take care
of common utility tasks, and try to take some of intricacy out of creating
C and XS modules.

=head1 COMMANDS

To be completed

=head1 SEE ALSO

L<Module::Install>, L<ExtUtils::MakeMaker>

=head1 AUTHORS

Audrey Tang E<lt>autrijus@autrijus.orgE<gt>

Based on original works by Brian Ingerson E<lt>ingy@cpan.orgE<gt>

Documentated and refactored by Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, 2003, 2004, 2006 by
Audrey Tang E<lt>autrijus@autrijus.orgE<gt>,
Brian Ingerson E<lt>ingy@cpan.orgE<gt>,
Adam Kennedy E<lt>adamk@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
