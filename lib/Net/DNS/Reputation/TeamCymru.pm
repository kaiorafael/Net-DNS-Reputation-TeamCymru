package Net::DNS::Reputation::TeamCymru;

use 5.006;
use Net::DNS::Simple;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub new {
	my ($class, $args) = @_;
	my $self = {
		_entity => $args->{entity}, # ipv4, revipv4, ASN
		_service => $args->{service},
		_ip_addr => undef,
	};

	my $object = bless $self, $class;
	$object->set_entity;
	return $object;
}

sub get_service {
	my $domain_service = {
		origin => 'origin.asn.cymru.com',
		origin6 =>'origin6.asn.cymru.com',
		peer =>'peer.asn.cymru.com',
		asn =>'asn.cymru.com',
	};
	#first arg $_1 passed to function
	return $domain_service->{$_[1]};
}

sub parse_ipaddr {
	my $self = shift;

	my @ip4 = split /\./, $self->{_entity};
	#check for reverse first
	if ($self->{_entity} =~ m/in-addr.arpa/is) {
		return $ip4[0].".".$ip4[1].".".$ip4[2].".".$ip4[3].".".$self->get_service($self->{_service});
	}

	#tip from txt2re.com
	my $re1='((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))(?![\\d])';# IPv4 IP Address 1
	my $re=$re1;
	if ($self->{_entity} =~ m/$re/is) {
		return $ip4[3].".".$ip4[2].".".$ip4[1].".".$ip4[0].".".$self->get_service($self->{_service});
	}
}

sub set_entity {
	my $self = shift;

	# rev.ip.teamcymru.domain
	if ( $self->{_service} eq "origin" ) {
		$self->{_ip_addr} = $self->parse_ipaddr();
	}

	if ( $self->{_service} eq "origin6" ) {
		#TODO must to regex for IPv6 addr :(
		$self->{_ip_addr} = $self->{_entity}.".".$self->get_service($self->{_service});
	}

	if ( $self->{_service} eq "peer" ) {
		$self->{_ip_addr} = $self->parse_ipaddr();
	}

	if ( $self->{_service} eq "asn" ) {
		if ( $self->{_entity} =~ m/AS/is ) {
			$self->{_ip_addr} = $self->{_entity}.".".$self->get_service($self->{_service});
		}
		else { die "I need the ASN name such as:  AS23028"; }
	}	
}

sub get_response {
	my $self = shift;
	my $res = Net::DNS::Simple->new($self->{_ip_addr}, "TXT");

	if ( $res->get_ancount() <= 0 ) { return ""; }
	else { return $res->get_answer_section(); }
}

1;

=head1 EXAMPLE

my $foo = Net::DNS::Reputation::TeamCymru->new({
#               entity                           => '216.90.108.31',
		entity                           => '1.79.242.200.in-addr.arpa.',
		service                          => 'origin',
#		entity                           => '2.0.0.b.0.6.8.4.1.0.0.2',
#		service                          => 'origin6',
#		entity                           => '200.242.79.172',
#		service                          => 'peer',
#		entity                           => 'AS23028',
#		service                          => 'asn',
	}
);
print $foo->get_response(), "\n";

=cut

__END__

=head1 NAME

Net::DNS::Reputation::TeamCymru - Perl module for using TeamCymru services.

=head1 SYNOPSIS

  use Net::DNS::Reputation::TeamCymru;
  my $foo = Net::DNS::Reputation::TeamCymru->new({
		entity => 'IPADDR',
		service => 'origin',
	}
  );

  print $foo->get_response();


=head1 DESCRIPTION

Net::DNS::Reputation::TeamCymru - Perl module for using TeamCymru services.
This is NOT AN OFFICIAL code from @TeamCymru.
Use it at your own risk.

=head2 EXPORT

None by default.

=head1 SEE ALSO


=head1 AUTHOR

Kaio Rafael, @kaiux

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Kaio Rafael

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>.

=cut
