#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Base;
use Moo;
use namespace::clean;

with 'WebService::Client';

has '+base_url' => ( default => 'http://127.0.0.1:8200' );
has token => ( is => 'ro', required => 1 );
has version => ( is => 'ro', default => 'v1' );
has mount => ( is => 'ro', required => 1 );

sub BUILD {
    my $self = shift;
    $self->ua->default_header('X-Vault-Token' => $self->token);
}

sub _mkuri {
    my $self = shift;
    my @paths = @_;
    return join '/',
        $self->base_url,
        $self->version,
        $self->mount,
        @paths;
}

1;
