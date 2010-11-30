package CMS::Lite::ArchiveParser;
use utf8;
use strict;
use warnings;
use Carp ();
use UNIVERSAL::require;

sub parse {
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $parser   = delete $args->{parser}   or Carp::croak('NotFound: parser...');
    my $basename = delete $args->{basename} or Carp::croak('NotFound: basename...');
    my $text     = delete $args->{text}     or Carp::croak('NotFound: text..');

    my $module = "CMS::Lite::ArchiveParser::" . $parser;
    $module->use or Carp::croak $@;

    $module->parse(
        basename => $basename,
        text     => $text,
    );
}

1;

__END__

=encoding utf-8

=for stopwords ownself xhtml

=head1 NAME

CMS::Lite::Path - path class 

=head1 METHODS

=head2 doc_dir

=head2 root_dir

=head2 backup_dir


