#!/usr/bin/env python

## @package tcp_read_fifo_test
# Send command to/and read fifo over tcp for testing purposes.
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

    reads = 65536
    buf = bytearray(4096)
    view = memoryview(buf)

    cmd = Cmd()
    scmd = cmd.write_register(0, 0x0001)
    scmd += cmd.send_pulse(0x8000)
    scmd += '\0' * 4 * 30
    fcmd = cmd.read_datafifo(reads-1)
    s.sendall(scmd+fcmd)
    totalRead = 0
    resent = False
    rr = 0
    while True:
        rl, wl, el = select.select([s], [], [], 1)
        if(not (rl or wl or el)):
            print "Timeout! at totalRead = %d" % totalRead
            totalRead = 0
            break
        if s in rl:
            ret = s.recv_into(view, 4096)
            totalRead += ret
#            print "Read %d, total read = %d" % (ret, totalRead)
#            sys.stdout.write(buf[0:ret])
#            sys.stdout.flush()
            if totalRead > reads * 2:
                if not resent:
                    s.sendall(fcmd)
                    resent = True
            if totalRead >= reads * 4:
                # if totalRead > reads * 4:
                #     print "totalRead = %d, Error!" % totalRead
                #     break
                totalRead -= reads * 4
                resent = False
                rr += 1
#                break
#            if rr == 3:
#                break
    s.close()
