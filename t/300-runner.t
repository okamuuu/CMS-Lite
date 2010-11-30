#!/usr/bin/perl
use strict;
use warnings;
use t::Utils;
use Test::Most;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use CMS::Lite::Runner;

subtest 'parser_option' => sub {
    
    CMS::Lite::Runner->parse_options('-w');
    is(CMS::Lite::Runner->status, 'w');
    CMS::Lite::Runner->parse_options('-bu');
    is(CMS::Lite::Runner->status, 'wbu');
    
    done_testing;
};

subtest 'reset' => sub {
    
    is(CMS::Lite::Runner->status, 'wbu');
    ok(CMS::Lite::Runner->reset);
    is(CMS::Lite::Runner->status, undef);
    
    done_testing;
};

subtest 'run' => sub {
    
    CMS::Lite::Runner->parse_options('-wbu')->run;
    ok(1);
    done_testing;
};

done_testing;

