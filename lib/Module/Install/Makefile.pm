# $File: //depot/cpan/Module-Install/lib/Module/Install/Makefile.pm $ $Author: autrijus $
# $Revision: #39 $ $Change: 1398 $ $DateTime: 2003/03/26 08:45:50 $ vim: expandtab shiftwidth=4

package Module::Install::Makefile;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict 'vars';
use vars '$VERSION';

use ExtUtils::MakeMaker ();

sub Makefile { $_[0] }

sub prompt { 
    shift;
    goto &ExtUtils::MakeMaker::prompt;
}

sub makemaker_args {
    my $self = shift;
    my $args = ($self->{makemaker_args} ||= {});
    %$args = ( %$args, @_ ) if @_;
    $args;
}

sub clean_files {
    my $self = shift;
    $self->makemaker_args( clean => { FILES => "@_ " } );
}

sub write {
    my $self = shift;
    die "&Makefile->write() takes no arguments\n" if @_;

    my $args = $self->makemaker_args;

    $args->{NAME} = $self->name || $self->determine_NAME($args);
    $args->{VERSION} = $self->version;

    if ($] >= 5.005) {
	$args->{ABSTRACT} = $self->abstract;
	$args->{AUTHOR} = $self->author;
    }

    # merge both kinds of requires into prereq_pm
    my $prereq = ($args->{PREREQ_PM} ||= {});
    %$prereq = ( %$prereq, map { @{$_} } @{ $self->$_ } )
        for grep $self->$_, qw(requires build_requires);

    # merge both kinds of requires into prereq_pm
    my $dir = ($args->{DIR} ||= []);
    push @$dir, map "$self->{prefix}/$self->{bundle}/$_->[1]", @{$self->bundles}
        if $self->bundles;

    my %args = map {($_ => $args->{$_})} grep {defined($args->{$_})} keys %$args;

    if ($self->admin->preop) {
        $args{dist} = $self->admin->preop;
    }

    ExtUtils::MakeMaker::WriteMakefile(%args);

    $self->fix_up_makefile();
}

sub fix_up_makefile {
    my $self = shift;
    my $top_class = ref($self->_top);
    my $top_version = $self->_top->VERSION;

    my $preamble = $self->preamble 
       ? "# Preamble by $top_class $top_version\n" . $self->preamble
       : '';
    my $postamble = "# Postamble by $top_class $top_version\n" . 
                    $self->postamble;

    open MAKEFILE, '< Makefile' or die $!;
    my $makefile = do { local $/; <MAKEFILE> };
    close MAKEFILE;

    open MAKEFILE, '> Makefile' or die $!;
    print MAKEFILE "$preamble$makefile$postamble";
    close MAKEFILE;
}

sub preamble {
    my ($self, $text) = @_;
    $self->{preamble} = $text . $self->{preamble} if defined $text;
    $self->{preamble};
}

sub postamble {
    my ($self, $text) = @_;

    $self->{postamble} ||= $self->admin->postamble;
    $self->{postamble} .= $text if defined $text;
    $self->{postamble}
}

1;

__END__

=head1 NAME

Module::Install::MakeMaker - Extension Rules for ExtUtils::MakeMaker

=head1 VERSION

This document describes version 0.01 of Module::Install::MakeMaker, released
March 1, 2003.

=head1 SYNOPSIS

In your F<Makefile.PL>:

    use inc::Module::Install;
    WriteMakefile();

=head1 DESCRIPTION

This module is a wrapper around B<ExtUtils::MakeMaker>.  It exports
two functions: C<prompt> (an alias for C<ExtUtils::MakeMaker::prompt>)
and C<WriteMakefile>.

The C<WriteMakefile> function will pass on keyword/value pair functions
to C<ExtUtils::MakeMaker::WriteMakefile>. The required parameters
C<NAME> and C<VERSION> (or C<VERSION_FROM>) are not necessary if
it can find them unambiguously in your code.

=head1 CONFIGURATION OPTIONS

This module also adds some Configuration parameters of its own:

=head2 NAME

The NAME parameter is required by B<ExtUtils::MakeMaker>. If you have a
single module in your distribution, or if the module name indicated by
the current directory exists under F<lib/>, this module will use the
guessed package name as the default.

If this module can't find a default for C<NAME> it will ask you to specify
it manually.

=head2 VERSION

B<ExtUtils::MakeMaker> requires either the C<VERSION> or C<VERSION_FROM>
parameter.  If this module can guess the package's C<NAME>, it will attempt
to parse the C<VERSION> from it.

If this module can't find a default for C<VERSION> it will ask you to
specify it manually.

=head1 MAKE TARGETS

B<ExtUtils::MakeMaker> provides you with many useful C<make> targets. A
C<make> B<target> is the word you specify after C<make>, like C<test>
for C<make test>. Some of the more useful targets are:

=over 4

=item * all

This is the default target. When you type C<make> it is the same as
entering C<make all>. This target builds all of your code and stages it
in the C<blib> directory.

=item * test

Run your distribution's test suite.

=item * install

Copy the contents of the C<blib> directory into the appropriate
directories in your Perl installation.

=item * dist

Create a distribution tarball, ready for uploading to CPAN or sharing
with a friend.

=item * clean distclean purge

Remove the files created by C<perl Makefile.PL> and C<make>.

=item * help

Same as typing C<perldoc ExtUtils::MakeMaker>.

=back

This module modifies the behaviour of some of these targets, depending
on your requirements, and also adds the following targets to your Makefile:

=over 4

=item * cpurge

Just like purge, except that it also deletes the files originally added
by this module itself.

=item * chelp

Short cut for typing C<perldoc Module::Install>.

=item * distsign

Short cut for typing C<cpansign -s>, for B<Module::Signature> users to
sign the distribution before release.

=back

=head1 SEE ALSO

L<Module::Install>, L<CPAN::MakeMaker>, L<CPAN::MakeMaker-Philosophy>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

Based on original works by Brian Ingerson E<lt>INGY@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2003 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.
Copyright (c) 2002. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
