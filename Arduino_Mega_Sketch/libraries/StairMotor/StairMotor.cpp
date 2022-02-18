#include "Arduino.h"
#include "StairMotor.h"


StairMotor::StairMotor(int directionConnectionPin, int motorConnectionPin, int relePin){
  pinMode(directionConnectionPin,OUTPUT);
  pinMode(motorConnectionPin,OUTPUT);
  pinMode(relePin,OUTPUT);
  digitalWrite(relePin, LOW);
  
  _directionConnectionPin = directionConnectionPin;
  _motorConnectionPin = motorConnectionPin;
  driverAlimentationRelePin = relePin;
}

StairMotor::StairMotor(){}

int StairMotor::delComputation(int rotationSpeed){
  return int((float(rotationSpeed)/100)*(MIN_DELAY_ROTATION - MAX_DELAY_ROTATION) + MAX_DELAY_ROTATION);
}

void StairMotor::enableDriver(bool enable){
  digitalWrite(driverAlimentationRelePin, (enable) ? HIGH : LOW);
  _isDriverEnabled = enable;
}

bool StairMotor::isDriverEnabled(){
  return _isDriverEnabled;
}

void StairMotor::moveMotor(int del){
  int i;
  if (!_isDriverEnabled) enableDriver(true);
  for(i=0;i<100;i++){
    // Makes 200 pulses for making one full cycle rotation
    digitalWrite(_motorConnectionPin,HIGH); 
    delayMicroseconds(del); 
    digitalWrite(_motorConnectionPin,LOW); 
    delayMicroseconds(del); 
  }
  //enableDriver(false);
}

void StairMotor::goForward(int rotationSpeed){
  //Enables the motor to move in a particular direction
  digitalWrite(_directionConnectionPin,LOW);

  int del = delComputation(rotationSpeed);
  if(del == MAX_DELAY_ROTATION) return;

  moveMotor(del);
}

void StairMotor::goBackward(int rotationSpeed){
  //Enables the motor to move in a particular direction
  digitalWrite(_directionConnectionPin,HIGH); 

  int del = delComputation(rotationSpeed);
  if(del == MAX_DELAY_ROTATION) return;

  moveMotor(del);
}
