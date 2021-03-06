#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault (Secret)

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Secret::LeasableBase;

use Moo;
# VERSION
use namespace::clean;

extends 'WebService::HashiCorp::Vault::Base';

has 'path'  => ( is => 'ro' );
has 'auth' => ( is => 'ro' );

=encoding utf8

=head1 SYNOPSIS

 package WebService::HashiCorp::Vault::Secret::Yours;
 use Moo;
 extends 'WebService::HashiCorp::Vault::Secret::LeasableBase';

 my $obj = WebService::HashiCorp::Vault::Secret::Yours->new(
   path => 'yours',
   %others
 );

=head1 DESCRIPTION

This base class is not intented to be used directly

=head1 METHODS

=head2 auth

 my $auth = $backend->auth();

B<Returns>

The 'auth' field of the Vault servers response.

=head2 creds

 my $credentials = $backend->creds($name);

Generates dynamic credentials based upon the named role

B<Paramaters>

=over 4

=item $name (string: B<required>) - Specifies the name of the role to create credentials against. This is part of the request URL.

=back

B<Returns>

A hashref containing the credentials

=cut

sub creds {
    my $self = shift;
    my $name = shift or return;
    return $self->get( $self->_mkuri($self->path, $name) );
}

=head2 path

 my $obj = WebService::HashiCorp::Vault::Secret::Yours->new(
     path => 'yours'
 );

 my $path = $obj->path();

Provides the path where the Secret service instance is mounted.

It is read-only once the object created.

=head1 SEE ALSO

L<WebService::HashiCorp::Vault>

=cut

1;
