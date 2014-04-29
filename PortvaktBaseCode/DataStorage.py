"""
By Emil Vikstrom & Theodor Brandt
Inner class for storing data
idMac = identification based on sensor MACaddress
sensorType = indentification for what type of sensor
value = registred value from sensor

addValue = average of previous and new value from sensor

"""

class SensorData():
    def __init__(self, idMac, idSensor, sensorType, value):
        self.idMac = idMac
        self.idSensor = idSensor 
        self.sensorType = sensorType
        self.value = value
        #print idMac, sensorType, value

    def getIdMac(self):
        return self.idMac

    def getIdSensor(self):
        return self.idSensor
    
    def getSensorType(self):
        return self.sensorType

    def getValue(self):
        return str(self.value)

    def addValue(self, newValue):
        self.value = (int(self.value) + int(newValue))/2
    
        
"""
Stores data from all sensors

pushdata = stores a value from sensor, adds new sensor if it can't find it
pullData = cleans and returns all data

"""



class DataStorage():
    def __init__(self):
        self.data = []
        

    def pushData(self, idMac, idSensor,sensorType, value):
        found = False
        for item in self.data:
            if item.getIdMac() == idMac and item.getIdSensor() == idSensor:
                item.addValue(value)
                found = True

        if(found == False):
            self.data.append(SensorData(idMac, idSensor,sensorType, value))

    def pullData(self):
        tmp = self.data
        self.data = []
        return tmp

    def toString(self):
        string = ''
        for item in self.data:
            if not string:
                string = str(item.getIdMac()) + '|'
            string += '%s:%s:%s|\n' % (item.getIdSensor(), item.getSensorType() ,item.getValue())
        
        return string
            
        
