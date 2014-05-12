import time
import socket 
from uuid import getnode as get_mac


class init ():
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.go = True
        self.id = get_mac()
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

    def getData(self):
        self.s.connect((self.host,self.port)) 
        self.s.send(str(self.id)+'\n')
        self.s.send("done"+'\n')
#recv data
        self.s.close()
        return 5, 1;
