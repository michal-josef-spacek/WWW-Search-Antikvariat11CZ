use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Class for searching http://antikvariat11.cz .';
author 'Michal Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.01;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'WWW-Search-Antikvariat11CZ';
readme_from 'Antikvariat11CZ.pm';
recursive_author_tests('xt');
requires 'HTTP::Cookies' => 0;
requires 'LWP::UserAgent' => 0;
requires 'Readonly' => 0;
requires 'Web::Scraper' => 0;
requires 'WWW::Search' => 0;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=WWW-Search-Antikvariat11CZ';
resources 'homepage' => 'https://github.com/tupinek/WWW-Search-Antikvariat11CZ';
resources 'repository' => 'git://github.com/tupinek/WWW-Search-Antikvariat11CZ';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
