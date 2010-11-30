#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin qw($Bin);
use Path::Class;
use t::Utils;
use CMS::Lite::Path;
use CMS::Lite::Model::Page;

subtest "create CMS::Lite::Model::Page object" => sub {

    my $root_dir = CMS::Lite::Path->root_dir;
    my $path = Path::Class::File->new($root_dir, 'sample.html');

    my $page = CMS::Lite::Model::Page->new(path=>$path);

    isa_ok( $page, 'CMS::Lite::Model::Page' );

    can_ok( $page, $_ ) for qw/path metadata tab bread menus external/;

    isa_ok $page->path, 'Path::Class::File';    

    is $page->metadata->site_name, "My Example Site";
    is $page->metadata->author, "okamura";
    is $page->metadata->copyright, "Copyright (C) All Rights Reserved.";
    is $page->metadata->base_url, "http://www.example.com";
    is $page->metadata->title, undef;
    is_deeply $page->metadata->keywords, [];
    is $page->metadata->description, undef;
    is $page->metadata->content, undef;
    
    is $page->external, undef; ### Model::ExternalはManagerで一度だけ生成

    isa_ok( $page->tab, "CMS::Lite::Model::Tab");
    isa_ok( $page->bread, "CMS::Lite::Model::Bread");
    isa_ok( $_, "CMS::Lite::Model::Menu") for @{$page->menus};
 
    done_testing();
};

done_testing();


