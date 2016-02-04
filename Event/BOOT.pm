package Event::BOOT;
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
use Table::NIC;
use Exc::TryCatch;

sub start {
   my $self = shift @_;
   my $sig_ptr = shift @_;
   my $event_ptr = shift @_;

   my $mycb = Exc::TryCatch->new(
   fn => sub {
      my @key = Table::NIC->get_keys();
      my $soc_open = 1;
      foreach my $k (@key) {
         my $fh = Table::NIC->get_fh($k);
         if (!($fh =~ m/^GL*/)) {
            $soc_open = 0;
         }
      }
      if ($soc_open) {
         $$sig_ptr->send;
      }
   }
);


   $$event_ptr = AnyEvent->timer(
      after => 1,
      interval => 3,
      cb => $mycb->get_wfn() 
   );

}

1;
