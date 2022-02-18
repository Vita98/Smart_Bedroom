/*
  
*/
#ifndef SectionManager_h
#define SectionManager_h

#include "Arduino.h"

#define SECTION_NUMBER 4

class SectionManager
{
  public:
    SectionManager();

    void setSectionsPin(int connectionPins[]);
    String getSectionsString();
    void updateSectionsStatus(String payload);
  private:
    typedef int ButtonID;

    typedef struct Section{
      int connectionPin;
      bool isIRLedEnabled;
      bool isOn;
      ButtonID effect;
    } Section;

    Section sections[SECTION_NUMBER];
};

#endif