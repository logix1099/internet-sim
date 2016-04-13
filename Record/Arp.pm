package Record::Arp;
#================================================================--
# File Name    : Record/Arp.pm
#
# Purpose      : implements Route record
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
use Exc::Exception;

my $mac = ' ';
my $time =' '; 
sub  new {
   my $class = shift @_;

   my $self = {mac => $mac,time=>$time
   };
                
   bless ($self, $class);
   return $self;
}

sub get_mac {
   my $self = shift @_;
   
   return $self->{mac};
}

sub set_mac {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{mac} = $m;
   return;
}
sub get_time {
   my $self = shift @_;
   
   return $self->{time};
}

sub set_time {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{time} = $m;
   return;
}

sub decrease {
   my $self = shift @_;

   $self->{time}--;
   return $self->{time};
}

sub dump {
   my $self = shift @_;

   print ("Mac: $self->{mac} \n");
   return;
}

1;
