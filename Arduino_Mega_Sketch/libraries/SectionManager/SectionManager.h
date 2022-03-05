/*
  Header file with the definition of the class and enum to manage all the bedroom section.
  
  A section correspond to a single GU10 spotlight with attached an IR emitter diode 
  in order to command it.
*/
#ifndef SectionManager_h
#define SectionManager_h

#include "Arduino.h"

/*
  Number of the section.
  Since we have only 4 spotlight, the section will be 4.

  Due to the algorithm used the actual maximum number of section is 4.
*/
#define SECTION_NUMBER 4

/*
  Main class used to manage the movement sensor
*/
class SectionManager
{
  public:
    //Empty constructor
    SectionManager();

    // Sections setter and getter
    void setSectionsPin(int connectionPins[]);
    String getSectionsString();
    void updateSectionsStatus(String payload);
  private:
    typedef int ButtonID; //Type used to identify a button id

    /*
      Struct used to rappresent a single instance of a section
      with his own values and data.
    */
    typedef struct Section{
      int connectionPin;  // The pin where the IR sender (IR Emitter diode) of the section is attached
      bool isIRLedEnabled;  // Whether the emitter of the section is enable or not.
      bool isOn;  // Whether the spotlight associated to the emitter is turned on or off.
      ButtonID effect;  // Current spotlight light effect.
    } Section;

    // Array of section
    Section sections[SECTION_NUMBER];
};

#endif