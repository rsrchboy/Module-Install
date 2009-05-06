#line 1
package Module::Install::Compiler;

use strict;
use Module::Install::Base;
use File::Basename ();

use vars qw{$VERSION $ISCORE @ISA};
BEGIN {
	$VERSION = '0.87';
	$ISCORE  = 1;
	@ISA     = qw{Module::Install::Base};
}

sub ppport {
	my $self = shift;
	if ( $self->is_admin ) {
		return $self->admin->ppport(@_);
	} else {
		# Fallback to just a check
		my $file = shift || 'ppport.h';
		unless ( -f $file ) {
			die "Packaging error, $file is missing";
		}
	}
}

sub cc_files {
	require Config;
	my $self = shift;
	$self->makemaker_args(
		OBJECT => join ' ', map { substr($_, 0, -2) . $Config::Config{_o} } @_
	);
}

sub cc_inc_paths {
	my $self = shift;
	$self->makemaker_args(
		INC => join ' ', map { "-I$_" } @_
	);
}

sub cc_lib_paths {
	my $self = shift;
	$self->makemaker_args(
		LIBS => join ' ', map { "-L$_" } @_
	);
}

sub cc_lib_links {
	my $self = shift;
	$self->makemaker_args(
		LIBS => join ' ', $self->makemaker_args->{LIBS}, map { "-l$_" } @_
	);
}

sub cc_optimize_flags {
	my $self = shift;
	$self->makemaker_args(
		OPTIMIZE => join ' ', @_
	);
}

1;

__END__

#line 123
