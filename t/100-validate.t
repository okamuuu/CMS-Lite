#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Utils;
 
use_ok("CMS::Lite::Config");
use_ok("CMS::Lite::Validate");

subtest 'metadata' => sub {

    my $validator = CMS::Lite::Validate->metadata( CMS::Lite::Config->metadata );

    ok !$validator->has_errors;

    done_testing();
};

done_testing();

