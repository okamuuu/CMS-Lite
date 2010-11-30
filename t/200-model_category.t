#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More;
use t::Utils;

use_ok("CMS::Lite::Model::Category");

my ( $index, $about, $news )  = t::Utils::get_archives();
my ( $menu1, $menu2, $menu3 ) = t::Utils::get_menus();
my $category;

subtest "create category object" => sub {

    $category = CMS::Lite::Model::Category->new(
        name     => 'HOME',
        dirname  => 'home',
        menus    => [ $menu1, $menu2, $menu3 ],
        archives => [ $index, $about, $news ],
    );

    isa_ok( $category, "CMS::Lite::Model::Category", "object isa CMS::Lite::Model::Category" );
    can_ok( $category, "menus" );  
    can_ok( $category, "archives" );  

    done_testing();
};

subtest "category has some archives" => sub {
    is_deeply( [$category->menus], [ $menu1, $menu2, $menu3 ] );
    done_testing();
};

subtest "category has some archives" => sub {
    is_deeply( [$category->archives], [$index, $about, $news] );
    done_testing();
};

done_testing();

