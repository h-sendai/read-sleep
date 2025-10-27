#!/usr/bin/python3

import os
import sys
import time

def main():
    f = open('data.activity.log', 'r')
    o = open('data-sum.log', 'w')
    sum = 0
    for line in f:
        e = line.strip().split()
        sum += int(e[16])
        o.writelines('%s %s %s %d\n' % (e[0], e[1], e[16], sum))

if __name__ == '__main__':
    main()
