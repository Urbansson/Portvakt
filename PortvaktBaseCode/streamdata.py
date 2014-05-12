import threading
import random
import time
import socket

def getRequest(socket):
    data = ""
    while True:
        data += socket.recv(1024)
        if "done" in data: break
    data = data.split("|")
    return data[:2]

class Streamdata(threading.Thread):


    def __init__(self, socket,lastmessage, condition):
        """
        Constructor.
        @param socket to remote server to send data to
        @param lastmessage class containg the last recived message
        @param condition condition synchronization object
        """       
        threading.Thread.__init__(self)
        self.lastmessage = lastmessage
        self.condition = condition
        self.socket = socket

    def run(self):
        """
        Thread run method. Waits for reciver thread to release the condition
        then takes the last message if it exists and sends it to the remote server
        Inte ultimat kommer bli mycket samma data i slutandan om manga enheter skickar data
        """
        macId, sensorId = getRequest(self.socket)
        try:
            while True:
                self.condition.acquire()
                while True:
                    data = self.lastmessage.readData(macId, sensorId)
                    self.socket.send(str(data) + '\n')
                    #self.socket.send("done\n")
                    self.condition.wait()
        except socket.error, e:
            print "Catching broken pipe"
        self.condition.release()
        self.socket.close()


        """
        macId, sensorId = getRequest(self.socket)
        print macId + "|" +sensorId
        self.condition.acquire()
        self.condition.wait()
        data = self.lastmessage.readData(macId, sensorId)
        self.condition.release()
        print str(data)
        self.socket.send(str(data) + '\n')
        self.socket.send("done\n")
        self.socket.close()
"""
"""
        while True:
            self.condition.acquire()
            print 'condition acquired by %s' % self.name
            while True:
                print self.integers[0] + " by " + self.name
                if self.sensoridmac and self.idend in self.integers[0]: 
                    self.socket.send(self.integers[0]+"\n")
                #print 'condition wait by %s' % self.name
                self.condition.wait()
            #print 'condition released by %s' % self.name
            self.condition.release()
    
"""
