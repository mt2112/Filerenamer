package Filerenamer;

use Time::Local;
use POSIX qw(strftime);
use File::Slurp;
use DateTime;
use strict;

require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION = 0.2;

@ISA = qw(Exporter);
@EXPORT = qw(&weekno &parse_filename &transform_filename &generate_filename &init_params);
%EXPORT_TAGS = ();
@EXPORT_OK = ();

my %nametable; # maps filename matching pattern to filename template

# return week number according to day, month and year
sub weekno {
  my ($day, $month, $year) = @_;
  my $dt = DateTime->new(year => $year, month => $month, day => $day);
  my $week = $dt->week();
}

# read pattern/template pairs to hash
sub init_params {
  my $file = shift;
  %nametable = map {chomp; split /=/;} read_file($file);
}

# parse and transform given filename 
sub generate_filename {
  my $filename = shift;
  my ($newfilename, $year, $month, $day) = parse_filename($filename);
  return transform_filename($newfilename, $year, $month, $day) if $newfilename;
}

# find filename template from %nametable
sub parse_filename {
  my $filename = shift;
  # search for file
  foreach my $file (keys %nametable) {
    # match pattern to filename
    my ($year, $month, $day) = ($filename =~ /$file/);
    my $newfilename = $nametable{$file} if defined($year);        # get filename template if matched
    return ($newfilename, $year, $month, $day) if defined($newfilename);          
  }
}

# transform filename to have previous month and possibly week number in its name
sub transform_filename {
  my ($nf, $yyyy, $mm, $dd) = @_;
  warn "invalid year argument: $nf >$yyyy<\n" if int($yyyy) == 0;
  warn "invalid month argument: $nf >$yyyy<\n" if int($mm) == 0 || int($mm) > 12;
  
  # week number
  my $vko = "VKO" . weekno($dd, $mm, $yyyy);
  
  # year and month (january is special case)
  if ($nf =~ /_KK_/) {
    if (int($mm) == 1) {
      $mm = "12";
      $yyyy--;
    } else {
      $mm--;
    }
  }
  $mm = sprintf("%02d", $mm);
  
  # fill template with real values 
  $nf =~ s/%VVVV%/$yyyy/;
  $nf =~ s/%KK%/$mm/;
  $nf =~ s/%VKO%/$vko/;
  return $nf;
}

END {}

1;