#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault;

use Moo;
use namespace::clean;

use 'WebService::HashiCorp::Vault::Secret';
use 'WebService::HashiCorp::Vault::System';

extends 'WebService::HashiCorp::Vault::Base';

sub BUILD {
    my $self = shift;
    $self->ua->default_header('X-Vault-Token' => $self->token);
}

sub secret {
    my $self = shift;
    my %args = @_;
    $args{mount} ||= 'secret';
    return WebService::HashiCorp::Vault::Secret->new(
    );
}

sub system {
    my $self = shift;
    my %args = @_;
    $args{mount} ||= 'system';
    return WebService::HashiCorp::Vault::System->new(
    );
}

1;
