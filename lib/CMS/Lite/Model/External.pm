package CMS::Lite::Model::External;
use strict;
use warnings;
use utf8;
use CMS::Lite::Croak;
use CMS::Lite::Config;

sub new {
    my $class = shift;
    my $self = bless { 
        _externals => CMS::Lite::Config->externals_data },
      $class;
}

sub externals { @{ $_[0]->{_externals} } }

sub add_externals {
    my $self      = shift;
    my @externals = @_;

    $self->{_externals} = [ $self->externals, @externals ];
}

sub xhtml {
    my $self = shift;
   
    my $xhtml = qq{<!-- externals[start] -->\n};
    $xhtml .= qq{<p class="externals">\n};
   
    my $count=0; 
    for my $external ( $self->externals ) {
        my $href = $external->{href};
        my $name = $external->{name};
        
        if ( ++$count == scalar $self->externals ) {
            $xhtml .= qq{<a href="$href">$name</a>\n};
        }
        else {
            $xhtml .= qq{<a href="$href">$name</a> | \n};
        }
    }

    $xhtml .= qq{</p>\n};
    $xhtml .= qq{<!-- externals[end] -->\n};
}

1;

