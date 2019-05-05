#encoding: utf-8
import SocketServer
import time
import struct
import binascii
import os,sys
import traceback
import logging

from SocketServer import StreamRequestHandler as SRH
from time import ctime

host = '0.0.0.0'
port = 2000

port2 = 1000
addr = (host, port)
addrapp = (host,port2)
l_port ={}     #all port


class ServersApp(SRH):
    #timeout =115
    def handle(self):
        while True:
            try:
                data = self.request.recv(1024)
                #print "RECV from ", self.client_address
                #s1 = "RECV from ", self.client_address
                #self.request.send('I recv you MSG')
                l_port[self.client_address[1]] = self.connection
                #print 'the l_port is ',l_port
                print 'first recv data is ',data
                #print type(data)
                if data[0:3] == 'kkk':
                    print self.client_address[1],':OK KKK'
                    self.request.send('OK KKK')
                elif data[0:3] =='mmm':
                    self.connection.send('this is frpm socket send')
                    print self.client_address[1],':this is mmm'
                elif data[0:3] == 'ppp':

                    print self.client_address[1],':this is ppp'
                elif data[0:4] == 'over':
                    print self.client_address[1], ':over'
                else:
                    print self.client_address[1],':this is other data'
                
            except:
                traceback.print_exc()
                #logging.info("recv error")
                break
            else:
                if not data:
                    break

    def handle_timeout(self):
        print "port %s is timeout" % self.client_address[1]
        #logging.info("port %s is timeout" % self.client_address[1])
        #l_port.remove(self.client_address[1])
        del l_port[self.client_address[1]]

    def finish(self):
        #print "port %s is lost" % self.client_address[1]
        #logging.info("port %s is lost" % self.client_address[1])
        #l_port.remove(self.client_address[1])
        del l_port[self.client_address[1]]



def daemon():
    pid = os.fork()
    if pid > 0:
        sys.exit(0)
    # 修改子进程工作目录
    os.chdir("/")
    # 创建新的会话，子进程成为会话的首进程
    os.setsid()
    # 修改工作目录的umask
    os.umask(0)
    # 创建孙子进程，而后子进程退出
    pid = os.fork()
    if pid > 0:
        sys.exit(0)
    # 重定向标准输入流、标准输出流、标准错误
    sys.stdout.flush()
    sys.stderr.flush()
    si = file("/dev/null", 'r')
    so = file("/dev/null", 'a+')
    se = file("/dev/null", 'a+', 0)
    os.dup2(si.fileno(), sys.stdin.fileno())
    os.dup2(so.fileno(), sys.stdout.fileno())
    os.dup2(se.fileno(), sys.stderr.fileno())


if __name__ =="__main__":
    #daemon()
    print 'client is running....'
    #logging.info('server is running....')
   # server = SocketServer.ThreadingTCPServer(addr, Servers)
    #server.daemon_threads = True
    serverapp = SocketServer.ThreadingTCPServer(addr, ServersApp)
    serverapp.daemon_threads = True
   # server.serve_forever()
    serverapp.serve_forever()