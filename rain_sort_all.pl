#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

my $sum ={};

for(0..250){
    next if $_ %3 !=0;
    $sum->{$_}=0;
}

my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);

for (@total){
    rian_data("$_.txt",$sum);
}

print Dumper $sum;

sub rian_data{
    my($txtname,$result) = @_;

    $txtname = "RainData/$txtname";

    if(! -e $txtname){
        return;
    }

    open(IN,$txtname);

    my $count = 0;


    while(<IN>){
        chomp;
        my $default =int($_/3);
        $default *= 3;

        $result->{$default}++;

        $count++;
    }

    close(IN);

    $result->{0}+=(24 - $count) if $count == 24;

}
