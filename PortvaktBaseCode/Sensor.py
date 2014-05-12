"""
Simulates a sensor with one conencted end divice

"""

import threading
import time
import socket 
from uuid import getnode as get_mac

def main():
    host = "130.229.145.50"
    port = 8822
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    data = []
    data.append("70835001134784|1:2:500|")
    data.append(True)
    print data

    t1 = threading.Thread(target = sendData, args=(s, host, port,data))
    t1.start()

    while True:
        value=raw_input('Please enter a value: for sensor 2: ')
        if int(value) > 1024:
            data[1] = False
            break
        data[0] = "70835001134784|1:2:"+str(value)+"|"
        print "sending: "+data[0] 
    t1.join()
    print "Exit"

def sendData(socket, host, port, data):
    while data[1]:
        socket.sendto(data[0],(host, port))
        time.sleep(2)
    print "done"

if __name__ == '__main__':
    main()
