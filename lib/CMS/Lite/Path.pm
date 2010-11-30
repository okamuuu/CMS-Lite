package CMS::Lite::Path;
use utf8;
use strict;
use warnings;
use Cwd;
use Path::Class ();
use CMS::Lite::Config;

sub css_files {
    my $class = shift;
    my $type  = shift;

    my @path = @{ $class->_config->{cms}->{css_files} };

    my @files =
      (defined $type and $type eq 'home') # ()がないと結果が変わる
      ? map { Path::Class::File->new($_) } @path  
      : map { Path::Class::File->new( '..', $_) } @path;

    return [@files];
}

sub category_dirs {
    my $class = shift;
    my @categories = sort { $a cmp $b } $class->doc_dir->children;
}

sub doc_dir { 
    my $class = shift;
    my $doc_dir = $class->_config->{cms}->{doc_dir} || 'doc'; 
    Path::Class::Dir->new( cwd(), $doc_dir ); 
}

sub root_dir { 
    my $class = shift;
    my $root_dir = $class->_config->{cms}->{root_dir} || 'root'; 
    Path::Class::Dir->new( cwd(), $root_dir );
}

sub backup_file { 
    my $class = shift;
    my $dt  = DateTime->now( time_zone => 'local' );    
    my $backup_file = Path::Class::File->new($class->backup_dir, "backup_" . $dt->ymd('') . ".zip" );
}

sub backup_dir { 
    my $class = shift;
    my $backup_dir = $class->_config->{cms}->{backup_dir} || 'backup'; 
    Path::Class::Dir->new( cwd(), $backup_dir ); 
}

sub remote_root_dir { 
    Path::Class::Dir->new( $_[0]->_config->{ftp_data}->{remote_root_dir} ); 
}

sub remote_backup_dir { 
    Path::Class::Dir->new( $_[0]->_config->{ftp_data}->{remote_backup_dir} );
}

sub _config { CMS::Lite::Config->instance() }

1;

__END__

=encoding utf-8

=for stopwords ownself xhtml

=head1 NAME

CMS::Lite::Path - path class 

=head1 METHODS

=head2 doc_dir

=head2 root_dir

=head2 backup_dir


