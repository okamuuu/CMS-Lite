package CMS::Lite::Model::Page;
use utf8;
use strict;
use warnings;
use CMS::Lite::Croak;
use CMS::Lite::Model::Metadata;
use CMS::Lite::Model::Tab;
use CMS::Lite::Model::Bread;
use CMS::Lite::Model::External;
use CMS::Lite::Model::Adsense;
use CMS::Lite::Model::Analytics;
use Class::Accessor::Lite;
Class::Accessor::Lite->mk_accessors(qw/path metadata tab bread menus adsense analytics external/);

sub new { 
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $path = CMS::Lite::Croak->if_not_isa_path_class_file( delete $args->{path} );

    my $metadata  = CMS::Lite::Model::Metadata->new;
    my $tab       = CMS::Lite::Model::Tab->new;
    my $bread     = CMS::Lite::Model::Bread->new;
    my $adsense   = CMS::Lite::Model::Adsense->new;
    my $analytics = CMS::Lite::Model::Analytics->new;

    my $self = bless {
        path      => $path,
        metadata  => $metadata,
        tab       => $tab,
        bread     => $bread,
        menus     => [],
        external  => undef,
        adsense   => $adsense,
        analytics => $analytics,
    }, $class;

}

sub xhtml {
    my $self = shift;

    my $title       = $self->metadata->title;
    my $site_name   = $self->metadata->site_name;
    my $base_url    = $self->metadata->base_url;
    my $author      = $self->metadata->author;
    my $keyword     = join ', ', @{ $self->metadata->keywords };
    my $description = $self->metadata->description;
    my $copyright   = $self->metadata->copyright;
    my $robots      = $self->metadata->robots;
    my @css_files   = @{ $self->metadata->css_files };
    my $content     = $self->metadata->content;
    my @menus       = @{ $self->menus };

    ### XXX: \nをつけるの面倒。演算子乗っ取る?
    my $xhtml = qq{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" \n};
    $xhtml .= qq{"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n};
    $xhtml .= qq{<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">\n};
    $xhtml .= qq{<head>\n};
    $xhtml .= qq{<meta http-equiv="content-type" content="text/html; charset=utf8" />\n};
    $xhtml .= qq{<title>$title | $site_name </title>\n};
    $xhtml .= qq{<meta name="keywords" content="$keyword" />\n};
    $xhtml .= qq{<meta name="description" content="$description" />\n};
    $xhtml .= qq{<meta name="author" content="$author" />\n} if $author;
    $xhtml .= qq{<meta name="copyright" content="$copyright" />\n} if $copyright;
    $xhtml .= qq{<meta name="robots" content="$robots" />\n} if $robots;
    for my $css_file ( @css_files ) {
        $xhtml .= qq{<link rel="stylesheet" type="text/css" media="screen" href="$css_file"/>\n};
    }
    $xhtml .= qq{</head>\n};
    $xhtml .= qq{<body>\n};
    $xhtml .= qq{<div id="wrapper">\n};
    $xhtml .= qq{<div id="wrap">\n};
    $xhtml .= qq{<div id="header">\n};
    $xhtml .= qq{<p id="title"><a href="$base_url">$site_name</a></p>\n};
    $xhtml .= qq{</div>\n};
    $xhtml .= $self->tab->xhtml;
    $xhtml .= $self->bread->xhtml;
    $xhtml .= qq{<div id="content">\n};
    $xhtml .= qq{$content\n};
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{<div id="side-bar">\n};
    for my $menu ( @menus ) {
        $xhtml .= $menu->xhtml if $menu;
    }
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{<br class="clear" />\n};
    $xhtml .= qq{<div id="footer">\n};
    $xhtml .= $self->external->xhtml;
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{<div id="adsense">\n};
    $xhtml .= $self->adsense->script;
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{</div>\n};
    $xhtml .= $self->analytics->script;
    $xhtml .= qq{</body>\n};
    $xhtml .= qq{</html>\n};
}

1;

=head1 NAME

CMS::Lite::Page - htmlファイルの内容とファイル名を持つオブジェクト

=cut
