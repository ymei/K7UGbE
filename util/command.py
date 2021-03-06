from ctypes import *


class Cmd:
    # soname = "./build/lib.freebsd-11.0-STABLE-amd64-2.7/command.so"
    soname = "./build/lib.macosx-10.6-x86_64-2.7/command.so"
    soname = "./build/lib.linux-x86_64-2.7/command.so"
    nmax = 20000

    def __init__(self):
        self.cmdGen = cdll.LoadLibrary(self.soname)
        self.buf = create_string_buffer(self.nmax)

    def send_pulse(self, mask):
        cfun = self.cmdGen.cmd_send_pulse
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(mask))
        return self.buf.raw[0:n]

    def read_status(self, addr):
        cfun = self.cmdGen.cmd_read_status
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(addr))
        return self.buf.raw[0:n]

    def write_memory(self, addr, aval, nval):
        cfun = self.cmdGen.cmd_write_memory
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(addr), c_void_p(aval), c_size_t(nval))
        return self.buf.raw[0:n]

    def read_memory(self, addr, val):
        cfun = self.cmdGen.cmd_read_memory
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(addr), c_uint(val))
        return self.buf.raw[0:n]

    def write_register(self, addr, val):
        cfun = self.cmdGen.cmd_write_register
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(addr), c_uint(val))
        return self.buf.raw[0:n]

    def read_register(self, addr):
        cfun = self.cmdGen.cmd_read_register
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(addr))
        return self.buf.raw[0:n]

    def read_datafifo(self, val):
        cfun = self.cmdGen.cmd_read_datafifo
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_uint(val))
        return self.buf.raw[0:n]

    def write_memory_file(self, file_name):
        cfun = self.cmdGen.cmd_write_memory_file
        buf = addressof(self.buf)
        n = cfun(byref(c_void_p(buf)), c_char_p(file_name))
        return self.buf.raw[0:n]

if __name__ == "__main__":
    cmd = Cmd()
    ret = cmd.write_register(1, 0x5a5a)
    print [hex(ord(s)) for s in ret]

