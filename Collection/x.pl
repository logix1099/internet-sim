$x="Tic   _H_ ggggggggg  _M_       Toc";
$x =~ s/_H_.*?_M_//;
print ($` , "\n");
print ($& , "\n");
print ($' , "\n");

$x=$';

print ("New message ", "Tic" . $x , "\n");
if ($x =~ m/_H_.*?_M_/) {
   $x =~ s/_H_.*?_M_//;
   print ($` , "\n");
   print ($& , "\n");
   print ($' , "\n");
}

