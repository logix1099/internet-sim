package System::GRUB;
#================================================================--
# File Name    : System/GRUB.pm
#
# Purpose      : manages boot-loader information
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
use AnyEvent::Socket;
use System::HOST;
use Table::NIC;
use Table::QUEUE;
use Table::ARP;
use Table::ROUTE;
use Handler::STDOUT;
use Packet::Generic;
use Device::SerialPort;
use Exc::Exception;
use Exc::TryCatch;

use constant HUB_HOST => 'localhost';
use constant P2P_HOST => 'localhost';

my $generic_packet = Packet::Generic->new();

sub serial_configure {
   my $nic = shift;

   my $sp;
   my $fh;
   my $config = '/tmp/pw_serial_config.txt';
   if (! -e $config) {
      $sp = Device::SerialPort->new("/dev/ttyUSB0", 1, '/tmp/pwlock')  || die "Panic Panic\nCant Open Seriel Port\nCRASH\n";
      #$sp->baudrate(9600);
      $sp->baudrate(115200);
      $sp->parity("none");
      $sp->handshake("none");
      $sp->databits(8);
      $sp->stopbits(1);
      $sp->read_char_time(0);
      $sp->read_const_time(1);
      $sp->save($config);
      $sp->close();
      undef $sp;
   }

   $sp = tie (*FH, 'Device::SerialPort', $config) || die "Panic Panic\nCan't Tie Serial Port File Handle\nCRASH\n";
   $fh = \*FH;

   Table::NIC->set_fh($nic, $fh);
   my $tab_fh = Table::NIC->get_fh($nic);
   print("$nic bound to FH: $tab_fh \n");
   #syswrite($fh, "hello device");
}

sub socket_configure {
   my $nic = shift;
   my $host = shift;
   my $port = shift;

   my $mycb = Exc::TryCatch->new(
      fn => sub {

         my $fh = shift;

         if (!defined $fh) {
            print ("Panic Panic \nCant Open Interface\nCRASH\n");
            die(Exc::Exception->new(name => "Grub->boot"));
         }

         Table::NIC->set_fh($nic, $fh);

         my $tab_fh = Table::NIC->get_fh($nic);
         print("$nic bound to FH: $tab_fh \n");
      }
   );


   tcp_connect $host, $port, $mycb->get_wfn();

}

sub boot {
   my $pkg = shift @_;

   open(VFH, "< ./Doc/Version") || die "Cant open Version File \n";
   System::HOST->set_version(<VFH>);
   print("\n", System::HOST->get_version(), "\n");
   


   my $sel = -1;
   while (!($sel =~ m/^[0-1]/) || (length($sel) != 1))  {

      print ("\n\tBoot Menu\n\n");
      print ("Boot kevin H 0\n");
      print ("Boot kevin R 1\n");

      print ("\nEnter Selection ");
      $sel = <>;
      chop($sel);
   }
   
   if ($sel == 0) {

      # little checking performed :(

      System::HOST->set_name("kevin H");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.2.1', '201');
      socket_configure('eth0', HUB_HOST, 6078);
     #Table::ARP->set_mac('192.168.2.2', '202');
      Table::ROUTE->set_route('192.168.2.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.2', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.2.2', 'eth0');
   }

   if ($sel == 1) {

      # little checking performed :(

      System::HOST->set_name("kevin R");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);

      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.2.2', '202');
      Table::NIC->set('p2p0', 'point2point', '10.0.2.100', '0');
      Table::NIC->set('p2p1', 'point2point', '10.0.1.200', '0');
      socket_configure('eth0', HUB_HOST, 6079);
      socket_configure('p2p0', P2P_HOST, 9004);
      socket_configure('p2p1', P2P_HOST, 9003);
     #Table::ARP->set_mac('192.168.2.1', '201');
      Table::ROUTE->set_route('192.168.2.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('10.0.2.100', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('10.0.1.200', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.2', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '10.0.2.200', 'p2p0');
   }

   $generic_packet->set_msg(System::HOST->get_name() . "> ");
   Table::QUEUE->enqueue('stdout', $generic_packet->encode());
   Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
   return;
}

1;
