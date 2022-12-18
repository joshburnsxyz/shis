#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();

# TODO: Build URL
# - Take @ARGV[0] and check if it starts with schema or not
# - If it does, do nothing
# - if it does not, prepend https schema to it

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

my $response = $ua->get($ARGV[0]);

if ($response->is_success) {
    print $response->decoded_content;
}
else {
    die $response->status_line;
}
