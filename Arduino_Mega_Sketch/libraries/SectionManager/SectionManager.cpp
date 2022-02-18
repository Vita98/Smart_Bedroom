#include "Arduino.h"
#include "SectionManager.h"



SectionManager::SectionManager(){}

void SectionManager::setSectionsPin(int connectionPins[]){
	int i;
	for(i=0;i<SECTION_NUMBER;i++){
		sections[i] = {connectionPins[i],true,false,0};
		pinMode(connectionPins[i], OUTPUT);
		digitalWrite(connectionPins[i],HIGH);
	}
}

//Method that return the status of the IR sender
//as a String in quadrant order
String SectionManager::getSectionsString(){
  String sectionsString = "";
  for (int i=0;i<SECTION_NUMBER;i++){ 
  	sectionsString += (sections[i].isIRLedEnabled == true) ? "1" : "0"; 
  }
  return sectionsString;
}

void SectionManager::updateSectionsStatus(String payload){
	//Setting the selected section
	if(SECTION_NUMBER > payload.length()) return;

  	for (int i = 0; i < SECTION_NUMBER; i++){

	    //Saving the status
	    sections[i].isIRLedEnabled = payload.charAt(i) == '1' ? true : false;

	    //Setting the pin of the section
	    digitalWrite(sections[i].connectionPin, sections[i].isIRLedEnabled == true ? HIGH : LOW );
	}
}