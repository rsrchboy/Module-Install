# $File: //depot/cpan/Module-Install/Makefile.PL $ $Author: autrijus $
# $Revision: #28 $ $Change: 1557 $ $DateTime: 2003/05/26 02:19:12 $ vim: expandtab shiftwidth=4

use lib 'lib'; # NOTE: Module::Install's Makefile.PL needs this statement
               # to bootstrap itself.  Other module distributions using
               # Module::Install do not need it.

use inc::Module::Install;

name            ('Module-Install');
abstract        ('Standalone, extensible Perl module installer');
author          ('Autrijus Tang (autrijus@autrijus.org)');
version_from    ('lib/Module/Install.pm');
license         ('perl');

include         ('ExtUtils::AutoInstall');
features(
    'Include packages with full dependencies' => [
        -default            => 0,
        'Test::Harness'     => 2.03,    # merely a dependency of M::CoreList
        'Test::More'        => 0,       # ditto
        recommends  ('Module::ScanDeps' => 0.17),
        recommends  ('Module::CoreList'),
    ],
    'PAR-based binary distributions' => [
        -default            => 0,
        'Compress::Zlib'    => 0,
        recommends  ('Archive::Zip'     => 1.00),
    ],
    'Module::Build support' => [
        -default            => 0,
        recommends  ('Archive::Tar'     => 0.23),
        recommends  ('ExtUtils::Install'=> 0.3),
        recommends  ('ExtUtils::ParseXS'),
        recommends  ('YAML'             => 0.35),
        recommends  ('Module::Build'),
    ],
);

auto_install_now( -config => { prerequisites_policy => 'follow' } );

# XXX: eventually adopt '**' or '...' ?
#include         ('Module::Build::*');
#include         ('Module::Build::*::*');
#include         ('Module::Build::*::*::*');

include_deps    ('Test::More', 5.004);
build_requires  ('Test::More', 0);

par_base();     # par_base('AUTRIJUS') to enable downloading
check_nmake();

&Meta->write;
&Build->write    if lc($0) eq 'build.pl';
&Makefile->write if lc($0) eq 'makefile.pl';
