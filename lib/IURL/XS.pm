package IURL::XS;

use 5.024000;
use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw(parse_url);

our $VERSION = '0.1.0';

require XSLoader;
XSLoader::load('IURL::XS', $VERSION);

1;

__END__
