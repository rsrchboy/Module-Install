# $File: //depot/cpan/Module-Install/lib/inc/Module/Install.pm $ $Author: ingy $
# $Revision: #12 $ $Change: 1474 $ $DateTime: 2003/05/05 15:25:47 $ vim: expandtab shiftwidth=4

if (-d 'inc/.author') {
    use File::Path;
    rmtree('inc');
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

This module simply unshifts C<inc> into C<@INC>, then loads
B<Module::Install> from there.  Below is an explanation of the reason
for using a I<loader module>:

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

Copyright 2003 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
