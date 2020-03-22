package IURL::XS;

use 5.024000;
use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw(parse_url);

our $VERSION = '0.9.0';

require XSLoader;
XSLoader::load('IURL::XS', $VERSION);

1;

__END__

=encoding UTF-8

=head1 NAME

IURL::XS - ...

=head1 DESCRIPTION

IURL::XS - is a small (one function), simple and fast Perl-XS module
for creation a thumbnails (with resizing and cropping), using Imlib2 library.

=head1 AUTHOR

Peter P. Neuromantic <p.brovchenko@protonmail.com>

=head1 SYNOPSIS

  use IRUL::XS (parse_url split_url_path parse_url_query);

  ...

=head1 FUNCTIONS

=head2 parse_url($)

Creates a small copy (resizing and cropping) of the image.

=over 20

=item $_[0]->{width}  - destination width

=back

=head1 LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2020 Peter P. Neuromantic E<lt>p.brovchenko@protonmail.comE<gt>.
All rights reserved.

See LICENSE file for more information.

=cut
