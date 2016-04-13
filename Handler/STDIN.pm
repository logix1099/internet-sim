package Handler::STDIN;
#================================================================--
# File Name    : Handler/STDIN.pm
#
# Purpose      : implements stdin handler
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
use Table::QUEUE;
use System::HOST;
use Handler::INC;
use Handler::STDOUT;
use Handler::PING;
use Table::NIC;
use Table::ARP;
use Table::ROUTE;
my $help_message = "COMMAND\t\t\tBEHAVIOUR\nhelp\t\t\tdisplay help message \nquit\t\t\tshutdown\nsystem\t\t\tdisplay system information\nping ip\t\t\tping\nguess ip:val\t\tplay the guess game\nincrement ip:val\trequest increment service\nwatchme ip:val\t\tregister/deregister with ssnmp\n";
my $process_ref = sub {
   my $pkg = shift @_;
   
   my $generic_packet = Packet::Generic->new();

   if (Table::QUEUE->get_siz('stdin')) {
      my $raw = Table::QUEUE->dequeue('stdin');
      $generic_packet->decode($raw);
      my @words = split(' ', $generic_packet->get_msg());
      my $command = shift(@words);
      if (!defined($command)) {
         $command = ' ';
      }

      # assume HOST is assigned a value
      if ($command eq "help") {
         $generic_packet->set_msg($help_message . System::HOST->get_name() . "> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      } elsif ($command eq "system") {
         $generic_packet->set_msg(System::HOST->get_version. Table::ROUTE->get_Table(). Table::ARP->get_Table().System::HOST->get_name()."> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      } elsif ($command eq "guess") {
         $generic_packet->set_msg("Coming Soon\n> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      } elsif ($command eq "increment") {
      	my $inc_msg = shift(@words);
         (my $inc_ip, my $inc_num) = split(':', $inc_msg);
         $generic_packet->set_previous_handler("STDIN");
         $generic_packet->set_dest_ip($inc_ip);
         $generic_packet->set_msg($inc_num);
         Table::QUEUE->enqueue('inc', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::INC->get_process_ref());
      } elsif ($command eq "watchme") {
         $generic_packet->set_msg("Coming Soon\n> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      } elsif ($command eq "ping") {
         my $ping_msg = shift(@words);
         (my $ping_ip, my $ttl) = split(':', $ping_msg);
         $generic_packet->set_previous_handler("STDIN");
         $generic_packet->set_dest_ip($ping_ip);
         if (!defined($ttl) || $ttl>64)
         {
         	$ttl = 32;
         }
         $generic_packet->set_msg($ttl);
         Table::QUEUE->enqueue('ping', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::PING->get_process_ref());
      } elsif ($command eq "quit") {
         main::leaveScript();
      } elsif ($command eq " ") {
         $generic_packet->set_msg(System::HOST->get_name() . "> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      } else {
         $generic_packet->set_msg("error: invalid command $command enter help to display help message\n" . System::HOST->get_name() . "> ");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
      }
   }
   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
