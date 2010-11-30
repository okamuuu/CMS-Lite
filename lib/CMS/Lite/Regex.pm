package CMS::Lite::Regex;
use utf8;
use strict;
use warnings;
use CMS::Lite::Croak;
use Cwd;

sub keywords2emphases {
    my ($class, $text, $keywords ) = @_;

    my $str = join '|', @{ $keywords };
    my $regex = "(:?" . $str . ")";
    $text =~ s{$regex}{<em>$1</em>}g;
    return $text;
}

sub if_match_archive_file { 
    my ($class, $file) = @_;
    
    CMS::Lite::Croak->if_not_isa_path_class_file($file);

    $file->basename =~ m/
                          ^
                          (\d+)             # 並び順
                          -                 # ハイフン
                          ([^-.]*)          # ファイル名にハイフン、ドットは指定できない
                          \.(trac|hatena)   # Parserを指定。拡張性は後日考える
                          \.(txt|pl)        # 拡張子。plは実装していないが将来Pod::Parserを使い、.plでセットアップスクリプト兼ドキュメントにしたい
                          $
                       /x or return;

    my ($order, $basename, $parser, $extention) = ($1, $2, $3, $4);
}

sub if_match_archive_dir { 
    my ($class, $dir) = @_;
    $class->if_match_category_dir($dir);
}

sub if_match_menu_dir { 
    my ($class, $dir) = @_;
    $class->if_match_category_dir($dir);
}

sub if_match_category_dir {
    my ($class, $dir) = @_;
    
    CMS::Lite::Croak->if_not_isa_path_class_dir($dir);
    
    my $regex = $class->dir_regex;
    $dir->dir_list(-1) =~ m/$regex/ or return;
    
    my ($order, $dirname) = ($1, $2);
}

sub dir_regex {
    my $class = shift;
    my $regex = qr/
                 ^
                 (\d+)             # order
                 -
                 ([a-zA-Z0-9_\.]*) # dirname
                 $
             /x;
}

1;

__END__

=encoding utf-8

=for stopwords Path::Class

=head1 NAME

CMS::Lite::Path - get Path::Class 

=head1 METHODS

=head2 doc_dir

=head2 root_dir

=head2 backup_dir


