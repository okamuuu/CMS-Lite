package CMS::Lite::Model::Archive;
use utf8;
use strict;
use warnings;

sub new {
    my ( $class, %data ) = @_;

    bless {
        _basename    => $data{basename},
        _title       => $data{title},
        _keywords    => $data{keywords},
        _description => $data{description},
        _content     => $data{content},
    }, $class;
}

sub basename    { $_[0]->{_basename} }
sub title       { $_[0]->{_title} }
sub keywords    { $_[0]->{_keywords} }
sub description { $_[0]->{_description} }
sub content     { $_[0]->{_content} }

1;

=head1 NAME

CMS::Lite::Model::Archive - smallest component

=head1 DESCRIPTION

exist for store parsed data 

=head1 METHODS

=head2 new

=head2 basename

=head2 title

=head2 keywords

=head2 description

=head2 content

