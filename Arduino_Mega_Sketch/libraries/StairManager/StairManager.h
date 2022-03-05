/*
  Header file with the definition of the class and enum to manage everything about the motor
  for the linear actuator.
  
  It also include a mechanism for cut the power to the motor driver when not used.
*/
#ifndef StairManager_h
#define StairManager_h

#include "Arduino.h"
#include "StairMotor.h"


/*
  Main class used to manage the stairs
*/
class StairManager
{
  public:

    /*
      Enum for indicate the linear actuator direction
    */
    enum StairDirection {
      BACKWARD,
      FORWARD
    };

    // Constructor
    StairManager(int openButtonPin, int closeButtonPin);

    // Method to set the motor
    void setMotor(int directionConnectionPin, int motorConnectionPin, int relePin);
    
    // Setter and getter for the stairAckWifi and stairAck
    void setStairAckWifi(bool status);
    bool getStairAckWifi();
    bool getStairAck();

    // Method to set the linear actuator direction and speed
    void setWifiCurrentSpeed(int speed);
    void setWifiDirection(StairDirection direction);

    // Main method to run the manager
    void runStairManager();

  private:
    StairDirection wifiCurrentDirection = FORWARD;  // Variable to store the current direction.
    int wifiCurrentSpeed = 0; // Variable to store the motor speed coming from the App.

    /*
      Ardunio pin to which are connected the two physical button to 
      move forward or backward the linear actuator
    */
    int _openButtonPin;
    int _closeButtonPin;

    StairMotor _stairMotor; // Instance of a Motor.

    bool isButtonsEnabled = true; // Physical button status for the motor.
    
    /*
      Variabled usefull to the machanism for cutting the power to 
      the motor driver when not used.
    */
    bool stairAck = false;
    bool stairAckWifi = false;
    int cyclesWithoutStairAck = 0;
};

#endif