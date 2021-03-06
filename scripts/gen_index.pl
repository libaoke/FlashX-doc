#/usr/bin/perl

use strict;

my $num_args = @ARGV;

if ($num_args < 2) {
	print STDERR "gen_index rd_file html_file proj_name\n";
	exit(1);
}

open(my $in_fh, "<", $ARGV[0]) or die "open $ARGV[0]: $!";
open(my $out_fh, ">", $ARGV[1]) or die "open $ARGV[1]: $!";
my $proj_name = $ARGV[2];

print $out_fh "---\n";
print $out_fh "title: $proj_name API\n";
print $out_fh "keywords: API\n";
print $out_fh "last_updated: Dec 28, 2016\n";
print $out_fh "tags: [API]\n";
print $out_fh "summary: \"$proj_name API\"\n";
print $out_fh "sidebar: mydoc_sidebar\n";
print $out_fh "permalink: $proj_name-API.html\n";
print $out_fh "folder: mydoc\n";
print $out_fh "---\n\n\n";
print $out_fh "| name | comment |\n";
print $out_fh "| :--- | :------ |\n";

while (<$in_fh>) {
	chomp($_);
	if ($_ eq "") {
		next;
	}
	if ($_ =~ /([^ ]+) +([^ ].*)$/) {
		my $name = $1;
		my $msg = $2;
		print $out_fh "| [$name]($proj_name-API/${name}.Rd.html) | $msg |\n";
	}
}

close $in_fh;
close $out_fh;
