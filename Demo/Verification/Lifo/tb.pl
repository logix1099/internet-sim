#================================================================--
# File Name    : Demo/Verification/LIFO/tb.cew
#
# Purpose      : unit testing
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#================================================================--

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Demo::Lifo;
use Exc::Exception;
use Try::Tiny;

my $cew_Test_Count  = 0;
my $cew_Error_Count = 0;
no warnings "experimental::smartmatch";

# Local Function Load (s, n);
# pushes n values on the stack from
# the sequence 10, 20, 30  ...
# note: no exception checking

sub load {
   my $s = shift @_;
   my $n = shift @_;

   for ( my $i = 0 ; $i < $n ; $i++ ) {
      $s->push( ( $i + 1 ) * 10 );
   }
}

#############
# empty stack
#############

my $stack0 = Demo::Lifo->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack0->top();
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 48, "\n" );
      print( "Expected exception ", "empty", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "empty" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               48, "\n" );
            print( "Unexpected exception ", $cew_exc_name, " thrown \n" );
         }
      }
      else {
         die("ref($cew_e)");
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack0->pop();
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 49, "\n" );
      print( "Expected exception ", "empty", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "empty" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               49, "\n" );
            print( "Unexpected exception ", $cew_exc_name, " thrown \n" );
         }
      }
      else {
         die("ref($cew_e)");
      }
   }
};

#################
# half full stack
#################

my $stack1 = Demo::Lifo->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      load( $stack1, 5 );
      my $xact = $stack1->top();
      my $xexp = 50;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 56, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 56, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack1->pop();
      my $xact = $stack1->top();
      my $xexp = 40;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 57, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 57, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack1->pop();
      my $xact = $stack1->top();
      my $xexp = 30;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 58, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 58, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

#################
# full stack
#################

my $stack2 = Demo::Lifo->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      load( $stack2, 10 );
      my $xact = $stack2->top();
      my $xexp = 100;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 65, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 65, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack2->push(110);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 66, "\n" );
      print( "Expected exception ", "full", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "full" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               66, "\n" );
            print( "Unexpected exception ", $cew_exc_name, " thrown \n" );
         }
      }
      else {
         die("ref($cew_e)");
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      ;
      my $xact = $stack2->top();
      my $xexp = 100;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 67, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 67, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $stack2->pop();
      my $xact = $stack2->top();
      my $xexp = 90;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 68, "\n" );

         if ( !defined($xact) ) {
            $xact = "undefined";
         }
         if ( !defined($xexp) ) {
            $xexp = "undefined";
         }

         print( "Actual Value is ",   $xact, " \n" );
         print( "Expected Value is ", $xexp, "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 68, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

################
# stress test
################

my $stack3 = Demo::Lifo->new( max => 100 );

for ( my $i = 0 ; $i < 100 ; $i++ ) {
   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         $stack3->push($i);
         my $xact = $stack3->top();
         my $xexp = $i;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               77, "\n" );

            if ( !defined($xact) ) {
               $xact = "undefined";
            }
            if ( !defined($xexp) ) {
               $xexp = "undefined";
            }

            print( "Actual Value is ",   $xact, " \n" );
            print( "Expected Value is ", $xexp, "\n" );
         }
      }
      catch {
         my $cew_e = $_;
         if ( ref($cew_e) ~~ "Exc::Exception" ) {
            my $cew_exc_name = $cew_e->get_name();
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               77, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

}

for ( my $i = 99 ; $i >= 0 ; $i-- ) {
   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         ;
         my $xact = $stack3->top();
         my $xexp = $i;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               81, "\n" );

            if ( !defined($xact) ) {
               $xact = "undefined";
            }
            if ( !defined($xexp) ) {
               $xexp = "undefined";
            }

            print( "Actual Value is ",   $xact, " \n" );
            print( "Expected Value is ", $xexp, "\n" );
         }
      }
      catch {
         my $cew_e = $_;
         if ( ref($cew_e) ~~ "Exc::Exception" ) {
            my $cew_exc_name = $cew_e->get_name();
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               81, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         $stack3->pop();
         my $xact = 0;
         my $xexp = 0;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               82, "\n" );

            if ( !defined($xact) ) {
               $xact = "undefined";
            }
            if ( !defined($xexp) ) {
               $xexp = "undefined";
            }

            print( "Actual Value is ",   $xact, " \n" );
            print( "Expected Value is ", $xexp, "\n" );
         }
      }
      catch {
         my $cew_e = $_;
         if ( ref($cew_e) ~~ "Exc::Exception" ) {
            my $cew_exc_name = $cew_e->get_name();
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               82, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

}

print("\n**********Summary**********\n");
print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

