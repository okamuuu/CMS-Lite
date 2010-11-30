package CMS::Lite::ArchiveParser::Hatena;
use strict;
use warnings;
use utf8;
use CMS::Lite::Archive;
use CMS::Lite::Extend::Text::Hatena;
use Web::Scraper;

sub new { bless {}, $_[0] }

sub parse {
    my ( $self , %arg ) = @_;

    my $basename = $arg{basename} or Carp::croak("please specify arg: basename...");
    my $text     = $arg{text}     or Carp::croak("please specify arg: text...");
    
    my $html = CMS::Lite::Extend::Text::Hatena->parse($text);

    my $html = $self->parser->html;

    ### 構文を乗っ取る
    ### '''''xxx''''' => <p id="description">xxx</p>
    ### ''yyy''       => <em>yyy</em>
    $html =~ s!<p>\s*<strong><i>(.*)</i></strong>\s*</p>!<p id="description">$1<\/p>!gm;
    $html =~ s!<i>([^<]*)</i>!<em>$1<\/em>!g;

    ### TODO: 正規表現に変えるとWeb::Scraperへの依存を避けられるがどうする？
    my $scraper = scraper { 
        process 'h1', 'title' => 'TEXT';
        process '#description', description => 'TEXT';
        process 'em', 'emphases[]' => 'TEXT';
    };
    my $res = $scraper->scrape( $html );

    ### h1が存在しないドキュメントを認めない
    die("couldn't find top heading in this document: $basename") if not $res->{title};

    ### 強調語句が初めて出現した場合は@keywordsに格納され、2度目は格納されない
    ### 強調語句が1つも存在しない場合はwarn
    my %is_existing;
    my @keywords    = grep { !$is_existing{$_}++ } @{ $res->{emphases} }; 
    warn "$basename has no keyword!!"     unless @keywords;
   
    ### descriptionがない場合もwarn 
    my $description = $res->{description} || undef;
    warn "$basename has no description!!" unless $description;
    
    return CMS::Lite::Archive->new( 
        basename    => $basename,    
        title       => $res->{title},
        keywords    => [@keywords],
        description => $description,
        content     => $html,
    );
}

1;

__END__

=encoding utf-8

=for stopwords xhtml

=head1 NAME

CMS::Lite::ArchiveParser::Trac - parse document formatted Text::Trac to xhtml.

=head1 METHODS

=head2 new

=head2 parse

