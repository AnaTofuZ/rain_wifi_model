#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

#結果を収納するハッシュリファレンス
my $sum ={};
#刻み幅を設定
my $stride = 1;

#開くファイル名を指定
my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);
#まずrサブルーチンian_dataに処理を渡す
for (@total){
    rian_data("$_.txt",$sum,$stride);
}
#サブルーチンmakeSumの返り値が,全データの件数であるのでsumRainに代入する
my $sumRain = &makeSum($sum);
#その後makePersにハッシュリファレンスとデータ件数を渡す
&makePers($sum,$sumRain);

open(OUT,"> sortRain.txt");
#整形されたデータを書き込む．パーセントに直すために100をかける
for my $key (sort {$b <=> $a} keys %$sum){
    printf (OUT "%s %s\n",$sum->{$key}*100,$key);
}

close(OUT);

sub rian_data{
#サブルーチンria_dataでは,テキストファイル名と結果のハッシュリファレンス,刻み幅を受け取る
    my($txtname,$result,$stride) = @_;
#ファイル名をパスを含めて整形
    $txtname = "RainData/$txtname";
#ファイルがなければ終了
    return if(! -e $txtname);

    open(IN,$txtname);

    while(<IN>){
        chomp;
    #刻み幅で割り,整数型にして再度刻み幅をかけることで
    #刻み幅の倍数の数に整形する
        my $default =int($_/$stride);
        $default *= $stride;
    #その変数がいる範囲のハッシュの値をインクリメント(初期値は0)
        $result->{$default}++;
    }

    close(IN);

}

sub makeSum {
    my ($result) = @_;
    #総数をカウントする変数beforeを宣言
    my $before =0;

    for my $key(sort {$b <=> $a} keys %$result){
#キー(出現した値)を降順でハッシュループさせる
       if($before ==0){
#最初のループで変数beforeにハッシュ値を設定
          $before= $result->{$key};
          next;
       }
#以降のループでは,その1つ前までの値をハッシュ値に足していく
        $result->{$key}+=$before;
        $before =$result->{$key};
    }
#総計を返り値とする
    return $before;
}

sub makePers {

    my($result,$sum) =@_;
#総計を受取,小数点以下5位まで割り算をしハッシュ値を更新していく
    for my $key(sort {$b <=> $a} keys %$result){
        $result->{$key}=sprintf("%.5f",$result->{$key}/=$sum);
    }
}
