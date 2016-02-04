package Handler::P2P;
#================================================================--
# File Name    : Handler/P2P.pm
#
# Purpose      : implements p2p handler
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

use Packet::Generic;
use Packet::Ip;
use Table::QUEUE;
use Table::NIC;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In P2P\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $ip_packet = Packet::Ip->new();

   if (Table::QUEUE->get_siz('point2point')) {
      my $raw = Table::QUEUE->dequeue('point2point');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("P2P");

      if ($ph eq "IP") {
         #  send to appropriate NIC interface

        
         Table::NIC->enqueue_packet($generic_packet->get_interface(), $generic_packet->get_msg());
         # note, enqueue an ip packet NOT a generic packet
         # and no need to schedule task as nic event covers that

      } else {
         # packet coming in from NIC of type point2point
         # process packet

         Table::QUEUE->enqueue('ip', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
      }

   }

   if  ($trace) {
      print ("Out P2P\n");
   }
   return;   
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
