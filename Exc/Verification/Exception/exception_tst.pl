#!/usr/bin/perl
######################################################
# Peter Walsh
# exception test driver 
######################################################

use lib '../../../';
use Exc::Exception;
use Try::Tiny;

$| = 1;

do {
   try { 
      print ("In the try block before throwing full\n");
      die (Exc::Exception->new(name => "full"));
      print ("In the try block after throwing full\n");
   }
   
   catch { 
      my $exc = $_;
      print ("EXCEPTION\n");
      my $exc_name = $exc->get_name();
      print ("Exception $exc_name cought \n");
   }

};

