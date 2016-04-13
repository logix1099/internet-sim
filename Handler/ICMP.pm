package Handler::ICMP;
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
use Packet::Icmp;
use Packet::Ip;
use Table::QUEUE;
use Handler::PINGD;
use Handler::IP;
use System::HOST;
my $process_ref = sub {
   my $pkg = shift @_;
   
   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In ICMP\n");
   }

   my $generic_packet = Packet::Generic->new();
 	my $ip_packet = Packet::Ip->new();

   if (Table::QUEUE->get_siz('icmp')) {
      my $raw = Table::QUEUE->dequeue('icmp');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("ICMP");

      my $icmp_packet = Packet::Icmp->new();

      if (($ph eq "PING") || ($ph eq "PINGD")) {
      	#$generic_packet->dump();
         (my $ty, my $ts, my $ttl) = split(':', $generic_packet->get_msg());
         $icmp_packet->set_type($ty);
         $icmp_packet->set_msg(join(':',$ts, $ttl));
         #$icmp_packet->dump();
         $generic_packet->set_msg($icmp_packet->encode());
         Table::QUEUE->enqueue('ip', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());

      } else {
         # assume  $ph eq "IP"
         $icmp_packet->decode($generic_packet->get_msg());
         #$icmp_packet->dump();
         $generic_packet->set_msg(join(':', @{[$icmp_packet->get_type(), $icmp_packet->get_msg()]}));
         if ($icmp_packet->get_type() eq "ECHO") {
            Table::QUEUE->enqueue('pingd', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::PINGD->get_process_ref());
         } elsif ($icmp_packet->get_type() eq "ECHO_REPLY") {
            Table::QUEUE->enqueue('ping', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::PING->get_process_ref());
         }elsif ($icmp_packet->get_type() eq "INFO_REPLY"){
         	$icmp_packet->set_type("TIME_EXCEEDED");
         	$generic_packet->set_msg($icmp_packet->encode());
         	Table::QUEUE->enqueue('ip', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
         }
         elsif($icmp_packet->get_type() eq "TIME_EXCEEDED" || $icmp_packet->get_type() eq "HOST_UNREACHABLE")
         {
         	#$generic_packet->dump();
          	Table::QUEUE->enqueue('ping', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::PING->get_process_ref());
         }
      }
   }

   if  ($trace) {
      print ("Out ICMP\n");
   }
   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
