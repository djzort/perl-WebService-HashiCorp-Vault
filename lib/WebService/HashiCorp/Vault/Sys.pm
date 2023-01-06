#!perl
# vim: softtabstop=4 tabstop=4 shiftwidth=4 ft=perl expandtab smarttab
# ABSTRACT: Perl API for HashiCorp's Vault (System)

# See also https://github.com/hashicorp/vault-ruby
# And https://github.com/ianunruh/hvac
# And https://www.vaultproject.io/api/index.html

package WebService::HashiCorp::Vault::Sys;

use Moo;
# VERSION
use namespace::clean;
extends 'WebService::HashiCorp::Vault::Base';

has '+mount' => ( is => 'ro', default => 'sys' );

=encoding utf8

=head1 SYNOPSIS

 use WebService::HashiCorp::Vault;
 my $vault = WebService::HashiCorp::Vault->new(%args);

 my $sys = $vault->sys();

 my $health = $sys->health();

=head1 DESCRIPTION

The /sys functions in the Vault REST api.

=head1 METHODS

=cut

#
#            <a href="/api/system/audit.html"><tt>/sys/audit</tt></a>
#

=head2 audit

 my $audit = $sys->audit();

Returns the 'audit' of the vault from API location I</sys/audit>

The result is a hash reference

=cut

sub audit {
    my $self = shift;
    return $self->get( $self->_mkuri('audit') )
}

=head2 audit_put

 my $audit = $sys->audit($audit_device, %options);

Add an audit device.
Returns true (1) if it succeeds, false (0) other wise.

=cut

sub audit_put {
    my ( $self, $name, %params ) = @_;
    return $self->_sys_put( 'audit', $name, %params );

}


=head2 audit_del

 my $audit = $sys->auth_del($audit_device);

Delete an audit device.

=cut

sub audit_del {
    my ( $self, $name ) = @_;
    return $self->_sys_del( 'audit', $name );
}



#            <a href="/api/system/audit-hash.html"><tt>/sys/audit-hash</tt></a>
#
#
#            <a href="/api/system/auth.html"><tt>/sys/auth</tt></a>

=head2 auth

 my $auth = $sys->auth();

Returns the 'auth' of the vault from API location I</sys/auth>

The result is a hash reference 


=cut

sub auth {
    my $self = shift;
    return $self->get( $self->_mkuri('auth') );
}

=head2 auth_put

 my $audit = $sys->auth($auth_method, %options);

Add an Auth method
Returns true (1) if it succeeds, false (0) other wise.

=cut

sub auth_put {
    my ( $self, $name, %params ) = @_;
    return $self->_sys_put( 'audit', $name, %params );

}

=head2 auth_del

 my $audit = $sys->auth_del($audit_device);

Delete an auth method.

=cut

sub auth_del {
    my ( $self, $name ) = @_;
    return $self->_sys_del( 'audit', $name );
}

#
# Internal functions to do the put/del actions.
#
sub _sys_put {
    my ( $self, $sys_type, $name, %params ) = @_;
    my $uri = join '/', $self->_mkuri($sys_type), $name;
    return $self->post( $uri, \%params );

}

sub _sys_del {
    my ( $self, $sys_type, $name ) = @_;
    my $uri = join '/', $self->_mkuri($sys_type), $name;
    return $self->delete( $uri );

}


#            <a href="/api/system/capabilities.html"><tt>/sys/capabilities</tt></a>
#
#
#            <a href="/api/system/capabilities-accessor.html"><tt>/sys/capabilities-accessor</tt></a>
#
#
#            <a href="/api/system/capabilities-self.html"><tt>/sys/capabilities-self</tt></a>
#
#
#            <a href="/api/system/config-auditing.html"><tt>/sys/config/auditing</tt></a>
#
#
#            <a href="/api/system/generate-root.html"><tt>/sys/generate-root</tt></a>
=head2 generate_root

 my $generate-root = $sys->generate-root();

Returns the 'generate-root/attempt' of the vault from API location I</sys/generate-root/attempt>

The result is a hash reference

TODO: implement PUT and DELETE auth with this function

=cut

sub generate_root {
    my $self = shift;
    return $self->get( $self->_mkuri('generate-root') )
}

=head2 health

 my $health = $sys->health();

Returns the 'health' of the vault from API location I</sys/health>

The result is a hash reference

=cut

