# $File: //member/autrijus/.vimrc $ $Author: autrijus $
# $Revision: #14 $ $Change: 4137 $ $DateTime: 2003/02/08 11:41:59 $

package Module::Install::Admin::Bundle;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.01';

sub bundle {
    my $self = shift;
    my $bundle_dir = $self->_top->{bundle};

    require Cwd;
    require CPANPLUS::Backend;

    my $cwd  = Cwd::getcwd();
    my $cp   = CPANPLUS::Backend->new;
    my $conf = $cp->configure_object;
    my $modtree = $cp->module_tree;

    mkdir $bundle_dir;

    my %bundles;
    while (my ($name, $version) = splice(@_, 0, 2)) {
        my $fetch_result = $cp->fetch(
            modules     => [$name],
            fetchdir    => $bundle_dir,
        );
        my $rv = $fetch_result->rv or next;
        my $file = $rv->{$name} or next;
	$file = Cwd::abs_path($file);

        my $extract_result = $cp->extract(
            files       => [$file],
            extractdir  => $bundle_dir,
        );

	unlink $file;

        $rv = $extract_result->rv or next;
	my $filename = $rv->{$file} or next;
	$bundles{$name} = $filename;
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
