#!/usr/bin/env perl
package shis;

use strict;
use warnings;

use HTTP::CookieJar::LWP ();
use LWP::UserAgent       ();
use Getopt::Long;
use Switch;
use JSON::Parse 'parse_json';

# globals
my %args;
my $response;

# Helper, returns true if given string (arg1)
# starts with another given string (arg2)
sub stringstart {
    return substr($_[0], 0, length[$_[1]]) eq $_[1];
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

# Request Handlers
sub perform_get {
    $response = $ua->get($_[0]);
}

sub perform_post {
    die 'Missing data, Script exiting early.' unless $_[1];
    $response = $ua->post($_[0], %form_data);
}

sub perform_put {
    die 'Missing data, Script exiting early.' unless $_[1];
    $response = $ua->put($_[0], %form_data)
}

sub perform_patch {
    die 'Missing data, Script exiting early.' unless $_[1];
    $response = $ua->patch($_[0], %form_data);
}

sub perform_delete {
    die 'Missing data, Script exiting early.' unless $_[1];
    $response = $ua->delete($_[0], %form_data);
}

# Sanity check - Determine if machine has internet connection
# before performing request.
die 'UserAgent cannot connect to the internet, Script exiting early.' unless $ua->is_online; 

# Populate the %form_data hash if we can
%form_data = parse_json($args{data}) if $args{data};

switch($args{verb}) {
    case "get" { perform_get $url, %form_data },
    case "post" { perform_post $url, %form_data },
    case "put" { perform_put $url, %form_data },
    case "patch" { perform_patch $url, %form_data },
    case "delete" { perform_delete $url, %form_data },
    else { perform_get $url },
}

if ($response->is_success) {
    print $response->decoded_content;
}
else {
    die $response->status_line;
}
