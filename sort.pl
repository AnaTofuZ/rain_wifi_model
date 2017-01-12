#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;
use 5.23.9;

my $Ghz18 = "192.168.100.9";
my $Ghz26 = "192.168.100.11";

my @directory = (200906,200910,200911,200912);

for  my $roop (@directory){
    for (01..31){
        $_ = sprintf("%02d",$_);
        my $name = $roop."/".$roop.$_;
        &count($Ghz18,$name,1);
        &count($Ghz26,$name,0);
    }
}

sub count{ 


    my($Ghz,$path,$flag) = @_;

    my @array_hour =();
    my @array_min = ();
    my @array_second =();
    my @array_level = ();

    my $result = {};
   

    if(! -e "RxData/".$path."/"."$Ghz"."_csv.log"){
    my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
        return if(! -d "RxData/".$path);
        open(OUT,">","$tmp");
        printf(OUT "%s %s\n",0,0);
        close(OUT);
        return;

    }

    open(IN,"RxData/".$path."/"."$Ghz"."_csv.log");

    my $goal=0;
    my $sum=0;
    my $count=0;
    my $hourCount = 0;

    my ($hour,$min,$second,$level) = (0,0,0,0);
    my ($f_hour,$f_min,$f_second,$f_level) = (0,0,0,0);

    while(<IN>){
        chomp;
        next if($. eq 1..2);
        
        ($hour,$min,$second,$level) = split /\:|\,/,$_;

        next if(! ($hour =~ /^[0-9]+$/));
        
        next if(! defined $level);

        next if(!($level =~ /^-?[0-9]+\.?[0-9]+$/));

        if($count == 0){ 

        
        if($f_hour != $hour){
            $f_hour = $hour;
            $hourCount++;
        }
        $f_min = $min;
        $f_second = $second;
        $goal = $f_second +8;
        $goal= $goal >= 60 ? $goal % 60 : $goal;
        $sum=$level;

        $count++; next; }

        $sum+=$level;

        if($goal <= $second){
           $sum /=($count+1);

         if($flag == 1){
            
             $sum += 256 if $sum <0;
             $sum /=2;
             $sum -= 121;
         }


         $result->{"$f_hour".":"."$f_min".":"."$f_second"}="$sum";
         $count=0;
         next;
        }

       $count ++;

    }

    close(IN);

    if($hourCount < 12 ){
        my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
        open(OUT,">$tmp");
        printf(OUT "%s %s\n",0,0);
        close(OUT);
        return;

    }
    my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
    open(OUT,"> $tmp");

    #print Dumper($result);
       for my $key(sort keys %$result){
            printf(OUT "%s %s\n",$key,$result->{$key});
        } 

        close(OUT);

}
