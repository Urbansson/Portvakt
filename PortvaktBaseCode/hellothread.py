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
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def run(self):
        print "Starting " + self.name
        while self.go:
            time.sleep(self.updaterate)
            self.s.sendto(str(self.id),(self.host, self.port))
        s.close()

    def stop(self):
        self.go = False
