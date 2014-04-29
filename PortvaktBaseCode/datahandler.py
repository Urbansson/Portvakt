import time
import threading
import socket
import fcntl
import struct

from DataStorage import DataStorage
from uuid import getnode as get_mac

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def sendData(data):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
    server.connect(("192.168.1.7",6782)) 
    server.send(data+'\n')
    server.send("done"+'\n')
    server.close()
    print "Data sent to remote server"
    

class datahandler(threading.Thread):
    def __init__(self, port, updaterate):
        threading.Thread.__init__(self)
        self.host = get_ip_address('eth1')
        self.port = port
        self.go = True
        self.id = get_mac()
        self.updaterate = updaterate*60
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.ds = DataStorage()
        self.lastMessage = ""

    def run(self):
        print "Starting data Thread\n"
        update = time.time()
        self.s.bind((self.host, self.port)) # Bind socket to interface

        while self.go:
            data, addr = self.s.recvfrom(1024) # buffer size is 1024 bytes
            #print "Data recived\n"
            #print "Data: ", data
            #print "Recived from: ", addr
            self.lastMessage = data 
            tmp = data.split('|')
            idmac = tmp[0]
            for item in tmp[1:]:
                tmpsensor = item.split(":")
                if tmpsensor[0]:
                    self.ds.pushData(idmac,tmpsensor[0],tmpsensor[1],tmpsensor[2])

            if self.updaterate < time.time()-update:
                sendData(self.ds.toString())
                self.ds.pullData()
                update = time.time()

        print "Data Thread Done\n"


#recv data
        self.s.close()
        return 10;

    def stop(self):
        self.go = False

        
    def getLastMessage(self):
        return self.lastMessage
