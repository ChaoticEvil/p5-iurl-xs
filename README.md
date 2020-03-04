# IURL::XS

IURL::XS - perl binding to libyaurel (simple C library for parsing URLs with zero-copy and no mallocs).

# Motivation

...
```
              Rate Mojo::URL       URI   URI::XS  IURL::XS
Mojo::URL  56296/s        --      -54%      -91%      -91%
URI       121197/s      115%        --      -80%      -81%
URI::XS   608746/s      981%      402%        --       -4%
IURL::XS  632644/s     1024%      422%        4%        --
```

## Dependences & requires

Required Perl >= v5.24.0

## Installation

To manual install this module type the following (may be you need root/sudo permission to install into the system):

```
$ git clone ...
$ cd p5-iurl-xs/
$ perl Makefile.PL
$ make
$ make test
$ make install
```

To automatical install this module type the following:

```
$ cpan -i IURL::XS
```

## Usage

### From shell (as one-liner)

```
$ perl -MIURL::XS=parse_url -MData::Dumper -e \
    "print Dumper parse_url('http://localhost:8989/path/to/test?query=yes#frag=1')"
```

### From perl code

```perl
use IURL::XS ();

my $url = 'http://localhost:8989/path/to/test?query=yes#frag=1';
my $parsed_url = IURL::XS::parse_url($url);
```

## CopyRight and license

The MIT License (MIT)

Copyright (c) 2020 Peter P. Neuromantic \<p.brovchenko@protonmail.com\>.\
All rights reserved.

See LICENSE file for more information.
