#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault;

use Moo;
# VERSION

extends 'WebService::HashiCorp::Vault::Base';
use namespace::clean;

use WebService::HashiCorp::Vault::Secret::Cassandra;
use WebService::HashiCorp::Vault::Secret::Generic;
use WebService::HashiCorp::Vault::Secret::MongoDB;
use WebService::HashiCorp::Vault::Secret::MSSQL;
use WebService::HashiCorp::Vault::Secret::MySQL;
use WebService::HashiCorp::Vault::Secret::PostgreSQL;
use WebService::HashiCorp::Vault::Secret::RabbitMQ;
use WebService::HashiCorp::Vault::Sys;

sub BUILD {
    my $self = shift;
    $self->ua->default_header('X-Vault-Token' => $self->token);
}

=encoding utf8

=head1 SYNOPSIS

 use WebService::HashiCorp::Vault;

 my $vault = WebService::HashiCorp::Vault->new(
     token => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
     base_url => 'http://127.0.0.1:8200', # optional, default shown
     verson => 'v1', # optional, for future use if api changes

 );

 my $secret = $vault->secret();
 my $sys    = $vault->sys();

=head1 DESCRIPTION

A perl API for convenience in using HashiCorp's Vault server software.

=head1 METHODS

=head2 secret

 my $secret = $vault->secret(
     mount => 'secret', # optional if mounted non-default
     backend => 'Generic', # or MySQL, or SSH, or whatever
 );

Returns a L<WebService::HashiCorp::Vault::Secret::Generic> object, all ready to be used.
Or whatever object based upon provided backend parameter.

=cut

{

    my %backendmap = (
        aws => 'AWS',
        cassandra => 'Cassandra',
        consul => 'Consul',
        cubbyhole => 'Cubbyhole',
        generic => 'Generic',
        mongodb => 'MongoDB',
        mssql => 'MsSQL',
        mysql => 'MySQL',
        pki => 'PKI',
        postgresql => 'PostgreSQL',
        rabbitmq => 'RabbitMQ',
        ssh => 'SSH',
        transit => 'Transit',
    );

sub secret {
    my $self = shift;
    my %args = @_;
    $args{token}   = $self->token();
    $args{version} = $self->version();
    $args{backend} ||= 'generic';
    die sprintf( "Unknown backend type: %s\n", $args{backend} )
        unless $backendmap{ lc($args{backend}) };
    my $class = 'WebService::HashiCorp::Vault::Secret::'
              . $backendmap{ lc($args{backend}) };
    return $class->new( %args );
}

}

=head2 sys

 my $sys = $vault->sys(
     mount => 'sys', # optional if mounted non-default
 );

Returns a L<WebService::HashiCorp::Vault::Sys> object, all ready to be used.

=cut

sub sys {
    my $self = shift;
    my %args = @_;
    $args{mount} ||= 'sys';
    $args{token} = $self->token();
    $args{version} = $self->version();
    return WebService::HashiCorp::Vault::Sys->new( %args );
}

1;
