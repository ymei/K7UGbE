#!/usr/bin/env python

## @package tcp_send
# Send data over tcp for testing purposes.
#

from command import *
import socket
import select
import time
import sys, os, errno

if __name__ == "__main__":
    host = '192.168.2.3'
    port = 1024
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((host,port))
    s.setblocking(False)

    val = ""
    for j in xrange(100):
        for i in xrange(256):
            val += chr(i)
    for i in xrange(256):
        val += chr(0)
#    s.sendall(val)

    cmd = Cmd()
    val = cmd.write_register(0, 0x01)
    s.sendall(val)

    val = ""
    for i in xrange(2560):
        val += cmd.read_datafifo(4096*10)
    # val = cmd.read_register(0)
    s.sendall(val)
    while True:
        try:
            ret = s.recv(4096)
        except socket.error, e:
            err = e.args[0]
            if err == errno.EAGAIN or err == errno.EWOULDBLOCK:
                # no data
                continue
            else:
                print e
                break
        sys.stdout.write(ret)
        sys.stdout.flush()

    s.close()
