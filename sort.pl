#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;


my $Ghz18 = "192.168.100.9";
my $Ghz26 = "192.168.100.11";
my $array_hour = [];
my $array_min = [];
my $array_second = [];
my $array_level = [];

my $result = {};

print "RxData/200906/20090601/"."$Ghz18"."_csv.log";
 
open(IN,"RxData/200906/20090601/"."$Ghz18"."_csv.log");

my $count = 0;

print;
print;

while(<IN>){
    chomp;
    #if($_ eq "HOST NAME : Undefined Host  IP ADDRESS : 192.168.100.11"){ next;}
    # if($_ eq "time, MX_RX_LEVEL, MX_TX_POWER, MX_BER_1, MX_BER_2"){ next;}

   ( $array_hour->["$count"],$array_min->["$count"],$array_second->["$count"],$array_level->["$count"]) = split /\:|\,/,$_;

   print $count;

   $count ++;

   }
