/*
  
*/
#ifndef WallButton_h
#define WallButton_h

#include "Arduino.h"
#include "Payloads.h"


class WallButton
{
  public:
    WallButton(int connectionPin, int singleClickEffect, int longPressionEffect);

    String getPayloadLongPression();
    String getPayloadSingleClick();

    bool isWallButtonEnabled();
    void enableWallButton(bool enable);

    void enableSingleClick(bool enable);
    void setSingleClickEffect(int newEffect);
    int getSingleClickEffect();

    void enableLongPression(bool enable);
    void setLongPressionEffect(int newEffect);
    int getLongPressionEffect();

    int readWallButtonPression();
    bool isPressionEnded();

    bool isSingleClickEnabled();
    bool isLongPressionEnabled();
  private:
    typedef int ButtonID;

    //Variable with the index of the command to be executed after the ON command
    //from the Wall button
    ButtonID _singleClickEffect;
    bool _isSingleClickEnabled = true;

    //Variable with the index of the command to be executed after the
    //long pression of the wall button
    ButtonID _longPressionEffect;
    bool _isLongPressionEnabled = true;
    
    //Variable used uidentify the single Wall click or the long pression
    int _numberOfPression = 0;
    int pressionEnded = true;

    //Wall button status
    bool _isWallButtonEnabled = true;

    int _connectionPin;
};

#endif