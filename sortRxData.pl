#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use constant;

use Data::Dumper;
use 5.23.9;

use constant Ghz18 => "192.168.100.9";
use constant Ghz26 => "192.168.100.11";

use constant directory =>(200906,200910,200911,200912);

my $sumGhz18 = {};
my $sumGhz26 = {};

for  (-100..0){
    next if $_ %5 != 0;
    $sumGhz18->{$_}=0;
    $sumGhz26->{$_}=0;
}

for my $roop (directory){
    for  (01..31){
        $_ = sprintf("%02d",$_);
        my $name = "$roop/$roop$_";
        &sumGhz18($name,$sumGhz18);    
    }
}

print Dumper $sumGhz18;

sub sumGhz18 {

    my($path,$result) = @_;

    open(IN,"RxData/$path/192.168.100.9_csv_sort.log");

   while (<IN>) {
       chomp;
       $_ =(split / /,$_)[1];  
       $_=5*int($_/5);
       $result->{$_}++;
   } 
   close IN;
}

sub sumGhz26 {
    
}
