#!/usr/bin/perl
use t::Utils;
use Test::More;

use_ok("CMS::Lite::Model::Metadata");

subtest "check default properties" => sub {

    my $metadata = CMS::Lite::Model::Metadata->new;

    isa_ok($metadata, 'CMS::Lite::Model::Metadata');
    is $metadata->site_name, 'My Example Site';
    is $metadata->author, 'okamura';
    is $metadata->copyright, 'Copyright (C) All Rights Reserved.';
    is $metadata->base_url, 'http://www.example.com';
    
    done_testing();
};

subtest "set rest properties" => sub {

    my $metadata = CMS::Lite::Model::Metadata->new;
    $metadata->title('test title');
    $metadata->keywords([qw/test key words/]);
    $metadata->description('description');
    $metadata->content('content');
    
    is $metadata->title, 'test title';
    is_deeply $metadata->keywords, [qw/test key words/];
    is $metadata->description, 'description';
    is $metadata->content, 'content';
    
    done_testing();
};


done_testing();

