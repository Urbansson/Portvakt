import time
import socket 
from uuid import getnode as get_mac

class datahandler ():
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.host = host
        self.port = port
        self.go = True
        self.id = get_mac()
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def run(self):
    	while self.go
    		#gather data 
    		#Stora data in ram and/or on disk
    		#Wait x minutes before sending the data over to the server'
    		#repeat 

#recv data
        self.s.close()
        return 10;

    def stop(self):
        self.go = False