package Collection::Line;
#================================================================--
# File Name    : Collection/Line.pm
#
# Purpose      : implements wired line framing and queueing 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use lib '../../';
use Exc::Exception;

my $PCHAR_ESC = '_G_';
my $PCHAR_END = '_H_';
# set as local variables because they will be used in regex
use constant SEPSIZE => 6; # |$PCHAR_ESC| + |$PCHAR_END|
use constant MAX => 1000;

my $inbuff='';
my $outbuff='';

sub  new {
   my $class = shift @_;
   my %params = @_;

   my $self = {maxbuff => 1000,
               inbuff => $inbuff,
               outbuff => $outbuff};

   if (defined($params{maxbuff})) {
      $self->{maxbuff} = $params{maxbuff};
   }
                
   bless ($self, $class);
   return $self;
}

sub dequeue_packet {
   my $self = shift @_;

   my $hold = undef;
   # regex is prototype code... needs to be optimized
   if ($self->{inbuff} =~ m/$PCHAR_ESC.*?$PCHAR_END/) {
      $self->{inbuff} =~ s/$PCHAR_ESC.*?$PCHAR_END//;
      $self->{inbuff} = $'; # remove any garbage before the pkt
      $hold=$&;
      $hold =~ s/$PCHAR_END//g;
      $hold =~ s/$PCHAR_ESC//g;
      if ($hold eq "heartbeat") {
         $hold = undef;
      }  
   }

   return $hold;
}

sub enqueue_packet {
   my $self = shift @_;
   my $msg = shift @_;

   if ((length($self->{outbuff}) + length($msg) + SEPSIZE) > ($self->{maxbuff})) {
      die(Exc::Exception->new(name => "fullbuff"));
   }

   $self->{outbuff} = $self->{outbuff} . $PCHAR_ESC . $msg . $PCHAR_END;
   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $chunk = shift @_;

   if ((length($self->{inbuff}) + length($chunk)) > ($self->{maxbuff})) {
      die(Exc::Exception->new(name => "fullbuff"));
   }
   $self->{inbuff} = $self->{inbuff} . $chunk;
   return;
}

sub dequeue_packet_fragment {
   my $self = shift @_;
   my $siz = shift @_;

   if (!defined($siz)) {
      $siz=10;
   }

   my $len = length($self->{outbuff});
   if ($len == 0) {
      return undef;
   } else {
      if ($len < $siz) {
         $siz = $len;
      }
      $self->{outbuff} =~ s/.{$siz,$siz}//;

      return $&;
   }
}

sub get_outbuff_size {
   my $self = shift @_;

   return length($self->{outbuff});
}

sub dump {
   my $self = shift @_;

   print "INBUFF->$self->{inbuff}<-\n";
   print "OUTBUFF->$self->{outbuff}<-\n";

   return;
}

1;
