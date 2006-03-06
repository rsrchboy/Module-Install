package Module::Install::Deprecated;

# Although it should never be included with a release, this module
# is used to contain all the deprecated or renamed commands, so authors
# can have them reported fully without bloating releases.

use strict;
use Module::Install::Base;

use vars qw{$VERSION @ISA};
BEGIN {
	$VERSION = '0.59';
	@ISA     = qw{Module::Install::Base};
}

# Deprecations

sub c_files {
	warn "c_files has been changed to cc_files to reduce confusion and keep all compiler commands as cc_";
	shift()->cc_files(@_);
}

sub inc_paths {
	warn "inc_paths has been changed to cc_inc_paths due to confusion between Perl and C";
	shift()->cc_inc_paths(@_);
}

sub lib_paths {
	warn "lib_paths has been changed to cc_lib_paths due to confusion between Perl and C";
	shift()->cc_lib_paths(@_);
}

sub lib_links {
	warn "lib_links has been changed to cc_lib_links due to confusion between Perl and C";
	shift()->cc_lib_links(@_);
}

sub optimize_flags {
	warn "optimize_flags has been changed to cc_optimize_flags for consistency reasons";
	shift()->cc_optimize_flags(@_);
}

1;
