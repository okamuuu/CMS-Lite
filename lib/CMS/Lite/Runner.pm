package CMS::Lite::Runner;
use strict;
use warnings;
use utf8;
use Getopt::Long;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use CMS::Lite::Manager;

my $write;
my $backup;
my $upload;

sub status {
    my $class = shift;

    my $status = undef;
    $status .= "w" if $write;
    $status .= "b" if $backup;
    $status .= "u" if $upload;
    
    return $status 
}

sub reset { 
    my $class = shift;
    $write = $backup = $upload = undef; 
    return $class; 
}

sub parse_options {
    my $class = shift;

    local @ARGV = @_;

    Getopt::Long::Configure( qw/bundling no_ignore_case/ );
    Getopt::Long::GetOptions(
        "w|write"    => \$write,
        "b|backup"   => \$backup,
        "u|upload"   => \$upload,
    );
    
    return $class;
}

sub run {
    my $class = shift;

    CMS::Lite::Manager->write if $write; 
    CMS::Lite::Manager->backup if $backup;
    CMS::Lite::Manager->upload if $upload;

    $class->reset;
}

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

CMS::Lite::Runner - Runner 

=head1 METHODS

=head2 new

=head2 manager

=head2 parse_options

=head2 run


