#!/usr/bin/perl
# $File: //depot/cpan/Module-Install/t/0-signature.t $ $Author: autrijus $
# $Revision: #4 $ $Change: 1313 $ $DateTime: 2003/03/08 02:30:22 $ vim: expandtab shiftwidth=4

use strict;
print "1..1\n";

if (!-s 'SIGNATURE') {
    print "ok 1 # skip - No signature file found";
}
elsif (!eval { require Socket; Socket::inet_aton('pgp.mit.edu') }) {
    print "ok 1 # skip - Cannot connect to the keyserver";
}
elsif (!eval { require Module::Signature; 1 }) {
    warn "# Next time around, consider install Module::Signature,\n".
         "# so you can verify the integrity of this distribution.\n";
    print "ok 1 # skip - Module::Signature not installed\n";
}
else {
    (Module::Signature::verify() == Module::Signature::SIGNATURE_OK())
        or print "not ";
    print "ok 1 # Valid signature\n";
}

