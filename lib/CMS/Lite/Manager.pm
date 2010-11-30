package CMS::Lite::Manager;
use strict;
use warnings;
use utf8;
use File::Slurp ();
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Archive::Zip;
use DateTime;
use CMS::Lite::Config;
use CMS::Lite::Path;
use CMS::Lite::Regex;
use CMS::Lite::FTP;
use CMS::Lite::ArchiveParser;
use CMS::Lite::Model::Site;
use CMS::Lite::Model::Category;
use CMS::Lite::Model::Menu;
use CMS::Lite::Model::Page;

sub write {
    my $class = shift;
    for my $page ( $class->doc2pages ) {
        $page->path->dir->mkpath(1);
        File::Slurp::write_file( 
            $page->path->stringify,
            $page->xhtml,
        )
    }
}

sub doc2pages {
    my $class = shift;

    my @pages;
    my @category_dirs = CMS::Lite::Path->category_dirs;
    
    for my $dir (@category_dirs) {
        
        my $category = $class->dir2category($dir);

        for my $archive ( $category->archives ) {
          
            my $filename = $archive->basename . ".html"; 
            
            my $path =
              $category->dirname eq 'home'
              ? file( CMS::Lite::Path->root_dir, $filename )
              : file( CMS::Lite::Path->root_dir, $category->dirname, $filename );

            my $css_files =
              $category->dirname eq 'home'
              ? CMS::Lite::Path->css_files('home')
              : CMS::Lite::Path->css_files;

            my $page = CMS::Lite::Model::Page->new(path=>$path);
            my $external = CMS::Lite::Model::External->new;
            $page->path($path);
            $page->tab->current($category->dirname);
            $page->menus([$category->menus]);
            $page->external($external);

            $page->bread->add(
                { dir => $category->dirname, name => $category->name },
                { dir => 'dummy',            name => $archive->title }
            );

            $page->metadata->title( $archive->title );
            $page->metadata->keywords( $archive->keywords );
            $page->metadata->description( $archive->description );
            $page->metadata->content( $archive->content );
            $page->metadata->css_files($css_files);

            push @pages, $page;
        }
    }
    return @pages;
}

sub dir2category {
    my ( $class, $category_dir ) = @_;

    my ( $order, $dirname ) =
      CMS::Lite::Regex->if_match_category_dir($category_dir)
      or return;

    my ( @all_archives, @menus );
    for my $menu_dir ( sort { $a cmp $b } $category_dir->children ) {

        my $menu = $class->dir2menu($menu_dir)
          or next;

        my @archives = $class->dir2archives($menu_dir);

        ### 生成された記事を元にメニューを作る
        for my $archive (@archives) {
            $menu->add_lists(
                {
                    basename => $archive->basename,
                    title    => $archive->title
                }
            );
        }

        push @all_archives, @archives;
        push @menus,        $menu;
    }

    CMS::Lite::Model::Category->new(
        name     => $dirname,
        dirname  => $dirname,
        menus    => [@menus],
        archives => [@all_archives]
    );
}

sub dir2menu {
    my ($class, $dir) = @_;
   
    my ($order, $dirname) =
      CMS::Lite::Regex->if_match_menu_dir($dir)
      or return;

    CMS::Lite::Model::Menu->new( order => $order, name => $dirname );
}

sub dir2archives {
    my ( $self, $dir ) = @_;

    my ( $dir_order, $dirname ) =
      CMS::Lite::Regex->if_match_archive_dir($dir)
      or return;

    my @archives =
      grep { defined $_ }
      map { $self->file2archive( $dir_order, $_ ) }
      sort { "$a" cmp "$b" } $dir->children;
}

sub file2archive {
    my ( $class, $dir_num, $file ) = @_;

    my ( $order, $basename, $parser, $extention ) =
      CMS::Lite::Regex->if_match_archive_file($file)
      or return;

    $basename = ( $basename eq 'index' ) ? 'index' : $dir_num . "-" . $basename;

    CMS::Lite::ArchiveParser->parse(
        parser   => 'Trac',
        basename => $basename,
        text     => scalar $file->slurp
    ) or undef;
}

sub backup {
    my $class = shift;

    my $filename = CMS::Lite::Path->backup_file->stringify;

    my $zip = Archive::Zip->new;
    $zip->addTree( CMS::Lite::Path->doc_dir );
    $zip->writeToFileNamed($filename);
}

sub upload {
    my $class = shift;

    my $root_dir          = CMS::Lite::Path->root_dir;
    my $backup_dir        = CMS::Lite::Path->backup_dir;
    my $remote_root_dir   = CMS::Lite::Path->remote_root_dir;
    my $remote_backup_dir = CMS::Lite::Path->remote_backup_dir;

    CMS::Lite::FTP->upload( $root_dir, $remote_root_dir );

    for my $dir ( $root_dir->children ) {
        next unless $dir->is_dir;
        CMS::Lite::FTP->upload( $dir, dir( $remote_root_dir, $dir->dir_list(-1) ) );
    }

    CMS::Lite::FTP->upload($backup_dir,$remote_backup_dir);
}

1;

__END__

=encoding utf-8

=for stopwords dir2category dir2menu dir2archives

=head1 NAME

CMS::Lite::Manager - Manager Class

=head1 METHODS

=head2 new

=head2 name

=head2 doc_dir

=head2 root_dir

=head2 backup_dir 
 
=head2 parser

=head2 write

=head2 doc2site

=head2 dir2category

=head2 dir2menu

=head2 dir2archives

=head2 file2archive

=head2 backup

