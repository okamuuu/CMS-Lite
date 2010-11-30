#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Utils;
 
use_ok("CMS::Lite::Config");

subtest 'methods' => sub {

    my @methods =
      qw/metadata analytics_data adsense_data tab_data externals_data/;
    can_ok( 'CMS::Lite::Config', $_ ) for @methods;

    done_testing();
};

subtest 'get instance' => sub {

    my $config = CMS::Lite::Config->instance();
    
    is $config->{name}, 'Example';

    done_testing();
};

subtest 'metadata' => sub {

    my $metadata = CMS::Lite::Config->metadata;
    is_deeply $metadata,
      {
        site_name => 'My Example Site',
        author    => 'okamura',
        copyright => 'Copyright (C) All Rights Reserved.',
        base_url  => 'http://www.example.com'
      };

    done_testing();
};

subtest 'metadata' => sub {

    my $metadata = CMS::Lite::Config->metadata;
    is_deeply $metadata,
      {
        site_name => 'My Example Site',
        author    => 'okamura',
        copyright => 'Copyright (C) All Rights Reserved.',
        base_url  => 'http://www.example.com'
      };

    done_testing();
};

done_testing();

