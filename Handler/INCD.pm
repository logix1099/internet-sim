package Handler::INCD;
#================================================================--
# File Name    : Handler/PINGD.pm
#
# Purpose      : handles the PINGD service
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
use Packet::Udp;
use Packet::Generic;
use Table::QUEUE;
use Handler::UDP;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In INCD\n");
   }
   
   my $generic_packet = Packet::Generic->new();
	my $udp_packet = Packet::Udp->new();
	
   if (Table::QUEUE->get_siz('incd')) {
      my $raw = Table::QUEUE->dequeue('incd');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("INCD");

      if ($ph eq "UDP") {
      	$udp_packet->decode($generic_packet->get_msg());
         (my $inc_num) = $udp_packet->get_msg();
         $inc_num = $inc_num + 1;
         $udp_packet->set_msg($inc_num);
         $generic_packet->set_dest_ip($generic_packet->get_src_ip());
         my $i;
         my $g;
         ($i, $g) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         if ($i eq 'lo') {
            $generic_packet->set_src_ip($generic_packet->get_dest_ip());
         } else {
            $generic_packet->set_src_ip(Table::NIC->get_ip($i));
         }
         $generic_packet->set_msg($udp_packet->encode());
         Table::QUEUE->enqueue('udp', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::UDP->get_process_ref());
      } else {
         # should never get a non UDP packet
      }
   }

   if  ($trace) {
      print ("Out INCD\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
