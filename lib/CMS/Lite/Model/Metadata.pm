package CMS::Lite::Model::Metadata;
use utf8;
use strict;
use warnings;
use CMS::Lite::Config;
use Class::Accessor::Lite;

Class::Accessor::Lite->mk_accessors(
    qw/
      site_name author copyright base_url robots title keywords description content css_files
      /
);

sub new {
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $metadata = CMS::Lite::Config->metadata;

    bless {
        site_name   => $metadata->{site_name},
        author      => $metadata->{author},
        copyright   => $metadata->{copyright},
        base_url    => $metadata->{base_url},
        robots      => $metadata->{robots} || 'all',
        keywords    => [],
        title       => undef,
        description => undef,
        content     => undef,
        css_files   => [],
    }, $class;
}

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