sub health {
    my $self = shift;
    return $self->get( $self->_mkuri('health') )
}

=head2 init

 my $init = $sys->init();

Returns the 'init' of the vault from API location I</sys/init>

The result is a hash reference

TODO: implement PUT

=cut

sub init {
    my $self = shift;
    return $self->get( $self->_mkuri('init') )
}

=head2 key_status

 my $key_status = $sys->key_status();

Returns the 'key-status' of the vault from API location I</sys/key-status>

The result is a hash reference

=cut

sub key_status {
    my $self = shift;
    return $self->get( $self->_mkuri('key-status') )
}

=head2 leader

 my $leader = $sys->init();

Returns the 'leader' of the vault from API location I</sys/init>

The result is a hash reference

=cut

sub leader {
    my $self = shift;
    return $self->get( $self->_mkuri('leader') )
}

=for Pod::Coverage mount

=head2 mounts

 my $mounts = $sys->mounts();

Returns the 'mounts' of the vault from API location I</sys/mounts>

The result is a hash reference

TODO: implement making mounts with this function

=cut

sub mounts {
    my $self = shift;
    return $self->get( $self->_mkuri('mounts') )
}

=head2 policy

 my $policy = $sys->policy();

Returns the 'policy' of the vault from API location I</sys/policy>

The result is a hash reference

TODO: implement making policy with this function

=cut

sub policy {
    my $self = shift;
    return $self->get( $self->_mkuri('policy') )
}

#            <a href="/api/system/raw.html"><tt>/sys/raw</tt></a>
#            <a href="/api/system/rekey.html"><tt>/sys/rekey</tt></a>

=head2 rekey_init

 my $rekey_init = $sys->rekey_init();

Returns the 'rekey/init' of the vault from API location I</sys/rekey/init>

The result is a hash reference

TODO: implement PUT and DELETE

=cut

sub rekey_init {
    my $self = shift;
    return $self->get( $self->_mkuri('rekey/init') )
}

=head2 rekey_backup

 my $rekey_backup = $sys->rekey_backup();

Returns the 'rekey/backup' of the vault from API location I</sys/rekey/backup>

The result is a hash reference

TODO: implement DELETE

=cut

sub rekey_backup {
    my $self = shift;
    return $self->get( $self->_mkuri('rekey/backup') )
}

#=head2 rekey_update
#
# my $rekey_update = $sys->rekey_update();
#
#Returns the 'rekey/update' of the vault from API location I</sys/rekey/update>
#
#The result is a hash reference
#
#TODO: implement DELETE
#
#=cut
#
#sub rekey_update {
#    my $self = shift;
#    return $self->get( $self->_mkuri('rekey/update') )
#}

#            <a href="/api/system/remount.html"><tt>/sys/remount</tt></a>
#            <a href="/api/system/renew.html"><tt>/sys/renew</tt></a>
#            <a href="/api/system/replication.html"><tt>/sys/replication</tt></a>
#            <a href="/api/system/revoke.html"><tt>/sys/revoke</tt></a>
#            <a href="/api/system/revoke-force.html"><tt>/sys/revoke-force</tt></a>
#            <a href="/api/system/revoke-prefix.html"><tt>/sys/revoke-prefix</tt></a>
#            <a href="/api/system/rotate.html"><tt>/sys/rotate</tt></a>
#            <a href="/api/system/seal.html"><tt>/sys/seal</tt></a>
#            <a href="/api/system/seal-status.html"><tt>/sys/seal-status</tt></a>

=head2 seal_status

 my $seal_status = $sys->seal_status();

Returns the 'seal-status' of the vault from API location I</sys/seal-status>

The result is a hash reference

=cut

sub seal_status {
    my $self = shift;
    return $self->get( $self->_mkuri('seal-status') )
}

#            <a href="/api/system/step-down.html"><tt>/sys/step-down</tt></a>
#            <a href="/api/system/unseal.html"><tt>/sys/unseal</tt></a>
#            <a href="/api/system/wrapping-lookup.html"><tt>/sys/wrapping/lookup</tt></a>
#            <a href="/api/system/wrapping-rewrap.html"><tt>/sys/wrapping/rewrap</tt></a>
#            <a href="/api/system/wrapping-unwrap.html"><tt>/sys/wrapping/unwrap</tt></a>
#            <a href="/api/system/wrapping-wrap.html"><tt>/sys/wrapping/wrap</tt></a>
#

1;
