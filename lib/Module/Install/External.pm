package Module::Install::External;

# Provides dependency declarations for external non-Perl things

use Module::Install::Base;
@ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict;

sub requires_external {
	my ($self, $type, @args) = @_;

	# Check the dependency type
	unless ( defined $type and ! ref $type ) {
		die "Did not provide an external dependency type";
	}
	unless ( $type =~ /^\w+$/ ) {
		die "Invalid external dependency type '$type'";
	}
	my $method = 'requires_external_' . $type;
	unless ( $self->can($method) ) {
		die "External dependency type '$type' is not implemented (yet)";
	}

	# Hand off to the specific method
	$self->$method(@args);
}

sub requires_external_bin {
	my ($self, $bin, $version) = @_;
	if ( $version ) {
		die "requires_external_bin does not support versions (yet)";
	}

	# Load the can_run package early
	# to avoid breaking the message below.
	$self->load('can_run');

	# Locate the bin
	print "Locating required external dependency bin:$bin...";
	my $found_bin = $self->can_run( $bin );
	if ( $found_bin ) {
		print " found at $found_bin.\n";
	} else {
		print " missing.\n";
		print "Unresolvable missing external dependency.\n";
		print "Please install '$bin' seperately and try again.\n";
		print STDERR "NA: Unable to build distribution on this platform.\n";
		exit(255);
	}

	# Once we have some way to specify external deps, do it here.
	# In the mean time, continue as normal.

	1;
}

1;
