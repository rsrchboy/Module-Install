# $File: //depot/cpan/Module-Install/lib/Module/Install/Admin/ScanDeps.pm $ $Author: autrijus $
# $Revision: #14 $ $Change: 1781 $ $DateTime: 2003/10/22 17:14:03 $ vim: expandtab shiftwidth=4

package Module::Install::Admin::ScanDeps;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

sub scan_dependencies {
    my ($self, $pkg, $perl_version) = @_;
    $perl_version ||= $];

    require Module::ScanDeps;
    require Module::CoreList;

    die "Module::CoreList has no information on perl $perl_version"
        unless exists $Module::CoreList::version{$perl_version};

    if (my $min_version = Module::CoreList->first_release($pkg)) {
        return if $min_version <= $perl_version;
    }

    my @files = scalar $self->admin->find_in_inc($pkg)
        or die "Cannot find $pkg in \@INC";
    my %result = ($pkg => $files[0]);

    while (@files) {
        my $deps = Module::ScanDeps::scan_deps(
            files   => \@files,
            recurse => 0,
        );

        @files = ();

        foreach my $key (keys %$deps) {
            if ($deps->{$key}{type} eq 'shared') {
                foreach my $used_by (@{$deps->{$key}{used_by}}) {
                    $used_by =~ s!/!::!;
                    $used_by =~ s!\.pm\Z!!i or next;
                    next if exists $result{$used_by};
                    $result{$used_by} = undef;
                    print "skipped $used_by (needs shared library)\n";
                }
            }

            my $dep_pkg = $key;
            $dep_pkg =~ s!/!::!;
            $dep_pkg =~ s!\.pm\Z!!i or next;

            if (my $min_version = Module::CoreList->first_release($dep_pkg)) {
                next if $min_version <= $perl_version;
            }
            next if $dep_pkg =~ /^(?:DB|(?:Auto|Dyna|XS)Loader|threads|warnings)\b/i;
            next if exists $result{$dep_pkg};

            $result{$dep_pkg} = $deps->{$key}{file};
            push @files, $deps->{$key}{file};
        }
    }

    while (my($k,$v) = each %result) {
        delete $result{$k} unless defined $v;
    }
    return \%result;
}

1;
