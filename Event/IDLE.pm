package Event::IDLE;
#================================================================--
# File Name    : Event/IDLE.pm
#
# Purpose      : idle event (execute tasks)
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
use Table::QUEUE;
use Exc::TryCatch;

sub start {
   my $self = shift @_;
   my $event_ptr = shift @_;

   my $mycb = Exc::TryCatch->new(
      fn => sub {
         if (Table::QUEUE->get_siz('task')) {
            my $nexttask = Table::QUEUE->dequeue('task');
            $nexttask->();
         }
      }
   );

   $$event_ptr = AnyEvent->idle(
      cb => $mycb->get_wfn()
   );

}

1;
