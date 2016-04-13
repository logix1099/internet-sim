package Handler::UDP;
#================================================================--
# File Name    : Handler/ICMP.pm
#
# Purpose      : handler for icmp packet
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
use Packet::Udp;
use Table::QUEUE;
use Handler::INCD;
use Handler::IP;
use System::HOST;
my $process_ref = sub {
   my $pkg = shift @_;
   
   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In UDP\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $udp_packet = Packet::Udp->new();
   if (Table::QUEUE->get_siz('udp')) {
      my $raw = Table::QUEUE->dequeue('udp');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("UDP");

      if ($ph eq "INC") {
      	(my $inc_num) = split(':', $generic_packet->get_msg());

      	$udp_packet->set_src_port(1);
         $udp_packet->set_dest_port(40);
         $udp_packet->set_msg($inc_num);
        $generic_packet->set_msg($udp_packet->encode());
         	Table::QUEUE->enqueue('ip', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());

         
      }elsif ($ph eq "INCD"){
      	$udp_packet->decode($generic_packet->get_msg());
         (my $inc_num) = $udp_packet->get_msg();
         
         $udp_packet->set_dest_port($udp_packet->get_src_port());
         $udp_packet->set_src_port(40);
         $udp_packet->set_msg($inc_num);
			$generic_packet->set_msg($udp_packet->encode());  
        Table::QUEUE->enqueue('ip', $generic_packet->encode());
        Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
         

      } else {
#          assume  $ph eq "IP"
			$udp_packet->decode($generic_packet->get_msg());
			if ($udp_packet->get_dest_port() eq 40)
			{
				Table::QUEUE->enqueue('incd', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::INCD->get_process_ref());
			}
			elsif ($udp_packet->get_dest_port() eq 1)
			{
				Table::QUEUE->enqueue('inc', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::INC->get_process_ref());
			}
     }
   }

   if  ($trace) {
      print ("Out UDP\n");
   }
   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
