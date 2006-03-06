package Module::Install::Share;

BEGIN {
	$VERSION = '0.59';
	@ISA     = qw{Module::Install::Base};
}

use strict;
use Module::Install::Base;

sub install_share {
    my ($self, $dir) = @_;

    if ( ! defined $dir ) {
        die "Cannot find the 'share' directory" unless -d 'share';
        $dir = 'share';
    }

    $self->postamble(<<"END_MAKEFILE");
config ::
\t\$(NOECHO) \$(MOD_INSTALL) \\
\t\t\"$dir\" \$(INST_AUTODIR)

END_MAKEFILE
}

1;

__END__

=pod

=head1 NAME

Module::Install::Share - Install non-code files for use during run-time

=head1 SYNOPSIS

    # Put everything inside ./share/ into the distribution 'auto' path
    install_share 'share';

    # Same thing as above using the default directory name
    install_share;

=head1 DESCRIPTION

As well as Perl modules and Perl binary applications, some distributions
need to install read-only data files to a location on the file system
for use at run-time.

XML Schemas, L<YAML> data files, and L<SQLite> databases are examples of
the sort of things distributions might typically need to have available
after installation.

C<Module::Install::Share> is a L<Module::Install> extension that provides
commands to allow these files to be installed to the applicable location
on disk.

To locate the files after installation so they can be used inside your
module, see this extension's companion module L<File::ShareDir>.

=head1 TO DO

Currently C<install_share> installs not only the files you want, but
if called by the author will also copy F<.svn> and other source-control
directories, and other junk.

Enhance this to copy only files under F<share> that are in the
F<MANIFEST>, or possibly those not in F<MANIFEST.SKIP>.

=head1 AUTHORS

Audrey Tang E<lt>autrijus@autrijus.orgE<gt>

Adam Kennedy E<lt>cpan@ali.asE<gt>

=head1 SEE ALSO

L<Module::Install>, L<File::ShareDir>

=head1 COPYRIGHT

Copyright 2006 Audrey Tang, Adam Kennedy. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
