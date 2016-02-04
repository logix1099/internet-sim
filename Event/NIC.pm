package Event::NIC;
#================================================================--
# File Name    : Event/NIC.pm
#
# Purpose      : nic event
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
no warnings "experimental::smartmatch";

use lib '../../';
use AnyEvent;
use Packet::Generic;
use Packet::Ip;
use Handler::ETHERNET;
use Table::NIC;
use Table::QUEUE;
use Exc::Exception;
use Exc::TryCatch;
use Table::QUEUE;
 
use constant MAXTIME => 5000;

sub start {
   my $self = shift @_;
   my $event_ptr = shift @_;
   my $iface = shift @_;
   my $timer = MAXTIME;
   my $line;
   my $num;

   if (!defined($iface)) {
      die(Exc::Exception->new(name => "Event::NIC->start"));
   }

   my $mycb = Exc::TryCatch->new(
      fn => sub {
         my $fh = Table::NIC->get_fh($iface);
         if (!defined($fh)) {
            return;
         }

         $num = sysread($fh, $line, 200);

         if (defined($num) && ($num != 0)) {
            #print("$iface Line seg in ->$line<-\n"); # for testing
            Table::NIC->enqueue_packet_fragment($iface, $line);
            $timer = MAXTIME;
         } else {
            if ($timer > 0) {
               $timer = $timer - 1;
            } elsif ($timer == 0) {
               #print ("Warning heartbeat lost on $iface \n");
               my $gen = Packet::Generic->new();
               $gen->set_msg("\n \n Warning, heartbeat lost on interface $iface \n \n");
               Table::QUEUE->enqueue('stdout', $gen->encode());
               Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
               $timer = -1; # warning issued once only 
            } 
         }

         my $pk = Table::NIC->dequeue_packet($iface);
         if (defined($pk)) {
            my $gen = Packet::Generic->new();
            $gen->set_interface($iface);
            $gen->set_msg($pk);
            if (Table::NIC->get_type($iface) eq 'ethernet') {
               Table::QUEUE->enqueue('ethernet', $gen->encode());
               Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
            }
            if (Table::NIC->get_type($iface) eq 'point2point') {
               Table::QUEUE->enqueue('point2point', $gen->encode());
               Table::QUEUE->enqueue('task', Handler::P2P->get_process_ref());
            }
         }

         my $seg = Table::NIC->dequeue_packet_fragment($iface);
         if (defined($seg)) {
            #print("$iface Line seg out ->$seg<-\n"); # for testing
            syswrite($fh, $seg);

         }
      }
   );

   $$event_ptr = AnyEvent->timer (
      after => 1,
      interval => 0.01,
      cb => $mycb->get_wfn()
   );

}

1;
