package Handler::ARP;
#================================================================--
# File Name    : Handler/ARP.pm
#
# Purpose      : implements ARP packet handler
#
# Author       : kevin skinner, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use lib '../';

use Packet::Generic;
use Packet::Ethernet;
use Packet::Arp;
use Packet::Ip;
use Table::QUEUE;
use Table::NIC;
use Table::UNKNOWNMAC;
use System::HOST;

my $process_ref = sub 
{
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In ARP\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $ethernet_packet = Packet::Ethernet->new();
   my $ip_packet = Packet::Ip->new();
   my $arp_packet = Packet::Arp->new();

   if (Table::QUEUE->get_siz('arp')) 
   {
      my $raw = Table::QUEUE->dequeue('arp');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("ARP");

      if ($ph eq "ETHERNET") 
      {
      	$ethernet_packet->decode($generic_packet->get_msg());
      	if ($ethernet_packet->get_proto eq "IP")
      	{
         	my $i;
            my $g;
            ($i, $g) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
            if ($g ne '0.0.0.0') {
               $generic_packet->set_dest_ip($g);
            }
         	Table::UNKNOWNMAC->enqueue($generic_packet->get_dest_ip(), $generic_packet->encode());

         	$arp_packet->set_src_ip(Table::NIC->get_ip($generic_packet->get_interface()));
            $arp_packet->set_dest_ip($generic_packet->get_dest_ip());
            $arp_packet->set_src_mac($ethernet_packet->get_src_mac());
            $arp_packet->set_dest_mac("0");
         	$arp_packet->set_opcode("REQUEST");
				$ethernet_packet->set_dest_mac($arp_packet->get_dest_mac());
				$ethernet_packet->set_src_mac($arp_packet->get_src_mac());
				$ethernet_packet->set_proto("ARP");
         	$ethernet_packet->set_msg($arp_packet->encode());
         	$generic_packet->set_msg($ethernet_packet->encode());
         	#$arp_packet->dump();
         	Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
         	Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
        }elsif ($ethernet_packet->get_proto eq "ARP")
         {
         	$arp_packet->decode($ethernet_packet->get_msg());

         	Table::ARP->set_mac($arp_packet->get_src_ip(),$arp_packet->get_src_mac());
         	
         	$generic_packet->decode(Table::UNKNOWNMAC->dequeue($arp_packet->get_src_ip()));
         	
         	$ethernet_packet->decode($generic_packet->get_msg());
         	$ethernet_packet->set_dest_mac($arp_packet->get_src_mac());
         	$ethernet_packet->set_proto("IP");
         	$generic_packet->set_msg($ethernet_packet->encode());
         	$generic_packet->dump();
         	Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
	         Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
	   	}
      }
   }

   if($trace) {
      print ("Out ARP\n");
   }
   return;   
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
