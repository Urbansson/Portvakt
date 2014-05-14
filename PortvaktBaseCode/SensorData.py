"""
By Emil Vikstrom & Theodor Brandt
Class for storing sensor data
idMac = identification based on sensor MACaddress
idSensor = identification for the end sensor connected
sensorType = indentification for what type of sensor
value = registred value from sensor

addValue = Adds a new value for the sensor

"""

class SensorData():
    def __init__(self, idMac, idSensor, sensorType, value):
        self.idMac = idMac
        self.idSensor = idSensor 
        self.sensorType = sensorType
        self.value = float(value)
        self.nrofvalues = 1
        #print idMac, sensorType, value

    def getIdMac(self):
        return self.idMac

    def getIdSensor(self):
        return self.idSensor
    
    def getSensorType(self):
        return self.sensorType

    def getValue(self):
        temp = (self.value/self.nrofvalues)
        #self.setNewValue(0)
        return str(temp)

    def addValue(self, newValue):
        self.value += float(newValue)
        self.nrofvalues += 1
        #print str(self.value) + " : " + str(self.nrofvalues)

    def setNewValue(self, value):
        self.value = float(value)
        self.nrofvalues = 1

