package Module::Install::Admin::Include;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.02';

sub include {
    my ($self, $pattern) = @_;

    foreach my $rv ( $self->admin->glob_in_inc($pattern) ) {
        $self->admin->copy_package(@$rv);
    }
    return $file;
}

sub include_deps {
    my ($self, $pkg) = @_;
    my $deps = $self->admin->scan_dependencies($pkg) or return;

    foreach my $key (sort keys %$deps) {
        $self->include($key);
    }
}

sub auto_include {
    my $self = shift;
    foreach my $module ( map $_->[0], map @$_, grep $_, $self->build_requires ) {
        $self->include($module);
    }
}

sub auto_include_deps {
    my $self = shift;
    foreach my $module ( map $_->[0], map @$_, grep $_, $self->build_requires ) {
        $self->include_deps($module);
    }
}

1;
