#!/usr/bin/perl
use strict;
use warnings;
use Cwd;
use Path::Class ();
use Test::More;
use t::Utils;

use_ok("CMS::Lite::Path");

subtest 'doc_dir' => sub {
     
    is( CMS::Lite::Path->doc_dir->stringify,
        Path::Class::Dir->new( cwd(), 't', 'samples', 'doc' )->stringify );

    is( CMS::Lite::Path->root_dir->stringify,
        Path::Class::Dir->new( cwd(), 't', 'samples', 'root' )->stringify );

    is( CMS::Lite::Path->backup_dir->stringify,
        Path::Class::Dir->new( cwd(), 't', 'samples', 'backup' )->stringify );

    done_testing();
};

subtest 'css_file' => sub {
     
    my $files = CMS::Lite::Path->css_files('home');
    is $files->[0]->stringify, 'common/css/base.css';
    is $files->[1]->stringify, 'common/css/extend.css';
    is $files->[2]->stringify, 'common/css/content.css';

    $files = CMS::Lite::Path->css_files;
    is $files->[0]->stringify, '../common/css/base.css';
    is $files->[1]->stringify, '../common/css/extend.css';
    is $files->[2]->stringify, '../common/css/content.css';

    done_testing();
};

done_testing();

