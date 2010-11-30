package CMS::Lite::Model::Category;
use strict;
use warnings;
use utf8;
use CMS::Lite::Croak;

sub new {
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $name    = $args->{name}    or Carp::croak("NotFound: name...");
    my $dirname = $args->{dirname} or Carp::croak("NotFound: dirname...");

    my @archives = @{ $args->{archives} } or Carp::croak("NotFound: archives...'");
    my @menus    = @{ $args->{menus} }    or Carp::croak("NotFound: menus...'");

    CMS::Lite::Croak->if_not_isa_model_archive($_) for @archives;
    CMS::Lite::Croak->if_not_isa_model_menu($_) for @menus;

    for (@archives) {
        $_->isa("CMS::Lite::Model::Archive")
          or die("this is not 'CMS::Lite::Archive'...");
    }

    for (@menus) {
        $_->isa("CMS::Lite::Model::Menu")
          or die("this is not 'CMS::Lite::Menu'...")
    }

    bless {
        _name     => $name,
        _dirname  => $dirname,
        _archives => [@archives],
        _menus    => [@menus],
    }, $class;
}

sub name    { $_[0]->{_name}    }
sub dirname { $_[0]->{_dirname} }

### deref
sub archives { @{ $_[0]->{_archives} } }
sub menus    { @{ $_[0]->{_menus}    } }

1;

__END__

=encoding utf-8

=for stopwords dirname

=head1 NAME

CMS::Lite::Category - Category has menus and archives

=head1 METHODS

=head2 new

=head2 name

=head2 dirname

=head2 archives

=head2 menus

