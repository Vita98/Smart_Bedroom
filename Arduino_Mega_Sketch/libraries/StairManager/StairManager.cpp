#include "Arduino.h"
#include "StairManager.h"
#include "StairMotor.h"



/*
	Constructor Method.

	Parameters:
	- openButtonPin: Arduino pin to which is connected the physical button to move the motor forward.
	- closeButtonPin: Arduino pin to which is connected the physical button to move the motor backward.
*/
StairManager::StairManager(int openButtonPin, int closeButtonPin){
	pinMode(openButtonPin, INPUT);
  	pinMode(closeButtonPin, INPUT);

  	_openButtonPin = openButtonPin;
  	_closeButtonPin = closeButtonPin;
}




/*
	Method to set the motor configuration.
	It crate a private StairMotor to manage the motor for the linear actuator.

	Prameters:
  - directionConnectionPin: Arduino pin to which is connected the motor direction regulation pin.
  - motorConnectionPin: Arduino pin to which is connected the motor step pin.
  - relePin: Arduino pin to which is connected the driver alimentation relè.
*/
void StairManager::setMotor(int directionConnectionPin, int motorConnectionPin, int relePin){
	StairMotor stairMotor(directionConnectionPin,motorConnectionPin,relePin);
	_stairMotor = stairMotor;
	int i = 0;
}




/*
	Setter method for stairAckWifi.

	Parameters:
	- status: the new status, true if a stair commad is received from the App
	false otherwise.
*/
void StairManager::setStairAckWifi(bool status){
	stairAckWifi = status;
}

/*
	Getter method for stairAckWifi.

	Return: true if the last command received from the App is a stair command, false otherwise.
*/
bool StairManager::getStairAckWifi(){
	return stairAckWifi;
}

/*
	Getter method for stairAck.

	Return: true if the one of the two physical button (_openButtonPin / _closeButtonPin)
	is active, false otherwise.
*/
bool StairManager::getStairAck(){
	return stairAck;
}




/*
	Setter method for the rotation speed received from the App. 

	Parameters:
	- speed: the motor rotation speed coming from the App.
*/
void StairManager::setWifiCurrentSpeed(int speed){
	wifiCurrentSpeed = speed;
}

/*
	Setter method for the motor current rotation direction.

	Parameters:
	- direction: the new motor rotation direction.
*/
void StairManager::setWifiDirection(StairDirection direction){
	wifiCurrentDirection = direction;
}




/*
	Main method that manage all the motor lifecycle.

	Is resposible for the correct movement of the motor in the correct
	direction and it is also resposible of the mechanism for cut the power to the motor driver.

	Warning: the method works using the private variables wifiCurrentSpeed and wifiCurrentDirection to determine
	the rotation speed when connected to the App and use the buttons attached to the _openButtonPin and 
	_closeButtonPin arduino pin to determine the speed and direction when not connected to the App.

	It's strongly recommended to set the two values with the respective setter method.

	Call this method on each loop iteration.
*/
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
