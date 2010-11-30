package CMS::Lite::Model::Adsense;
use strict;
use warnings;
use utf8;
use Carp ();
use CMS::Lite::Croak;
use CMS::Lite::Config;

sub new {
    my $class = shift;
    my $self = bless { 
        _adsense_data => CMS::Lite::Config->adsense_data,
    }, $class;
}

sub client { $_[0]->{_adsense_data}->{client} }
sub slot   { $_[0]->{_adsense_data}->{slot}   }

sub script {
    my $self = shift;
    
    ### XXX: 面倒だからここでチェックしてしまえ
    my $client = $self->client or Carp::croak("NotFound: client");
    my $slot   = $self->slot or Carp::croak("NotFound: slot");

    my $script;

    $script .= qq{<script type="text/javascript"><!--\n};
    $script .= qq{google_ad_client = "$client";\n};
    $script .= qq{google_ad_slot = "$slot";\n};
    $script .= qq{google_ad_width = 120;\n};
    $script .= qq{google_ad_height = 600;\n};
    $script .= qq{//-->\n};
    $script .= qq{</script>\n};
    $script .= qq{<script type="text/javascript"\n};
    $script .= qq{src="http://pagead2.googlesyndication.com/pagead/show_ads.js">\n};
    $script .= qq{</script>\n};
    
    return $script;
} 


1;

