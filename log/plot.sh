#!/usr/bin/gnuplot

set term pngcairo size 1200,800 font 'Arial,20'
set output 'ack-by-prog.prog-ack.2-2.1.png'
set xlabel 'sec'
set ylabel 'seq num (Mega)'
set ytics nomirror
set y2tics nomirror
#set yrange [100:120]
#set ytics 0,10
set y2range [0:1.1]
set xtics 0,0.01
set grid x
set grid y
plot [2:2.1] 'ack.activity.log' u 1:($3/1024/1024) w p ax x1y1 title 'pc sent ack. seq. num.', \
'program.activity.log' u 1:3 w step lw 3 ax x1y2 title 'program activity (1 = read, 0 = sleep)'

reset

set term pngcairo size 1200,800 font 'Arial,20'
set output 'ack-by-prog.packet.2-2.1.png'
set xlabel 'sec'
set ylabel 'packet recv bytes (kB)'
set ytics nomirror
set y2tics nomirror
set y2range [0:1.1]
#set yrange [0:40]
#set ytics 0,10
#set xtics 0,0.01
set xtics 0,0.1
set mxtics 10
set grid x
set grid y
plot [2:3] 'packet.activity.log' u 1:($17/1024) w p pt 5 ax x1y1 title 'pc recv. packet len.', \
'program.activity.log' u 1:3 w step lw 3 ax x1y2 title 'program activity (1 = read, 0 = sleep)'

reset

set term pngcairo size 1200,800 font 'Arial,20'
set output 'ack-by-prog.packet.2-2.02.png'
set xlabel 'sec'
set ylabel 'packet recv bytes (kB)'
set ytics nomirror
set y2tics nomirror
set y2range [0:1.1]
#set xtics 0,0.01
#set yrange [0:40]
#set ytics 0,10
set grid x
set grid y
plot [2:2.2] 'packet.activity.log' u 1:($17/1024) w p pt 5 ax x1y1 title 'pc recv. packet len.', \
'program.activity.log' u 1:3 w step lw 3 ax x1y2 title 'program activity (1 = read, 0 = sleep)'

reset 

set term pngcairo size 1200,800 font 'Arial,20'
set output 'ack-by-prog.recvbuf.png'
set xlabel 'sec'
set ylabel 'recv buf size / data in recv buf (kB)'
#set ytics nomirror
#set y2tics nomirror
#set y2range [0:1.1]
#set xtics 0,0.01
#unset ytics
set yrange [0:30000]
#set ytics 0,10
#unset set ytics 0,10
set grid x
set grid y
set log y
plot [0:5] \
'rcvbuf.activity.log' u 1:($5/1024)  w p pt 5 title 'data in rcvbuf before readn', \
'rcvbuf.activity.log' u 1:($11/1024) w lp pt 3 title 'rcvbuf size'
