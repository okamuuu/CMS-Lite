package CMS::Lite::ArchiveParser::Trac;
use strict;
use warnings;
use utf8;
use Carp ();
use CMS::Lite::Model::Archive;
use Text::Trac;
use Web::Scraper qw/scraper/;

sub replace_emphases {
    my ($class, $html, $keywords) = @_;

    return $html unless scalar @{$keywords};
 
    ### <p>直後の改行と</p>直前の改行を消す
    $html =~ s{<p>\s}{<p>}sg;
    $html =~ s{\s</p>}{</p>}sg;

    ### keywords にマッチしたものを強調語句にする
    my $joined  = join '|', @{ $keywords };
    my $search  = qr{($joined)};

    my @lines;
    for my $line ( split "\n", $html ) { 
        $line =~ s{$search}{<em>$1</em>}g;
        push @lines, $line;
    }

    return $html = join "\n", @lines;
}

sub parse {
    my $class = shift;
    my $args = @_ == 1 ? shift : {@_};

    my $basename = delete $args->{basename} or Carp::croak('NotFound: basename...');
    my $text     = delete $args->{text}     or Carp::croak('NotFound: text...');
    
    my $parser = Text::Trac->new;
    $parser->parse($text);

    my $html = $parser->html;

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
    Carp::croak("couldn't find top heading in this document: $basename") if not $res->{title};

    ### 強調語句が初めて出現した場合は@keywordsに格納され、2度目は格納されない
    ### 強調語句が1つも存在しない場合はwarn
    my %is_existing;
    my @keywords    = grep { !$is_existing{$_}++ } @{ $res->{emphases} }; 
    warn "$basename has no keyword!!"     unless @keywords;
   
    ### descriptionがない場合もwarn 
    my $description = $res->{description} || undef;
    warn "$basename has no description!!" unless $description;
    
    return CMS::Lite::Model::Archive->new( 
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

