#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Collection/Verification/Line/line_tst.pl
# Module test driver
# Marius' test case
######################################################

use lib '../../../';
use Collection::Line;

use constant PCHAR_ESC => '_G_';
use constant PCHAR_END => '_H_';

$x = Collection::Line->new((maxbuff => 1000));

$x->enqueue_packet_fragment('_garbage_');
$x->enqueue_packet_fragment(PCHAR_ESC . 'peter' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'yy' ); # missing PCHAR_END
$x->enqueue_packet_fragment(PCHAR_ESC . 'zz' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'ww' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'Ping' . PCHAR_END);

# Expected output
# Packet 1 Peter
# Packet 2 yyzz
# Packet 3 ww
# No Packet returned


$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
if (defined($pk)) {
   print ("PACKET ", $pk , "\n");
} else {
   print ("No packet returned\n");

}

$x->dump();



