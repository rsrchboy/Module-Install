# $File: //depot/cpan/Module-Install/lib/Module/Install/Admin/Makefile.pm $ $Author: ingy $
# $Revision: #5 $ $Change: 1474 $ $DateTime: 2003/05/05 15:25:47 $ vim: expandtab shiftwidth=4

package Module::Install::Admin::Makefile;
use Module::Install::Base; @ISA = qw(Module::Install::Base);

$VERSION = '0.01';

use strict 'vars';
use vars '$VERSION';

use ExtUtils::MakeMaker ();

sub postamble {
    my ($self, $text) = @_;
    my $class = ref($self);
    my $top_class = ref($self->_top);
    my $admin_class = join('::', @{$self->_top}{qw(name dispatch)});

    $self->{postamble} ||= << "END";
# --- $class section:

realclean purge ::
\t\$(RM_F) \$(DISTVNAME).tar\$(SUFFIX)

reset :: purge
\t\$(RM_RF) inc MANIFEST.bak _build
\t\$(PERL) -I. -M$admin_class -e \"remove_meta()\"

upload :: test dist
\tcpan-upload -verbose \$(DISTVNAME).tar\$(SUFFIX)

grok ::
\tperldoc $top_class

distsign ::
\tcpansign -s

END
    $self->{postamble} .= $text if defined $text;
    $self->{postamble};
}

sub preop {
    my $self = shift;
    my $admin_class = join('::', @{$self->_top}{qw(name dispatch)});
    +{ PREOP => qq{\$(PERL) -I. -M$admin_class -e "dist_preop()"} }
}

1;
