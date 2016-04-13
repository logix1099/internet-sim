package Handler::ARPD;
#================================================================--
# File Name    : Handler/ARPD.pm
#
# Purpose      : handles the ARPD service
#
# Author       : kevin skinner, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use lib '../';
use Packet::Arp;
use Packet::Ethernet;
use Packet::Generic;
use Table::QUEUE;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;
   
	
   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In ARPD\n");
   }
   
   my $generic_packet = Packet::Generic->new();
	my $arp_packet = Packet::Arp->new();
	my $ethernet_packet = Packet::Ethernet->new();
	
   if (Table::QUEUE->get_siz('arpd')) {
      my $raw = Table::QUEUE->dequeue('arpd');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("ARPD");

      if ($ph eq "ETHERNET") {
      	#Table::ARP->set_mac($arp_packet->get_src_ip(),$arp_packet->get_src_mac());
      	$ethernet_packet->decode($generic_packet->get_msg());
      	$arp_packet->decode($ethernet_packet->get_msg());
      	$arp_packet->set_dest_mac($arp_packet->get_src_mac());
      	$arp_packet->set_src_mac(Table::NIC->get_mac($generic_packet->get_interface()));
         $arp_packet->set_dest_ip($arp_packet->get_src_ip());
         $arp_packet->set_src_ip(Table::NIC->get_ip($generic_packet->get_interface()));
			$arp_packet->set_opcode("REPLY");
			
         my $i;
         my $g;
         ($i, $g) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         if ($i eq 'lo'){
            $generic_packet->set_src_ip($generic_packet->get_dest_ip());
         } else {
            $generic_packet->set_src_ip(Table::NIC->get_ip($i));
         }
         $ethernet_packet->set_msg($arp_packet->encode());
         $generic_packet->set_msg($ethernet_packet->encode());
         Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
      } else {
         # should never get a non ethernet packet
      }

   if  ($trace) {
      print ("Out ARPD\n");
   }
   return;
}
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
