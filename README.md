# ソケットを使ってデータを読むプログラム(read/readnしたらsleepする)

DAQコンポーネントで
```
SiTCP - (Gigabit Ethernet) - Source - Sink
```
と組み合わせてSiTCP機器を読み込ませたとき、
SourceでreadAll()させるサイズを増加させていくと、
サイズがおおきくなると読み出し速度がEthernetの最大値
より小さくなる（読み出しサイズが大きくなるとだんだん遅くなる)
という現象が生じているのでそれを理解するためのプログラム。

Source DAQコンポーネントは読んでSinkに送るというのを
逐次実行している。readAll()のサイズが大きくなると
「データを読んで、 Sinkにデータを送ってSinkでの受信を確認する」
という一連の動作に時間がかかるようになり、読み出し時間間隔が
大きくなっていく。

## 走らせ方

log/goにサンプルがある。
tcpdumpでキャプチャしながら、プログラムを走らせて、
プログラム終了後にプログラムのログとパケットキャプチャを
マージする。

```
#!/bin/zsh

sudo tcpdump -nn -i exp0 -s 78 -w net.cap </dev/null >& /dev/null &
sleep 1
timeout 5 ../../read-sleep -b 1024k -n -s 20000 192.168.10.17:24 >& prog.log
sleep 1
sudo pkill tcpdump

grep -v Gbps prog.log > read.log
tcpdump -tt -nn -r net.cap > net.txt
# use sort -s (stable sort if the time stamp is same)
cat read.log net.txt | sort -s -n > total.log
tcpdumpdiff total.log > total.diff
```

結果の例: [log/result.txt](log/result.txt)

sleepしている間にどんどんパケットがやってくるかと思ったが、
くることはくるが途中で送られなくる。これは読みだし側が
ACKを返してこないことにあるようだ。
sleepが終了してread()が動作しはじめたとたんACKが送られて
パケットがやってくるようになる。

Linuxではユーザープログラムがどのくらい読んだのかをみて
ACKがおくれれているということか?

DAQコンポーネントで
```
SiTCP - (Gigabit Ethernet) - Source - Sink
```
という構成で読みだしサイズを大きくしていくと
ある程度のところで読みだし速度が下がるのは
データサイズが大きくなるとSourceからSinkへデータを
送るのに時間がかかるようになり、その間、Sourceは
イーサネットを読むことはなくなるからACKが返らない
ようになりsitcp機器がデータを送るのを止めるから、という
ふうになっているのではないか。

sleep時間を300msにした例: [log/sitcp-300ms.txt](log/sitcp-300ms.txt)

read()していない間、ACKを約40ms間隔でだしているところがある。
read()がはじまるとすぐにACKがでているように見える。

