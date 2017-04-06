#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac

{
    package WebService::HashiCorp::Vault;
    use Moo;
    with 'WebService::Client';

    has '+address' => { default => 'http://127.0.0.1:8200' };
    has token => { is => 'ro', required => 1 };

    sub BUILD {
        my $self = shift;
        $self->ua->default_header('X-Vault-Token' => $self->token);
    }

}

1;
