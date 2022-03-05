/*
  Header file with the definition of the class and enum to manage the Movement sensor.
*/
#ifndef MovementSensor_h
#define MovementSensor_h

#include "Arduino.h"
#include "Payloads.h"

/*
  Enum indicating the status of the movement sensor:
  - ENABLED: the movement sensor is enabled
  - DISABLED: the movement sensor is disabled
  - AUTO: the movement sensor is in auto status, which means that
    is enabled only in night hours. 
*/
enum MovementSensorStatus{
  ENABLED,
  DISABLED,
  AUTO
};

/*
  Enum indicating the hours type:
  - LIGHT: hours between the sunrise and the sunset
  - DARK: hours after the sunset and before the sunrise
*/
enum HoursType{
  LIGHT,
  DARK
};

/*
  Main class used to manage the movement sensor
*/
class MovementSensor
{
  public:
    //Constructor
    MovementSensor(int connectionPin, int effect);

    // Payload generator
    String getPayloadMovementSensor();

    /* Movement sensor status setter and getter */
    void setStatus(MovementSensorStatus status);
    void setStausByPayload(String payload);
    MovementSensorStatus getStatus();

    /* Movement sensor effect code setter and getter */
    void setEffect(int effect);
    int getEffect();

    /* Hour type setter and getter */
    void setHoursType(HoursType hoursType);
    HoursType getHoursType();

    // Movement detecter
    bool detectMovement();
  private:

    //Type used to identify a button id
    typedef int ButtonID;

    int _connectionPin; //Variable in which to store the pin where the movement sensor is attached
    bool _isMovementDetected = false; //It is true when a movement is detected, false otherwise
    MovementSensorStatus _status = AUTO;  //Variables indicating the status of the movement sensor
    HoursType _hoursType = LIGHT; //Variables indicating the actual hours type
    ButtonID _effect; //Effect code to send when a movement is detected
};

#endif