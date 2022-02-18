/*

*/
#ifndef ConnectionHelper_h
#define ConnectionHelper_h

#include "Arduino.h"
#define SINGLE_MESSAGE_LENGTH 10
#define NUM_CONTROL_OPCODE 3
#define NUM_OPCODE 7
#define NUM_SETUP_OPCODE 5



const String ConnectionOPCode[2] = {"NEWCONNECT", "ENDCONNECT"};
const String SetupStatusOPCode[NUM_CONTROL_OPCODE] = {"CHECKCONNE","ENDSETUP","NTRCVD"};
const String NormalStatusOPCode[NUM_OPCODE] = {"BUTTON","SECTIO","WBUTTO","1KWBUT","LONPRE","STAIRS","MOVSEN"};
const String SetupConfigurationOPCode[NUM_SETUP_OPCODE] = {"SECTIO" , "WBUTTO" , "1KWBUT" , "LONPRE", "MOVSEN"};



String getString(int index, String incomingString);
bool isConnectionEnded(String command);
bool isNewConnection(String command);

bool isNotReceived(String command);
bool isEndSetup(String command);
bool isCheckConnection(String command);

bool isButtonCommand(String command);
bool isSectionCommand(String command);
bool isWallButtonCommand(String command);
bool isSingleClickWallButtonCommand(String command);
bool isLongPressionWallButtonCommand(String command);
bool isStairCommand(String command);
bool isMovementSensorCommand(String command);

bool isMissingSectionCommand(String command);
bool isMissingWallButtonCommand(String command);
bool isMissingSingleClickCommand(String command);
bool isMissingLongPressionCommand(String command);
bool isMissingSectionMovementSensorCommand(String command);


#endif