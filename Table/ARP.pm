package Table::ARP;
#================================================================--
# File Name    : Table/ARP.pm
#
# Purpose      : table of  Arp records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use lib '../';
use Record::Arp;
use Exc::Exception;

my %table;
my $rtable = "";
sub set_mac {
   my $pkg = shift @_;
   my $ip = shift @_;
   my $mac = shift @_;
   my $time = "60";

   if (!defined($ip) || (!defined($mac))) {
      die(Exc::Exception->new(name => "Table::ARP->set_mac"));
   }

   if (!exists($table{$ip})) {
      $table{$ip} = Record::Arp->new();
   } 

   $table{$ip}->set_mac($mac);
   $table{$ip}->set_time($time);
}

sub get_mac {
   my $pkg = shift @_;
   my $ip = shift @_;

   if (!defined($ip)) {
      die(Exc::Exception->new(name => "Table::ARP->get_mac"));
   }

   if (exists($table{$ip})) {
      return $table{$ip}->get_mac();
   } else {
      return undef;
   } 
}
sub get_Table{
	my $self = shift @_;
	$rtable = "";
   my $key;
   foreach $key (keys(%table)) {
   	$rtable = $rtable ."Name: $key MAC" . $table{$key}->get_mac(). "\n";
   }
   return $rtable;
}

sub decrease {
   my $pkg = shift @_;
   my $key;
   foreach $key (keys(%table)) {
      if($table{$key}->decrease() < 0) { delete($table{$key}); }      
   }
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
