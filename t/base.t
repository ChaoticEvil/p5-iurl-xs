use strict;
use warnings;

use Test::More 'no_plan';

BEGIN { use_ok('IURL::XS'); };

use Data::Dumper; # TODO: remove after debugging

can_ok('IURL::XS', 'parse_url', 'split_url_path', 'parse_url_query');

subtest 'parse_url with minimal url' => sub {
    my $r;
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];

    $r = IURL::XS::parse_url('http://example.com');
    ok $r, 'minimal HTTP URL parsed ok';
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    ok !$r->{$_}, "no $_" for qw/port query path fragment/;
};

subtest 'parse_url with path (/)' => sub {
    my $r;
    my $expected_url_fields = [sort qw/scheme host port path query fragment/];

    $r = IURL::XS::parse_url('http://example.com/');
    ok $r, 'minimal HTTP URL parsed ok';
    is_deeply [sort keys %$r], $expected_url_fields, 'parsed url fields expected';
    is $r->{scheme}, 'http', 'url scheme is http';
    is $r->{host}, 'example.com', 'url host is example.com';
    ok !$r->{$_}, "no $_" for qw/port query path fragment/;
};

	# /* With path */
	# url_string = strdup("http://example.com/path");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with path ('/path')", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, "path", NULL, NULL);
	# free(url_string);

	# /* With port */
	# url_string = strdup("http://example.com:80");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port only", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 80, NULL, NULL, NULL);
	# free(url_string);

	# /* With query */
	# url_string = strdup("http://example.com?query=only");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with query only", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, NULL, "query=only", NULL);
	# free(url_string);

	# /* With fragment */
	# url_string = strdup("http://example.com#frag=f1");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with fragment only", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 0, NULL, NULL, "frag=f1");
	# free(url_string);

	# /* With credentials */
	# url_string = strdup("http://u:p@example.com");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with credentials only", -1 != rc);
	# assert_struct(url, "http", "u", "p", "example.com", 0, NULL, NULL, NULL);
	# free(url_string);

	# /* With port and path */
	# url_string = strdup("http://example.com:8080/port/and/path");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port and path", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 8080, "port/and/path", NULL, NULL);
	# free(url_string);

	# /* With port and query */
	# url_string = strdup("http://example.com:8080?query=portANDquery");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port and query", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 8080, NULL, "query=portANDquery", NULL);
	# free(url_string);

	# /* With port and fragment */
	# url_string = strdup("http://example.com:8080#f1");
	# rc = yuarel_parse(&url, url_string);
	# mu_assert("with port and fragment", -1 != rc);
	# assert_struct(url, "http", NULL, NULL, "example.com", 8080, NULL, NULL, "f1");
	# free(url_string);

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
