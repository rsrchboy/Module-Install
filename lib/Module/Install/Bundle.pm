# $File: //depot/cpan/Module-Install/lib/Module/Install/Bundle.pm $ $Author: autrijus $
# $Revision: #5 $ $Change: 1805 $ $DateTime: 2003/12/11 18:43:02 $ vim: expandtab shiftwidth=4

package Module::Install::Bundle;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

use strict;
use Cwd ();
use File::Find ();
use File::Copy ();
use File::Basename ();

sub auto_bundle {
    my $self = shift;

    # Flatten array of arrays into a single array
    my @core = map @$_, map @$_, grep ref,
               $self->build_requires, $self->requires;

    $self->bundle(@core);
}

sub bundle {
    my $self = shift;
    $self->admin->bundle(@_) if $self->is_admin;

    my $cwd = Cwd::cwd();
    my $bundles = $self->read_bundles;
    my $bundle_dir = $self->_top->{bundle};
    $bundle_dir =~ s/\W+/\\W+/g;

    while (my ($name, $version) = splice(@_, 0, 2)) {
        next if eval "use $name $version; 1";
        my $source = $bundles->{$name} or next;
        my $target = File::Basename::basename($source);
        mkdir $target or die $! unless -d $target;

        # XXX - clean those directories upon "make clean"
        File::Find::find({
            wanted => sub {
                my $out = $_;
                $out =~ s/$bundle_dir/./i;
                mkdir $out if -d;
                File::Copy::copy($_ => $out) unless -d;
            },
            no_chdir => 1,
        }, $source);

        $self->bundles($name, $target);
    }

    chdir $cwd;
}

sub read_bundles {
    my $self = shift;
    my %map;

    local *FH;
    open FH, $self->_top->{bundle} . ".yml" or return {};
    while (<FH>) {
        /^(.*?): (['"])?(.*?)\2$/ or next;
        $map{$1} = $3;
    }
    close FH;

    return \%map;
}

sub bundle_deps {
    warn "bundle_deps() not yet implemented, sorry.\n";
}

1;

__END__

=head1 NAME

Module::Install::Bundle - Bundle distributions along with your distribution

=head1 SYNOPSIS

Have your Makefile.PL read as follows:

  use inc::Module::Install;

  name("Foo-Bar");
  version_from("lib/Foo/Bar.pm");
  abstract("Description of your distribution");
  author("Your Name <your@email.com>");
  license("gpl"); # or "perl", etc
  requires("Baz" => "1.60");
  check_nmake();

  # one of either:
  auto_bundle(); # OR
  bundle("Baz" => "1.60");

  &Meta->write;
  &Build->write if lc($0) eq "build.pl";
  &Makefile->write if lc($0) eq "makefile.pl";

=head1 DESCRIPTION

Module::Install::Bundle allows you to bundle a CPAN distribution within your
distribution. When your end-users install your distribution, the bundled
distribution will be installed along with yours, unless a newer version of the
bundled distribution already exists on their local filesystem.

While bundling will increase the size of your distribution, it has several
benefits:

  Allows installation of bundled distributions when CPAN is unavailable
  Allows installation of bundled distributions when networking is unavailable
  Allows everything your distribution needs to be packaged in one place

Bundling differs from auto-installation in that when it comes time to
install, a bundled distribution will be installed based on the distribution
bundled with your distribution, whereas with auto-installation the distibution
to be installed will be acquired from CPAN and then installed.

=head1 METHODS

=over 4

=item * L<auto_bundle>

Takes no arguments, will bundle every distribution specified by a requires().
When you, as a module author, do a perl Makefile.PL the latest versions of the
distributions to be bundled will be acquired from CPAN and placed in
inc/BUNDLES/.

=item * L<bundle>

Takes a list of key/value pairs specifying a distribution name and version
number. When you, as a module author, do a perl Makefile.PL the distributions
that you specified with bundle() will be acquired from CPAN and placed in
inc/BUNDLES/.

=back

=head1 BUGS

  Please report any bugs to (patches welcome):
  http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Install

=head1 COPYRIGHT

  Copyright 2003 by Autrijus Tang <autrijus@autrijus.org>.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item * L<perl>

=item * L<ExtUtils::AutoInstall>

=back

=head1 AUTHORS

  Autrijus Tang <autrijus@autrijus.org>
  Documentation by Adam Foxson <afoxson@pobox.com>

=cut
