#!/usr/bin/perl
#========================================================
# Project      : Virtual internet TCP/IP stack system
#
# File Name    : vnet.pl
#
# Purpose      : main routine of the base implementation
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#========================================================

$SIG{INT} = sub {leaveScript();};

$|=1;

use strict;
use warnings;
no warnings "experimental::smartmatch";

use lib './';
use AnyEvent;
use Table::QUEUE;
use Table::NIC;
use Table::ROUTE;
use System::GRUB;
use System::HOST;
use Event::STDIN;
use Event::NIC;
use Event::BOOT;
use Event::IDLE;
use Handler::STDOUT;
use Exc::Exception;
use Exc::TryCatch;
use Try::Tiny;

my $z_event;
my $y_event;
my $stdin_event;
my $boot_event;
my @nic_event;
my $idle_event;
my $generic_packet=Packet::Generic->new();
my $nexttask;

sub leaveScript {
   system("rm -f /tmp/pw*");
   print("Shutdown Now !!!!! \n");
   exit();
}
my $vnet = Exc::TryCatch->new(
   fn => sub {

      System::HOST->set_trace(1);

      System::GRUB->boot();

      #begin boot loop ++++++++

         $y_event = AnyEvent->condvar;

         Event::BOOT->start(\$y_event, \$boot_event);

         $y_event->recv;
         undef $boot_event; # kill the boot loop

      #end boot loop ++++++++

      Table::ROUTE->dump();

      #begin implicit while (1) event loop ++++++++

         $z_event = AnyEvent->condvar;

         Event::STDIN->start(\$stdin_event);

         my @key = Table::NIC->get_keys();
         foreach (my $i = 0; $i <= $#key; $i++) {
            Event::NIC->start(\$nic_event[$i],$key[$i]);
         }

         Event::IDLE->start(\$idle_event);

         $z_event->recv;

      #end implicit while (1) event loop ++++++++

   }
);

$vnet->run();

