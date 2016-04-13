package Table::UNKNOWNMAC;
#================================================================--
# File Name    : Handler/ETHERNET.pm
#
# Purpose      : implements ethernet packet handler
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
use Collection::UnknownMac;

my %table;

sub enqueue {
   my $pkg = shift @_;
   my $q = shift @_;
   my $l = shift @_;
   
   if (!defined($q) || (!defined($l))) {
      die(Exc::Exception->new(name => "Table::unknown_mac->enqueue"));
   }

   if (!exists($table{$q})) {
      $table{$q} = Collection::Queue->new();
   } 

   $table{$q}->enqueue($l);
}

sub dequeue {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Exc::Exception->new(name => "Table::unknown_mac->dequeue"));
   }

   if (exists($table{$q})) {
      return $table{$q}->dequeue();
   } else {
      return undef;
   }
}

sub get_siz {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Exc::Exception->new(name => "Table::unknown_mac->get_siz"));
   }

   if (exists($table{$q})) {
      return $table{$q}->get_siz();
   } else {
      return undef;
   }
}

1;
