#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault (Secret)

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Secret::Generic;

use Moo;
# VERSION
use namespace::clean;

extends 'WebService::HashiCorp::Vault::Base';

has '+mount'  => ( is => 'ro', default => 'secret' );
has 'path'  => ( is => 'ro', required => 1 );
has 'auth' => ( is => 'ro' );
has 'data' => ( is => 'rw' );
has 'lease_duration' => ( is => 'ro' );
has 'lease_id' => ( is => 'ro' );
has 'renewable' => ( is => 'ro' );

sub BUILD {
    my $self = shift;
    if (my $resp = $self->get( $self->_mkuri($self->path) )) {
        $self->{auth} = $resp->{auth}
            if $resp->{auth};
        $self->data( $resp->{data} );
        $self->{lease_duration} = $resp->{lease_duration}
            if $resp->{lease_duration};
        $self->{lease_id} = $resp->{lease_id}
            if $resp->{lease_id};
        $self->{renewable} = 0 + $resp->{renewable} # convert from JSON::Boolean
            if $resp->{renewable};
    }
}

sub delete {
    my $self = shift;
    my $result = $self->delete( $self->_mkuri($self->path) );
    $self->{data} = undef; # FIXME whatever?
}

# FIXME how to trigger this automaticaly?
sub save {
    my $self = shift;
    return $self->post( $self->_mkuri($self->path), $self->data() );

}

1;
