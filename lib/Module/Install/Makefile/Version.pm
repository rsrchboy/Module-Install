# $File: //depot/cpan/Module-Install/lib/Module/Install/Makefile/Version.pm $ $Author: autrijus $
# $Revision: #12 $ $Change: 1375 $ $DateTime: 2003/03/18 12:29:32 $ vim: expandtab shiftwidth=4

package Module::Install::Makefile::Version;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict;

sub determine_VERSION {
    my $self = shift;
    my @modules = glob('*.pm');

    require File::Find;
    File::Find::find(sub { push @modules, $File::Find::name if /\.pm/i }, 'lib');

    if (@modules == 1) {
        eval {
            $self->version(ExtUtils::MM_Unix->parse_version($modules[0]));
        };
        print STDERR $@ if $@;
    }
    elsif (my $file = "lib/" . $self->name . ".pm") {
        $file =~ s!-!/!g;
        $self->version(ExtUtils::MM_Unix->parse_version($file)) if -f $file;
    }

    $self->version or die << "END";
Can't determine a VERSION for this distribution.
Please call the 'version' or 'version_from' function in Makefile.PL.
END
}

1;
