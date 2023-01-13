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
has token => ( is => 'rw' );
has _token_expires => ( is => 'rw' );
has approle => ( is => 'ro' );
has version => ( is => 'ro', default => 'v1' );
has mount => ( is => 'ro' );

before 'get' => sub {
    $_[0]->_check_token();
    $_[0]->_set_headers();
};

before 'post' => sub {
    # Skip checking the token on a token request
    if ($_[1] !~ m#auth/approle/login$#) {
        $_[0]->_check_token();
    }
    $_[0]->_set_headers();
};

before 'put' => sub {
    $_[0]->_check_token();
    $_[0]->_set_headers();
};

before 'delete' => sub {
    $_[0]->_check_token();
    $_[0]->_set_headers();
};

sub _check_token {
    my $self = shift;

    $self->_request_token()
        unless defined $self->token;

    ## Check the token and get a new one if required
    if (defined $self->_token_expires && (time > $self->_token_expires)) {
        $self->_request_token()
    }
}

sub _set_headers {
    my $self = shift;
    $self->ua->default_header(
        'X-Vault-Token' => $self->token,
        'User_Agent'    => sprintf(
            'WebService::HashiCorp::Vault %s (perl %s; %s)',
            __PACKAGE__->VERSION,
            $^V, $^O),
    );
}

sub _mkuri {
    my $self = shift;
    my @paths = @_;
    return join '/',
        $self->base_url,
        $self->version,
        $self->mount,
        @paths
}


sub _request_token {
    my $self = shift;

    die 'Must provide either token or approle'
        unless defined $self->approle;
    die 'role_id missing in approle'
        unless defined $self->approle->{role_id};
    die 'secret_id missing in approle'
        unless defined $self->approle->{secret_id};

    my $url  =  join('/', $self->base_url, $self->version, 'auth/approle/login');
    my $resp =  $self->post( $url , $self->approle );
    $self->{token} = $resp->{auth}->{client_token};
    ## Set the expiry to 1 second before acutal expiry
    $self->_token_expires(time + $resp->{auth}->{lease_duration} - 1);
}

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

The authentication token.

=head2 approle

 my $obj = WebService::HashiCorp::Vault::Something->new(
     approle => {
        role_id   => 'xxxxxxx',
        secret_id => 'xxxxx',
     }
 );


The client approle.

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

=head2 list

 my $list = $obj->list('path');

HashiCorp have decided that 'LIST' is a http verb, so we must hack it in.

You can pretend this is now a normal part of L<WebService::Client> upon which this module is based.

=cut

sub list {
    my ($self, $path) = @_;

    $self->_check_token;
    $self->_set_headers;

    my $headers = $self->_headers();
    my $url = $self->_url($path);

    # HashiCorp have decided that 'LIST' is a http verb, so we must hack it in
    my $req = HTTP::Request->new(
        'LIST' => $url,
        HTTP::Headers->new(%$headers)
    );

    # this is a WebService::Client internal function. I said hack!
    return $self->req( $req );

}

=head1 SEE ALSO

L<WebService::HashiCorp::Vault>

=cut

1;
