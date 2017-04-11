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

use WebService::HashiCorp::Vault::Secret;
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
 );

Returns a L<WebService::HashiCorp::Vault::Secret> object, all ready to be used.

=cut

sub secret {
    my $self = shift;
    my %args = @_;
    $args{mount} ||= 'secret';
    $args{token} = $self->token();
    $args{version} = $self->version();
    return WebService::HashiCorp::Vault::Secret->new( %args );
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
