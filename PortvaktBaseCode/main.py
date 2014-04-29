from hellothread import HelloThread
from datahandler import datahandler
from init import init
import time
import socket 

start = init("192.168.1.7", 6780)
start.run()

# Create new threads
threadHello = HelloThread("192.168.1.7", 8000, 5)
# Create thread for getting data and sending data
threadData = datahandler(8822,1)

# Start new Threads
threadHello.start()
threadData.start()
while True:
    tmp = threadData.getLastMessage()
    print tmp
    time.sleep(1)
time.sleep(120)
threadHello.stop()
threadData.stop()

"""
#Create Socket to listen to commands from Server and make changes

s = socket.socket()
TCP_PORT = 8888
TCP_HOST = socket.gethostbyname(socket.gethostname())
s.bind((TCP_HOST,TCP_PORT))
print socket.gethostbyname(socket.gethostname())
s.listen(5)
while True:
   c, addr = s.accept()     # Establish connection with client.
   print 'Got connection from', addr
   c.send('Thank you for connecting\n')
   c.close()

   """
print "Exiting Main Thread"
