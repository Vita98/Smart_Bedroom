/*
  
*/
#ifndef StairMotor_h
#define StairMotor_h

#include "Arduino.h"

class StairMotor
{
  public:
    StairMotor(int directionConnectionPin, int motorConnectionPin, int relePin);
    StairMotor();

    void goForward(int rotationSpeed);
    void goBackward(int rotationSpeed);

    void enableDriver(bool enable);
    bool isDriverEnabled();
    
  private:
    enum StairMotorDelayRotation{
      MIN_DELAY_ROTATION = 500,
      MAX_DELAY_ROTATION = 1000
    };

    int _directionConnectionPin;
    int _motorConnectionPin;
    int driverAlimentationRelePin;

    bool _isDriverEnabled = false;

    int delComputation(int rotationSpeed);
    void moveMotor(int del);
};

#endif
