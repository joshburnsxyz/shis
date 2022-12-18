#!/usr/bin/env perl
package shis;

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();
use Getopt::Long;
use Switch;

# Define variables ahead of time
my %args;
my $response;

# Helper, returns true if given string (arg1)
# starts with another given string (arg2)
sub stringstart {
    return substr($_[0], 0, length[$_[1]]) eq $_[1];
}

# Request Handlers
sub perform_get {
    $response = $ua->get($_[0]);
}

sub perform_post {
    $response = $ua->post($_[0], $_[1]);
}

sub perform_put {
    $response = $ua->put($_[0], $_[1]);
}

sub perform_patch {
    $response = $ua->patch($_[0], $_[1]);
}

sub perform_delete {
    $response = $ua->delete($_[0], $_[1]);
}

# Handle CLI arguments and options
GetOptions(\%args,
           "verb=s",
           "data=s",
           "url=s",
) or die "Usage: perl ./shis.pl [-verb=VERB] [-data=DATA] -url=URL";
die "Missing -url!" unless $args{url};

# Build URL
my $url = $args{url};
$url = "https://$url" unless stringstart("https://", $url);

# Build user agent http interface 
my $jar = HTTP::CookieJar::LWP->new();
my $ua  = LWP::UserAgent->new(
  cookie_jar        => $jar,
  protocols_allowed => ['http', 'https'],
  timeout           => 10,
  ssl_opts => { verify_hostname => 0 },
);

$ua->env_proxy;

# Sanity check - Determine if machine has internet connection
# before performing request.
die 'UserAgent cannot connect to the internet, Script exiting early.' unless $ua->is_online; 

# FIXME: Actually perform requests
switch($args{verb}) {
    case "get" { print "GET: $url" },
    case "post" { print "POST: $url $data" },
    case "put" { print "PUT: $url $data" },
    case "patch" { print "PATCH: $url $data" },
    case "delete" { print "DELETE: $url" },
    else { print "GET: $url" },
}

if ($response->is_success) {
    print $response->decoded_content;
}
else {
    die $response->status_line;
}
