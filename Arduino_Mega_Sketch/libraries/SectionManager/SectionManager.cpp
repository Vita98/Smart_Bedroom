#include "Arduino.h"
#include "SectionManager.h"


/*
	Empty constructor
*/
SectionManager::SectionManager(){}




/*
	Method to create and initialize all the sections.

	Paramenters:
	- connectionPins: array with all the pin to which the IR emitter diode
		are attached.
*/
void SectionManager::setSectionsPin(int connectionPins[]){
	int i;
	for(i=0;i<SECTION_NUMBER;i++){
		sections[i] = {connectionPins[i],true,false,0};
		pinMode(connectionPins[i], OUTPUT);
		digitalWrite(connectionPins[i],HIGH);
	}
}

/*
	Getter method for the status of all the sections in such a way 
	to be used as a payload for a command during the setup.

	Return: a string with all the status of the sections:
	- "1" if the section is enabled
	- "0" if the section is disabled
*/
String SectionManager::getSectionsString(){
  String sectionsString = "";
  for (int i=0;i<SECTION_NUMBER;i++){ 
  	sectionsString += (sections[i].isIRLedEnabled == true) ? "1" : "0"; 
  }
  return sectionsString;
}

/*
	Setter method for all the section status.
	Can be used only with the raw payload coming from the App and through the ESP.

	Parameters:
	- payload: raw payload coming from the app.
*/
void SectionManager::updateSectionsStatus(String payload){
	if(SECTION_NUMBER > payload.length()) return;

	//Setting the selected section
	for (int i = 0; i < SECTION_NUMBER; i++){
    //Saving the status
    sections[i].isIRLedEnabled = payload.charAt(i) == '1' ? true : false;

    //Setting the pin of the section
    digitalWrite(sections[i].connectionPin, sections[i].isIRLedEnabled == true ? HIGH : LOW );
	}
}