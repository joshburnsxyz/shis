#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();
use Getopt::Long;

# Helpers
sub stringstart {
    return substr($_[0], 0, length[$_[1]]) eq $_[1];
}

my %args;
GetOptions(\%args,
           "verb=s",
           "data=s",
           "url=s",
) or die "Usage: perl ./shis.pl [-verb=VERB] [-data=DATA] -url=URL";
die "Missing -url!" unless $args{url};

# Build URL
my $url = $args{url};
$url = "https://$url" unless stringstart("https://", $url);


my $jar = HTTP::CookieJar::LWP->new();
my $ua  = LWP::UserAgent->new(
  cookie_jar        => $jar,
  protocols_allowed => ['http', 'https'],
  timeout           => 10,
  ssl_opts => { verify_hostname => 0 },
);

$ua->env_proxy;

my $response = $ua->get($url);

if ($response->is_success) {
    print $response->decoded_content;
}
else {
    die $response->status_line;
}
