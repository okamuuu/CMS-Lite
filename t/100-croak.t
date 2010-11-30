#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;
use t::Utils;
 
use_ok("CMS::Lite::Croak");

subtest 'methods' => sub {

    my @methods =
      qw/
if_not_found_data
if_not_isa_path_class_file
if_not_isa_path_class_dir
if_not_isa_model_archive
if_not_isa_model_menu
if_not_isa_model_category
/;

    can_ok( 'CMS::Lite::Croak', $_ ) for @methods;

    done_testing();
};

subtest 'croak by if_not_found' => sub {
    
    throws_ok { test1(); } qr/NotFound: test1\.\.\./;
    throws_ok { test2(); } qr/NotFound: test2\.\.\./;

    done_testing();
};

subtest 'croak by if_not_isa_path_class_file' => sub {

    lives_ok {
        CMS::Lite::Croak->if_not_isa_path_class_file('Path::Class::File');
    };

    throws_ok {
        CMS::Lite::Croak->if_not_isa_path_class_file('Path::Class::Dir');
    }
    qr/this is not Path::Class::File\.\.\./;

    done_testing();
};

done_testing();

sub test1 { CMS::Lite::Croak->if_not_found_data(undef);}
sub test2 { CMS::Lite::Croak->if_not_found_data(undef);}


