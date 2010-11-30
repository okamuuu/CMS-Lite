package CMS::Lite::Model::Tab;
use strict;
use warnings;
use utf8;
use CMS::Lite::Croak;
use Class::Accessor::Lite;
Class::Accessor::Lite->mk_accessors(qw/current base_url categories/);

sub new {
    my $class = shift;

    my $data = CMS::Lite::Config->tab_data;

    bless {
        current    => undef,
        base_url   => $data->{base_url},
        categories => $data->{categories},
    }, $class;
}

sub xhtml {
    my $self = shift;

    my $xhtml = "<!-- category[start] -->\n";
    $xhtml .= "<ul id=\"tab\">\n";

    for my $category ( @{ $self->categories } ) {

        my $dir   = $category->{dir};
        my $name  = $category->{name};
        my $current = $self->current;

        my $class = ( defined $current and $dir eq $current ) ? "$dir current" : $dir;
        my $base_url = $current eq 'home' ? '.' : '..';

        if ($dir eq 'home' ) {
            $xhtml .= qq{<li><a href="$base_url" class="$class">$name</a></li>\n};
        }
        else {
            $xhtml .= qq{<li><a href="$base_url/$dir/" class="$class">$name</a></li>\n};
        }
    }

    $xhtml .= "</ul>\n";
    $xhtml .= "<!-- category[end] -->\n";
}

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

