#include "Arduino.h"
#include "WallButton.h"



WallButton::WallButton(int connectionPin, int singleClickEffect, int longPressionEffect){
	pinMode(connectionPin,INPUT);

	_connectionPin = connectionPin;
	_singleClickEffect = singleClickEffect;
	_longPressionEffect = longPressionEffect;
}

String WallButton::getPayloadLongPression(){
  String payload = ( _isLongPressionEnabled ) ? "11" : "00";
  payload += addZeros(_longPressionEffect,2);
  return payload;
}

String WallButton::getPayloadSingleClick(){
  String payload = ( _isSingleClickEnabled ) ? "11" : "00";
  payload += addZeros(_singleClickEffect,2);
  return payload;
}

bool WallButton::isWallButtonEnabled(){
	return _isWallButtonEnabled;
}

void WallButton::enableWallButton(bool enable){
	_isWallButtonEnabled = enable;
}

void WallButton::enableSingleClick(bool enable){
	_isSingleClickEnabled = enable;
}

void WallButton::setSingleClickEffect(int newEffect){
	_singleClickEffect = newEffect;
}

int WallButton::getSingleClickEffect(){
	return _singleClickEffect;
}

void WallButton::enableLongPression(bool enable){
	_isLongPressionEnabled = enable;
}

void WallButton::setLongPressionEffect(int newEffect){
	_longPressionEffect = newEffect;
}

int WallButton::getLongPressionEffect(){
	return _longPressionEffect;
}

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

bool WallButton::isPressionEnded(){
	return pressionEnded;
}

bool WallButton::isSingleClickEnabled(){
	return _isSingleClickEnabled;
}

bool WallButton::isLongPressionEnabled(){
	return _isLongPressionEnabled;
}







