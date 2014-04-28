from hellothread import HelloThread
from init import init
import time

start = init("localhost", 6780)
start.run()

# Create new threads
thread1 = HelloThread("localhost", 8000, 5)

# Start new Threads
thread1.start()
time.sleep(10)
thread1.stop()
print "Exiting Main Thread"
