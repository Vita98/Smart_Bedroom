#include "Arduino.h"
#include "MovementSensor.h"


MovementSensor::MovementSensor(int connectionPin, int effect){
	_connectionPin = connectionPin;
	_effect = effect;

	pinMode(_connectionPin, INPUT);
}

String MovementSensor::getPayloadMovementSensor(){
	String payload = ( _isEnabled ) ? "11" : "00";
	payload += addZeros(_effect,2);
	return payload;
}

void MovementSensor::enable(bool enable){
	_isEnabled = enable;
}

bool MovementSensor::isEnabled(){
	return _isEnabled;
}

void MovementSensor::setEffect(int effect){
	_effect = effect;
}

int MovementSensor::getEffect(){
	return _effect;
}

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