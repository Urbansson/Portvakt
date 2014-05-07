import os

def savePid():
    pid = os.getpid()
    file = open("./pid.tmp",'w')
    file.write(str(pid))
    file.close()

savePid()
while True:
    print "HALLOJ"
