#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;
use 5.23.9;

my $Ghz18 = "192.168.100.9";
my $Ghz26 = "192.168.100.11";
my @array_hour =();
my @array_min = ();
my @array_second =();
my @array_level = ();

my $result = {};

#print "RxData/200906/20090601/"."$Ghz18"."_csv.log";
 
open(IN,"RxData/200906/20090601/"."$Ghz18"."_csv.log");

my $count = 0;
my $goal=0;
my $sum=0;

my ($hour,$min,$second,$level) = (0,0,0,0);
my ($f_hour,$f_min,$f_second,$f_level) = (0,0,0,0);

while(<IN>){
    chomp;
#    if($_ eq "HOST NAME : Undefined Host  IP ADDRESS : 192.168.100.9"){ next;}
#    if($_ eq "time, 1803_RX_LEVEL, 1803_TX_POWER, 1803_BER"){ next;}
    if($. eq 1..2){next;}
    
    ($hour,$min,$second,$level) = split /\:|\,/,$_;

    if(! ($hour =~ /^\d+$/)){
        next;
        
    }
    if(! ($level =~ /^(-)\d+$/)){
        next;
    } 

    if($count == 0){ 

    $f_hour = $hour;
    $f_min = $min;
    $f_second = $second;
    $goal = $f_second +8;
    $goal= $goal >= 60 ? $goal % 60 : $goal;
    $sum=$level;

    $count++; next; }

    $sum+=$level;

    if($goal <= $second){
#        print "$goal\n";
#        print "$second\n";
     $sum /=($count+1);
     $result->{"$f_hour".":"."$f_min".":"."$f_second"}="$sum";
     $count=0;
     next;
    }
=commnet
    push(@array_hour,shift @tmp);
    push(@array_min,shift @tmp);
    push(@array_second,shift @tmp);
    push(@array_level,shift @tmp);
=cut

   $count ++;

}

#print Dumper($result);
   for my $key(sort keys %$result){
        printf("%s %s\n",$key,$result->{$key});
    } 
