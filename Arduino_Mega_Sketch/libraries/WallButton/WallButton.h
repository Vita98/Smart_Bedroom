/*
  Header file with the definition of the class and enum to manage the Wall Button.
*/
#ifndef WallButton_h
#define WallButton_h

#include "Arduino.h"
#include "Payloads.h"


/*
  Main class used to manage the wall button
*/
class WallButton
{
  public:

    // Constructor
    WallButton(int connectionPin, int singleClickEffect, int longPressionEffect);

    // Payload generator
    String getPayloadLongPression();
    String getPayloadSingleClick();

    /* Wall button status setter and getter */
    bool isWallButtonEnabled();
    void enableWallButton(bool enable);

    /* Wall button single click status setter and getter */
    bool isSingleClickEnabled();
    void enableSingleClick(bool enable);

    /* Wall button long pression status setter and getter */
    bool isLongPressionEnabled();
    void enableLongPression(bool enable);

    /* Wall button single click effect code setter and getter */
    void setSingleClickEffect(int newEffect);
    int getSingleClickEffect();

    /* Wall button long pression effect code setter and getter */
    void setLongPressionEffect(int newEffect);
    int getLongPressionEffect();

    /* Method to manage the wall button pression event */
    int readWallButtonPression();
    bool isPressionEnded();

  private:
    typedef int ButtonID; //Type used to identify a button id

    ButtonID _singleClickEffect;  // Effect code to send when the wall button is pressed only one time.
    bool _isSingleClickEnabled = true;  // It is true if the wall button single click is enabled, false otherwise.

    ButtonID _longPressionEffect; // Effect code to send when the wall button is pressed for a long time (~2 sec).
    bool _isLongPressionEnabled = true; // It is true if the wall button long pression is enabled, false otherwise.
    
    int _numberOfPression = 0;  // Variable used to identify the single Wall click from the long pression
    int pressionEnded = true; // It is true if the pression of the wall button ended.

    bool _isWallButtonEnabled = true; // Variables used to identify the wall button status.
    int _connectionPin; //Variable in which to store the pin where the wall button is attached.
};

#endif