#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

#ディレクトリ,及びファイル名を範囲演算子を用いて配列に代入
my @total =(20090601..20090630,20091002..20091031,20091101..20091130,20091201..20091230);


for (@total){
#各ディレクトリ,およびファイルを開き,サブルーチンrian_dataに渡す
    my $txt ="RainData/"."$_"."/"."$_"."_rain.csv";
    rian_data($txt,$_);

}


sub rian_data{
    my($txtname,$num) = @_;
#ファイルが存在しない場合,サブルーチンnotFilesysytemに処理を渡し,終了する
    if(! -e $txtname){
       &notFilesystem($num);
       return;
    }
#ファイルを開く
    open(IN,$txtname);

    my $count = 1;
    my $result ={};
    my $rain_sum = 0;
     
    while(<IN>){
        chomp;
        next if $_ eq "";
        next if $_ eq "Recording started.";
#文字列の様なバグがあればスキップし,","を区切りに分割
        my($time,$rain) = split /,/,(split / /,$_)[1];
#1時間降雨強度への変換を行う
        $rain*=60;
        $rain*=0.0083333;
#小数点2桁まで保存しハッシュに代入
        $result->{"$time"}=sprintf('%.2f',$rain);
        
    }

    close(IN);

    my $textfile = "RainData/$num.txt";
    open(OUT,"> $textfile");
#整形したデータを,降雨強度のみテキストファイルに書き込み
        for my $key(sort keys %$result){
            printf(OUT "%s\n",$result->{$key});
        }
    close(OUT);
}


sub notFilesystem {
    my ($textname) = @_;

    $textname .= ".txt";

    open(OUT,"> $textname");
#ファイルが無かった場合,晴天を示す0を24時間分作成する(実際にはデータには含めないので誤差)
    for (0..23){
        printf(OUT "%s\n",0);
    }

    close(OUT);
}
