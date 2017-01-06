#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use constant;

use Data::Dumper;
use 5.23.9;

use constant Ghz18 => "192.168.100.9";
use constant Ghz26 => "192.168.100.11";

use constant @directory =>(200906,200910,200911,200912);

my $sumGhz18 = {};
my $sumGhz26 = {};

for  (-100..0){
    next if $_ %5 != 0;
    $sumGhz18->{$_}=0;
    $sumGhz26->{$_}=0;
}

for my $roop (@directory){
    for  (01..31){
        $_ = sprintf("%02d",$_);
        my $name = "$roop/$roop$_";
    
    }
}
