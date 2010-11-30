#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::Most;
use t::Utils;

use_ok("CMS::Lite::Model::External");

my $external;

subtest "construction" => sub {

    $external = CMS::Lite::Model::External->new;

    isa_ok($external, 'CMS::Lite::Model::External');
    can_ok($external, 'externals');
    can_ok($external, 'add_externals');
    can_ok($external, 'xhtml');
    
    is_deeply [ $external->externals ], [
        {
            'href' => 'http://www.exernal1.com/',
            'name' => 'External Site1'
        },
        {
            'href' => 'http://www.exernal2.com/',
            'name' => 'External Site2'
        },
        {
            'href' => 'http://www.exernal3.com/',
            'name' => 'External Site3'
        },
        {
            'href' => 'http://www.exernal4.com/',
            'name' => 'External Site4'
        },
    ];

    done_testing();
};

subtest "add externas" => sub {

    $external->add_externals(
        {
            href => 'http://www.example1.com',
            name => 'Example1'
        }
    );

    is_deeply [ $external->externals ], [
        {
            'href' => 'http://www.exernal1.com/',
            'name' => 'External Site1'
        },
        {
            'href' => 'http://www.exernal2.com/',
            'name' => 'External Site2'
        },
        {
            'href' => 'http://www.exernal3.com/',
            'name' => 'External Site3'
        },
        {
            'href' => 'http://www.exernal4.com/',
            'name' => 'External Site4'
        },

        {
            href => 'http://www.example1.com',
            name => 'Example1'
        }
    ];

    done_testing();
};

subtest "add externals 2" => sub {

    $external->add_externals(
        {
            href => 'http://www.example2.com',
            name => 'Example2'
        },
        {
            href => 'http://www.example3.com',
            name => 'Example3'
        },
    );

    is_deeply [ $external->externals ],
      [
        {
            'href' => 'http://www.exernal1.com/',
            'name' => 'External Site1'
        },
        {
            'href' => 'http://www.exernal2.com/',
            'name' => 'External Site2'
        },
        {
            'href' => 'http://www.exernal3.com/',
            'name' => 'External Site3'
        },
        {
            'href' => 'http://www.exernal4.com/',
            'name' => 'External Site4'
        },



        {
            href => 'http://www.example1.com',
            name => 'Example1'
        },
        {
            href => 'http://www.example2.com',
            name => 'Example2'
        },
        {
            href => 'http://www.example3.com',
            name => 'Example3'
        },
      ];

    done_testing();
};

subtest "render xhtml" => sub {

    eq_or_diff $external->xhtml, <<"_EOF_";
<!-- externals[start] -->
<p class="externals">
<a href="http://www.exernal1.com/">External Site1</a> | 
<a href="http://www.exernal2.com/">External Site2</a> | 
<a href="http://www.exernal3.com/">External Site3</a> | 
<a href="http://www.exernal4.com/">External Site4</a> | 
<a href="http://www.example1.com">Example1</a> | 
<a href="http://www.example2.com">Example2</a> | 
<a href="http://www.example3.com">Example3</a>
</p>
<!-- externals[end] -->
_EOF_
    
    done_testing();
};

done_testing();

