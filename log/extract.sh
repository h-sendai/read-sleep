#!/bin/zsh

sleep_usec=85000

port=$(head -n 1 net.txt | awk '{print $3}' | awk -F '.' '{print $5}')
start_time=$(head -n 1 total.log | awk '{print $1}')

grep -E '(now sleep|readn\(\) start)' total.log | sed -e "s/now sleeping $sleep_usec usec/0/" -e 's/readn() start.*$/1/' > program.activity
grep -E "IP 192.168.10.202.$port > 192.168.10.17.24: Flags \[.\], ack" total.log | sed -e 's/,//g' | awk '{print $1, $9}' > ack.activity

tcpdumpdiff -s $start_time program.activity > program.activity.log
tcpdumpdiff -s $start_time ack.activity > ack.activity.log

grep -E "IP 192.168.10.17.24 > 192.168.10.202.$port:" total.log | grep -v mss | grep -v none | sed -e 's/,//g' -e 's/:/ /g' > packet.activity
tcpdumpdiff -s $start_time packet.activity > packet.activity.log

fgrep 'readn() start' total.log | sed -e 's/(//g'  -e s'/)//g' > rcvbuf.activity
tcpdumpdiff -s $start_time rcvbuf.activity > rcvbuf.activity.log
