#================================================================--
# File Name    : Demo/Verification/SSet/tb.cew
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
use Demo::SSet;
use Exc::Exception;
use Try::Tiny;
my $cew_Test_Count  = 0;
my $cew_Error_Count = 0;
no warnings "experimental::smartmatch";

# Local Function Load (s, n);
# adds n values on the list from
# the sequence 10, 20, 30  ...
# note: no exception checking

sub load {
   my $s = shift @_;
   my $n = shift @_;

   for ( my $i = 0 ; $i < $n ; $i++ ) {
      $s->add( ( $i + 1 ) * 10 );
   }
}
#############
# empty list
#############

my $list0 = Demo::SSet->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $list0->ismem(20);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 46, "\n" );
      print( "Expected exception ", "empty", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "empty" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               46, "\n" );
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
      $list0->delete(10);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 47, "\n" );
      print( "Expected exception ", "empty", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "empty" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               47, "\n" );
            print( "Unexpected exception ", $cew_exc_name, " thrown \n" );
         }
      }
      else {
         die("ref($cew_e)");
      }
   }
};

##################
## half full list
##################

my $list1 = Demo::SSet->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      load( $list1, 5 );
      my $xact = $list1->ismem(50);
      my $xexp = 1;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 54, "\n" );

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
         print( "Test Case ERROR (Ncase) in script at line number ", 54, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $list1->add(40);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 55, "\n" );
      print( "Expected exception ", "element", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "element" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               55, "\n" );
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
      $list1->delete(50);
      my $xact = $list1->ismem(50);
      my $xexp = 0;
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
      ;
      my $xact = $list1->ismem(10);
      my $xexp = 1;
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
      $list1->delete(10);
      my $xact = $list1->ismem(10);
      my $xexp = 0;
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

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      ;
      my $xact = $list1->ismem(30);
      my $xexp = 1;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 59, "\n" );

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
         print( "Test Case ERROR (Ncase) in script at line number ", 59, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $list1->delete(30);
      my $xact = $list1->ismem(30);
      my $xexp = 0;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 60, "\n" );

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
         print( "Test Case ERROR (Ncase) in script at line number ", 60, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $list1->delete(38);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 61, "\n" );
      print( "Expected exception ", "nonelement", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "nonelement" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               61, "\n" );
            print( "Unexpected exception ", $cew_exc_name, " thrown \n" );
         }
      }
      else {
         die("ref($cew_e)");
      }
   }
};

##################
## full list
##################

my $list2 = Demo::SSet->new( max => 10 );
$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      load( $list2, 10 );
      my $xact = $list2->ismem(100);
      my $xexp = 1;
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
      $list2->add(110);
      $cew_Error_Count = $cew_Error_Count + 1;
      print( "Test Case ERROR (Ecase) in script at line number ", 68, "\n" );
      print( "Expected exception ", "full", " not thrown \n" );
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         if ( $cew_exc_name ne "full" ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ecase) in script at line number ",
               68, "\n" );
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
      my $xact = $list2->ismem(110);
      my $xexp = 0;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 69, "\n" );

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
         print( "Test Case ERROR (Ncase) in script at line number ", 69, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      $list2->delete(40);
      my $xact = $list2->ismem(40);
      my $xexp = 0;
      if ( !( ($xact) ~~ ($xexp) ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 70, "\n" );

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
         print( "Test Case ERROR (Ncase) in script at line number ", 70, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

#################
## stress test
#################

my $list3 = Demo::SSet->new( max => 100 );

for ( my $i = 0 ; $i < 100 ; $i++ ) {
   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         $list3->add($i);
         my $xact = $list3->ismem($i);
         my $xexp = 1;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               79, "\n" );

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
               79, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

}

for ( my $i = 99 ; $i > 0 ; $i-- ) {
   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         ;
         my $xact = $list3->ismem($i);
         my $xexp = 1;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               83, "\n" );

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
               83, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

   $cew_Test_Count = $cew_Test_Count + 1;
   do {
      try {
         $list3->delete($i);
         my $xact = $list3->ismem($i);
         my $xexp = 0;
         if ( !( ($xact) ~~ ($xexp) ) ) {
            $cew_Error_Count = $cew_Error_Count + 1;
            print( "Test Case ERROR (Ncase) in script at line number ",
               84, "\n" );

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
               84, "\n" );
            print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
         }
      }
   };

}

print("\n**********Summary**********\n");
print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

