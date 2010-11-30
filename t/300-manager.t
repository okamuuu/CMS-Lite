#!/usr/bin/perl
use strict;
use warnings;
use t::Utils;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use CMS::Lite::Manager;
use Cwd;

subtest "use ok manager class" => sub {

    ### 振舞いの可否をチェック
    can_ok( 'CMS::Lite::Manager', $_ )
      for
      qw/write doc2pages dir2category dir2menu dir2archives file2archive backup/;

    done_testing();
};

subtest "file2archive" => sub {
    
    my $dir_num = '01';
    my $file    = Path::Class::File->new( CMS::Lite::Path->doc_dir, '01-home', '01-README', '01-index.trac.txt' );
    my $archive = CMS::Lite::Manager->file2archive($dir_num, $file); 

    isa_ok $archive, "CMS::Lite::Model::Archive";
    done_testing();
};

subtest "dir2archives" => sub {
    
    my $dir      = Path::Class::Dir->new( CMS::Lite::Path->doc_dir, '01-home', '01-README' );
    my @archives = CMS::Lite::Manager->dir2archives($dir); 

    isa_ok($_, "CMS::Lite::Model::Archive") for @archives;
    done_testing();
};

subtest "dir2menu" => sub {
    
    my $dir = Path::Class::Dir->new( CMS::Lite::Path->doc_dir, '01-home' );

    my $menu = CMS::Lite::Manager->dir2menu($dir); 
    isa_ok( $menu, 'CMS::Lite::Model::Menu');

    done_testing();
};

subtest "dir2category" => sub {
    
    my $dir = Path::Class::Dir->new( CMS::Lite::Path->doc_dir, '01-home' );

    my $category = CMS::Lite::Manager->dir2category($dir); 
    isa_ok( $category, 'CMS::Lite::Model::Category');

    done_testing();
};

subtest "doc2pages" => sub {
   
    my @pages = CMS::Lite::Manager->doc2pages;
    isa_ok( $_, 'CMS::Lite::Model::Page') for @pages;

    done_testing();
};

done_testing();


