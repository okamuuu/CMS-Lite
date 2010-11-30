package t::Utils;
use strict;
use warnings;
use utf8;
use Cwd;
use Path::Class ();
use YAML::Syck;
use CMS::Lite::Config;
use CMS::Lite::Model::Archive;
use CMS::Lite::Model::Archive;
use CMS::Lite::Model::Menu;
use CMS::Lite::Model::Category;
use CMS::Lite::Model::Site;

my $CACHE;

sub import {
    strict->import;
    warnings->import;
    utf8->import;
    $CMS::Lite::Config::CONF_DIR =
      Path::Class::Dir->new( cwd(), 't', 'samples', 'conf' );
}

sub get_archives {
    map { CMS::Lite::Model::Archive->new(%{$_}) } @{ _get_fixture('archives')->{archives} };
}

sub get_menus {
    map { CMS::Lite::Model::Menu->new(%{$_}) } @{ _get_fixture('menus')->{menus} };
}

sub get_categories {
    my ( $index, $about, $news )  = get_archives;
    my ( $menu1, $menu2, $menu3 ) = get_menus;

    my $category1 = CMS::Lite::Model::Category->new(
        name     => 'HOME',
        dirname  => 'home',
        menus    => [ $menu1, $menu2, $menu3 ],
        archives => [ $index, $about, $news ],
    );

    my $category2 = CMS::Lite::Model::Category->new(
        name     => 'CentOS5.3',
        dirname  => 'centos53',
        menus    => [ $menu1, $menu2, $menu3 ],
        archives => [ $index, $about, $news ],
    );

    return [$category1, $category2];
}

sub get_site {
    my $site = CMS::Lite::Model::Site->new(
        name       => 'My Site',
        categories => get_categories,
    );
}

sub _get_fixture {
    my ($target) = @_;

    $CACHE = do { local $/; <DATA>; } unless $CACHE;

    my $data = $CACHE
      or Carp::confess("Could not get data from __DATA__ segment");

    my @files = split /^__(.+)__\r?\n/m, $data;

    shift @files;
    while (@files) {
        my ( $name, $content ) = splice @files, 0, 2;

        if ( $target eq $name ) {
            return YAML::Syck::Load($content);
        }
    }

    return 0;
}

1;

__DATA__

__archives__
archives:
  - basename: index
    title: 'index title'
    keywords:
      - some
      - keywords
      - here
    description: 'outline of this documentation'
    content: 'long long text'
  - basename: about
    title: 'about title'
    keywords: 
      - key 
      - word
      - here
    description: 'outline of atout this website'
    content: 'this site is ..'
  - basename: news
    title: news
    keywords:
      - news
    description: 'this is news ..'
    content: 'news news news!!'

__menus__
menus:
  - order: '01'
    name: README
  - order: '02'
    name: SETUP
  - order: '03'
    name: SECURITY

