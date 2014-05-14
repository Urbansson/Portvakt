import threading
import time
import socket 
from uuid import getnode as get_mac


class HelloThread (threading.Thread):
    def __init__(self, host, port, updaterate):
        
        threading.Thread.__init__(self)
        self.host = host
        self.port = port
        self.updaterate = updaterate
        self.go = True
        self.id = get_mac()

    def run(self):
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        print "Starting hello Thread\n"
        while self.go:
            time.sleep(self.updaterate)
            self.s.sendto(str(self.id),(self.host, self.port))
        self.s.close()
        print "Hello Thread Done\n"

    def stop(self):
        self.go = False
