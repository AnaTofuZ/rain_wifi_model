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

    if(! -e $txtname){
        return;
    }

    open(IN,$txtname);

    my $count = 1;
    my $result ={};
    my $rain_sum = 0;
    my $time_b;
     
    while(<IN>){
        chomp;

        my($day,$time_r) = split / /,$_;
        my($time,$rain) = split /,/,$time_r;

        if($count == 1){
            $time_b = $time;}

        $rain_sum += $rain;

        if($count == 60){
            $rain_sum*=0.0083333;
            $rain_sum*=60;
            $result->{"$time_b"}=sprintf('%.2f',$rain_sum);
            $count =0;
            $rain_sum =0;
        }

        $count++;
        
    }

    close(IN);

    my $textfile = "$num.txt";
    open(OUT,"> $textfile");

        for my $key(sort keys %$result){
            printf(OUT "%s\n",$result->{$key});
        }
#print OUT Dumper($result);
    close(OUT);
}
