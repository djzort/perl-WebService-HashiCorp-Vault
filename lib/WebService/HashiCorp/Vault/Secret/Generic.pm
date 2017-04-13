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
has 'data' => ( is => 'rw',
                trigger => sub {
                    my $self = shift;
                    $self->_save(@_);
                    $self->BUILD()
                });
has 'lease_duration' => ( is => 'ro' );
has 'lease_id' => ( is => 'ro' );
has 'renewable' => ( is => 'ro' );

sub BUILD {
    my $self = shift;
    $self->_clear_self();
    if (my $resp = $self->get( $self->_mkuri($self->path) )) {
        $self->{auth} = $resp->{auth}
            if $resp->{auth};
        $self->{data} = $resp->{data}; # avoid tiggerng the trigger
        $self->{lease_duration} = $resp->{lease_duration}
            if $resp->{lease_duration};
        $self->{lease_id} = $resp->{lease_id}
            if $resp->{lease_id};
        $self->{renewable} = 0 + $resp->{renewable} # convert from JSON::Boolean
            if $resp->{renewable};
    }
}

=encoding utf8

=head1 SYNOPSIS

 use WebService::HashiCorp::Vault;
 my $vault->new(%args);

 # Grab or prepare to instantiate a secret 'path'
 my $foo = $vault->secret( backend => 'generic', path => 'foo' );

 # Examine the data
 my $data = $foo->data();

 # Save the data in to the secret
 $foo->data({
    Lorem => 'ipsum'.
    dolor => 'sit'
    amet => 'consectetur'
    });

 # Delete the secret
 $foo->delete();

=head1 DESCRIPTION

The Generic Secret Backend handling for HashiCorps Vault server software.
To be used via L<WebService::HashiCorp::Vault>.

=head1 METHODS

=head2 data

 my $data = $secret->data();
 $secret->data( \%hashref );

Without arguments, returns the secrets data as a hashref (if any exists)

With an arugment (must be hashref), data is saved to the secret

=cut

sub _clear_self {
    my $self = shift;
    for my $k (qw/ auth data lease_duration lease_id renewable /) {
        delete $self->{$k} if $self->{$k}
    }
    return 1
}

=head2 delete

 $secret->delete();

Deletes the secret from the Vault server, and clears the internals of the object.
The secret path and server details are retained so you can delete then save data.

=cut

sub delete {
    my $self = shift;
    my $result = $self->SUPER::delete( $self->_mkuri($self->path) );
    $self->_clear_self();
    return $result
}

sub _save {
    my $self = shift;
    my $data = shift;
    die sprintf( "Secret data must be hashref, not a %s\n", ref $data )
       if ref $data ne 'HASH';
    return $self->post( $self->_mkuri($self->path), $data );
}

1;
