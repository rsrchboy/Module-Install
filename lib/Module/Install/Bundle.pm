# $File: //depot/cpan/Module-Install/lib/Module/Install/Bundle.pm $ $Author: autrijus $
# $Revision: #4 $ $Change: 1375 $ $DateTime: 2003/03/18 12:29:32 $ vim: expandtab shiftwidth=4

package Module::Install::Bundle;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

sub bundle {
    my ($self, $pkg) = @_;
    my $prefix = $self->{prefix};
    my $bundle = $self->{bundle};

    warn "bundle() not yet implemented, sorry.\n";
    return;

    # XXX - put things into inc/bundle/$pkg/
    my $dir = "Acme-Module-0.03";
    $self->bundles($pkg, $dir);
}

sub bundle_deps {
    warn "bundle_deps() not yet implemented, sorry.\n";
}

1;
