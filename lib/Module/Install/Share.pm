package Module::Install::Share;

use Module::Install::Base;
@ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict;

sub install_share {
    my $self = shift;
    my $dir  = shift;

    if ( ! defined $dir ) {
        die "Cannot find the 'share' directory" unless -d 'share';
        $dir = 'share';
    }

    $self->postamble(<<".");
config ::
\t\$(NOECHO) \$(MOD_INSTALL) \\
\t\t\"$dir\" \$(INST_ARCHAUTODIR)

.
}

__END__

=head1 NAME

Module::Install::Share - Install non-code files for use during runtime

=head1 SYNOPSIS

    # Put everything inside ./share/ into the distribution 'auto' path
    install_share 'share';

    # Same thing as above using the default directory name
    install_share;

=head1 DESCRIPTION

As well as Perl modules and Perl binary applications, some distributions
need to install read-only data files to a location on the file system
for use at run-time.

XML Schemas, YAML data files, and SQLite databases are examples of the
sort of things distributions might typically need to have available
after installation.

Module::Install::Share is a L<Module::Install> extension that provides
commands to allow these files to be installed to the applicable location
on disk.

To locate the files after installation so they can be used inside your
module, see this extension's companion module L<File::ShareDir>.

=head1 SEE ALSO

L<Module::Install>, L<File::ShareDir>

=cut
