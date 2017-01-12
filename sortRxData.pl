#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use constant;

use Data::Dumper;
use 5.23.9;

#各ipAddressを定数として宣言
use constant Ghz18 => "192.168.100.9";
use constant Ghz26 => "192.168.100.11";

#使用するディレクトリを定数の配列として宣言する
use constant directory =>(200906,200910,200911,200912);

#結果を収納するハッシュリファレンス,及び合計値を初期化
my $sumGhz18 = {};
my $sumGhz26 = {};
my $numGhz18 = 0;
my $numGhz26 = 0;

#刻み幅を設定
my $stride = 1;

#降雨減衰量は負の値であるので予め-100から0までハッシュを作成する(実際には動的に作成される)
for  (-100..0){
    next if $_ % $stride!= 0;
    $sumGhz18->{$_}=0;
    $sumGhz26->{$_}=0;
}
#各ディレクトリ分ループ
for my $roop (directory){
    #1ヶ月分ループし,サブルーチンsumGhz18,26をそれぞれ呼び出し
    for  (01..31){
        $_ = sprintf("%02d",$_);
        my $name = "$roop/$roop$_";
        &sumGhz18($name,$sumGhz18);  
        &sumGhz26($name,$sumGhz26);  
    }
}

#makeSumで合計値が返ってくる為に,それぞれ設定
my $MaxGhz18 = &makeSum($sumGhz18);
my $MaxGhz26 = &makeSum($sumGhz26);

#割り算を行うmakepersにそれぞれハッシュリファレンスと総数を渡す
    &makePers($sumGhz18,$MaxGhz18);
    &makePers($sumGhz26,$MaxGhz26);

#テキストファイル生成用サブルーチンoutPutに結果と文字列を渡す
&outPut($sumGhz18,"sumGhz18");
&outPut($sumGhz26,"sumGhz26");

sub sumGhz18 {

    my($path,$result) = @_;
#ファイルが無ければreturn
    return if(! -e "RxData/$path/".Ghz18."_csv_sort.log");

    open(IN,"RxData/$path/".Ghz18."_csv_sort.log");

   while (<IN>) {
       chomp;
#ファイルを開き,降雨減衰量を刻み幅の倍数に設定し直す
       $_ =(split / /,$_)[1];  
       $_= $stride*int($_/$stride);
#0以上はエラーとみなし,0に強制設定
       $_ = 0 if($_ >0);
#ハッシュをインクリメント
       $result->{$_}++;
       $numGhz18++;
   } 
   close IN;
}

sub sumGhz26 {
#ほぼ処理はsumGhz18と同様である
    my($path,$result) = @_;

    return if(! -e "RxData/$path/".Ghz26."_csv_sort.log");
    open(IN,"RxData/$path/".Ghz26."_csv_sort.log");

   while (<IN>) {
       chomp;
        $_ =(split / /,$_)[1];
        $_=$stride*int($_/$stride);
        $_ = 0 if($_ >0);
        $result->{$_}++;
        $numGhz26++;
    }
    close IN;

}

sub makeSum {
    my ($result) = @_;
    
    my $before =0;

#keyの値を昇順でソートし,1つ前の値を加算してく

    for my $key(sort {$a <=> $b} keys %$result){
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
#各値について割合を求めておく
    my($result,$sum) =@_;

    for my $key(sort {$b <=> $a} keys %$result){
        $result->{$key}=sprintf("%.5f",$result->{$key}/=$sum)
    }
}

sub outPut {

    my ($result,$name) = @_;
#ファイルハンドルを開く
    open(OUT,"> $name"."Sort.txt");
#keyの値を降順でソートし,テキストファイルに書き込んでいく．またパーセンテージに直すために100倍する
    for my $key(sort {$b <=> $a} keys %$result){
        printf(OUT "%s %s\n",$result->{$key}*100,$key);
    }

    close(OUT);
}