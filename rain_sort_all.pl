#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

my $sum ={};
my $stride = 1;

=comment
for(0..250){
    next if $_ % $stride !=0;
    $sum->{$_}=0;
}
=cut

my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);

for (@total){
    rian_data("$_.txt",$sum);
}

my $sumRain = &makeSum($sum);

&makePers($sum,$sumRain);

open(OUT,"> sortRain.txt");

for my $key (sort {$b <=> $a} keys %$sum){
    printf (OUT "%s %s\n",$key,$sum->{$key});
}

close(OUT);

sub rian_data{
    my($txtname,$result) = @_;

    $txtname = "RainData/$txtname";

    return if(! -e $txtname);

    open(IN,$txtname);

    my $count = 0;


    while(<IN>){
        chomp;
        my $default =int($_/$stride);
        $default *= $stride;

        $result->{$default}++;

        $count++;
    }

    close(IN);

    $result->{0}+=(24 - $count) if $count == 24;

}

sub makeSum {
    my ($result) = @_;
    
    my $before =0;

    for my $key(sort {$b <=> $a} keys %$result){
       if($before ==0){
          $before= $result->{$key};
          next;
       }
        $result->{$key}+=$before;
        $before =$result->{$key};
    }

    return $before;
}

sub makePers {

    my($result,$sum) =@_;

    for my $key(sort {$b <=> $a} keys %$result){
        $result->{$key}=sprintf("%.5f",$result->{$key}/=$sum)
    }
}
