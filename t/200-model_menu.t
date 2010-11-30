#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Test::More;

use_ok("CMS::Lite::Model::Menu");

my $menu;

subtest "prepare archive objects for store into category objecte" => sub {

    $menu = CMS::Lite::Model::Menu->new( order=> '01', name => 'README' );

    ok($menu, "object created ok");
    isa_ok($menu, 'CMS::Lite::Model::Menu');
    can_ok($menu, 'order');
    can_ok($menu, 'name');
    can_ok($menu, 'is_dup_title');
    can_ok($menu, 'is_dup_basename');
    can_ok($menu, 'get_lists');
    can_ok($menu, 'add_lists');
    can_ok($menu, 'valid_list');
    
    is $menu->order, '01';
    is $menu->name, 'README';
   
    done_testing();
};

subtest "add list and get lists" => sub {

    $menu->add_lists( {basename=>'index', title => 'index title' } );
    
    is_deeply [$menu->get_lists],
    [
        { basename => 'index', title => 'index title' },
    ];

    done_testing();
};

subtest "add list again" => sub {

    $menu->add_lists( {basename=>'01-about', title => 'about title' } );
     
    is_deeply [$menu->get_lists],
    [
        { basename => 'index', title => 'index title' },
        { basename => '01-about', title => 'about title' },
    ];

    done_testing();
};

subtest "add some lists" => sub {

    $menu->add_lists(
        { basename => '02-contact me', title => 'contact me' },
        { basename => '03-links',      title => 'links' },
    );

    is_deeply [ $menu->get_lists ],
      [
        { basename => 'index',         title => 'index title' },
        { basename => '01-about',      title => 'about title' },
        { basename => '02-contact me', title => 'contact me' },
        { basename => '03-links',      title => 'links' },
      ];

    done_testing();
};


subtest "render xhtml" => sub {

    is $menu->xhtml, <<"_EOF_";
<!-- menu[start] -->
<h3>README</h3>
<ul class="menu">
    <li><a href="index.html">index title</a></li>
    <li><a href="01-about.html">about title</a></li>
    <li><a href="02-contact me.html">contact me</a></li>
    <li><a href="03-links.html">links</a></li>
</ul>
<!-- menu[end] -->
_EOF_
    
    done_testing();
};

done_testing();

