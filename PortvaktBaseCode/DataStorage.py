"""
Stores data from all sensors

pushdata = stores a value from sensor, adds new sensor if it can't find it
pullData = cleans and returns all data

"""
from SensorData import *

class DataStorage():
    def __init__(self):
        self.data = []

    def push(self, data):
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
                item.addValue(value)
                found = True

        if(found == False):
            self.data.append(SensorData(idMac, idSensor,sensorType, value))

    def pull(self):
        tmp = self.data
        self.data = []
        return tmp

    def toString(self):
        string = ''
        for item in self.data:
            string += str(item.getIdMac()) + '|'
            string += '%s:%s:%s|' % (item.getIdSensor(), item.getSensorType() ,item.getValue())
        string += '\n'
        self.pull()
        return string
            
if __name__ == '__main__':
    ds = DataStorage()
    ds.push("70835001134784|1:2:900|")
    ds.push("70835001134784|1:2:800|")
    print ds.toString()
    ds.pull()
    ds.push("70835001134784|1:2:200|")
    print ds.toString()

