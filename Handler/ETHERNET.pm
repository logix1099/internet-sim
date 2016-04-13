package Handler::ETHERNET;
#================================================================--
# File Name    : Handler/ETHERNET.pm
#
# Purpose      : implements ethernet packet handler
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use lib '../';
use Handler::ARPD;
use Packet::Generic;
use Packet::Ethernet;
use Packet::Ip;
use Packet::Arp;
use Table::QUEUE;
use Table::NIC;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) 
   {
      print ("In ETHERNET\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $ethernet_packet = Packet::Ethernet->new();
   my $ip_packet = Packet::Ip->new();
   my $arp_packet = Packet::Arp->new();

   if (Table::QUEUE->get_siz('ethernet')) 
   {
      my $raw = Table::QUEUE->dequeue('ethernet');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("ETHERNET");
		if ($ph eq "ARP"|| $ph eq "ARPD")
		{
			 $ethernet_packet->decode($generic_packet->get_msg());
			 $arp_packet->decode($ethernet_packet->get_msg);
			 if ($ethernet_packet->get_proto eq 'ARP')
			 {
			 	if ($arp_packet->get_opcode() eq "REQUEST")
			 	{
					Table::NIC->enqueue_packet($generic_packet->get_interface(), $ethernet_packet->encode());
			 	}
			 	elsif($arp_packet->get_opcode() eq "REPLY")
			 	{
			 			Table::NIC->enqueue_packet($generic_packet->get_interface(), $ethernet_packet->encode());
			 	}
			 }
			 elsif($ethernet_packet->get_proto eq 'IP')
			 {	
         		Table::NIC->enqueue_packet($generic_packet->get_interface(), $ethernet_packet->encode());
			 }
			 
		}	 
      elsif ($ph eq "IP") 
      {
          # add MAC addresses and send ethernet packet
          # to appropriate NIC interface
          
         my $dest_mac;
         my $src_mac = Table::NIC->get_mac($generic_packet->get_interface());
         if ($generic_packet->get_gateway() eq '0.0.0.0') {
            $dest_mac = Table::ARP->get_mac($generic_packet->get_dest_ip());
         }
         else
         {
            $dest_mac = Table::ARP->get_mac($generic_packet->get_gateway());
         }
            $ethernet_packet->set_src_mac($src_mac);
         	$ethernet_packet->set_proto('IP');
         	$ethernet_packet->set_msg($generic_packet->get_msg());
			if (defined($dest_mac))
			{
				$ethernet_packet->set_dest_mac($dest_mac);
         	Table::NIC->enqueue_packet($generic_packet->get_interface(), $ethernet_packet->encode());
         }
         else
         {
         	$generic_packet->set_msg($ethernet_packet->encode());
         	Table::QUEUE->enqueue('arp', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::ARP->get_process_ref());
         }
         
          #note, enqueue an ethernet packet NOT a generic packet
        #  and no need to schedule task as nic event covers that

      } 
      else 
      {
         # packet coming in from NIC of type ethernet
         # if packet for us then process
			
         $ethernet_packet->decode($generic_packet->get_msg());
         if ($ethernet_packet->get_proto() eq 'IP') 
         {
       	  my $my_mac = Table::NIC->get_mac($generic_packet->get_interface());
       	  my $in_mac = $ethernet_packet->get_dest_mac();
       	  if ($in_mac eq $my_mac) 
       	  {
               $ip_packet->decode($ethernet_packet->get_msg());
               $generic_packet->set_msg($ip_packet->encode());
               Table::QUEUE->enqueue('ip', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
            } # else { print("In packet type broken \n");}
         }else
         {#proto = arp
         	#$generic_packet->dump();
         	$arp_packet->decode($ethernet_packet->get_msg());
         	my $my_ip = Table::NIC->get_ip($generic_packet->get_interface());
       	  my $in_ip = $arp_packet->get_dest_ip();
       	  if ($in_ip eq $my_ip) 
       	  {
       	  	if ($arp_packet->get_opcode() eq "REQUEST")
			   {
               $ethernet_packet->set_msg($arp_packet->encode());
               $generic_packet->set_msg($ethernet_packet->encode());
               Table::QUEUE->enqueue('arpd', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ARPD->get_process_ref());
            }
            elsif($arp_packet->get_opcode() eq "REPLY")
			 	{
			 	 	Table::QUEUE->enqueue('arp', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ARP->get_process_ref());
			 	}
            } # else { print("In packet type broken \n");}
         } 
      }

   }

   if  ($trace) 
   {
      print ("Out ETHERNET\n");
   }
   return;   
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
