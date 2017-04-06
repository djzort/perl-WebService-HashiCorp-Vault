#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault;
use Moo;
use namespace::clean;

with 'WebService::Client';

has '+base_url' => ( default => 'http://127.0.0.1:8200' );
has token => ( is => 'ro', required => 1 );
has version => ( is => 'ro', default => 'v1' );
has mount => ( is => 'ro', default => 'secret' );

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

sub secret {
    my $self = shift;
    my $name = shift;
    my %args = @_;

    # TODO both should return an object

    # this is a save (put)
    if (keys %args) {
        return $self->put( $self->_mkuri($name), \%args )
    }
    # this is a get
    else {
        return $self->get( $self->_mkuri($name) )
    }
}


1;
