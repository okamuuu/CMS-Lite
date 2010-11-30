package CMS::Lite::Validate;
use strict;
use warnings;
use utf8;
use Carp ();

### bless ARRAYREF
### SEE ALSO DBIx::Skinny::Transaction
sub new { bless [ 0, [] ], $_[0] } 

sub set_errors { 
    my ($self, @errors) = @_;
    $self->[0] = 1; 
    $self->[1] = [$self->get_errors, @errors];
    return $self;
}

sub set_not_found_error { 
    my ($self, $string) = @_;
    $self->set_errors("NotFound: $string");
}

sub has_errors { $_[0]->[0] ? 1 : 0; }

sub get_errors { @{ $_[0]->[1] } }

sub metadata {
    my ( $class, $data ) = @_;
    Carp::croak("incorrect use...") if ref($class);

    my $validator = $class->new;

    $validator->set_not_found_error('site_name') if not $data->{site_name};
    $validator->set_not_found_error('author')    if not $data->{author};
    $validator->set_not_found_error('copyright') if not $data->{copyright};

    return $validator;
}

sub analytics_data {
    my ( $class, $data ) = @_;
    Carp::croak("incorrect use...") if ref($class);

    my $validator = $class->new;

    $validator->set_not_found_error('site_name') if not $data->{site_name};
    $validator->set_not_found_error('author')    if not $data->{author};
    $validator->set_not_found_error('copyright') if not $data->{copyright};

    return $validator;
}


1;

=head1 NAME

CMS::Lite::Croak - Croak Class

=head1 METHODS


=head2 if_not_file

=head2 if_not_dir

=head2 _if_not_isa

=cut

