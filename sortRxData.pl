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

my $stride = 1;

for  (-100..0){
    next if $_ % $stride!= 0;
    $sumGhz18->{$_}=0;
    $sumGhz26->{$_}=0;
}

for my $roop (directory){
    for  (01..31){
        $_ = sprintf("%02d",$_);
        my $name = "$roop/$roop$_";
        &sumGhz18($name,$sumGhz18);  
        &sumGhz26($name,$sumGhz26);  
    }
}

print Dumper $sumGhz18;
print Dumper $sumGhz26;

sub sumGhz18 {

    my($path,$result) = @_;

    return if(! -e "RxData/$path/".Ghz18."_csv_sort.log");

    open(IN,"RxData/$path/".Ghz18."_csv_sort.log");

   while (<IN>) {
       chomp;
       $_ =(split / /,$_)[1];  
       $_= $stride*int($_/$stride);
       $_ = 0 if($_ >0);
       $result->{$_}++;
   } 
   close IN;
}

sub sumGhz26 {
    my($path,$result) = @_;

    return if(! -e "RxData/$path/".Ghz26."_csv_sort.log");
    open(IN,"RxData/$path/".Ghz26."_csv_sort.log");

   while (<IN>) {
       chomp;
        $_ =(split / /,$_)[1];
        $_=$stride*int($_/$stride);
        $_ = 0 if($_ >0);
        $result->{$_}++;
    }
    close IN;

}
