package CMS::Lite::Config;
use strict;
use warnings;
use utf8;
use base 'Class::Singleton';
use FindBin qw($Bin);
use Path::Class ();
use Config::Multi;
use Carp ();
use CMS::Lite::Croak;
use CMS::Lite::Validate;

our $CONF_DIR  = Path::Class::Dir->new( $Bin, '..', 'conf' );
our $APP_NAME  = 'config';
our $EXTENSION = 'yml';

sub ftp_data {
    my $data = CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{ftp_data} );
    return my @info = ( $data->{hostname}, $data->{username}, $data->{password} );
}

sub metadata {
    CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{metadata} );
}

sub analytics_data {
    CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{analytics_data} );
}

sub adsense_data {
    CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{adsense_data} );
}

sub tab_data {
    CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{model}->{tab_data} );
}

sub externals_data {
    CMS::Lite::Croak->if_not_found_data( $_[0]->instance()->{externals} );
}

sub _new_instance {
    
    CMS::Lite::Croak->if_not_isa_path_class_dir($CONF_DIR);

    my $data = Config::Multi->new(
        {
            dir       => $CONF_DIR->stringify,
            app_name  => $APP_NAME,
            extension => $EXTENSION,
        }
    )->load;
}

1;

