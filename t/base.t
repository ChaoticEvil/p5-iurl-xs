use strict;
use warnings;

use Test::More 'no_plan';

BEGIN { use_ok('IURL::XS'); };

use Data::Dumper; # TODO: remove after debugging

can_ok('IURL::XS', 'parse_url', 'split_url_path', 'parse_url_query');

subtest 'parse_url with minimal url' => sub {
    my $r = IURL::XS::parse_url('http://example.com');
    ok $r, 'minimal HTTP URL parsed ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/port query path fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
};

subtest 'parse_url with path (/)' => sub {
    my $r = IURL::XS::parse_url('http://example.com/');
    ok $r, 'parse_url with path (/) ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/port query path fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
};

subtest 'parse_url with path' => sub {
    my $r = IURL::XS::parse_url('http://example.com/path');
    ok $r, 'parse_url with path only ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/port query fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    is $r->{path}, 'path', 'url path is expected';
};

subtest 'parse_url with port' => sub {
    my $r = IURL::XS::parse_url('http://example.com:80');
    ok $r, 'parse_url with port only ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/path query fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    cmp_ok $r->{port}, '==', 80, 'http port is expected';
};

subtest 'parse_url with query' => sub {
    my $r = IURL::XS::parse_url('http://example.com?query=only');
    ok $r, 'parse_url with query only ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/port path fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    is $r->{query}, 'query=only', 'url query is expected';
};

subtest 'parse_url with fragment' => sub {
    my $r = IURL::XS::parse_url('http://example.com#frag=f1');
    ok $r, 'parse_url with fragment only ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/port path query/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    is $r->{fragment}, 'frag=f1', 'url fragment is expected';
};

subtest 'parse_url with credentials' => sub {
    my $r = IURL::XS::parse_url('http://u:p@example.com');
    ok $r, 'parse_url with credentials ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    # ok !$r->{$_}, "no $_" for qw/port path query/;
    # is $r->{scheme}, 'http', 'url scheme is http';
    # is $r->{host}, 'example.com', 'url host is example.com';
    # is $r->{fragment}, 'frag=f1', 'url fragment is expected';
};

subtest 'parse_url with port and path' => sub {
    my $r = IURL::XS::parse_url('http://example.com:8080/port/and/path');
    ok $r, 'parse_url with with port and path ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/query fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    cmp_ok $r->{port}, '==', 8080, 'port is expected';
    is $r->{path}, 'port/and/path', 'url path is expected';
};

subtest 'parse_url with port and query' => sub {
    my $r = IURL::XS::parse_url('http://example.com:8080?query=portANDquery');
    ok $r, 'parse_url with port and query ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/path fragment/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    cmp_ok $r->{port}, '==', 8080, 'port is expected';
    is $r->{query}, 'query=portANDquery', 'url query is expected';
};

subtest 'parse_url with port and fragment' => sub {
    my $r = IURL::XS::parse_url('http://example.com:8080#f1');
    ok $r, 'parse_url with port and fragment ok';
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    ok !$r->{$_}, "no $_" for qw/path query/;
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    cmp_ok $r->{port}, '==', 8080, 'port is expected';
    is $r->{fragment}, 'f1', 'url fragment is expected';
};

	# /* With port and credentials */
	# url_string = strdup("http://u:p@example.com:8080");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port and credentials", -1 != rc);
	# assert_struct(url, "http", "u", "p", "example.com", 8080, NULL, NULL, NULL);
	# free(url_string);

	# /* With path and query */
	# url_string = strdup("http://example.com/path/and/query?q=yes");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with path and query", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, "path/and/query", "q=yes", NULL);
	# free(url_string);

	# /* With path and fragment */
	# url_string = strdup("http://example.com/path/and#fragment");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with path and fragment", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, "path/and", NULL, "fragment");
	# free(url_string);

	# /* With query and fragment */
	# url_string = strdup("http://example.com?q=yes#f1");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with query and fragment", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, NULL, "q=yes", "f1");
	# free(url_string);

	# /* With query and credentials */
	# url_string = strdup("http://u:p@example.com?q=yes");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with query and credentials", -1 != rc);
	# assert_struct(url, "http", "u", "p", "example.com", 0, NULL, "q=yes", NULL);
	# free(url_string);

	# /* With empty credentials */
	# url_string = strdup("http://:@example.com");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with empty credentials", -1 != rc);
	# assert_struct(url, "http", "", "", "example.com", 0, NULL, NULL, NULL);
	# free(url_string);

	# /* With empty credentials and port */
	# url_string = strdup("http://:@example.com:89");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with empty credentials and port", -1 != rc);
	# assert_struct(url, "http", "", "", "example.com", 89, NULL, NULL, NULL);
	# free(url_string);

	# /* Full URL */
	# url_string = strdup("https://jack:password@localhost:8989/path/to/test?query=yes&q=jack#fragment1");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port, path and query", -1 != rc);
	# assert_struct(url, "https", "jack", "password", "localhost", 8989, "path/to/test", "query=yes&q=jack", "fragment1");
	# free(url_string);

# subtest 'split_url_path' => sub {
#     ok 1;
# };

# subtest 'parse_url_query' => sub {
#     ok 1;
# };

done_testing();
