package WWW::Search::Antikvariat11CZ;

# Pragmas.
use base qw(WWW::Search);
use strict;
use warnings;

# Modules.
use HTTP::Cookies;
use LWP::UserAgent;
use Readonly;
use Web::Scraper;

# Constants.
Readonly::Scalar our $MAINTAINER => 'Michal Spacek <skim@cpan.org>';
Readonly::Scalar my $ANTIKVARIAT11_CZ => 'http://antikvariat11.cz';
Readonly::Scalar my $ANTIKVARIAT11_CZ_ACTION1 => '/hledani';

# Version.
our $VERSION = 0.01;

# Setup.
sub native_setup_search {
	my ($self, $query) = @_;
	$self->{'_cookie'} = HTTP::Cookies->new(
		'autosave' => 1,
		'file' => "$ENV{'HOME'}/.cookies.txt",
	);
	$self->{'_def'} = scraper {

		# Link to next page.
		process '//ul[@class="pager"]/li/a', 'next_page' => '@href';

		# Get list of books.
		process '//div[@id="content"]/div[@id]', 'books[]' => scraper {
			process '//div/h3', 'title' => 'TEXT';
			process '//div/h3/a', 'detailed_link' => '@href';
			process '//div[@class="para-au"]/span',
				'author' => 'TEXT';
			process '//div[@class="para-ill"]/span',
				'illustrator' => 'TEXT';
			process '//div[@class="para-pg"]/span',
				'pages' => 'RAW';
			process '//div[@class="para-issued"]/span',
				'year_issued' => 'TEXT';
			process '//div[@class="para-cat"]/span',
				'category' => 'TEXT';
			process '//div[@class="para-state"]/span',
				'stay' => 'TEXT';
			process '//div[@class="para-price"]/span',
				'price' => 'TEXT';
			process '//div/img', 'image' => '@src';
			return;
		};
		return;
	};
	$self->{'_offset'} = 0;
	$self->{'_query'} = $query;
	$self->{'ua'} = LWP::UserAgent->new(
		'agent' => "WWW::Search::Antikvariat11CZ/$VERSION",
		'cookie_jar' => $self->{'_cookie'},
	);

	# Get for root for cookie.
	$self->{'ua'}->get($ANTIKVARIAT11_CZ);
	return 1;
}

# Get data.
sub native_retrieve_some {
	my $self = shift;

	# Get content.
	my $response = $self->{'ua'}->post($ANTIKVARIAT11_CZ.
		$ANTIKVARIAT11_CZ_ACTION1,
		'Content' => {
			'q' => $self->{'_query'},
			'Submit' => 'hledat',
		},
	);

	# Process.
	if ($response->is_success) {
		my $content = $response->content;

		# Get books structure.
		my $books_hr = $self->{'_def'}->scrape($content);

		# Process each book.
		foreach my $book_hr (@{$books_hr->{'books'}}) {
			_fix_url($book_hr, 'detailed_link');
			_fix_url($book_hr, 'image');
			push @{$self->{'cache'}}, $book_hr;
		}

		# Next url.
		_fix_url($books_hr, 'next_page');
		$self->next_url($books_hr->{'next_page'});
	}

	return;
}

# Fix URL to absolute path.
sub _fix_url {
	my ($book_hr, $url) = @_;
	if (exists $book_hr->{$url}) {
		$book_hr->{$url} = $ANTIKVARIAT11_CZ.$book_hr->{$url};
	}
	return;
}

1;

__END__
