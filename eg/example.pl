#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;

use lib 'lib';

use WebService::HashiCorp::Vault;

my $vault = WebService::HashiCorp::Vault->new( token => '94257c2a-a475-a301-cd33-2ead770de31b' );

print Dumper $vault;


my $list = $vault->secret( backend => 'generic' )->list;

print Dumper $list;


__END__

my $sys = $vault->sys;
print Dumper $sys->health();
print Dumper $sys->init();
print Dumper $sys->leader();
print Dumper $sys->mounts();
print Dumper $sys->policy();
print Dumper $sys->seal_status();

my $baz = $vault->secret( backed => 'generic', path => 'baz' );

print Dumper $baz->data;

my $newthing = $vault->secret( backed => 'generic', path => 'newthing2' );
$newthing->data( { hello => 'there', whats => 'yourname today', 'time' => time() } );
# $newthing->delete();
