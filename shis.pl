#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();

my $jar = HTTP::CookieJar::LWP->new();
my $ua  = LWP::UserAgent->new(
  cookie_jar        => $jar,
  protocols_allowed => ['http', 'https'],
  timeout           => 10,
  ssl_opts => { verify_hostname => 0 },
);

$ua->env_proxy;

my $response = $ua->get($ARGV[0]);

if ($response->is_success) {
    print $response->decoded_content;
}
else {
    die $response->status_line;
}
