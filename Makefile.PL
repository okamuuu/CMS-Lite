use inc::Module::Install;
name 'CMS-Lite';
all_from 'lib/CMS/Lite.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
