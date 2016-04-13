package Handler::INC;
#================================================================--
# File Name    : Handler/PING.pm
#
# Purpose      : implements ping packet handler
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
use AnyEvent;
use Packet::Udp;
use Packet::Generic;
use Handler::UDP;
use Table::QUEUE;
use Handler::STDOUT;
use Handler::STDIN;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In INC\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $udp_packet = Packet::Udp->new();

   if (Table::QUEUE->get_siz('inc')) {
      my $raw = Table::QUEUE->dequeue('inc');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("INC");
      if ($ph eq "STDIN") {
      	my $inc_num = $generic_packet->get_msg();
            $generic_packet->set_msg($inc_num);
         my $i;
         my $g;
         ($i, $g) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         if ($i eq 'lo') {
            $generic_packet->set_src_ip($generic_packet->get_dest_ip());
         } else {
            $generic_packet->set_src_ip(Table::NIC->get_ip($i));
         }
         

         Table::QUEUE->enqueue('udp', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::UDP->get_process_ref());

      } else {
         # assume $ph eq "UDP" 
         $udp_packet->decode($generic_packet->get_msg());
         (my $inc_num) = $udp_packet->get_msg();         
         $generic_packet->set_msg($inc_num."\n");

         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
         $generic_packet->set_msg(' '); # tidy up shell prompt
         Table::QUEUE->enqueue('stdin', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDIN->get_process_ref());

      }
   }

   if  ($trace) {
      print ("Out INC\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
