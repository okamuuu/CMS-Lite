#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Utils;

subtest 'simple isa test' => sub {

    isa_ok( $_, 'CMS::Lite::Model::Archive') for t::Utils::get_archives;

    done_testing();
};

done_testing();

