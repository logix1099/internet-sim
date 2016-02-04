package Event::STDIN;
#================================================================--
# File Name    : Event/STDIN.pm
#
# Purpose      : stdin event
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use lib '../../';
use AnyEvent;
use Packet::Generic;
use Table::QUEUE;
use Handler::STDIN;
use Exc::TryCatch;

sub start {
   my $self = shift @_;
   my $event_ptr = shift @_;

   my $mycb = Exc::TryCatch->new(
      fn => sub {
         my $line = <>;
         my $generic_packet = Packet::Generic->new();
         $generic_packet->set_msg("$line");
         Table::QUEUE->enqueue('stdin', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDIN->get_process_ref());
      }
   );


   $$event_ptr = AnyEvent->io (
      fh => \*STDIN,
      poll => "r",
      cb => $mycb->get_wfn()
   );

}

1;
