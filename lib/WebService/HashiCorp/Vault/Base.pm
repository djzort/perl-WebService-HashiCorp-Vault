#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault (Base)

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Base;

use Moo;
# VERSION
use namespace::clean;

with 'WebService::Client';

has '+base_url' => ( default => 'http://127.0.0.1:8200' );
has token => ( is => 'ro', required => 1 );
has version => ( is => 'ro', default => 'v1' );
has mount => ( is => 'ro' );

sub BUILD {
    my $self = shift;
    $self->ua->default_header('X-Vault-Token' => $self->token);
}

sub _mkuri {
    my $self = shift;
    use Data::Dumper;
    my @paths = @_;
    return join '/',
        $self->base_url,
        $self->version,
        $self->mount,
        @paths
}

1;

=for Pod::Coverage BUILD

=encoding utf8

=head1 SYNOPSIS

 package WebService::HashiCorp::Vault::Something;
 use Moo;
 extends 'WebService::HashiCorp::Vault::Base';

=head1 DESCRIPTION

Base class for everything in WebService::HashiCorp::Vault.

Builds on top of L<WebService::Client>, adds a few things.

=head1 METHODS

=head2 base_url

 my $obj = WebService::HashiCorp::Vault::Something->new(
     base_url => 'https://127.0.0.1:8200'
 );

 my $base_url = $obj->base_url();

The base url of the Vault instance you are talking to.
Is read-only once you have created the object.

=head2 token

 my $obj = WebService::HashiCorp::Vault::Something->new(
     token => 'xxxxxxxxxxxx'
 );

 my $token = $obj->token();

The authentication token, is read-only after object is created.

=head2 version

 my $obj = WebService::HashiCorp::Vault::Something->new(
   version => 'v1'
 );

 my $version = $obj->version();

Allows you to set the API version if it changes in the future.
Default to 'v1' and you probably don't need to touch it.

Read-only one the object is created.

=head2 mount

 my $obj = WebService::HashiCorp::Vault::Something->new(
   mount => '/something'
 );

 my $version = $obj->mount();

The mount location of the resource. There is no default, but you should apply one in your class that builds upon this class.

=head1 SEE ALSO

L<WebService::HashiCorp::Vault>

=cut
