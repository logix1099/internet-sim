package Demo::SSet;
#================================================================--
# File Name    : Demo/SSet.pm
#
# Purpose      : implements FIFO (list) adt
#
# Author       : kevin skinner, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------


$|=1;

use strict;
use warnings;

use lib '../../';
use Exc::Exception;

use constant false => 0;
use constant true  => 1;
sub new {

   my $class = shift @_;
   my %params = @_;

   my $self = {maxsiz => 5,
               list => []
              };

   if (defined($params{max})) {
      $self->{maxsiz} = $params{max};
   }

   bless ($self, $class);

   return $self;
}

sub size {
   my $self = shift @_;

   return scalar  @{$self->{list}};
}

sub add {
   my $self = shift @_;
   my $val = shift @_;
   my $test = $self->size();

   if ($self->size() == $self->{maxsiz}) {
      die(Exc::Exception->new(name => "full"));
   }
   for (my $i = 0; $i < $self->size(); $i++) {
      if(${$self->{list}}[$i] == $val)
      {
      	die(Exc::Exception->new(name => "element"));
      }
   }
	@{$self->{list}}[$self->size()] = $val;

#		print "$_ " for @{$self->{list}};
#		print ("\n");
}

sub delete {
   my $self = shift @_;
	my $val = shift @_;
	my $deleted = false;
   if ($self->size() == 0) {
      die(Exc::Exception->new(name => "empty"));
   }
	for (my $i = 0; $i<$self->size(); $i++)
	{
		if(${$self->{list}}[$i] == $val)
		{
			splice @{$self->{list}}, $i, 1;
			$deleted = true;
		}
		elsif ($i == $self->size()-1 && $deleted == false)
		{
			die(Exc::Exception->new(name => "nonelement"));
		}
	}

   return 0;
}

sub ismem {
   my $self = shift @_;
   my $val = shift @_;
   
   my $found = false;
   if ($self->size() == 0) {
      die(Exc::Exception->new(name => "empty"));
   }
	for (my $i = 0; $i < $self->size(); $i++)
	{
		if (${$self->{list}}[$i] == $val)
		{
			$found = true;
		}
	}
   return $found;
}

# for interactive testing only

sub dump {
   my $self = shift @_;
   
   print ("list Dump\n");
   for (my $i = 0; $i < $self->size(); $i++) {
      print (${$self->{list}}[$i], "\n");
   }

   return 0;
}
1;
