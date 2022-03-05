#include "Arduino.h"
#include "StairMotor.h"


/*
  Constructor method.
  
  Prameters:
  - directionConnectionPin: Arduino pin to which is connected the motor direction regulation pin.
  - motorConnectionPin: Arduino pin to which is connected the motor step pin.
  - relePin: Arduino pin to which is connected the driver alimentation relè.
*/
StairMotor::StairMotor(int directionConnectionPin, int motorConnectionPin, int relePin){
  pinMode(directionConnectionPin,OUTPUT);
  pinMode(motorConnectionPin,OUTPUT);
  pinMode(relePin,OUTPUT);
  digitalWrite(relePin, LOW);
  
  _directionConnectionPin = directionConnectionPin;
  _motorConnectionPin = motorConnectionPin;
  driverAlimentationRelePin = relePin;
}

/*
  Empty constructor
*/
StairMotor::StairMotor(){}




/*
  Method that convert the rotation speed (0 to 99%) into a delay value
  between one pulse and another needed to move the motor.

  Parameter:
  - rotatioSpeed: the percentage rotation speed to convert.

  Return: the converted delay.
*/
int StairMotor::delComputation(int rotationSpeed){
  return int((float(rotationSpeed)/100)*(MIN_DELAY_ROTATION - MAX_DELAY_ROTATION) + MAX_DELAY_ROTATION);
}

/*
  Method that makes 200 motor pulses for making one full cycle rotation.

  Parameters:
  - del: delay between one pulse and another

  Warning: this method also enable the motor driver using rele pin
  but does not disable it. Implement a mechanism to disable it by yourself.
*/
void StairMotor::moveMotor(int del){
  int i;
  if (!_isDriverEnabled) enableDriver(true);
  for(i=0;i<100;i++){
    digitalWrite(_motorConnectionPin,HIGH); 
    delayMicroseconds(del); 
    digitalWrite(_motorConnectionPin,LOW); 
    delayMicroseconds(del); 
  }
}




/*
  Method that enable or disable the motor driver.
  
  It is physically implemented using a relè that cut the power
  supply from the driver.

  Parameters:
  - enable: the new motor driver enable status.
*/
void StairMotor::enableDriver(bool enable){
  digitalWrite(driverAlimentationRelePin, (enable) ? HIGH : LOW);
  _isDriverEnabled = enable;
}

/*
  Getter method for the motor driver enable status.

  Return: true is the motor driver is anabled and therefore the
  current flow through the driver, false otherwise. 
*/
bool StairMotor::isDriverEnabled(){
  return _isDriverEnabled;
}




/*
  Method that moves the motor of one full cycle rotation and therefore
  moves the linear actuator forward.

  Parameters:
  - rotationSpeed: the rotation speed in percentage.
*/
void StairMotor::goForward(int rotationSpeed){
  //Enables the motor to move in a particular direction
  digitalWrite(_directionConnectionPin,LOW);

  int del = delComputation(rotationSpeed);
  if(del == MAX_DELAY_ROTATION) return;

  moveMotor(del);
}

/*
  Method that moves the motor of one full cycle rotation and therefore
  moves the linear actuator backward.

  Parameters:
  - rotationSpeed: the rotation speed in percentage.
*/
void StairMotor::goBackward(int rotationSpeed){
  //Enables the motor to move in a particular direction
  digitalWrite(_directionConnectionPin,HIGH); 

  int del = delComputation(rotationSpeed);
  if(del == MAX_DELAY_ROTATION) return;

  moveMotor(del);
}
