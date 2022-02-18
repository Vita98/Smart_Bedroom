/*
  
*/
#ifndef StairManager_h
#define StairManager_h

#include "Arduino.h"
#include "StairMotor.h"

class StairManager
{
  public:
    StairManager(int openButtonPin, int closeButtonPin);

    enum StairDirection {
      BACKWARD,
      FORWARD
    };

    void setMotor(int directionConnectionPin, int motorConnectionPin, int relePin);
    void setStairAckWifi(bool status);
    bool getStairAckWifi();
    void setWifiCurrentSpeed(int speed);
    void setWifiDirection(StairDirection direction);
    bool getStairAck();

    void runStairManager();

  private:
    StairDirection wifiCurrentDirection = FORWARD;
    int wifiCurrentSpeed = 0;

    int _openButtonPin;
    int _closeButtonPin;

    StairMotor _stairMotor;

    bool isButtonsEnabled = true;
  
    bool stairAck = false;
    bool stairAckWifi = false;
    int cyclesWithoutStairAck = 0;
};

#endif