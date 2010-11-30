package CMS::Lite::FTP;
use strict;
use warnings;
use utf8;
use Net::FTP;
use CMS::Lite::Config;

my ($hostname, $username, $password ) = CMS::Lite::Config->ftp_data;

sub upload {
    my ( $class, $local_dir, $remote_dir ) = @_;

    Carp::croak("the client_dir must be Path::Class::Dir...")
      unless $local_dir->isa('Path::Class::Dir');
  
    Carp::croak("the server_dir must be Path::Class::Dir...")
      unless $remote_dir->isa('Path::Class::Dir');

    my $ftp = Net::FTP->new( $hostname, Debug => 0)
      or die "Cannot connect to $hostname: $@";

    $ftp->login($username, $password)
      or die "Cannot login ", $ftp->message;

    $ftp->cwd( "/" )
      or die "Cannot change working directory ", $ftp->message;

    ### mkdir ( DIR [, RECURSE ])
    $ftp->mkdir($remote_dir->stringify, 1)
      or die "mkdir failed ", $ftp->message;

    $ftp->cwd($remote_dir->stringify)
      or die "Cannot change working directory ", $ftp->message;

    for my $child ( $local_dir->children ) {
        next if $child->is_dir;
        $ftp->put( $child->stringify, $child->basename );
    }

    $ftp->quit;

}

1;

__END__
 
=head1 NAME

CMS::Lite::FTP - ftp client class

=head1 METHODS

=head2 upload

=cut

