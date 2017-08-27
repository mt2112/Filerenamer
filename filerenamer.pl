use strict;
use Getopt::Long;
use Filerenamer;

init_params("input.txt");

foreach (map { glob } @ARGV) {  
  my $was = $_;
  my $new = generate_filename($_);  
  rename $was, $new if defined($new); 
  #print "$was renamed as $new\n";
}
