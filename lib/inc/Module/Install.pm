# $File: //depot/cpan/Module-Install/lib/inc/Module/Install.pm $ $Author: autrijus $
# $Revision: #17 $ $Change: 2301 $ $DateTime: 2004/07/13 07:16:40 $ vim: expandtab shiftwidth=4

package inc::Module::Install;

if (-d 'inc/.author') {
    require File::Path;
    File::Path::rmtree('inc');
}

unshift @INC, 'inc';
require Module::Install;

1;

__END__

=head1 NAME

inc::Module::Install - Module::Install loader

=head1 SYNOPSIS

    use inc::Module::Install;

=head1 DESCRIPTION

This module first checks whether the F<inc/.author> directory exists,
and removes the whole F<inc/> directory if it does, so the module author
always get a fresh F<inc> every time they run F<Makefile.PL>.  Next, it
unshifts C<inc> into C<@INC>, then loads B<Module::Install> from there.

Below is an explanation of the reason for using a I<loader module>:

The original implementation of B<CPAN::MakeMaker> introduces subtle
problems for distributions ending with C<CPAN> (e.g. B<CPAN.pm>,
B<WAIT::Format::CPAN>), because its placement in F<./CPAN/> duplicates
the real libraries that will get installed; also, the directory name
F<./CPAN/> may confuse users.

On the other hand, putting included, for-build-time-only libraries in
F<./inc/> is a normal practice, and there is little chance that a
CPAN distribution will be called C<Something::inc>, so it's much safer
to use.

Also, it allows for other helper modules like B<ExtUtils::AutoInstall>
to reside also in F<inc/>, and to make use of them.

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2003, 2004 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
