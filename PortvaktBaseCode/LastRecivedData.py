"""
Stores the last recived message from all sensors

pushdata = stores a value from sensor, adds new sensor if it can't find it
pullData = pulls the last recived message from a sensor

"""

from SensorData import *

class LastRecivedData():
    def __init__(self):
        self.data = []

    def storeData(self,data):
        tmp = data.split('|')
        idmac = tmp[0]
        for item in tmp[1:]:
            tmpsensor = item.split(":")
            if tmpsensor[0]:
                self.pushData(idmac,tmpsensor[0],tmpsensor[1],tmpsensor[2])
                 
    def pushData(self, idMac, idSensor,sensorType, value):
        found = False
        for item in self.data:
            if item.getIdMac() == idMac and item.getIdSensor() == idSensor:
                item.setNewValue(value)
                #item.addValue(value)
                found = True

        if(found == False):
            self.data.append(SensorData(idMac, idSensor,sensorType, value))

    def readData(self, idMac, idSensor):
        for item in self.data:
            if item.getIdMac() == idMac and item.getIdSensor() == idSensor:
                return item.getValue()
        return None

if __name__ == '__main__':
    lrm = LastRecivedData()
    lrm.storeData("70835001134783|1:2:322|2:2:1000|")

    print lrm.pullData("70835001134783","2")


    
