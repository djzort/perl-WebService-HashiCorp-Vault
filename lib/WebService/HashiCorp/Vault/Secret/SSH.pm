#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault (Secret)

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Secret::SSH;

use Moo;
# VERSION
use namespace::clean;

extends 'WebService::HashiCorp::Vault::Base';

has '+mount'  => ( is => 'ro', default => 'ssh' );

=encoding utf8

=head1 SYNOPSIS

 use WebService::HashiCorp::Vault;
 my $vault->new(%args);

 my $foo = $vault->secret( backend => 'ssh' );

=head1 DESCRIPTION

The SSH Secret Backend handling for HashiCorps Vault server software.
To be used via L<WebService::HashiCorp::Vault>.

=head1 METHODS

=head2 roles

=cut

sub roles {
    my $self = shift;
    warn $self->_mkuri( 'roles' );
    return $self->list( $self->_mkuri( 'roles' ));
}


=head1 SEE ALSO

L<WebService::HashiCorp::Vault>

=cut

1;
