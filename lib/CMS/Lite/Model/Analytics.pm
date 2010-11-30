package CMS::Lite::Model::Analytics;
use strict;
use warnings;
use utf8;
use Carp ();
use CMS::Lite::Croak;
use CMS::Lite::Config;

sub new {
    my $class = shift;
    my $self = bless { 
        _analytics_data => CMS::Lite::Config->analytics_data,
    }, $class;
}

sub account { $_[0]->{_analytics_data}->{account} }

sub script {
    my $self = shift;

    my $account  = $self->account or Carp::croak("NotFound: account");

    my $script;
    $script .= qq{<script type="text/javascript">\n};
    $script .= qq{var _gaq = _gaq || [];\n};
    $script .= qq{_gaq.push(['_setAccount'$account'])\n};
    $script .= qq{_gaq.push(['_trackPageview'])\n};
    $script .= "(function() {\n";
    $script .= qq{var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n};
    $script .= qq{ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';\n};
    $script .= qq{var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n};
    $script .= "/})()\n";
    $script .= qq{</script>\n};
    
    return $script;
} 


1;

