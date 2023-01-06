#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;

use lib 'lib';

use WebService::HashiCorp::Vault;

my $TOKEN = $ENV{VAULT_ROOT_TOKEN_ID};
die "Please set your root token" if ! $TOKEN;

my $vault = WebService::HashiCorp::Vault->new(token => $TOKEN);

die "Couldn't open vault" if !$vault;

my $sys = $vault->sys;

my $audits = $sys->audit;
my @keys;
for my $key (keys %{$audits->{data}}) {
    next if $key eq 'audit_name/';
    $key =~ s!\/$!!;
    push @keys, $key;
}

if (!$audits->{data}{"goat/"}) {
    print "About to add audit goat\n";
    $sys->audit_put('goat', type => 'file', options => {file_path  => '/tmp/goat'});
}


$audits = $sys->audit;

if ($audits->{data}{"goat/"}) {
    print "Either we added goat or it was there already\n";
}

$sys->audit_del('goat');

$audits = $sys->audit;

if (!$audits->{data}{"goat/"}) {
    print   " Deleted goat\n";
}
my $auths = $sys->auth;

for my $key (keys %{$auths->{data}}) {
    next if $key eq 'auth_name/';
    $key =~ s!\/$!!;
    push @keys, $key;
}

if (!$auths->{data}{"goat/"}) {
    print "About to add auth goat\n";
    $sys->auth_put('goat', type => 'file', options => {file_path  => '/tmp/goat'});
}


$auths = $sys->auth;

if ($auths->{data}{"goat/"}) {
    print "Either we added goat or it was there already\n";
}

$sys->auth_del('goat');

$auths = $sys->auth;

if (!$auths->{data}{"goat/"}) {
    print   " Deleted goat\n";
}


my $cubby = $vault->secret( backend => 'cubbyhole', path => 'cubbyhole' );

$cubby->data({ hello => 'there' });

p $cubby->data();

warn "deleted";
$cubby->delete();

# p $cubby;

warn "grab list of cubbyholes";
my $list = $vault->secret( backend => 'cubbyhole' )->list;

p $list;

# my $list = $vault->secret( backend => 'generic' )->list;

# p $list;


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
