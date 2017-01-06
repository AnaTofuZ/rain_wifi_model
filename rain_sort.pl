#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;


my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);

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

    my $count = 0;
    my $result ={};
    
    for  (0..250){
        next if $_ %5 !=0;
        $result->{$_}=0;
    }



    while(<IN>){
        chomp;
        my $default =int($_/5);
        $default *= 5;

        $result->{$default}++;

        $count++;
    }

    close(IN);

    $result->{0}+=(24 - $count) if $count == 24;

    my($txtname2) = @_;
    $txtname2 = "RainData/RAIN/$txtname2";

    open(OUT,"> $txtname2");

    for my $key(sort keys %$result) {
       printf(OUT "%s\n",$result->{$key});
    }


    close(OUT);

}
