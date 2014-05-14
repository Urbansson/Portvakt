import threading
import random
import time
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

def sendData(data, host, port):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
    server.connect((host,port))
    server.send(str(get_mac())+'||\n')
    server.send(data+'\n')
    server.send("done"+'\n')
    server.close()
    print "Data sent to remote server"

class getData(threading.Thread):
    """
    Gets data from sensors and stores them in DataStorage class
    """
    def __init__(self, serverhost, serverport, updaterate, lastmessage, condition):
        """
        Constructor.
        @param serverhost address to remote server to send data to
        @param serverport port of remote server
        @param updaterate amount of time before data is sent to remote server
        @param lastmessage last message recived from server
        @param condition condition synchronization object
        """ 
        threading.Thread.__init__(self)

        self.lastmessage = lastmessage
        self.condition = condition

        self.remotehost = serverhost
        self.remoteport = serverport

        self.host = get_ip_address('eth1')
        print self.host
        #self.host = "130.229.145.50"
        self.port = 8822
        self.go = True
        self.id = get_mac()
        self.updaterate = updaterate*10
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.ds = DataStorage()
    
    def run(self):
        print "Starting data Thread\n"

        self.s.bind((self.host, self.port)) # Bind socket to interface
        data, addr = self.s.recvfrom(1024) # buffer size is 1024 bytes
        update = time.time()

        while self.go:
            data, addr = self.s.recvfrom(1024) # buffer size is 1024 bytes
            #print data
            #Stores the data and notifys the streaimg threads that new data is available
            self.condition.acquire()
            self.lastmessage.storeData(data)
            self.condition.notifyAll()
            self.condition.release()

            self.ds.push(data)

            if self.updaterate < time.time()-update:
                #Sends data to remote server
                t1 = threading.Thread(target = sendData, args=(self.ds.toString(), self.remotehost, self.remoteport))
                t1.start()
                print "Data to Server"
                print self.ds.toString()
                update = time.time()

        self.s.close()             
  
    def stop(self):
        self.go = False
