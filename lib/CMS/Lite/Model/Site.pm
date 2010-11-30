package CMS::Lite::Model::Site;
use strict;
use warnings;
use utf8;
use CMS::Lite::Croak;

sub new {
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $name = $args->{name} or Carp::croak("please set args: name...");

    my @categories = @{ $args->{categories} }
      or Carp::croak("'couldn't find categories...'");

    CMS::Lite::Croak->if_not_model_category($_) for @categories;
    
    if ( $categories[0]->dirname !~ m/^home$/ ) {
        Carp::croak("dirname mustbe 'home' at first category");
    }

    bless {
        _name       => $name,
        _categories => [@categories],
    }, $class;
}

sub name { $_[0]->{_name} }

sub categories { @{ $_[0]->{_categories} } }

1;

=encoding utf-8
 
=for stopwords
  
=head1 NAME

CMS::Lite::Site - Site object

=head1 METHODS

=head2 new 

=head2 name

=head2 categories

=cut

