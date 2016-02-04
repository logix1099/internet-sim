package Handler::IP;
#================================================================--
# File Name    : Handler/IP.pm
#
# Purpose      : implements ip packet handler
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
use Packet::Generic;
use Packet::Ip;
use Packet::Icmp;
use Table::QUEUE;
use Table::NIC;
use System::HOST;
use Handler::ICMP;
use Handler::ETHERNET;
use Handler::P2P;

my $process_ref = sub {
   my $pkg = shift @_;
   
   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In IP\n");
   }


   if (Table::QUEUE->get_siz('ip')) {

      my $generic_packet = Packet::Generic->new();
      my $raw = Table::QUEUE->dequeue('ip');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("IP");

      my $ip_packet = Packet::Ip->new();
      my $icmp_packet = Packet::Icmp->new();

      my $iface;
      my $gateway;

      if (($ph eq "ETHERNET") || ($ph eq "P2P")) {
         # I have an ip packet 

         $ip_packet->decode($generic_packet->get_msg());
         $generic_packet->set_src_ip($ip_packet->get_src_ip());         
         $generic_packet->set_dest_ip($ip_packet->get_dest_ip());         
         ($iface, $gateway) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         $generic_packet->set_interface($iface);
         $generic_packet->set_gateway($gateway);

         if (defined($iface) && ($iface ne 'lo')) {
            #to be routed (forwarding)

            $generic_packet->set_msg($ip_packet->encode());
            
            if (Table::NIC->get_type($iface) eq 'ethernet') {
               Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
            } else {
               # p2p
               Table::QUEUE->enqueue('point2point', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::P2P->get_process_ref());
           }   

         } elsif (defined($iface)) {
            # for local host
            if ($ip_packet->get_proto() eq 'ICMP') {
               $icmp_packet->decode($ip_packet->get_msg());
               $generic_packet->set_msg($icmp_packet->encode());
               Table::QUEUE->enqueue('icmp', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
            }
         }
      } elsif ($ph eq 'ICMP') {
         # I have an icmp packet   

         ($iface, $gateway) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         $generic_packet->set_interface($iface);
         $generic_packet->set_gateway($gateway);

         if (defined($iface) && ($iface ne 'lo')) {
            $ip_packet->set_msg($generic_packet->get_msg());
            $ip_packet->set_src_ip($generic_packet->get_src_ip());
            $ip_packet->set_dest_ip($generic_packet->get_dest_ip());
            $ip_packet->set_proto('ICMP');
            
            $generic_packet->set_msg($ip_packet->encode());

            if (Table::NIC->get_type($iface) eq 'ethernet') {
               Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
            } else {
               # p2p
               Table::QUEUE->enqueue('point2point', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::P2P->get_process_ref());
           }
         } elsif (defined($iface)) {
            # for localhost
            Table::QUEUE->enqueue('icmp', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
         }
      } 
   }

   if  ($trace) {
      print ("Out IP\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
