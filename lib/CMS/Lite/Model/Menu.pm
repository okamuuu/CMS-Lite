package CMS::Lite::Model::Menu;
use utf8;
use strict;
use warnings;

sub new {
    my ( $class, %opt ) = @_;

    my $order = $opt{order} or die("Please set opt 'order' ...");
    my $name  = $opt{name} or die("Please set opt 'name' ...");

    bless {
        _order       => $order,
        _name        => $name,
        _lists       => [],
        _is_title    => {},
        _is_basename => {},
    }, $class;
}

sub order { $_[0]->{_order} }
sub name  { $_[0]->{_name}  }

sub is_dup_title    { $_[0]->{_is_title}->{$_[1]}    ? 1 : 0 }
sub is_dup_basename { $_[0]->{_is_basename}->{$_[1]} ? 1 : 0 }

sub get_lists { @{ $_[0]->{_lists} } } 
sub add_lists {
    my ( $self, @lists ) = @_;
    $self->valid_list(@lists);
    $self->{_lists} = [$self->get_lists , @lists];

    for my $list (@lists) {
        $self->{_is_title}->{$list->{title}} = 1;
        $self->{_is_basename}->{$list->{basename}} = 1;
    }
}

sub valid_list {
    my ( $self, @lists ) = @_;
    for my $list ( @lists ) {

        my $title = $list->{title}
          or Carp::croak("could't find 'title' in this list");

        my $basename = $list->{basename}
          or Carp::croak("could't find 'basename' in this list");

        ### check title dupplicatiton むぅ。
        Carp::croak("title is duplicate") if $self->is_dup_title($title);
        Carp::croak("basename is duplicate") if $self->is_dup_basename($basename);
    }
    return 1;
}

sub xhtml {
    my ( $self ) = @_;

    my $name  = $self->name; 
    my $order = $self->order;

    my $xhtml = qq{<!-- menu[start] -->\n};
    $xhtml   .= qq{<h3>$name</h3>\n};
    $xhtml   .= qq{<ul class="menu">\n};
    
    for my $list ( $self->get_lists ) {
        my $basename = $list->{basename}; 
        my $title    = $list->{title}; 
        
       $xhtml   .= qq{    <li><a href="$basename.html">$title</a></li>\n};
    } 
    $xhtml   .= qq{</ul>\n};
    $xhtml   .= qq{<!-- menu[end] -->\n};

}

1;

__END__

=encoding utf-8

=for stopwords ownself xhtml

=head1 NAME

CMS::Lite::Menu - menu part

=head1 DESCRIPTION

menu part. this object dose render xhtml by ownself.

=head1 METHODS

=head2 new

=head2 order

=head2 name

=head2 is_dup_title

=head2 is_dup_basename

=head2 get_lists

=head2 add_lists

=head2 valid_list

=head2 xhtml


