#!/usr/bin/env python 

""" 
A simple echo client 
""" 

import socket 
import time

class SendUDP ():
    def __init__(self, host, port, id):
        self.host = host
        self.port = port
        self.id = id
        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def send(self):
    	self.s.sendto(str(self.id),(self.host, self.port))
    	print "done"
