use strict;
use warnings;
use Test::Base;
use CMS::Lite::ArchiveParser;

sub test_method {

    my $archive = CMS::Lite::ArchiveParser->parse(
        parser   => 'Trac',
        basename => 'filename',
        keywords => [qw/test em 強調/],
        text     => $_[0]
    );

    my $result = {
        basename    => $archive->basename,
        title       => $archive->title,
        keywords    => $archive->keywords,
        description => $archive->description,
#        content     => $archive->content,
    };
}

filters {
    i => [ 'test_method' ],
    e => [ 'yaml'],
};

run_is_deeply 'i' => 'e';

__DATA__
=== # 標準的な文章
--- i
= head1 =

'''''this is test'''''

== head2 =

これは''test''です。''em''は''強調''です。

== heading2 ==
--- e
basename: filename
title: head1
keywords: 
  - test
  - em
  - '強調'
description: 'this is test' 

=== # keywordsが重複しても一つしか抽出しない
--- i
= head1 =

'''''this is test'''''

== heading2 ==

''test''です。これは''test''です。そう、''test''です。

--- e
basename: filename
title: head1
keywords:
  - 'test'
description: 'this is test'


