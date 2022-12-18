#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();

# Helpers
sub stringstart {
    return substr($_[0], 0, length[$_[1]]) eq $_[1];
}

# Build URL
my $url = $ARGV[0];
$url = "https://$url" unless stringstart("https://", $url);

# TODO: Handle (-X / --verb VERB) flag
# - Will take a positional argument that maps to HTTP verb
# - get, post, push, patch, put, delete.
# - Switch case to perform the correct request.

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
