package Event::TIMER;
#================================================================--
# File Name    : Event/BOOT.pm
#
# Purpose      : boot event
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
use AnyEvent::Socket;
use Exc::TryCatch;
use Table::ARP;

sub start {
   my $self = shift @_;
	my $event_ptr = shift @_;
   my $mycb = Exc::TryCatch->new(
   fn => sub {
      Table::ARP->decrease();
   }
);


   $$event_ptr = AnyEvent->timer(
      after => 1,
      interval => 1,
      cb => $mycb->get_wfn() 
   );

}

1;
