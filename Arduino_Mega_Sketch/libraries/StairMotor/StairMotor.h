/*
  Header file with the definition of the class and enum to manage the 
  linear actuator for the stairs.

  It allows to move the actuator forward or backward and enable or disable the driver 
  through a relè.

  Since the motor driver makes a strange and loud noise, it has been implemented a relè to
  cut the motor driver supply current.
*/
#ifndef StairMotor_h
#define StairMotor_h

#include "Arduino.h"


/*
  Main class used to manage the linear actuator for the stairs
*/
class StairMotor
{
  public:

    // Constructors
    StairMotor(int directionConnectionPin, int motorConnectionPin, int relePin);
    StairMotor();

    // Setter and getter method for the driver status
    void enableDriver(bool enable);
    bool isDriverEnabled();

    // Method to move the motor in both direction
    void goForward(int rotationSpeed);
    void goBackward(int rotationSpeed);
  private:

    /* 
      Enum with the minimum and maximum delay for 
      the regulation of the motor rotation speed.
    */
    enum StairMotorDelayRotation{
      MIN_DELAY_ROTATION = 500,
      MAX_DELAY_ROTATION = 1000
    };

    int _directionConnectionPin;  // Arduino pin to which is connected the motor direction regulation pin.
    int _motorConnectionPin;  // Arduino pin to which is connected the motor step pin.
    int driverAlimentationRelePin;  // Arduino pin to which is connected the driver alimentation relè.

    bool _isDriverEnabled = false;  // Driver alimentation status.

    // Private method
    int delComputation(int rotationSpeed);
    void moveMotor(int del);
};

#endif
