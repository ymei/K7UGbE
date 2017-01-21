#!/usr/bin/env python

## @package tcp_send
# Send data over tcp for testing purposes.
#

from command import *
import socket
import time

if __name__ == "__main__":
    host = '192.168.2.3'
    port = 1024
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((host,port))

    val = ""
    for j in xrange(100):
        for i in xrange(256):
            val += chr(i)
    for i in xrange(256):
        val += chr(0)
#    s.sendall(val)

    cmd = Cmd()
    val = cmd.write_register(0, 0x00)
    s.sendall(val)

    s.close()
