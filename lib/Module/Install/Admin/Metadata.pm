package Module::Install::Admin::Metadata;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict;

sub remove_meta {
    my $self = shift;
    my $package = ref($self->_top);
    my $version = $self->_top->VERSION;

    return unless -f 'META.yml';
    open META, 'META.yml'
      or die "Can't open META.yml for output:\n$!";
    my $meta = do {local $/; <META>};
    close META;
    return unless $meta =~ /^generated_by: $package version $version/m;
    unless (-w 'META.yml') {
        warn "Can't remove META.yml file. Not writable.\n";
        return;
    }
    warn "Removing auto-generated META.yml\n";
    unlink 'META.yml'
      or die "Couldn't unlink META.yml:\n$!";
}

1;
