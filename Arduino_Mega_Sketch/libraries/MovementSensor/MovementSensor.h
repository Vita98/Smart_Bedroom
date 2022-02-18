/*
  
*/
#ifndef MovementSensor_h
#define MovementSensor_h

#include "Arduino.h"
#include "Payloads.h"


class MovementSensor
{
  public:
    MovementSensor(int connectionPin, int effect);
    String getPayloadMovementSensor();
    void enable(bool enable);
    void setEffect(int effect);
    int getEffect();
    bool isEnabled();

    bool detectMovement();

  private:
    typedef int ButtonID;

    int _connectionPin;
    bool _isMovementDetected = false;
    bool _isEnabled = false;
    ButtonID _effect;
};

#endif