#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;


my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);


for (@total){

    my $txt ="RainData/"."$_"."/"."$_"."_rain.csv";
    rian_data($txt,$_);

}


sub rian_data{
    my($txtname,$num) = @_;

    if(! -e $txtname){
       &notFilesystem($num);
       return;
    }

    open(IN,$txtname);

    my $count = 1;
    my $result ={};
    my $rain_sum = 0;
     
    while(<IN>){
        chomp;
        next if $_ eq "";
        next if $_ eq "Recording started.";

        my($time,$rain) = split /,/,(split / /,$_)[1];

        $rain*=60;
        $rain*=0.0083333;

        $result->{"$time"}=sprintf('%.2f',$rain);
        
    }

    close(IN);

    my $textfile = "RainData/$num.txt";
    open(OUT,"> $textfile");

        for my $key(sort keys %$result){
            printf(OUT "%s\n",$result->{$key});
        }
    close(OUT);
}


sub notFilesystem {
    my ($textname) = @_;

    $textname .= ".txt";

    open(OUT,"> $textname");

    for (0..23){
        printf(OUT "%s\n",0);
    }

    close(OUT);
}
