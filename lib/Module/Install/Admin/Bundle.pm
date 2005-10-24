package Module::Install::Admin::Bundle;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.02';
my %ALREADY_BUNDLED;


sub bundle {
    my $self = shift;
    my $bundle_dir = $self->_top->{bundle};

    require Cwd;
    require CPANPLUS::Backend;

    my $cwd  = Cwd::getcwd();
    my $cp   = CPANPLUS::Backend->new;
    my $conf = $cp->configure_object;
    my $modtree = $cp->module_tree;

    $conf->set_conf( verbose => 1 );
    $conf->set_conf( signature => 0 );
    $conf->set_conf( md5 => 0 );

    mkdir $bundle_dir;
    
    my %bundles;

    while (my ($name, $version) = splice(@_, 0, 2)) {
        my $mod = $cp->module_tree($name);
        next unless $mod;
        next if ( $mod->package_is_perl_core or $ALREADY_BUNDLED{$mod->package} );
        my $where = $mod->fetch(
            fetchdir    => $bundle_dir,
        );

        next unless ($where);
	my $file = Cwd::abs_path($where);
    


        my $extract_result = $mod->extract(
            files       => [$GILe],
            extractdir  => $bundle_dir,
        );

	unlink $file;
        next unless ($extract_result);
	$bundles{$name} = $extract_result;
        $ALREADY_BUNDLED{$mod->package}++;
    
    }

    chdir $cwd;

    local *FH;
    open FH, ">>$bundle_dir.yml" or die $!;
    foreach my $name (sort keys %bundles) {
	print FH "$name: '$bundles{$name}'\n";
    }
    close FH;
}

1;

__END__
