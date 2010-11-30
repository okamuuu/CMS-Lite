package CMS::Lite::Model::Bread;
use strict;
use warnings;
use utf8;
use Path::Class;

sub new { 
    my $class = shift;
    my $self = bless {
        base_url => '',
        breads => [{ dir => '', name => 'HOME' }],
    }, $class;
}

sub base_url { $_[0]->{base_url} }

sub breads { @{ $_[0]->{breads} } }

sub add {
    my $self = shift;
    my @breads = grep {; $_->{dir} ne 'home' } @_;  
    $self->{breads} = [ $self->breads, @breads ];
}

sub xhtml {
    my $self = shift;

    my $path = $self->base_url;

    my $xhtml = qq{<!-- bread[start] -->\n};
    $xhtml .= qq{<p id="bread">\n};

    my $count  = 0;
    my @breads = $self->breads;
    for my $bread (@breads) {
        my $dir  = $bread->{dir};
        my $name = $bread->{name};

        # 特にPath::Classで処理する必要は無い。
        $path = Path::Class::Dir->new( $path, $dir )->stringify;
        if ( $#breads != $count ) {
            $xhtml .= qq{<a href="$path">$name</a> &gt;\n};
        }
        else {
            $xhtml .= qq{$name\n};
        }
        $count++;
    }

    $xhtml .= qq{</p>\n};
    $xhtml .= qq{<!-- bread[end] -->\n};
}

1;

