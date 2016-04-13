#!/usr/bin/perl
######################################################
# kevin skinner
# SSet test driver
######################################################

use lib '../../../';
use Demo::SSet;

$l0 = Demo::SSet->new(max => 10);
print("Initial list size ", $l0->size(), "\n");
$l0->add(90);
$l0->add(2);
$l0->add(6);
$l0->add(9);
$l0->add(12);
print ("added 5 elements. list size now = ", $l0->size(), "\n");
print ("12 should be in the list = ", $l0->ismem(12), "\n");
$l0->delete(12);
print ("12 should not be in the list = ", $l0->ismem(12), "\n");
print ("6 should be in the list = ", $l0->ismem(6), "\n");
$l0->delete(6);
print ("6 should not be in the list = ", $l0->ismem(6), "\n");
print("list size should be 3 = ", $l0->size(), "\n");
#$l0->dump();
