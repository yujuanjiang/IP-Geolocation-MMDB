package IP::Geolocation::MMDB;

# SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later

use 5.016;
use warnings;
use utf8;

our $VERSION = 0.002;

require XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

sub new {
  my ($class, %attrs) = @_;

  my $file  = $attrs{file} or die q{The "file" parameter is mandatory};
  my $flags = 0;

  my $self = $class->_new($file, $flags);

  return $self;
}

sub getcc {
  my ($self, $ip_address) = @_;

  my $country_code;

  my $lookup_result = $self->record_for_address($ip_address);
  if (exists $lookup_result->{country}) {
    my $country = $lookup_result->{country};
    if (exists $country->{iso_code}) {
      $country_code = $country->{iso_code};
    }
  }

  return $country_code;
}

1;
__END__

=encoding UTF-8

=head1 NAME

IP::Geolocation::MMDB - Map IP addresses to country codes

=head1 VERSION

version 0.002

=head1 SYNOPSIS

  use IP::Geolocation::MMDB;
  my $db = IP::Geolocation::MMDB->new(file => 'GeoIP2-Country.mmdb');
  my $country_code = $db->getcc('2620:fe::9');

=head1 DESCRIPTION

A Perl module that maps IP addresses to two-letter country codes such as "DE",
"FR" and "US".

=head1 SUBROUTINES/METHODS

=head2 new

  my $db = IP::Geolocation::MMDB->new(file => 'GeoIP2-Country.mmdb');

Returns a new database object.  Dies if the specified file cannot be read.

=head2 getcc

  my $country_code = $db->getcc($ip_address);

Takes an IPv4 or IPv6 address as a string and returns a two-letter country
code or the undefined value.  Dies if the address is not a valid IP address.

=head2 record_for_address

  my $lookup_result = $db->record_for_address($ip_address);

Takes an IPv4 or IPv6 address as a string and returns the data associated with
the IP address or the undefined value.  Dies if the address is not a valid IP
address.

=head2 version

  my $version = IP::Geolocation::MMDB->version;

Returns the libmaxminddb version.

=head1 DIAGNOSTICS

=over

=item B<< Couldn't open database file >>

The database file could not be read.

=item B<< Couldn't parse IP address >>

A string did not contain a valid IP address.

=item B<< Couldn't look up IP address >>

A database error occurred while looking up an IP address.

=item B<< Couldn't read data for IP address >>

A database error occurred while reading the data associated with an IP
address.

=back

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 DEPENDENCIES

Requires Alien::libmaxminddb from CPAN.  On Windows, Alien::MSYS needs to be
installed.

Requires an IP to country database in the MaxMind DB file format from
L<DP-IP.com|https://db-ip.com/> or L<MaxMind|https://www.maxmind.com/>.

=head1 INCOMPATIBILITIES

None.

=head1 AUTHOR

Andreas Vögele E<lt>voegelas@cpan.orgE<gt>

=head1 BUGS AND LIMITATIONS

libmaxminddb uses 64-bit integers.

The data type MMDB_DATA_TYPE_UINT128 is currently not mapped to a number.

Some Windows versions do not support IPv6.

=head1 LICENSE AND COPYRIGHT

Copyright 2021 Andreas Vögele

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut