#include "Arduino.h"
#include "WallButton.h"



/*
	Constructor function.

	Parameters:
	- connectionPin: pin where the wall button is connected
	- singleClickEffect: effect code to send when a single click is detected
	- longPressionEffect: effect code to send when a long pression is detected
*/
WallButton::WallButton(int connectionPin, int singleClickEffect, int longPressionEffect){
	pinMode(connectionPin,INPUT);

	_connectionPin = connectionPin;
	_singleClickEffect = singleClickEffect;
	_longPressionEffect = longPressionEffect;
}




/*
	Function that prepare and return the payload to send to the app
	during the setup with the wall button single click status values.

	Return: a string with the correct payload.
*/
String WallButton::getPayloadLongPression(){
  String payload = ( _isLongPressionEnabled ) ? "11" : "00";
  payload += addZeros(_longPressionEffect,2);
  return payload;
}

/*
	Function that prepare and return the payload to send to the app
	during the setup with the wall button long pression status values.

	Return: a string with the correct payload.
*/
String WallButton::getPayloadSingleClick(){
  String payload = ( _isSingleClickEnabled ) ? "11" : "00";
  payload += addZeros(_singleClickEffect,2);
  return payload;
}




/*
	Getter method for the wall button status.

	Return: true if the wall button is enabled, false otherwise. 
*/
bool WallButton::isWallButtonEnabled(){
	return _isWallButtonEnabled;
}

/*
	Method that allow to change the wall button status.

	Parameters:
	- enable: the new wall button status.
*/
void WallButton::enableWallButton(bool enable){
	_isWallButtonEnabled = enable;
}




/*
	Getter method for the wall button single click status.

	Return: true if the wall button single click is enabled, false otherwise. 
*/
bool WallButton::isSingleClickEnabled(){
	return _isSingleClickEnabled;
}

/*
	Method that allow to change the wall button single click status.

	Parameters:
	- enable: the new wall button single click status.
*/
void WallButton::enableSingleClick(bool enable){
	_isSingleClickEnabled = enable;
}




/*
	Getter method for the wall button long pression status.

	Return: true if the wall button long pression is enabled, false otherwise. 
*/
bool WallButton::isLongPressionEnabled(){
	return _isLongPressionEnabled;
}

/*
	Method that allow to change the wall button long pression status.

	Parameters:
	- enable: the new wall button long pression status.
*/
void WallButton::enableLongPression(bool enable){
	_isLongPressionEnabled = enable;
}




/*
	Setter method for the effect to send when a wall button single click event is detected.

	Parameters:
	- effect: new effect sent when a wall button single click event is detected.
*/
void WallButton::setSingleClickEffect(int newEffect){
	_singleClickEffect = newEffect;
}

/*
	Getter method for the effect code to send when a wall button single click event is detected.

	Return: the actual effect code to send when a wall button single click event is detected.
*/
int WallButton::getSingleClickEffect(){
	return _singleClickEffect;
}




/*
	Setter method for the effect to send when a wall button long pression event is detected.

	Parameters:
	- effect: new effect sent when a wall button long pression event is detected.
*/
void WallButton::setLongPressionEffect(int newEffect){
	_longPressionEffect = newEffect;
}

/*
	Getter method for the effect code to send when a wall button long pression event is detected.

	Return: the actual effect code to send when a wall button long pression event is detected.
*/
int WallButton::getLongPressionEffect(){
	return _longPressionEffect;
}




/*
	Method that manage and read the physical state of the wall button.
	It  manages all the status variable in his own class.

	Return: the wall button pression number.
*/
int WallButton::readWallButtonPression(){
	if (digitalRead(_connectionPin) == HIGH){
		_numberOfPression++;
	    Serial.println("Wall Button pressed!");
	    pressionEnded = false;
	    return _numberOfPression;
	}else{
		//Wall button pression 
		if(!pressionEnded){
			Serial.println("Wall button pression ended!");
			int returnValue = _numberOfPression;
			_numberOfPression = 0;
			pressionEnded = true;
			return returnValue;
		}else return 0;
	}
}

/*
	Method that return the status of the pression.

	Return: true if the wall button pression ended, false if it's still pressed.
*/
bool WallButton::isPressionEnded(){
	return pressionEnded;
}
