#!/usr/bin/perl
use strict;
use warnings;
use t::Utils;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use CMS::Lite::Manager;
use Cwd;

subtest "write" => sub {
   
    CMS::Lite::Manager->write;
    ok(1); # とりあえず
    done_testing();
};


done_testing();


