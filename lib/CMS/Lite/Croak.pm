package CMS::Lite::Croak;
use strict;
use warnings;
use utf8;
use Carp ();

sub if_not_found_data {
    my ($class, $data) = @_;
    my @caller = caller(1);
    my $method = [split '::', $caller[3]]->[-1];
    Carp::croak("NotFound: $method...") if not $data;
    return $data; 
}

sub if_not_isa_path_class_file {
    $_[0]->_if_not_isa('Path::Class::File',$_[1]);
}

sub if_not_isa_path_class_dir {
    $_[0]->_if_not_isa('Path::Class::Dir',$_[1]);
}

sub if_not_isa_model_archive {
    $_[0]->_if_not_isa('CMS::Lite::Model::Archive',$_[1]);
}

sub if_not_isa_model_menu {
    $_[0]->_if_not_isa('CMS::Lite::Model::Menu',$_[1]);
}

sub if_not_isa_model_category {
    $_[0]->_if_not_isa( 'CMS::Lite::Model::Category', $_[1] );
}

sub _if_not_isa {
    my ( $class, $name, $obj ) = @_;
    Carp::croak("this is not $name...") if not $obj->isa($name);
    return $obj;
}

1;

=head1 NAME

CMS::Lite::Croak - Croak Class

=head1 METHODS


=head2 if_not_file

=head2 if_not_dir

=head2 _if_not_isa

=cut

