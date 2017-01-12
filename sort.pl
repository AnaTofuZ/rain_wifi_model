#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;
use 5.23.9;

#Ghzの値を変数として定義
my $Ghz18 = "192.168.100.9";
my $Ghz26 = "192.168.100.11";

#雨量データが保存されているディレクトリ名を配列で宣言
my @directory = (200906,200910,200911,200912);

for  my $roop (@directory){
#1ヶ月分をforループで回し,サブルーチンcountに渡す．
    for (01..31){
#01,02などの0を入れるためにsprintfで整形
        $_ = sprintf("%02d",$_);
        my $name = $roop."/".$roop.$_;
        &count($Ghz18,$name,1);
        &count($Ghz26,$name,0);
    }
}

sub count{ 

#引数処理及び,結果を格納するハッシュリファレンス等を宣言
    my($Ghz,$path,$flag) = @_;

    my @array_hour =();
    my @array_min = ();
    my @array_second =();
    my @array_level = ();

    my $result = {};
   
#もしファイルが存在していなかった場合,0を記したファイルを作成し終了
    if(! -e "RxData/".$path."/"."$Ghz"."_csv.log"){
    my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
        return if(! -d "RxData/".$path);
        open(OUT,">","$tmp");
        printf(OUT "%s %s\n",0,0);
        close(OUT);
        return;

    }
#logファイルを開く
    open(IN,"RxData/".$path."/"."$Ghz"."_csv.log");

    my $goal=0;
    my $sum=0;
    my $count=0;
    my $hourCount = 0;

    my ($hour,$min,$second,$level) = (0,0,0,0);
    my ($f_hour,$f_min,$f_second,$f_level) = (0,0,0,0);

    while(<IN>){
        chomp;
#1,2行目は共通して文字列であるので飛ばす
        next if($. eq 1..2);
        
        ($hour,$min,$second,$level) = split /\:|\,/,$_;
#splitした結果が数字出なかった場合,次の行を読み込む
        next if(! ($hour =~ /^[0-9]+$/));
        
        next if(! defined $level);

        next if(!($level =~ /^-?[0-9]+\.?[0-9]+$/));
# countが0だった場合に処理
        if($count == 0){ 

 # 時間を跨いでいた場合,時間を更新       
        if($f_hour != $hour){
            $f_hour = $hour;
            $hourCount++;
        }
#現在の秒数+8secを目標と設定,60秒を超えた場合は余りを目標に設定する
        $f_min = $min;
        $f_second = $second;
        $goal = $f_second +8;
        $goal= $goal >= 60 ? $goal % 60 : $goal;
        $sum=$level;

        $count++; next; }

        $sum+=$level;
#もし秒数が目標を超えた場合,それまでの合計を設定する．
        if($goal <= $second){
           $sum /=($count+1);
#18Ghzの場合の処理を行う
         if($flag == 1){
            
             $sum += 256 if $sum <0;
             $sum /=2;
             $sum -= 121;
         }

#文字列を整形し,ハッシュに格納
         $result->{"$f_hour".":"."$f_min".":"."$f_second"}="$sum";
         $count=0;
         next;
        }

       $count ++;

    }

    close(IN);
#12時間以内で終了した場合,0を示すデータを作成する
    if($hourCount < 12 ){
        my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
        open(OUT,">$tmp");
        printf(OUT "%s %s\n",0,0);
        close(OUT);
        return;

    }
    my $tmp = "RxData/".$path."/"."$Ghz"."_csv_sort.log";
    open(OUT,"> $tmp");
#まとめた結果をテキストファイルに書き出す
       for my $key(sort keys %$result){
            printf(OUT "%s %s\n",$key,$result->{$key});
        } 

        close(OUT);

}
