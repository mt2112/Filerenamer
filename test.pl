use Test::Simple tests => 6;
use Filerenamer;

init_params("input.txt");
($fn, $y, $m, $d) = parse_filename("ORIGINAL-FILENAME-2017-04-09-13-13-52.pdf");
ok ($fn eq "NEW-FILENAME-%VVVV%%KK%.pdf");
ok ($y eq "2017");
ok ($m eq "04");
ok ($d eq "09");
$nf = transform_filename($fn, $y, $m, $d);
ok ($nf eq "NEW-FILENAME-201704.pdf");
ok ("NEW-FILENAME-201704.pdf" eq generate_filename("ORIGINAL-FILENAME-2017-04-09-13-13-52.pdf"));
