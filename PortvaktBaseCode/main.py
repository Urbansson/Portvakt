import threading
import random
import time
import socket
import fcntl
import struct
from init import *
from hellothread import *
from datahandler import *
from streamdata import *
from LastRecivedData import *

#Hello
def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def main():
 
    ServerAddresPortvakt = "server2.portvakt.se"
    ServerAddres = "130.229.190.178"
           
    lrm = LastRecivedData()
    condition = threading.Condition()
    hellotimer = 5
    datatimer = 1

    """
    Saved
    Connects to the initation server registrating the divece and getting starting parameters
    """
    start = init(ServerAddres, 6780)
    #hellotimer ,datatimer = start.getData()

    """
    Starts the thread that sends hello messages to server keeping the conenction alive
    """
    threadHello = HelloThread(ServerAddresPortvakt, 6781, hellotimer)
    threadHello.start()

    """
    Starts the thread that gathers data and sends it to the remote server 
    """
    threadData = getData(ServerAddres, 6782, datatimer, lrm, condition)
    try:
        pass
        #threadData.start()
    except (KeyboardInterrupt, SystemExit):
        cleanup_stop_thread();
        sys.exit()

    """
    Main loop of the program, after the starting of threads the basestation waits for commands from the remote server.
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    TCP_PORT = 8822
    TCP_HOST = get_ip_address("wlan0")
    #TCP_HOST = "130.229.145.50"
    print "Ip Address to base is: " + TCP_HOST
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((TCP_HOST,TCP_PORT))
    s.listen(5)
    while True:
        request = ''
        c, addr = s.accept()     # Establish connection with client.
        print "Got connection: " + str(addr)
        while len(request) < 2:
            request += c.recv(1)
        print request
        if "1|" in request:
            t2 = Streamdata(c,lrm, condition)
            t2.start()
           

if __name__ == '__main__':
    main()

















"""
import socket 
import time
import threading
from datahandler import *

condition = threading.Condition()


rate = 1337
go = True

def gatherData():
    global go
    global rate
    while go:
        print rate
        print go
        time.sleep(1)


global go
thread = threading.Thread(target=gatherData, args=())

thread.start()
time.sleep(2)
rate = 8888
time.sleep(2)
rate = 9999
time.sleep(2)

go = False

datathread.stop()
"""
