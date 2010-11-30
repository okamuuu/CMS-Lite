#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More;
use t::Utils;

use_ok("CMS::Lite::Path");
use_ok("CMS::Lite::Regex");

subtest "isa regex" => sub {

    my @category_dirs  = CMS::Lite::Path->category_dirs;
    my $category_regex = CMS::Lite::Regex->dir_regex;

    isa_ok($category_regex, 'Regexp');
    
    ok $category_dirs[0]->dir_list(-1) =~ m/$category_regex/;
    is $1, '01'; 
    is $2, 'home'; 
 
    ok $category_dirs[1]->dir_list(-1) =~ m/$category_regex/;
    is $1, '02'; 
    is $2, 'catA'; 
  
    ok $category_dirs[2]->dir_list(-1) =~ m/$category_regex/;
    is $1, '03'; 
    is $2, 'catB'; 
   
    done_testing();
};

subtest "dig up dirname" => sub {

    my @category_dirs  = CMS::Lite::Path->category_dirs;
    my $category_regex = CMS::Lite::Regex->dir_regex;

    isa_ok($category_regex, 'Regexp');
    
    my ($order, $dirname);
    ($order, $dirname) = CMS::Lite::Regex->if_match_category_dir($category_dirs[0]);
    is $order,   '01';
    is $dirname, 'home'; 
 
    ($order, $dirname) = CMS::Lite::Regex->if_match_category_dir($category_dirs[1]);
    is $order,   '02';
    is $dirname, 'catA'; 
  
    ($order, $dirname) = CMS::Lite::Regex->if_match_category_dir($category_dirs[2]);
    is $order,   '03';
    is $dirname, 'catB'; 
   
    done_testing();
};

done_testing();

