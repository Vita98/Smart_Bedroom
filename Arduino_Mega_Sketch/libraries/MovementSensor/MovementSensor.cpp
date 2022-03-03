#include "Arduino.h"
#include "MovementSensor.h"


/*
	Constructor function.

	Parameters:
	- connectionPin: pin where the movement sensor is connected
	- effect: effect code to send when a movement is detected
*/
MovementSensor::MovementSensor(int connectionPin, int effect){
	_connectionPin = connectionPin;
	_effect = effect;

	pinMode(_connectionPin, INPUT);
}

/*
	Function that prepare and return the payload to send to the app
	during the setup with the movement sensor status values.

	Return: a string with the correct payload thus formed:
	- "0011" if the movement sensor is enabled
	- "0000" if the movement sensor is disabled
	- "0022" if the movement sensor is in auto
*/
String MovementSensor::getPayloadMovementSensor(){
	String payload = "";

	switch (_status){
		case ENABLED:
			payload += "11";
			break;
		case DISABLED:
			payload += "00";
			break;
		case AUTO:
			payload += "22";
			break;
	}
	payload += addZeros(_effect,2);
	return payload;
}




/*
	Setter method for the _status variable

	Parameters:
	- status: new status for the movement sensor.
*/
void MovementSensor::setStatus(MovementSensorStatus status){
	_status = status;
}

/*
	Setter method for the _status variable based on the payload received
	from the App.

	Parameters:
	- payload: payload string received from the app through the ESP.
*/
void MovementSensor::setStausByPayload(String payload){
	if(payload == "00") _status = DISABLED;
  	else if(payload == "11") _status = ENABLED;
  	else if(payload == "22") _status = AUTO;
}

/*
	Getter method for the movement sensor status.

	Return: the actual status of the movement sensor.
*/
MovementSensorStatus MovementSensor::getStatus(){
	return _status;
}





/*
	Setter method for the effect to send when a movement is detected

	Parameters:
	- effect: new effect sent when a movement is detected.
*/
void MovementSensor::setEffect(int effect){
	_effect = effect;
}

/*
	Getter method for the effect code.

	Return: the actual effect code to send when a movement is detected.
*/
int MovementSensor::getEffect(){
	return _effect;
}




/*
	Setter method for the hours type variable

	Parameters:
	- hoursType: HoursType value indicating the new hour type.
*/
void MovementSensor::setHoursType(HoursType hoursType){
	_hoursType = hoursType;
}

/*
	Getter method for the hours type variable

	Return: the actual HoursType value.
*/
HoursType MovementSensor::getHoursType(){
	return _hoursType;
}




/*
	Method that read the phisycal status of the movement sensor in such a
	way as to detect a movement.

	Return: true if a movement is detected, false otherwise.
*/
bool MovementSensor::detectMovement(){
	if (digitalRead(_connectionPin) == HIGH){
		if (_isMovementDetected == false){
	      	Serial.println("MOVEMENT DETECTED!");
	      	_isMovementDetected = true;
	    }
	}else{
	    if (_isMovementDetected == true){
		    Serial.println("MOVEMENT NOT DETECTED ANYMORE!");
		    _isMovementDetected = false;
		}
	}
	return _isMovementDetected;
}