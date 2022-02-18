#include "Arduino.h"
#include "StairManager.h"
#include "StairMotor.h"




StairManager::StairManager(int openButtonPin, int closeButtonPin){
	pinMode(openButtonPin, INPUT);
  	pinMode(closeButtonPin, INPUT);

  	_openButtonPin = openButtonPin;
  	_closeButtonPin = closeButtonPin;
}

void StairManager::setMotor(int directionConnectionPin, int motorConnectionPin, int relePin){
	StairMotor stairMotor(directionConnectionPin,motorConnectionPin,relePin);
	_stairMotor = stairMotor;
	int i = 0;
}

void StairManager::setStairAckWifi(bool status){
	stairAckWifi = status;
}

bool StairManager::getStairAckWifi(){
	return stairAckWifi;
}

void StairManager::setWifiCurrentSpeed(int speed){
	wifiCurrentSpeed = speed;
}

void StairManager::setWifiDirection(StairDirection direction){
	wifiCurrentDirection = direction;
}

bool StairManager::getStairAck(){
	return stairAck;
}

void StairManager::runStairManager(){
	int currentSpeed = wifiCurrentSpeed > 0 ? wifiCurrentSpeed : 100;
	if (wifiCurrentSpeed == 0) stairAckWifi = false;

	if(digitalRead(_openButtonPin) == HIGH || (wifiCurrentSpeed > 0 && wifiCurrentDirection == FORWARD && stairAckWifi == true)){
	    _stairMotor.goForward(currentSpeed);
	    stairAck = true;
	}else if(digitalRead(_closeButtonPin) == HIGH || (wifiCurrentSpeed > 0 && wifiCurrentDirection == BACKWARD && stairAckWifi == true)){
    	_stairMotor.goBackward(currentSpeed);
    	stairAck = true;
  	}else stairAck = false;

  	if(_stairMotor.isDriverEnabled()){
  		if(!stairAck && !stairAckWifi) cyclesWithoutStairAck++;
  		else cyclesWithoutStairAck = 0;

  		//Closing the motor relè after 10 cycles without a movement command
	    if(cyclesWithoutStairAck == 10) _stairMotor.enableDriver(false);
  	}

}



/*
void StairManager::porcoDio(){
	digitalWrite(_relePin,HIGH);
	_stairMotor.goForward(30);
	digitalWrite(_relePin,LOW);

	delay(2000);
}*/