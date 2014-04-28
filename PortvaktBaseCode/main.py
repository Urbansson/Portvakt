from hellothread import HelloThread

def print_time(threadName, delay, counter):
    while counter:
        if exitFlag:
            thread.exit()
        time.sleep(delay)
        print "%s: %s" % (threadName, time.ctime(time.time()))
        counter -= 1

# Create new threads
thread1 = HelloThread("localhost", 8000, 5)
#thread2 = HelloThread(2, "Thread-2", 2)

# Start new Threads
thread1.start()
#thread2.start()

print "Exiting Main Thread"
