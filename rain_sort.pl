#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;


#my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);
my @total = (20090601);

for (@total){
    rian_data("$_.txt");
}


sub rian_data{
    my($txtname) = @_;

    $txtname = "RainData/$txtname";

    if(! -e $txtname){
        return;
    }

    open(IN,$txtname);

    my $count = 1;
    my $result ={};
    my $rain_sum = 0;
    my $time_b;
     
    
    for  (0..250){
        next if $_ %5 !=0;
        $result->{$_}=0;
    }


    while(<IN>){
        chomp;
        my $default =int($_/5);
        $default *= 5;

        $result->{$default}++;

    }

    print Dumper $result;

    close(IN);

}
