#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;


my $Ghz18 = "192.168.100.9";
my $Ghz26 = "192.168.100.11";
my @array_hour =();
my @array_min = ();
my @array_second =();
my @array_level = ();

my $result = {};

print "RxData/200906/20090601/"."$Ghz18"."_csv.log";
 
open(IN,"RxData/200906/20090601/"."$Ghz18"."_csv.log");

my $count = 0;

while(<IN>){
    chomp;
    if($_ eq "HOST NAME : Undefined Host  IP ADDRESS : 192.168.100.9"){ next;}
    if($_ eq "time, 1803_RX_LEVEL, 1803_TX_POWER, 1803_BER"){ next;}
    
    my @tmp = split /\:|\,/,$_;
    push(@array_hour,shift @tmp);
    push(@array_min,shift @tmp);
    push(@array_second,shift @tmp);
    push(@array_level,shift @tmp);

#    ( $array_hour->["$count"],$array_min->["$count"],$array_second->["$count"],$array_level->["$count"]) = split /\:|\,/,$_;

   $count ++;

}


#print $start_min;

my $total_second =0;
my $goal =0;

for (my $i = 0; $i < scalar(@$array_hour); $i++) {
    

    $total_second += $array_second->[$i];

    if($total_second >= 60){
        $total_second %=60;
    }

    if($total_second < $goal){
        next;
    }else{
    
        print $start_second;
#        print "$text\n";
#     $result->{$start_hour".":"."$start_min".":"."$start_second}="$total_second";
       
    ($start_hour,$start_min,$start_second) = $array_hour->[$i+1],$array_min->[$i+1],$array_second->[$i+1];

    $goal = $start_second+ 10;
    if($goal >= 60 ){
        $goal %= 60;
    }
    }


}
#print @$array_level;

