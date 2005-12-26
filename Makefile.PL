#!perl -w

use strict;
use lib 'lib'; # NOTE: Module::Install's Makefile.PL needs this statement
               # to bootstrap itself.  Other module distributions using
               # Module::Install do not need it.
use inc::Module::Install;

name        'Module-Install';
author      'Audrey Tang <autrijus@autrijus.org>';
all_from    'lib/Module/Install.pm';
requires     'YAML' => 0.35;

feature 'Include packages with full dependencies',
    recommends
    'Test::Harness'     => 2.03,    # merely a dependency of M::CoreList
    'Test::More'        => 0,       # ditto
    'Module::ScanDeps'  => 0.28,
    'Module::CoreList';

feature 'Bundle other CPAN packages',
    recommends
    'CPANPLUS'          => 0.040;

feature 'PAR-based binary distributions',
    recommends
    'PAR::Dist'         => 0.03;

feature 'Module::Build support',
    'Archive::Tar'      => 0.23,
    'ExtUtils::Install' => 0.3,
    'ExtUtils::ParseXS',
    recommends
    'Module::Build';

no_index
    directory => 'example';

auto_install_now
    prerequisites_policy => 'follow';

auto_provides;

sign;
WriteAll;
