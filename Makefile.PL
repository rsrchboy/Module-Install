# $File: //depot/cpan/Module-Install/Makefile.PL $ $Author: autrijus $
# $Revision: #37 $ $Change: 2287 $ $DateTime: 2004/07/01 04:48:23 $ vim: expandtab shiftwidth=4

use lib 'lib'; # NOTE: Module::Install's Makefile.PL needs this statement
               # to bootstrap itself.  Other module distributions using
               # Module::Install do not need it.

use inc::Module::Install;

name            ('Module-Install');
author          ('Autrijus Tang (autrijus@autrijus.org)');
abstract_from   ('lib/Module/Install.pm');
version_from    ('lib/Module/Install.pm');
license         ('perl');
requires        ('perl' => 5.004);
no_index        (directory => 'example');
sign            (1);

build_requires  ('Test::More');
include         ('ExtUtils::AutoInstall');

features(
    'Include packages with full dependencies' => [
        -default            => 0,
        'Test::Harness'     => 2.03,    # merely a dependency of M::CoreList
        'Test::More'        => 0,       # ditto
        recommends  ('Module::ScanDeps' => 0.28),
        recommends  ('Module::CoreList'),
    ],
    'Bundle other CPAN packages' => [
        -default            => 0,
        recommends  ('CPANPLUS' => 0.040),
    ],
    'PAR-based binary distributions' => [
        -default            => 0,
        recommends  ('PAR::Dist' => 0.03),
    ],
    'Module::Build support' => [
        -default            => 0,
        'Archive::Tar'      => 0.23,
        'ExtUtils::Install' => 0.3,
        'ExtUtils::ParseXS' => 0,
        'YAML'              => 0.35,
        recommends  ('Module::Build'),
    ],
);

auto_include_deps();
auto_install_now( -config => { prerequisites_policy => 'follow' } );

par_base();     # par_base('AUTRIJUS') to enable downloading

&WriteAll;
